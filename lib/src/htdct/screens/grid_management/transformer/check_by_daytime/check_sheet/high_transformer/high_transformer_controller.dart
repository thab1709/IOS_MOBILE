// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/transformers_model.dart';
import 'package:evnmobile/src/htdct/models/weirdo_message.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';
import '../../../../../../../htld/common/constance/content_option.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';

import '../../../../../../common/utils/common.dart';

class HighTransformerController<T> extends BasePopupController {
  HighTransformerController() {
    dataModel = TransformersModel().obs;
  }

  RxDouble degreeDifferenceOilValue = 0.0.obs;
  RxDouble degreeDifferenceHighValue = 0.0.obs;
  RxDouble degreeDifferenceMediumValue = 0.0.obs;
  RxDouble degreeDifferenceLowValue = 0.0.obs;

  bool isMoreThan63kvA = true;
  RxDouble stepCounterIndexValue = 0.0.obs;
  double oldStepCounterIndex = 0;
  bool triggerCounterIndexWarning = true;
  bool triggerDegreeDifferenceWarning1 = true;
  bool triggerDegreeDifferenceWarning2 = true;
  bool triggerDegreeDifferenceWarning3 = true;
  bool triggerDegreeDifferenceWarning4 = true;
  bool triggerDegreeDifferenceAbnormal = false;
  bool showingDialogWarning = false;

