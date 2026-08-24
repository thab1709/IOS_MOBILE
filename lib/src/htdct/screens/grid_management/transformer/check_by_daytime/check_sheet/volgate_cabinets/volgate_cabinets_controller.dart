// @dart=2.9
import 'dart:convert';
import 'dart:math';

import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/content_option.dart';
import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../../common/utils/common.dart';
import '../../../../../../models/day_night/popups/voltage_cabinet_model.dart';

class VoltageCabinetController<T> extends BasePopupController {
  VoltageCabinetController() {
    dataModel = VoltageCabinetModel().obs;
  }

  RxDouble degreeDifferenceValue = 0.0.obs;
  RxString busbarVoltageDC1Value = ''.obs;

  bool triggerAutoUpdateAbnormal = false;

  //type - mục lớn
  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as VoltageCabinetModel;
    switch (type) {
      case 1:
        {
          if ((model.cabinetsType != ContentOptions.CtElectricCabinet.value &&
                  model.statusIndicatorLights == null) ||
              model.cabinetStatus == null ||
              model.conditionDryingLighting == null ||
              model.circuitStatusClampATM == null ||
              model.waterproofStatus == null ||
              model.checkGroundingSystem == null ||
              model.stateIndustrialHygiene == null ||
              (model.cabinetsType == ContentOptions.DcElectricCabinet.value &&
                  model.busbarVoltageDC == null) ||
              (model.cabinetsType == ContentOptions.AcElectricCabinet.value &&
                  model.busbarVoltageAC == null) ||
              (model.cabinetsType ==
                      ContentOptions.ScadaElectricCabinet.value &&
                  (model.mainBoardOperatingStatus == null ||
                      model.statusExpansionCardOperatingStatus == null ||
                      model.systemStatusHMIServerNetworkSwitchGPS == null)) ||
              (model.cabinetsType == ContentOptions.CtElectricCabinet.value &&
                  (model.statusCabinetLeadClamp == null ||
                      model.statusIndicatorLightsParameters == null)) ||
              (model.cabinetsType == ContentOptions.MkElectricCabinet.value &&
                  (model.statusOutdoorLightingHT == null ||
                      model.workingStatusMergingUnit == null))) {
            if (model.checkVoltageCabinets != null) {
              model.checkVoltageCabinets = null;
              invalid.refresh();
            }
            break;
          }

          if ((model.cabinetsType != ContentOptions.CtElectricCabinet.value &&
                  model.statusIndicatorLights != ContentOptions.normal.value) ||
              model.cabinetStatus != ContentOptions.normal.value ||
              model.conditionDryingLighting != ContentOptions.normal.value ||
              model.circuitStatusClampATM != ContentOptions.normal.value ||
              model.waterproofStatus != ContentOptions.normal.value ||
              model.checkGroundingSystem != ContentOptions.normal.value ||
              model.stateIndustrialHygiene != ContentOptions.normal.value ||
              (model.cabinetsType == ContentOptions.DcElectricCabinet.value &&
                  model.busbarVoltageDC != ContentOptions.normal.value) ||
              (model.cabinetsType == ContentOptions.AcElectricCabinet.value &&
                  model.busbarVoltageAC != ContentOptions.normal.value) ||
              (model.cabinetsType ==
                      ContentOptions.ScadaElectricCabinet.value &&
                  (model.mainBoardOperatingStatus !=
                          ContentOptions.normal.value ||
                      model.statusExpansionCardOperatingStatus !=
                          ContentOptions.normal.value ||
                      model.systemStatusHMIServerNetworkSwitchGPS !=
                          ContentOptions.normal.value)) ||
              (model.cabinetsType == ContentOptions.CtElectricCabinet.value &&
                  (model.statusCabinetLeadClamp !=
                          ContentOptions.normal.value ||
                      model.statusIndicatorLightsParameters !=
                          ContentOptions.normal.value)) ||
              (model.cabinetsType == ContentOptions.MkElectricCabinet.value &&
                  (model.statusOutdoorLightingHT !=
                          ContentOptions.normal.value ||
                      model.workingStatusMergingUnit !=
                          ContentOptions.normal.value))) {
            if (model.checkVoltageCabinets !=
                ContentOptions.weirdo.value) //bất thuong
            {
              model.checkVoltageCabinets = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else if (model.checkVoltageCabinets !=
              ContentOptions.normal.value) //khong binh thuong
          {
            model.checkVoltageCabinets = ContentOptions.normal.value;
            removeImageOfProblem(ImageProblems.muc1_0);
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  bool checkValid() {
    final model = dataModel.value as VoltageCabinetModel;
    if (model.validateData() || !checkValidAbnormal()) return false;
    return true;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as VoltageCabinetModel;

    if ((model.cabinetsType != ContentOptions.CtElectricCabinet.value &&
            model.statusIndicatorLights != ContentOptions.normal.value &&
            (model.statusIndicatorLightsAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_1).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.cabinetStatus != ContentOptions.normal.value &&
            (model.cabinetStatusAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_2).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.conditionDryingLighting != ContentOptions.normal.value &&
            (model.conditionDryingLightingAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_3).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_3)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.circuitStatusClampATM != ContentOptions.normal.value &&
            (model.circuitStatusClampATMAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_4).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_4)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.waterproofStatus != ContentOptions.normal.value &&
            (model.waterproofStatusAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_5).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_5)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.checkGroundingSystem != ContentOptions.normal.value &&
            (model.checkGroundingSystemAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_6).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_6)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.stateIndustrialHygiene != ContentOptions.normal.value &&
            (model.stateIndustrialHygieneAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_7).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_7)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.cabinetsType == ContentOptions.DcElectricCabinet.value &&
            model.busbarVoltageDC != ContentOptions.normal.value &&
            (model.busbarVoltageDCAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_8).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_8)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.cabinetsType == ContentOptions.AcElectricCabinet.value &&
            model.busbarVoltageAC != ContentOptions.normal.value &&
            (model.busbarVoltageACAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_9).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_9)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.cabinetsType == ContentOptions.ScadaElectricCabinet.value &&
            ((model.mainBoardOperatingStatus != ContentOptions.normal.value &&
                    (model.mainBoardOperatingStatusAbnormal.isNullOrBlank() ||
                        getImageByProblem(ImageProblems.muc1_10).isEmpty ||
                        getAbnormalByCategoryIndex(ImageProblems.muc1_10)
                            .abnormalId
                            .isNullOrEmpty())) ||
                (model.statusExpansionCardOperatingStatus != ContentOptions.normal.value &&
                    (model.statusExpansionCardOperatingStatusAbnormal.isNullOrBlank() ||
                        getImageByProblem(ImageProblems.muc1_11).isEmpty ||
                        getAbnormalByCategoryIndex(ImageProblems.muc1_11)
                            .abnormalId
                            .isNullOrEmpty())) ||
                (model.systemStatusHMIServerNetworkSwitchGPS != ContentOptions.normal.value &&
                    (model.systemStatusHMIServerNetworkSwitchGPSAbnormal.isNullOrBlank() ||
                        getImageByProblem(ImageProblems.muc1_12).isEmpty ||
                        getAbnormalByCategoryIndex(ImageProblems.muc1_12)
                            .abnormalId
                            .isNullOrEmpty())))) ||
        (model.cabinetsType == ContentOptions.CtElectricCabinet.value && ((model.statusCabinetLeadClamp != ContentOptions.normal.value && (model.statusCabinetLeadClampAbnormal.isNullOrBlank() || getImageByProblem(ImageProblems.muc1_13).isEmpty || getAbnormalByCategoryIndex(ImageProblems.muc1_13).abnormalId.isNullOrEmpty())) || (model.statusIndicatorLightsParameters != ContentOptions.normal.value && (model.statusIndicatorLightsParametersAbnormal.isNullOrBlank() || getImageByProblem(ImageProblems.muc1_14).isEmpty || getAbnormalByCategoryIndex(ImageProblems.muc1_14).abnormalId.isNullOrEmpty())))) ||
        (model.cabinetsType == ContentOptions.MkElectricCabinet.value && ((model.statusOutdoorLightingHT != ContentOptions.normal.value && (model.statusOutdoorLightingHTAbnormal.isNullOrBlank() || getImageByProblem(ImageProblems.muc1_15).isEmpty || getAbnormalByCategoryIndex(ImageProblems.muc1_15).abnormalId.isNullOrEmpty())) || (model.workingStatusMergingUnit != ContentOptions.normal.value && (model.workingStatusMergingUnitAbnormal.isNullOrBlank() || getImageByProblem(ImageProblems.muc1_16).isEmpty))))) {
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
      final model = data != null
          ? VoltageCabinetModel.fromJson(data['voltageCabinets'])
          : VoltageCabinetModel();
      degreeDifferenceValue.value = model.degreeDifference;
      model.title = '${equipmentModel.name}';
      model.equipmentId = equipmentId;
      // setValueTemperatureAndHumidity(data);
      if (equipmentsDestination == null) {
        dataModel.value = model;
        // getBusbarVoltageDCTitle();
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
    final model = dataModel.value as VoltageCabinetModel;
    if (model.cabinetsType == ContentOptions.CtElectricCabinet.value) {
      model.statusIndicatorLights = null;
    } else if (model.cabinetsType != ContentOptions.DcElectricCabinet.value) {
      model.busbarVoltageDC = null;
      // model.dC2Plus = null;
      // model.dC2Subtract = null;
      model.dC1Plus = null;
      model.dC1Subtract = null;
    } else if (model.cabinetsType != ContentOptions.AcElectricCabinet.value) {
      model.busbarVoltageAC = null;
    } else if (model.cabinetsType !=
        ContentOptions.ScadaElectricCabinet.value) {
      model.mainBoardOperatingStatus = null;
      model.statusExpansionCardOperatingStatus = null;
      model.systemStatusHMIServerNetworkSwitchGPS = null;
    } else if (model.cabinetsType != ContentOptions.CtElectricCabinet.value) {
      model.statusCabinetLeadClamp = null;
      model.statusIndicatorLightsParameters = null;
    } else if (model.cabinetsType != ContentOptions.MkElectricCabinet.value) {
      model.statusOutdoorLightingHT = null;
      model.workingStatusMergingUnit = null;
    }

    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'voltageCabinets');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory);

  @override
  Future copyData() async {
    final VoltageCabinetModel originalModel =
        await getData(equipmentId: equipmentModel.id);
    final modelCurrent = VoltageCabinetModel();
    setTile(modelCurrent);
    if (originalModel == null) {
      return;
    }
    modelCurrent.cabinetsType = originalModel.cabinetsType;
    modelCurrent.statusIndicatorLights =
        getValueCopySubstation(originalModel.statusIndicatorLights);
    modelCurrent.cabinetStatus =
        getValueCopySubstation(originalModel.cabinetStatus);
    modelCurrent.conditionDryingLighting =
        getValueCopySubstation(originalModel.conditionDryingLighting);
    modelCurrent.circuitStatusClampATM =
        getValueCopySubstation(originalModel.circuitStatusClampATM);
    modelCurrent.waterproofStatus =
        getValueCopySubstation(originalModel.waterproofStatus);
    modelCurrent.checkGroundingSystem =
        getValueCopySubstation(originalModel.checkGroundingSystem);
    modelCurrent.stateIndustrialHygiene =
        getValueCopySubstation(originalModel.stateIndustrialHygiene);
    modelCurrent.mainBoardOperatingStatus =
        getValueCopySubstation(originalModel.mainBoardOperatingStatus);
    modelCurrent.statusExpansionCardOperatingStatus = getValueCopySubstation(
        originalModel.statusExpansionCardOperatingStatus);
    modelCurrent.systemStatusHMIServerNetworkSwitchGPS = getValueCopySubstation(
        originalModel.systemStatusHMIServerNetworkSwitchGPS);
    modelCurrent.statusCabinetLeadClamp =
        getValueCopySubstation(originalModel.statusCabinetLeadClamp);
    modelCurrent.statusIndicatorLightsParameters =
        getValueCopySubstation(originalModel.statusIndicatorLightsParameters);
    modelCurrent.statusOutdoorLightingHT =
        getValueCopySubstation(originalModel.statusOutdoorLightingHT);
    modelCurrent.workingStatusMergingUnit =
        getValueCopySubstation(originalModel.workingStatusMergingUnit);
    modelCurrent.busbarVoltageDC =
        getValueCopySubstation(originalModel.busbarVoltageDC);
    if (modelCurrent.busbarVoltageDC != null) {
      modelCurrent.dC1Plus = originalModel.dC1Plus;
      modelCurrent.dC1Subtract = originalModel.dC1Subtract;
    }
    modelCurrent.busbarVoltageAC =
        getValueCopySubstation(originalModel.busbarVoltageAC);
    if (modelCurrent.busbarVoltageAC != null) {
      modelCurrent.degreeDifference = originalModel.degreeDifference;
      modelCurrent.ia = originalModel.ia;
      modelCurrent.ib = originalModel.ib;
      modelCurrent.ic = originalModel.ic;
      modelCurrent.utb = originalModel.utb;
    }

    dataModel.value = modelCurrent;
    checkValidPattern(1);
    invalid.refresh();
  }

  void updateDegreeDifference() {
    final model = dataModel.value as VoltageCabinetModel;
    if (model.ia != null && model.ib != null && model.ic != null) {
      model.degreeDifference = roundDouble(
          max(model.ia, max(model.ib, model.ic)) -
              min(model.ia, min(model.ib, model.ic)),
          2);
    } else {
      model.degreeDifference = null;
    }
    degreeDifferenceValue.value = model.degreeDifference;
    degreeDifferenceValue.refresh();
  }

  Future<void> updateBusbarVoltageDC() async {
    final model = dataModel.value as VoltageCabinetModel;
    bool weirdo1;
    // var weirdo2 = false;
    if (model.dC1Plus != null && model.dC1Subtract != null) {
      final busbar =
          roundDouble(((model.dC1Plus) - (model.dC1Subtract)) / 2, 2);
      weirdo1 = busbar > 20 || busbar < -20;
    }
    // getBusbarVoltageDCTitle();
    if ((weirdo1 == true) &&
        model.busbarVoltageDC != ContentOptions.weirdo.value) {
      model.busbarVoltageDC = ContentOptions.weirdo.value;
      checkValidPattern(1);
    } else if ((weirdo1 == false) &&
        model.busbarVoltageDC != ContentOptions.normal.value) {
      await removeImageOfProblem(ImageProblems.muc1_8);
      model.busbarVoltageDC = ContentOptions.normal.value;
      checkValidPattern(1);
    }

    invalid.refresh();
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as VoltageCabinetModel;
    if (equipmentsDestination.length > 1) {
      return model.checkVoltageCabinets == ContentOptions.normal.value;
    }
    return true;
  }
}

