// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/content_option.dart';
import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../models/line/popups/underground_cables_line_model.dart';

class UndergroundCableLineController<T> extends BasePopupController {
  UndergroundCableLineController() {
    dataModel = UndergroundCablesLineModel().obs;
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as UndergroundCablesLineModel;
    switch (type) {
      case ImageProblems.muc1_0:
        if (model.headStatus == null ||
            model.systemStatus == null ||
            model.constructionStatus == null ||
            model.lobbyStatus == null ||
            model.mustyStatus == null ||
            model.cablesStatus == null) {
          if (model.lineUndergroundCablesAbnormal != null) {
              model.lineUndergroundCablesAbnormal = null;
          }
          invalid.refresh();
          return;
        }

        {
          if (model.headStatus != ContentOptions.normal.value ||
              model.systemStatus != ContentOptions.normal.value ||
              model.constructionStatus != ContentOptions.normal.value ||
              model.lobbyStatus != ContentOptions.normal.value ||
              model.mustyStatus != ContentOptions.normal.value ||
              model.cablesStatus != ContentOptions.normal.value) {
            //bất thường
            if (model.lineUndergroundCablesAbnormal !=
                ContentOptions.weirdo.value) {
              model.lineUndergroundCablesAbnormal = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else {
            model.lineUndergroundCablesAbnormal = ContentOptions.normal.value;
            invalid.refresh();
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  bool checkValid() {
    final model = dataModel.value as UndergroundCablesLineModel;
    if (model.validateData() && checkValidAbnormal()) return true;
    return false;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as UndergroundCablesLineModel;

    if (model.headStatus != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_1).isEmpty||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1).abnormalId.isNullOrEmpty() ||
                model.headStatusAbnormal.isNullOrBlank()) ||
        model.systemStatus != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_2).isEmpty||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2).abnormalId.isNullOrEmpty() ||
                model.systemStatusAbnormal.isNullOrBlank()) ||
        model.constructionStatus != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_3).isEmpty||
                getAbnormalByCategoryIndex(ImageProblems.muc1_3).abnormalId.isNullOrEmpty() ||
                model.constructionStatusAbnormal.isNullOrBlank()) ||
        model.lobbyStatus != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_4).isEmpty||
                getAbnormalByCategoryIndex(ImageProblems.muc1_4).abnormalId.isNullOrEmpty() ||
                model.lobbyStatusAbnormal.isNullOrBlank()) ||
        model.mustyStatus != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_5).isEmpty||
                getAbnormalByCategoryIndex(ImageProblems.muc1_5).abnormalId.isNullOrEmpty() ||
                model.mustyStatusAbnormal.isNullOrBlank()) ||
        model.cablesStatus != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_6).isEmpty||
                getAbnormalByCategoryIndex(ImageProblems.muc1_6).abnormalId.isNullOrEmpty() ||
                model.cablesStatusAbnormal.isNullOrBlank())) {
      return false;
    }
    return true;
  }

  @override
  Future getData({String equipmentId}) async {
    return getDataLine('lineUndergroundCabelsModel', equipmentId: equipmentId);
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as UndergroundCablesLineModel;
    if (equipmentsDestination.length > 1) {
      return model.lineUndergroundCablesAbnormal == ContentOptions.normal.value;
    }
    return true;
  }

  @override
  Future updateData() async {
    final model = dataModel.value as UndergroundCablesLineModel;
    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'lineUndergroundCables');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory,
      testType: transformerTicketController.testType);

  @override
  Future copyData() async {
    final originalModel = await getData(equipmentId: equipmentModel.id)
        as UndergroundCablesLineModel;
    originalModel.images = [];

    dataModel.value = originalModel;
    invalid.refresh();
  }
}