  void updateDegreeDifference(int index) {
    if (triggerDegreeDifferenceAbnormal) {
      final model = dataModel.value as TransformersModel;
      switch (index) {
        case 1:
          {
            if (model.watchMBAFaceOil != null &&
                model.mbaProtectionMeterOil != null) {
              model.degreeDifferenceOil = roundDouble(
                      model.watchMBAFaceOil - model.mbaProtectionMeterOil, 2)
                  .abs();
              degreeDifferenceOilValue.value = model.degreeDifferenceOil;

              if (showingDialogWarning == true) {
                triggerDegreeDifferenceWarning1 = false;
              }

              if (model.degreeDifferenceOil > 50 &&
                  triggerDegreeDifferenceWarning1 == true) {
                triggerDegreeDifferenceWarning1 = false;
                showingDialogWarning = true;
                hShowDialogOneButton(HighElectricStrings.warningInputValue,
                    action: () {
                  showingDialogWarning = false;
                });
              }
            } else {
              model.degreeDifferenceOil = null;
              degreeDifferenceOilValue.value = model.degreeDifferenceOil;
            }
          }
          degreeDifferenceOilValue.refresh();
          break;
        case 2:
          {
            if (model.watchMBAFaceHigh != null &&
                model.mbaProtectionMeterHigh != null) {
              model.degreeDifferenceHigh = roundDouble(
                      model.watchMBAFaceHigh - model.mbaProtectionMeterHigh, 2)
                  .abs();
              degreeDifferenceHighValue.value = model.degreeDifferenceHigh;

              if (showingDialogWarning == true) {
                triggerDegreeDifferenceWarning2 = false;
              }

              if (model.degreeDifferenceHigh > 50 &&
                  triggerDegreeDifferenceWarning2 == true) {
                triggerDegreeDifferenceWarning2 = false;
                showingDialogWarning = true;
                hShowDialogOneButton(HighElectricStrings.warningInputValue,
                    action: () {
                  showingDialogWarning = false;
                });
              }
            } else {
              model.degreeDifferenceHigh = null;
              degreeDifferenceHighValue.value = model.degreeDifferenceHigh;
            }
          }
          degreeDifferenceHighValue.refresh();
          break;
        case 3:
          {
            if (model.watchMBAFaceMedium != null &&
                model.mbaProtectionMeterMedium != null) {
              model.degreeDifferenceMedium = roundDouble(
                      model.watchMBAFaceMedium - model.mbaProtectionMeterMedium,
                      2)
                  .abs();
              degreeDifferenceMediumValue.value = model.degreeDifferenceMedium;
              if (showingDialogWarning == true) {
                triggerDegreeDifferenceWarning3 = false;
              }

              if (model.degreeDifferenceMedium > 50 &&
                  triggerDegreeDifferenceWarning3 == true) {
                triggerDegreeDifferenceWarning3 = false;
                showingDialogWarning = true;
                hShowDialogOneButton(HighElectricStrings.warningInputValue,
                    action: () {
                  showingDialogWarning = false;
                });
              }
            } else {
              model.degreeDifferenceMedium = null;
              degreeDifferenceMediumValue.value = model.degreeDifferenceMedium;
            }
          }
          degreeDifferenceMediumValue.refresh();
          break;
        case 4:
          {
            if (model.watchMBAFaceLow != null &&
                model.mbaProtectionMeterLow != null) {
              model.degreeDifferenceLow = roundDouble(
                      model.watchMBAFaceLow - model.mbaProtectionMeterLow, 2)
                  .abs();

              degreeDifferenceLowValue.value = model.degreeDifferenceLow;

              if (showingDialogWarning == true) {
                triggerDegreeDifferenceWarning4 = false;
              }

              if (model.degreeDifferenceLow > 50 &&
                  triggerDegreeDifferenceWarning4 == true) {
                triggerDegreeDifferenceWarning4 = false;
                showingDialogWarning = true;
                hShowDialogOneButton(HighElectricStrings.warningInputValue,
                    action: () {
                  showingDialogWarning = false;
                });
              }
            } else {
              model.degreeDifferenceLow = null;
              degreeDifferenceLowValue.value = model.degreeDifferenceLow;
            }
          }
          degreeDifferenceLowValue.refresh();
          break;
        default:
          break;
      }

      if ((model.degreeDifferenceOil != null &&
              model.degreeDifferenceOil > 10) ||
          (model.degreeDifferenceHigh != null &&
              model.degreeDifferenceHigh > 10) ||
          (model.degreeDifferenceMedium != null &&
              model.degreeDifferenceMedium > 10) ||
          (model.degreeDifferenceLow != null &&
              model.degreeDifferenceLow > 10)) {
        model.degreeDifference = ContentOptions.weirdo.value;
      } else {
        model.degreeDifference = ContentOptions.normal.value;
        model.setUnusually(WeirdoMessage(ImageProblems.muc3_3, message: ''));
      }
    }
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as TransformersModel;
    switch (type) {
      case 1:
        {
          if (model.chirp == null ||
              model.bodyCondition == null ||
              model.statusTerminalsPorcelainSupportsMBA == null ||
              model.mbaoltcOilLevel == null ||
              model.desiccantParticleColor == null ||
              model.conditionDriveCabinetOLTC == null ||
              model.statusControlCabinets == null ||
              model.statusGroundingSystemTransformer == null ||
              model.conditionCoolingFanSystem == null ||
              // (isMoreThan63kvA &&
              //     model.conditionMBACirculatingOilSystem == null) ||
              model.checkFireProtectionSystem == null ||
              model.riskCausingOtherIncidents == null) {
            if (model.checkBonded != null) {
              model.checkBonded = null;
              invalid.refresh();
            }
            break;
          }
          if (model.chirp != ContentOptions.normal.value ||
              model.bodyCondition != ContentOptions.normal.value ||
              model.statusTerminalsPorcelainSupportsMBA !=
                  ContentOptions.normal.value ||
              model.mbaoltcOilLevel != ContentOptions.normal.value ||
              model.desiccantParticleColor != ContentOptions.normal.value ||
              model.conditionDriveCabinetOLTC != ContentOptions.normal.value ||
              model.statusControlCabinets != ContentOptions.normal.value ||
              model.statusGroundingSystemTransformer !=
                  ContentOptions.normal.value ||
              model.conditionCoolingFanSystem != ContentOptions.normal.value ||
              // (isMoreThan63kvA &&
              //     model.conditionMBACirculatingOilSystem !=
              //         ContentOptions.normal.value) ||
              model.conditionMBACirculatingOilSystem ==
                  ContentOptions.weirdo.value ||
              model.checkFireProtectionSystem != ContentOptions.normal.value ||
              model.riskCausingOtherIncidents != ContentOptions.normal.value) {
            if (model.checkBonded !=
                ContentOptions.weirdo.value) //khong binh thuong
            {
              model.checkBonded = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else if (model.checkBonded !=
              ContentOptions.normal.value) //khong binh thuong
          {
            model.checkBonded = ContentOptions.normal.value;
            removeImageOfProblem(ImageProblems.muc1_0);
          }
        }
        break;
      case 2:
        {
          if (model.operatingParameters == null) {
            if (model.mbaLoadTest != null) {
              model.mbaLoadTest = null;
              invalid.refresh();
            }
            break;
          }

          if (model.operatingParameters != ContentOptions.normal.value) {
            if (model.mbaLoadTest !=
                ContentOptions.weirdo.value) //khong binh thuong
            {
              model.mbaLoadTest = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else if (model.mbaLoadTest !=
              ContentOptions.normal.value) //khong binh thuong
          {
            model.mbaLoadTest = ContentOptions.normal.value;
            removeImageOfProblem(ImageProblems.muc2_0);
          }
        }
        break;
      case 3:
        {
          if (model.watchMBAFace == null ||
              model.mbaProtectionMeter == null ||
              model.degreeDifference == null) {
            if (model.oilTemperature != null) {
              model.oilTemperature = null;
              invalid.refresh();
            }
            break;
          }
          if (model.watchMBAFace != ContentOptions.normal.value ||
              model.mbaProtectionMeter != ContentOptions.normal.value ||
              model.degreeDifference != ContentOptions.normal.value) {
            if (model.oilTemperature !=
                ContentOptions.weirdo.value) //khong binh thuong
            {
              model.oilTemperature = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else if (model.oilTemperature !=
              ContentOptions.normal.value) //khong binh thuong
          {
            model.oilTemperature = ContentOptions.normal.value;
            removeImageOfProblem(ImageProblems.muc3_0);
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  bool checkValid() {
    final model = dataModel.value as TransformersModel;
    if (
        // (isMoreThan63kvA && model.conditionMBACirculatingOilSystem == null) ||

        model.validateData() || !checkValidAbnormal()) return false;
    return true;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as TransformersModel;

    //chưa có biểu hiện bất thường
    if ((model.chirp != ContentOptions.normal.value &&
            (model.chirpAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_1).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.bodyCondition != ContentOptions.normal.value &&
            (model.bodyConditionAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_2).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.statusTerminalsPorcelainSupportsMBA != ContentOptions.normal.value &&
            (model.statusTerminalsPorcelainSupportsMBAAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_3).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_3)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.mbaoltcOilLevel != ContentOptions.normal.value &&
            (model.mbaoltcOilLevelAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_4).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_4)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.desiccantParticleColor != ContentOptions.normal.value &&
            (model.desiccantParticleColorAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_5).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_5)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.conditionDriveCabinetOLTC != ContentOptions.normal.value &&
            (model.conditionDriveCabinetOLTCAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_6).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_6)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.statusControlCabinets != ContentOptions.normal.value &&
            (model.statusControlCabinetsAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_7).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_7)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.statusGroundingSystemTransformer != ContentOptions.normal.value &&
            (model.statusGroundingSystemTransformerAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_8).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_8)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.conditionCoolingFanSystem != ContentOptions.normal.value &&
            (model.conditionCoolingFanSystemAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_9).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_9)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (
            // isMoreThan63kvA &&
            model.conditionMBACirculatingOilSystem == ContentOptions.weirdo.value &&
                (model.conditionMBACirculatingOilSystemAbnormal.isNullOrBlank() ||
                    getImageByProblem(ImageProblems.muc1_10).isEmpty ||
                    getAbnormalByCategoryIndex(ImageProblems.muc1_10)
                        .abnormalId
                        .isNullOrEmpty())) ||
        (model.checkFireProtectionSystem != ContentOptions.normal.value &&
            (model.checkFireProtectionSystemAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_11).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_11)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.riskCausingOtherIncidents != ContentOptions.normal.value &&
            (model.riskCausingOtherIncidentsAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_12).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_12).abnormalId.isNullOrEmpty())) ||
        (model.operatingParameters != ContentOptions.normal.value && (model.operatingParametersAbnormal.isNullOrBlank() || getImageByProblem(ImageProblems.muc2_1).isEmpty || getAbnormalByCategoryIndex(ImageProblems.muc2_1).abnormalId.isNullOrEmpty())) ||
        (model.watchMBAFace != ContentOptions.normal.value && (model.watchMBAFaceAbnormal.isNullOrBlank() || getImageByProblem(ImageProblems.muc3_1).isEmpty || getAbnormalByCategoryIndex(ImageProblems.muc3_1).abnormalId.isNullOrEmpty())) ||
        (model.mbaProtectionMeter != ContentOptions.normal.value && (model.mbaProtectionMeterAbnormal.isNullOrBlank() || getImageByProblem(ImageProblems.muc3_2).isEmpty || getAbnormalByCategoryIndex(ImageProblems.muc3_2).abnormalId.isNullOrEmpty())) ||
        (model.degreeDifference != ContentOptions.normal.value && (model.degreeDifferenceAbnormal.isNullOrBlank() || getImageByProblem(ImageProblems.muc3_3).isEmpty || getAbnormalByCategoryIndex(ImageProblems.muc3_3).abnormalId.isNullOrEmpty()))) {
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

      if (data != null) {
        isMoreThan63kvA = data['isMoreThan63kvA'];
        oldStepCounterIndex = data['oldStepCounterIndex'] != null
            ? double.parse(data['oldStepCounterIndex'])
            : 0;
      }
      final model = (data != null && data['transformers'] != null)
          ? TransformersModel.fromJson(data['transformers'])
          : TransformersModel();

      degreeDifferenceOilValue.value = model.degreeDifferenceOil;
      degreeDifferenceHighValue.value = model.degreeDifferenceHigh;
      degreeDifferenceMediumValue.value = model.degreeDifferenceMedium;
      degreeDifferenceLowValue.value = model.degreeDifferenceLow;

      if (transformerTicketController.isHasPermissionEdit()) {
        stepCounterIndexValue.value = model.stepCounterIndex == null &&
                oldStepCounterIndex != null
            ? null
            : roundDouble(
                double.parse(model.stepCounterIndex) - oldStepCounterIndex, 2);
      } else {
        stepCounterIndexValue.value =
            double.parse(model.numberTimesSwitchSteps);
      }

      if (model.stepCounterIndex != null) {
        triggerCounterIndexWarning = false;
        triggerDegreeDifferenceWarning1 = false;
        triggerDegreeDifferenceWarning2 = false;
        triggerDegreeDifferenceWarning3 = false;
        triggerDegreeDifferenceWarning4 = false;
      }

      model.title = '${equipmentModel.name}';
      // setValueTemperatureAndHumidity(data);
      model.equipmentId = equipmentId;
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
    final model = dataModel.value as TransformersModel;
    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'transformers');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory);

  @override
  Future copyData() async {
    final TransformersModel originalModel =
        await getData(equipmentId: equipmentModel.id);
    final modelCurrent = TransformersModel();
    setTile(modelCurrent);

    modelCurrent.checkBonded =
        getValueCopySubstation(originalModel.checkBonded);
    modelCurrent.chirp = getValueCopySubstation(originalModel.chirp);
    modelCurrent.bodyCondition =
        getValueCopySubstation(originalModel.bodyCondition);
    modelCurrent.statusTerminalsPorcelainSupportsMBA = getValueCopySubstation(
        originalModel.statusTerminalsPorcelainSupportsMBA);
    modelCurrent.mbaoltcOilLevel =
        getValueCopySubstation(originalModel.mbaoltcOilLevel);
    modelCurrent.desiccantParticleColor =
        getValueCopySubstation(originalModel.desiccantParticleColor);
    if (modelCurrent.desiccantParticleColor != null) {
      modelCurrent.desiccantParticleColorMBA =
          originalModel.desiccantParticleColorMBA;
      modelCurrent.desiccantParticleColorOLTC =
          originalModel.desiccantParticleColorOLTC;
    }
    modelCurrent.conditionDriveCabinetOLTC =
        getValueCopySubstation(originalModel.conditionDriveCabinetOLTC);
    if (modelCurrent.conditionDriveCabinetOLTC != null) {
      modelCurrent.stepCounterIndex = originalModel.stepCounterIndex;
      modelCurrent.numberTimesSwitchSteps =
          originalModel.numberTimesSwitchSteps;
      stepCounterIndexValue.value =
          double.parse(modelCurrent.numberTimesSwitchSteps);
      if (stepCounterIndexValue.value > 100) {
        await hShowDialogOneButton(HighElectricStrings.warningInputValue);
      }
    }
    modelCurrent.statusControlCabinets =
        getValueCopySubstation(originalModel.statusControlCabinets);
    modelCurrent.statusGroundingSystemTransformer =
        getValueCopySubstation(originalModel.statusGroundingSystemTransformer);
    modelCurrent.conditionCoolingFanSystem =
        getValueCopySubstation(originalModel.conditionCoolingFanSystem);
    modelCurrent.conditionMBACirculatingOilSystem =
        getValueCopySubstation(originalModel.conditionMBACirculatingOilSystem);
    modelCurrent.checkFireProtectionSystem =
        getValueCopySubstation(originalModel.checkFireProtectionSystem);
    modelCurrent.riskCausingOtherIncidents =
        getValueCopySubstation(originalModel.riskCausingOtherIncidents);

    modelCurrent.mbaLoadTest =
        getValueCopySubstation(originalModel.mbaLoadTest);
    modelCurrent.operatingParameters =
        getValueCopySubstation(originalModel.operatingParameters);

    modelCurrent.oilTemperature =
        getValueCopySubstation(originalModel.oilTemperature);
    modelCurrent.watchMBAFace =
        getValueCopySubstation(originalModel.watchMBAFace);
    modelCurrent.mbaProtectionMeter =
        getValueCopySubstation(originalModel.mbaProtectionMeter);
    modelCurrent.degreeDifference =
        getValueCopySubstation(originalModel.degreeDifference);

    degreeDifferenceOilValue.value = null;
    degreeDifferenceHighValue.value = null;
    degreeDifferenceMediumValue.value = null;
    degreeDifferenceLowValue.value = null;

    dataModel.value = modelCurrent;
    invalid.refresh();
  }

  Future updateStepCounterIndex() async {
    final model = dataModel.value as TransformersModel;
    if (!model.stepCounterIndex.isNullOrEmpty()) {
      model.numberTimesSwitchSteps = (roundDouble(
              double.parse(model.stepCounterIndex) - oldStepCounterIndex, 2))
          .toString();
      model.stepCounterIndex =
          roundDouble(double.parse(model.stepCounterIndex), 2).toString();
      stepCounterIndexValue.value = double.parse(model.numberTimesSwitchSteps);

      if (stepCounterIndexValue.value > 100 &&
          triggerCounterIndexWarning == true) {
        triggerCounterIndexWarning = false;
        await hShowDialogOneButton(HighElectricStrings.warningInputValue);
      }
    } else {
      model.numberTimesSwitchSteps = null;
      stepCounterIndexValue.value = null;
    }

    stepCounterIndexValue.refresh();
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as TransformersModel;
    if (equipmentsDestination.length > 1) {
      return model.checkBonded == ContentOptions.normal.value &&
          model.mbaLoadTest == ContentOptions.normal.value &&
          model.oilTemperature == ContentOptions.normal.value;
    }
    return true;
  }
}

