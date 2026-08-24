// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/role_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/content_option.dart';
import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';

class RoleController<T> extends BasePopupController {
  RoleController() {
    dataModel = RoleModel().obs;
  }

  RxBool isEqual110 = true.obs;

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as RoleModel;
    switch (type) {
      case 1:
        {
          if (model.activeSourceStatus == null ||
              model.statusOperatingLights == null ||
              model.statusIndicatorStatus == null) {
            if (model.protectionRelays != null) {
              model.protectionRelays = null;
              invalid.refresh();
            }
            break;
          }

          if (model.activeSourceStatus != ContentOptions.normal.value ||
              model.statusOperatingLights != ContentOptions.normal.value ||
              model.statusIndicatorStatus != ContentOptions.normal.value) {
            if (model.protectionRelays !=
                ContentOptions.weirdo.value) //bất thuong
            {
              model.protectionRelays = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else if (model.protectionRelays !=
              ContentOptions.normal.value) //khong binh thuong
          {
            model.protectionRelays = ContentOptions.normal.value;
          }
        }
        break;
      case 2:
        {
          if (model.statusSignalLights == null ||
              model.statusIndicatorDevicesMIMIC == null ||
              model.conditionDryingLightingCircuitSystem == null ||
              model.circuitStatus == null ||
              model.invasionForeignAnimals == null ||
              model.checkStateIndustrialHygiene == null) {
            if (model.secondChamber != null) {
              model.secondChamber = null;
              invalid.refresh();
            }
            break;
          }

          if (model.statusSignalLights != ContentOptions.normal.value ||
              model.statusIndicatorDevicesMIMIC !=
                  ContentOptions.normal.value ||
              model.conditionDryingLightingCircuitSystem !=
                  ContentOptions.normal.value ||
              model.circuitStatus != ContentOptions.normal.value ||
              model.invasionForeignAnimals != ContentOptions.normal.value ||
              model.checkStateIndustrialHygiene !=
                  ContentOptions.normal.value) {
            if (model.secondChamber != ContentOptions.weirdo.value) //bất thuong
            {
              model.secondChamber = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else if (model.secondChamber !=
              ContentOptions.normal.value) //khong binh thuong
          {
            model.secondChamber = ContentOptions.normal.value;
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  bool checkValid() {
    final model = dataModel.value as RoleModel;
    if (model.validateData() ||
        !checkValidAbnormal() ||
        (isEqual110.value == false &&
            (model.secondChamber == null ||
                model.statusSignalLights == null ||
                model.statusIndicatorDevicesMIMIC == null ||
                model.conditionDryingLightingCircuitSystem == null ||
                model.circuitStatus == null ||
                model.invasionForeignAnimals == null ||
                model.checkStateIndustrialHygiene == null))) return false;
    return true;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as RoleModel;

    if ((model.activeSourceStatus != ContentOptions.normal.value && (model.activeSourceStatusAbnormal.isNullOrBlank() || getImageByProblem(ImageProblems.muc1_1).isEmpty || getAbnormalByCategoryIndex(ImageProblems.muc1_1).abnormalId.isNullOrEmpty())) ||
        (model.statusOperatingLights != ContentOptions.normal.value &&
            (model.statusOperatingLightsAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_2).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.statusIndicatorStatus != ContentOptions.normal.value &&
            (model.statusIndicatorStatusAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_3).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_3)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (isEqual110.value == false &&
            ((model.statusSignalLights != ContentOptions.normal.value && (model.statusSignalLightsAbnormal.isNullOrBlank() || getImageByProblem(ImageProblems.muc2_1).isEmpty || getAbnormalByCategoryIndex(ImageProblems.muc2_1).abnormalId.isNullOrEmpty())) ||
                (model.statusIndicatorDevicesMIMIC != ContentOptions.normal.value &&
                    (model.statusIndicatorDevicesMIMICAbnormal.isNullOrBlank() ||
                        getImageByProblem(ImageProblems.muc2_2).isEmpty ||
                        getAbnormalByCategoryIndex(ImageProblems.muc2_2)
                            .abnormalId
                            .isNullOrEmpty())) ||
                (model.conditionDryingLightingCircuitSystem != ContentOptions.normal.value &&
                    (model.conditionDryingLightingCircuitSystemAbnormal.isNullOrBlank() ||
                        getImageByProblem(ImageProblems.muc2_3).isEmpty ||
                        getAbnormalByCategoryIndex(ImageProblems.muc2_3)
                            .abnormalId
                            .isNullOrEmpty())) ||
                (model.circuitStatus != ContentOptions.normal.value &&
                    (model.circuitStatusAbnormal.isNullOrBlank() ||
                        getImageByProblem(ImageProblems.muc2_4).isEmpty ||
                        getAbnormalByCategoryIndex(ImageProblems.muc2_4)
                            .abnormalId
                            .isNullOrEmpty())) ||
                (model.invasionForeignAnimals != ContentOptions.normal.value &&
                    (model.invasionForeignAnimalsAbnormal.isNullOrBlank() ||
                        getImageByProblem(ImageProblems.muc2_5).isEmpty ||
                        getAbnormalByCategoryIndex(ImageProblems.muc2_5)
                            .abnormalId
                            .isNullOrEmpty())) ||
                (model.checkStateIndustrialHygiene != ContentOptions.normal.value &&
                    (model.checkStateIndustrialHygieneAbnormal.isNullOrBlank() ||
                        getImageByProblem(ImageProblems.muc2_6).isEmpty ||
                        getAbnormalByCategoryIndex(ImageProblems.muc2_6)
                            .abnormalId
                            .isNullOrEmpty()))))) {
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

      isEqual110.value = data['isEqual110'] ?? true;

      final model =
          data != null ? RoleModel.fromJson(data['role']) : RoleModel();

      if (model.secondChamber != null) {
        isEqual110.value = false;
      }
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
    final model = dataModel.value as RoleModel;
    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'role');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory);

  @override
  Future copyData() async {
    final RoleModel originalModel =
        await getData(equipmentId: equipmentModel.id);
    final modelCurrent = RoleModel();
    setTile(modelCurrent);
    if (originalModel == null) {
      return;
    }
    modelCurrent.protectionRelays =
        getValueCopySubstation(originalModel.protectionRelays);
    modelCurrent.activeSourceStatus =
        getValueCopySubstation(originalModel.activeSourceStatus);
    modelCurrent.statusOperatingLights =
        getValueCopySubstation(originalModel.statusOperatingLights);
    modelCurrent.statusIndicatorStatus =
        getValueCopySubstation(originalModel.statusIndicatorStatus);
    if (isEqual110.value == false) {
      modelCurrent.secondChamber =
          getValueCopySubstation(originalModel.secondChamber);
      modelCurrent.statusSignalLights =
          getValueCopySubstation(originalModel.statusSignalLights);
      modelCurrent.statusIndicatorDevicesMIMIC =
          getValueCopySubstation(originalModel.statusIndicatorDevicesMIMIC);
      modelCurrent.conditionDryingLightingCircuitSystem =
          getValueCopySubstation(
              originalModel.conditionDryingLightingCircuitSystem);
      modelCurrent.circuitStatus =
          getValueCopySubstation(originalModel.circuitStatus);
      modelCurrent.invasionForeignAnimals =
          getValueCopySubstation(originalModel.invasionForeignAnimals);
      modelCurrent.checkStateIndustrialHygiene =
          getValueCopySubstation(originalModel.checkStateIndustrialHygiene);
    }

    dataModel.value = modelCurrent;
    invalid.refresh();
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as RoleModel;
    if (equipmentsDestination.length > 1) {
      return model.protectionRelays == ContentOptions.normal.value ||
          (isEqual110.value == false &&
              model.secondChamber == ContentOptions.normal.value);
    }
    return true;
  }
}

