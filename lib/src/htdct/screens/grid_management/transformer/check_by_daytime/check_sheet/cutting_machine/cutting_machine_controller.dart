// @dart=2.9
import 'dart:async';
import 'dart:convert';

import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/common/utils/common.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/cutting_machine_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/content_option.dart';
import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';

class CuttingMachineController<T> extends BasePopupController {
  CuttingMachineController() {
    dataModel = CuttingMachineModel().obs;
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as CuttingMachineModel;
    switch (type) {
      case 1:
        {
          if ((model.cutterPosition == ContentOptions.outSite.value &&
                  model.conditionContactPoints == null) ||
              (model.cutterPosition == ContentOptions.outSite.value &&
                  model.conditionTransmissionCabinet == null) ||
              (model.cutterPosition == ContentOptions.inSite.value &&
                  model.conditionCableCompartment == null) ||
              (model.cutterPosition == ContentOptions.inSite.value &&
                  model.distributionRoomStatus == null) ||
              model.mechanicalStructureGrounding == null ||
              model.stateIndustrialHygiene == null ||
              (model.insulationClassificationGISCompartment !=
                      ContentOptions.vacuum.value &&
                  model.gasPressureSF6 == null)) {
            if (model.checkBonded != null) {
              model.checkBonded = null;
              invalid.refresh();
            }
            break;
          }

          if ((model.cutterPosition == ContentOptions.outSite.value &&
                  model.conditionContactPoints !=
                      ContentOptions.normal.value) ||
              (model.cutterPosition == ContentOptions.outSite.value &&
                  model.conditionTransmissionCabinet !=
                      ContentOptions.good.value) ||
              (model.cutterPosition == ContentOptions.inSite.value &&
                  model.conditionCableCompartment !=
                      ContentOptions.normal.value) ||
              (model.cutterPosition == ContentOptions.inSite.value &&
                  model.distributionRoomStatus !=
                      ContentOptions.normal.value) ||
              model.mechanicalStructureGrounding !=
                  ContentOptions.normal.value ||
              model.stateIndustrialHygiene != ContentOptions.normal.value ||
              (model.insulationClassificationGISCompartment !=
                      ContentOptions.vacuum.value &&
                  model.gasPressureSF6 != ContentOptions.normal.value)) {
            if (model.checkBonded != ContentOptions.weirdo.value) //bất thuong
            {
              model.checkBonded = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else if (model.checkBonded !=
              ContentOptions.normal.value) //khong binh thuong
          {
            model.checkBonded = ContentOptions.normal.value;
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
    final model = dataModel.value as CuttingMachineModel;
    if (model.validateData() ||
        !checkValidAbnormal() ||
        (model.cutterPosition == ContentOptions.outSite.value &&
            (model.conditionContactPoints == null ||
                model.conditionTransmissionCabinet == null)) ||
        (model.cutterPosition == ContentOptions.inSite.value &&
            (model.conditionCableCompartment == null ||
                model.temperature == null ||
                model.humidity == null ||
                model.ventilators == null ||
                model.distributionRoomStatus == null))) return false;
    return true;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as CuttingMachineModel;
    if ((model.cutterPosition == ContentOptions.outSite.value &&
            model.conditionContactPoints != ContentOptions.normal.value &&
            (model.conditionContactPointsAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_1).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1)
                        ?.abnormalId
                        ?.isNullOrEmpty() ==
                    true)) ||
        (model.cutterPosition == ContentOptions.outSite.value &&
            model.conditionTransmissionCabinet != ContentOptions.good.value &&
            (model.conditionTransmissionCabinetAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_2).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2)
                        ?.abnormalId
                        ?.isNullOrEmpty() ==
                    true)) ||
        (model.cutterPosition == ContentOptions.inSite.value &&
            model.conditionCableCompartment != ContentOptions.normal.value &&
            (model.conditionCableCompartmentAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_3).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_3)
                        ?.abnormalId
                        ?.isNullOrEmpty() ==
                    true)) ||
        (model.cutterPosition == ContentOptions.inSite.value &&
            model.distributionRoomStatus != ContentOptions.normal.value &&
            (model.distributionRoomStatusAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_4).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_4)
                        ?.abnormalId
                        ?.isNullOrEmpty() ==
                    true)) ||
        (model.mechanicalStructureGrounding != ContentOptions.normal.value &&
            (model.mechanicalStructureGroundingAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_5).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_5)
                        ?.abnormalId
                        ?.isNullOrEmpty() ==
                    true)) ||
        (model.stateIndustrialHygiene != ContentOptions.normal.value &&
            (model.stateIndustrialHygieneAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_6).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_6)
                        ?.abnormalId
                        ?.isNullOrEmpty() ==
                    true)) ||
        (model.insulationClassificationGISCompartment != ContentOptions.vacuum.value &&
            model.gasPressureSF6 != ContentOptions.normal.value &&
            (model.gasPressureSF6Abnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_7).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_7)
                        ?.abnormalId
                        ?.isNullOrEmpty() ==
                    true))) {
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
          ? CuttingMachineModel.fromJson(data['cuttingMachines'])
          : CuttingMachineModel();
      // model.cutterPosition ??= data['installationType'];
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
    final model = dataModel.value as CuttingMachineModel;
    if (model.insulationClassificationGISCompartment ==
        ContentOptions.vacuum.value) {
      model.phaseA = null;
      model.phaseB = null;
      model.phaseC = null;
      model.gasPressureSF6 = null;
      model.gasPressureSF6Abnormal = '';
      unawaited(removeImageOfProblem(ImageProblems.muc1_7));
    }

    if (model.cutterPosition == ContentOptions.inSite.value) {
      model.conditionContactPoints = null;
      model.conditionTransmissionCabinet = null;
    } else {
      model.temperature = null;
      model.humidity = null;
      model.ventilators = null;
      model.distributionRoomStatus = null;
    }

    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'cuttingMachines');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory);

  @override
  Future copyData() async {
    final CuttingMachineModel originalModel =
        await getData(equipmentId: equipmentModel.id);
    final modelCurrent = CuttingMachineModel();
    setTile(modelCurrent);

    if (originalModel == null) {
      return;
    }

    modelCurrent.conditionContactPoints =
        getValueCopySubstation(originalModel.conditionContactPoints);

    modelCurrent.conditionTransmissionCabinet =
        getValueCopySubstation(originalModel.conditionTransmissionCabinet);

    modelCurrent.conditionCableCompartment =
        getValueCopySubstation(originalModel.conditionCableCompartment);

    modelCurrent.distributionRoomStatus =
        getValueCopySubstation(originalModel.distributionRoomStatus);
    if (modelCurrent.distributionRoomStatus != null) {
      modelCurrent.operationMode = originalModel.operationMode;
    }
    modelCurrent.distributionRoomStatus =
        getValueCopySubstation(originalModel.distributionRoomStatus);
    if (modelCurrent.distributionRoomStatus != null) {
      modelCurrent.temperature = originalModel.temperature;
      modelCurrent.humidity = originalModel.humidity;
      modelCurrent.ventilators = originalModel.ventilators;
    }
    modelCurrent.mechanicalStructureGrounding =
        getValueCopySubstation(originalModel.mechanicalStructureGrounding);
    modelCurrent.stateIndustrialHygiene =
        getValueCopySubstation(originalModel.stateIndustrialHygiene);

    modelCurrent.gasPressureSF6 =
        getValueCopySubstation(originalModel.gasPressureSF6);

    modelCurrent.checkBonded =
        getValueCopySubstation(originalModel.checkBonded);

    modelCurrent.cutterPosition = originalModel.cutterPosition;

    if (modelCurrent.gasPressureSF6 != null) {
      modelCurrent.phaseA = originalModel.phaseA;
      modelCurrent.phaseB = originalModel.phaseB;
      modelCurrent.phaseC = originalModel.phaseC;
    }
    dataModel.value = modelCurrent;
    invalid.refresh();
  }

  void refreshView() {
    invalid.refresh();
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as CuttingMachineModel;
    if (equipmentsDestination.length > 1) {
      return model.checkBonded == ContentOptions.normal.value;
    }
    return true;
  }

  double getTitleMechanicalStructureGrounding(double addStepTitle) {
    final model = dataModel.value as CuttingMachineModel;
    if (model.cutterPosition != ContentOptions.inSite.value &&
        model.cutterPosition != ContentOptions.outSite.value) {
      if (model.insulationClassificationGISCompartment == null ||
          model.insulationClassificationGISCompartment ==
              ContentOptions.sf6.value) {
        return roundDouble(1.2 + addStepTitle, 1);
      } else if (model.insulationClassificationGISCompartment ==
          ContentOptions.vacuum.value) {
        return roundDouble(1.1 + addStepTitle, 1);
      }
    } else if (model.insulationClassificationGISCompartment ==
        ContentOptions.vacuum.value) {
      return roundDouble(1.3 + addStepTitle, 1);
    }
    return roundDouble(1.4 + addStepTitle, 1);
  }
}

