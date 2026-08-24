// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:get/get.dart';

import '../../../../../../qltnkd/common/utils/alert_dialog_utils.dart';
import '../../../../../common/constance/content_option.dart';
import '../../../../../common/constance/image_problems.dart';
import '../../../../../common/constance/strings.dart';
import '../../../../../models/line/line_content_night_time_model.dart';
import '../../../../../services/responsitory/line_repository.dart';
import '../../../base/base_popup_controller_inter.dart';

class NightContentController extends BasePopupController {

  NightContentController() {
    dataModel = ContentNightTimeModel().obs;
  }

  final _lineRepo = LineRepository();

  @override
  Future getData({String equipmentId}) async {

      final response = await _lineRepo.getContentNightTimeDetail(
        id: transformerTicketController.ticketId,
      );
      if (response.isLoadSuccess) {
        dataModel.value = response.data.model;
        invalid.refresh();
      } else {
        await rShowDialogOneButton(response.message);
      }
      invalid.refresh();
  }

  @override
  Future<void> updateData() async {
    if (!checkValid()) {
      invalid.value = true;
      invalid.refresh();
      await rShowDialogOneButton(HighElectricStrings.requireUpdatePopupText);
    } else {
      final model = dataModel.value as ContentNightTimeModel;
      model.id = transformerTicketController.ticketId;
      final response = await _lineRepo.updateContentNightTimeDetail(
        params: {'id': transformerTicketController.ticketId,'lineNightTime': model.toJson()},idTicket: transformerTicketController.ticketId
      );
      if (response.isLoadSuccess) {
        await rShowDialogOneButton(
            HighElectricStrings.updatePopupSuccessCommon);
        invalid.value = false;
        invalid.refresh();
      } else {
        await rShowDialogOneButton(response.message);
        invalid.refresh();
      }
    }
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as ContentNightTimeModel;

    if (
    (model.checkSplice != ContentOptions.normal.value &&
        (model.checkSpliceAbnormal.isNullOrBlank() ||
            getImageByProblem(ImageProblems.muc1_1).isEmpty||
            getAbnormalByCategoryIndex(ImageProblems.muc1_1)==null||
            getAbnormalByCategoryIndex(ImageProblems.muc1_1).abnormalId.isNullOrEmpty())) ||
    (model.checkDischarges != ContentOptions.normal.value &&
        (model.checkDischargesAbnormal.isNullOrBlank() ||
            getImageByProblem(ImageProblems.muc1_2).isEmpty||
            getAbnormalByCategoryIndex(ImageProblems.muc1_2)==null||
            getAbnormalByCategoryIndex(ImageProblems.muc1_2).abnormalId.isNullOrEmpty())) ||
    (model.other != ContentOptions.normal.value &&
        (model.otherAbnormal.isNullOrBlank() ||
            getImageByProblem(ImageProblems.muc1_3).isEmpty||
            getAbnormalByCategoryIndex(ImageProblems.muc1_3)==null||
            getAbnormalByCategoryIndex(ImageProblems.muc1_3).abnormalId.isNullOrEmpty())) ||
    (model.checkLight != ContentOptions.normal.value &&
        (model.checkLightAbnormal.isNullOrBlank() ||
            getImageByProblem(ImageProblems.muc1_4).isEmpty||
            getAbnormalByCategoryIndex(ImageProblems.muc1_4)==null||
            getAbnormalByCategoryIndex(ImageProblems.muc1_4).abnormalId.isNullOrEmpty()))

    ) {
      return false;
    }

    return true;
  }

  @override
  bool checkValidCopy() {
    return true;
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as ContentNightTimeModel;
    switch (type) {
      case ImageProblems.muc1_0:
        {
          if (model.checkSplice == null || model.checkDischarges == null || model.other==null || model.checkLight==null) {
            if (model.checkNight != null) {
              model.checkNight = null;
              invalid.refresh();
            }
            break;
          }

          if (model.checkSplice != ContentOptions.normal.value ||
              model.checkDischarges != ContentOptions.normal.value||
              model.other != ContentOptions.normal.value||
              model.checkLight != ContentOptions.normal.value
          ) {
            if (model.checkNight != ContentOptions.weirdo.value) {
              //bất thuong
              model.checkNight = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else {
            if (model.checkNight != ContentOptions.normal.value) {
              //khong binh thuong
              model.checkNight = ContentOptions.normal.value;
            }
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  Future copyData() {
    return Future.value();
  }

  @override
  String getEndPoint() {
    return '';
  }

  @override
  bool checkValid() {
    final model = dataModel.value as ContentNightTimeModel;
    if (model.validateData() &&
        checkValidAbnormal()) return true;
    return false;
  }

}

