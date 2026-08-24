// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/line/popups/lighting_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/content_option.dart';
import '../../../../../../common/constance/image_problems.dart';

class LightingController<T> extends BasePopupController {
  LightingController() {
    dataModel = LightingModel().obs;
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as LightingModel;
    switch (type) {
      case ImageProblems.muc1_0:
        {
          if (model.lineStatus == null || model.lineGroundingStatus == null) {
            if (model.lineLightingAbnormal != null) {
              model.lineLightingAbnormal = null;
              invalid.refresh();
            }
            return;
          }

          if (model.lineStatus != ContentOptions.normal.value ||
              model.lineGroundingStatus != ContentOptions.normal.value) {
            //bất thường
            if (model.lineLightingAbnormal != ContentOptions.weirdo.value) {
              model.lineLightingAbnormal = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else {
            model.lineLightingAbnormal = ContentOptions.normal.value;
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
    final model = dataModel.value as LightingModel;
    if (model.validateData() && checkValidAbnormal()) return true;
    return false;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as LightingModel;

    if (model.lineStatus != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_1).isEmpty||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1).abnormalId.isNullOrEmpty() ||
                model.lineStatusAbnormal.isNullOrBlank()) ||
        model.lineGroundingStatus != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_2).isEmpty||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2).abnormalId.isNullOrEmpty() ||
                model.lineGroundingStatusAbnormal.isNullOrBlank())) {
      return false;
    }
    return true;
  }

  @override
  Future getData({String equipmentId}) async {
    return getDataLine('lighLighting', equipmentId: equipmentId);
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as LightingModel;
    if (equipmentsDestination.length > 1) {
      return model.lineLightingAbnormal == ContentOptions.normal.value;
    }
    return true;
  }

  @override
  Future updateData() async {
    final model = dataModel.value as LightingModel;
    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'lighLighting');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory,
      testType: transformerTicketController.testType);

  @override
  Future copyData() async {
    final originalModel =
        await getData(equipmentId: equipmentModel.id) as LightingModel;
    originalModel.images = [];

    dataModel.value = originalModel;
    invalid.refresh();
  }
}

