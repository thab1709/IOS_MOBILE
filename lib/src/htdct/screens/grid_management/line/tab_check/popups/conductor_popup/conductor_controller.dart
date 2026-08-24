// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/line/popups/conductor_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/content_option.dart';
import '../../../../../../common/constance/image_problems.dart';

class ConductorController<T> extends BasePopupController {
  ConductorController() {
    dataModel = ConductorModel().obs;
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as ConductorModel;
    switch (type) {
      case ImageProblems.muc1_0:
        {
          if (model.lineConductorStatus == null ||
              model.lockStatus == null) {
            if (model.lineConductorAbnormal != null) {
              model.lineConductorAbnormal = null;
              invalid.refresh();
            }
            return;
          }

          if (model.lineConductorStatus != ContentOptions.normal.value ||
              model.lockStatus != ContentOptions.normal.value) {
            //bất thường
            if (model.lineConductorAbnormal != ContentOptions.weirdo.value) {
              model.lineConductorAbnormal = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else {
            if (model.lineConductorAbnormal != ContentOptions.normal.value) {
              model.lineConductorAbnormal = ContentOptions.normal.value;
              invalid.refresh();
            }
          }
        }
        break;

      default:
        break;
    }
  }

  @override
  bool checkValid() {
    final model = dataModel.value as ConductorModel;
    if (model.validateData() && checkValidAbnormal()) return true;
    return false;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as ConductorModel;

    if (model.lineConductorStatus == ContentOptions.weirdo.value &&
            (getImageByProblem(ImageProblems.muc1_1).isEmpty||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1).abnormalId.isNullOrEmpty() ||
                model.lineConductorStatusAbnormal.isNullOrBlank()) ||
        model.lockStatus == ContentOptions.weirdo.value &&
            (getImageByProblem(ImageProblems.muc1_2).isEmpty||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2).abnormalId.isNullOrEmpty() ||
                model.lockStatusAbnormal.isNullOrBlank())) {
      return false;
    }
    return true;
  }

  @override
  Future getData({String equipmentId}) async {
    return getDataLine('lineConductor', equipmentId: equipmentId);
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as ConductorModel;
    if (equipmentsDestination.length > 1) {
      return model.lineConductorAbnormal == ContentOptions.normal.value;
    }
    return true;
  }

  @override
  Future updateData() async {
    final model = dataModel.value as ConductorModel;
    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'lineConductor');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory,
      testType: transformerTicketController.testType);

  @override
  Future copyData() async {
    final originalModel =
        await getData(equipmentId: equipmentModel.id) as ConductorModel;

    originalModel.images = [];

    dataModel.value = originalModel;

    invalid.refresh();
  }
}

