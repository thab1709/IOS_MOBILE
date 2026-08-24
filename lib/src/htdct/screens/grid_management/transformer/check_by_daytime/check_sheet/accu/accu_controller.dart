// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/accu_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';

class ACCUController<T> extends BasePopupController {
  ACCUController() {
    dataModel = ACCUModel().obs;
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as ACCUModel;
    switch (type) {
      case 1:
        {
          if (model.conditionBottle == null ||
              model.conditionCconnectingRod == null ||
              model.troubleLightingStatus == null) {
            if (model.checkACCUSystem != null) {
              model.checkACCUSystem = null;
              invalid.refresh();
            }
            break;
          }

          if (model.conditionBottle != ContentOptions.normal.value ||
              model.conditionCconnectingRod != ContentOptions.normal.value ||
              model.troubleLightingStatus != ContentOptions.normal.value) {
            if (model.checkACCUSystem != ContentOptions.weirdo.value) {
              //bất thuong
              model.checkACCUSystem = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else {
            if (model.checkACCUSystem != ContentOptions.normal.value) {
              //khong binh thuong
              model.checkACCUSystem = ContentOptions.normal.value;
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
    final model = dataModel.value as ACCUModel;
    if (model.validateData() || !checkValidAbnormal()) return false;
    return true;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as ACCUModel;

    if ((model.conditionBottle != ContentOptions.normal.value &&
            (model.conditionBottleAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_1).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.conditionCconnectingRod != ContentOptions.normal.value &&
            (model.conditionCconnectingRodAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_2).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.troubleLightingStatus != ContentOptions.normal.value &&
            (model.troubleLightingStatusAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_3).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_3)
                    .abnormalId
                    .isNullOrEmpty()))) {
      return false;
    }

    return true;
  }

  @override
  Future getData({String equipmentId}) async {
    final response = await transformerService.get(
        ticketId: transformerTicketController.ticketId,
        endpoint: getEndPoint(),
        equipmentId: equipmentId ?? equipmentModel.id);
    if (response.isLoadSuccess) {
      final data = json.decode(response.data['data'].toString());
      final model =
          data != null ? ACCUModel.fromJson(data['accu']) : ACCUModel();

      model.title = '${equipmentModel.name}';
      model.equipmentId = equipmentId;
      // setValueTemperatureAndHumidity(data);
      if (equipmentsDestination == null) {
        dataModel.value = model;
        invalid.refresh();
      } else {
        return model;
      }
    } else {
      await hShowDialogOneButton(response.message);
    }
    return null;
  }

  @override
  Future updateData() async {
    final model = dataModel.value as ACCUModel;
    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'accu');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory);

  @override
  Future copyData() async {
    final originalModel = await getData(equipmentId: equipmentModel.id);
    final modelCurrent = ACCUModel();
    setTile(modelCurrent);

    modelCurrent.checkACCUSystem =
        getValueCopySubstation(originalModel.checkACCUSystem);
    modelCurrent.conditionBottle =
        getValueCopySubstation(originalModel.conditionBottle);
    modelCurrent.conditionCconnectingRod =
        getValueCopySubstation(originalModel.conditionCconnectingRod);
    modelCurrent.troubleLightingStatus =
        getValueCopySubstation(originalModel.troubleLightingStatus);
    dataModel.value = modelCurrent;
    invalid.refresh();
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as ACCUModel;
    if (equipmentsDestination.length > 1) {
      return model.checkACCUSystem == ContentOptions.normal.value;
    }
    return true;
  }
}

