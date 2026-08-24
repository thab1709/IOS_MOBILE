// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../common/constance/option_type.dart';
import '../../../../../../common/constance/strings.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../../models/day_night/popups/night/cutting_machine_night_model.dart';

class CuttingMachineNightController<T> extends BasePopupController {
  CuttingMachineNightController() {
    dataModel = CuttingMachineNightModel().obs;
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as CuttingMachineNightModel;
    switch (type) {
      case ImageProblems.muc1_0:
        {
          if (model.statusLocks == null ||
              model.operatingStatusResult == null ||
              model.checkAbnormalDischarge == null ||
              model.cutCounterIndex == null ||
              model.powerIndicator == null) {
            if (model.checkBonded != null) {
              model.checkBonded = null;
              invalid.refresh();
            }
            break;
          }

          if (model.statusLocks != ContentOptions.normal.value ||
              model.operatingStatusResult != ContentOptions.normal.value ||
              model.checkAbnormalDischarge != ContentOptions.normal.value ||
              model.cutCounterIndex != ContentOptions.normal.value ||
              model.powerIndicator != ContentOptions.normal.value) {
            if (model.checkBonded != ContentOptions.weirdo.value) {
              //bất thuong
              model.checkBonded = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else {
            if (model.checkBonded != ContentOptions.normal.value) {
              //khong binh thuong
              model.checkBonded = ContentOptions.normal.value;
            }
          }
        }
        break;

      case ImageProblems.muc2_0:
        if (model.distributionRoomStatus == null ||
            model.otherAbnormal == null) {
          if (model.indoorDistributionRoom != null) {
            model.indoorDistributionRoom = null;
            invalid.refresh();
          }
          break;
        }

        if (model.distributionRoomStatus != ContentOptions.normal.value ||
            model.otherAbnormal != ContentOptions.normal.value) {
          if (model.indoorDistributionRoom != ContentOptions.weirdo.value) {
            //bất thuong
            model.indoorDistributionRoom = ContentOptions.weirdo.value;
            invalid.refresh();
          }
        } else {
          if (model.indoorDistributionRoom != ContentOptions.normal.value) {
            //khong binh thuong
            model.indoorDistributionRoom = ContentOptions.normal.value;
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  bool checkValid() {
    final model = dataModel.value as CuttingMachineNightModel;
    if (!isModeCopy()) {
      if (model.validateData() && checkValidAbnormal()) return true;
    } else {
      //Not validate n able when in mode copy
      if (model.validateDataCopy() && checkValidAbnormal()) return true;
    }

    return false;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as CuttingMachineNightModel;

    if ((model.statusLocks != ContentOptions.normal.value &&
            (model.statusLocksAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_1).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.operatingStatusResult != ContentOptions.normal.value &&
            (model.operatingStatusResultAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_2).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.powerIndicator != ContentOptions.normal.value &&
            (model.powerIndicatorAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_4).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_4)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.checkAbnormalDischarge != ContentOptions.normal.value &&
            (model.checkAbnormalDischargeAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_5).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_5)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.cutCounterIndex != ContentOptions.normal.value &&
            (model.cutCounterIndexAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_6).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_6)
                    .abnormalId
                    .isNullOrEmpty()))) {
      return false;
    }

    return true;
  }

  void setOperatorValue(String value) {
    final model = dataModel.value as CuttingMachineNightModel;
    model.operatingStatus = value.toIntOrNull();
    if (OptionsType.status_operation.getOptions.first.value ==
        model.operatingStatus) {
      model.operatingStatusResult = ContentOptions.normal.value;
      model.operationSeparationDate = null;
    } else {
      if (model.operationSeparationDate.isNullOrEmpty()) {
        model.operatingStatusResult = null;
      }
    }
    checkValidPattern(ImageProblems.muc1_0);
    viewRefresh();
  }

  void setDateDetachedOperator() {
    final model = dataModel.value as CuttingMachineNightModel;
    final dateSelected = model.operationSeparationDate
        .toDate(format: HighElectricStrings.utcFormat);
    if (dateSelected != null) {
      final dateCompare = DateTime.now().add(const Duration(days: 90));
      if (dateSelected.isAfter(dateCompare)) {
        model.operatingStatusResult = ContentOptions.weirdo.value;
      } else {
        model.operatingStatusResult = ContentOptions.normal.value;
      }
    } else {
      model.operationSeparationDate = null;
    }
    checkValidPattern(ImageProblems.muc1_0);
    viewRefresh();
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
          ? CuttingMachineNightModel.fromJson(data['cuttingMachinesNightTime'])
          : CuttingMachineNightModel();

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
    final model = dataModel.value as CuttingMachineNightModel;
    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'cuttingMachinesNightTime');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory,
      ticketType: transformerTicketController.ticketType);

  @override
  Future copyData() async {
    final CuttingMachineNightModel originalModel =
        await getData(equipmentId: equipmentModel.id);
    final modelCurrent = CuttingMachineNightModel();
    setTile(modelCurrent);
    modelCurrent.statusLocks =
        getValueCopySubstation(originalModel.statusLocks);
    modelCurrent.checkAbnormalDischarge =
        getValueCopySubstation(originalModel.checkAbnormalDischarge);
    modelCurrent.cutCounterIndex =
        getValueCopySubstation(originalModel.cutCounterIndex);

    modelCurrent.distributionRoomStatus =
        getValueCopySubstation(originalModel.distributionRoomStatus);
    modelCurrent.otherAbnormal =
        getValueCopySubstation(originalModel.otherAbnormal);
    if (modelCurrent.distributionRoomStatus != null &&
        modelCurrent.distributionRoomStatus != null) {
      modelCurrent.indoorDistributionRoom =
          originalModel.indoorDistributionRoom;
    }
    dataModel.value = modelCurrent;
    invalid.refresh();
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as CuttingMachineNightModel;
    if (equipmentsDestination.length > 1) {
      return model.checkBonded == ContentOptions.normal.value &&
          model.indoorDistributionRoom == ContentOptions.normal.value;
    }
    return true;
  }
}

