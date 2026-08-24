// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/line/popups/csv_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/content_option.dart';
import '../../../../../../common/constance/image_problems.dart';

class CSVController<T> extends BasePopupController {
  CSVController() {
    dataModel = CsvModel().obs;
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as CsvModel;
    switch (type) {
      case ImageProblems.muc1_0:
        {
          if (model.pointStatus == null ||
              model.groundingStatus == null ||
              model.csStatus == null) {
            if (model.lineCSVAbnormal != null) {
              model.lineCSVAbnormal = null;
              invalid.refresh();
            }
            return;
          }

          if (model.pointStatus != ContentOptions.normal.value ||
              model.groundingStatus != ContentOptions.normal.value ||
              model.csStatus != ContentOptions.normal.value
          ) {
            //bất thường
            if (model.lineCSVAbnormal != ContentOptions.weirdo.value) {
              model.lineCSVAbnormal = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else {
            model.lineCSVAbnormal = ContentOptions.normal.value;
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
    final model = dataModel.value as CsvModel;
    if (model.validateData() && checkValidAbnormal()) return true;
    return false;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as CsvModel;

    if (model.csStatus != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_1).isEmpty||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1).abnormalId.isNullOrEmpty() ||
                model.csStatusAbnormal.isNullOrBlank()) ||
        model.groundingStatus != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_2).isEmpty||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2).abnormalId.isNullOrEmpty() ||
                model.groundingStatusAbnormal.isNullOrBlank()) ||
        model.pointStatus != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_3).isEmpty||
                getAbnormalByCategoryIndex(ImageProblems.muc1_3).abnormalId.isNullOrEmpty() ||
                model.pointStatusAbNormal.isNullOrBlank())) {
      return false;
    }
    return true;
  }

  @override
  Future getData({String equipmentId}) async {
    return getDataLine('lineCsv', equipmentId: equipmentId);
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as CsvModel;
    if (equipmentsDestination.length > 1) {
      return model.lineCSVAbnormal == ContentOptions.normal.value;
    }
    return true;
  }

  @override
  Future updateData() async {
    final model = dataModel.value as CsvModel;
    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'lineCsv');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory,
      testType: transformerTicketController.testType);

  @override
  Future copyData() async {
    final originalModel =
        await getData(equipmentId: equipmentModel.id) as CsvModel;
    originalModel?.images = [];

    dataModel.value = originalModel;
    invalid.refresh();
  }
}

