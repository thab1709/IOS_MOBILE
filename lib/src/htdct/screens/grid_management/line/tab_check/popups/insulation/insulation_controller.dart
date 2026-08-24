// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/content_option.dart';
import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../models/line/popups/insulation_model.dart';

class InsulationController<T> extends BasePopupController {
  InsulationController() {
    dataModel = InsulationModel().obs;
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as InsulationModel;
    switch (type) {
      case ImageProblems.muc1_0:
        {
          if (model.statusInsulation == null) {
            if (model.lineInsulationsAbnormal != null) {
              model.lineInsulationsAbnormal = null;
              invalid.refresh();
            }
            return;
          }

          if (model.statusInsulation != ContentOptions.normal.value) {
            //bất thường
            if (model.lineInsulationsAbnormal != ContentOptions.weirdo.value) {
              model.lineInsulationsAbnormal = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else {
            model.lineInsulationsAbnormal = ContentOptions.normal.value;
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
    final model = dataModel.value as InsulationModel;
    if (model.validateData() && checkValidAbnormal()) return true;
    return false;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as InsulationModel;

    if (model.statusInsulation != ContentOptions.normal.value &&
        (getImageByProblem(ImageProblems.muc1_1).isEmpty||
            getAbnormalByCategoryIndex(ImageProblems.muc1_1).abnormalId.isNullOrEmpty() ||
            model.statusInsulationAbnormal.isNullOrBlank())) {
      return false;
    }
    return true;
  }

  @override
  Future getData({String equipmentId}) async {
    return getDataLine('lineInsulationsModel', equipmentId: equipmentId);
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as InsulationModel;
    if (equipmentsDestination.length > 1) {
      return model.lineInsulationsAbnormal == ContentOptions.normal.value;
    }
    return true;
  }

  @override
  Future updateData() async {
    final model = dataModel.value as InsulationModel;
    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'lineInsulation');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory,
      testType: transformerTicketController.testType);

  @override
  Future copyData() async {
    final originalModel =
        await getData(equipmentId: equipmentModel.id) as InsulationModel;
    originalModel.images = [];

    dataModel.value = originalModel;
    invalid.refresh();
  }
}

