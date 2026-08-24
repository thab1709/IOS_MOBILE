// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../../models/day_night/popups/charging_cabinet_model.dart';

class ChargingCabinetController<T> extends BasePopupController {
  ChargingCabinetController() {
    dataModel = ChargingCabinetModel().obs;
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as ChargingCabinetModel;
    switch (type) {
      case 1:
        {
          if (model.operatingVoltage == null ||
              model.operatingCurrent == null ||
              model.cabinetSignalStatus == null ||
              model.loadingCabinetStatus == null) {
            if (model.checkLoadingCabinet != null) {
              model.checkLoadingCabinet = null;
              invalid.refresh();
            }
            break;
          }

          if (model.operatingVoltage != ContentOptions.normal.value ||
              model.operatingCurrent != ContentOptions.normal.value ||
              model.cabinetSignalStatus != ContentOptions.normal.value ||
              model.loadingCabinetStatus != ContentOptions.normal.value) {
            if (model.checkLoadingCabinet != ContentOptions.weirdo.value) {
              //bất thuong
              model.checkLoadingCabinet = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else {
            if (model.checkLoadingCabinet != ContentOptions.normal.value) {
              //khong binh thuong
              model.checkLoadingCabinet = ContentOptions.normal.value;
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
    final model = dataModel.value as ChargingCabinetModel;
    if (model.validateData() || !checkValidAbnormal()) return false;
    return true;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as ChargingCabinetModel;

    if ((model.operatingVoltage != ContentOptions.normal.value &&
            (model.operatingVoltageAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_1).isEmpty ||
                getAbnormalByCategoryIndex(
                        ImageProblems.muc1_1)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.operatingCurrent != ContentOptions.normal.value &&
            (model.operatingCurrentAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_2).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.cabinetSignalStatus != ContentOptions.normal.value &&
            (model.cabinetSignalStatusAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_3).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_3)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.loadingCabinetStatus != ContentOptions.normal.value &&
            (model.loadingCabinetStatusAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_4).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_4)
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
      final model = data != null
          ? ChargingCabinetModel.fromJson(data['chargingCabinet'])
          : ChargingCabinetModel();

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
    final model = dataModel.value as ChargingCabinetModel;
    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'chargingCabinet');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory);

  @override
  Future copyData() async {
    final originalModel = await getData(equipmentId: equipmentModel.id);
    final modelCurrent = ChargingCabinetModel();
    setTile(modelCurrent);

    modelCurrent.cabinetSignalStatus =
        getValueCopySubstation(originalModel.cabinetSignalStatus);

    modelCurrent.loadingCabinetStatus =
        getValueCopySubstation(originalModel.loadingCabinetStatus);
    modelCurrent.operatingVoltage =
        getValueCopySubstation(originalModel.operatingVoltage);
    modelCurrent.operatingCurrent =
        getValueCopySubstation(originalModel.operatingCurrent);
    modelCurrent.checkLoadingCabinet =
        getValueCopySubstation(originalModel.checkLoadingCabinet);
    if (modelCurrent.operatingVoltage != null) {
      modelCurrent.operatingVoltageBYIn = originalModel.operatingVoltageBYIn;
      modelCurrent.operatingVoltageBYOut = originalModel.operatingVoltageBYOut;
      modelCurrent.operatingVoltageACCU = originalModel.operatingVoltageACCU;
      modelCurrent.operatingVoltageDCLoad =
          originalModel.operatingVoltageDCLoad;
    }
    if (modelCurrent.operatingCurrent != null) {
      modelCurrent.operatingCurrentBYIn = originalModel.operatingCurrentBYIn;
      modelCurrent.operatingCurrentBYOut = originalModel.operatingCurrentBYOut;
      modelCurrent.operatingCurrentACCU = originalModel.operatingCurrentACCU;
      modelCurrent.operatingCurrentDCLoad =
          originalModel.operatingCurrentDCLoad;
    }

    dataModel.value = modelCurrent;
    invalid.refresh();
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as ChargingCabinetModel;
    if (equipmentsDestination.length > 1) {
      return model.checkLoadingCabinet == ContentOptions.normal.value;
    }
    return true;
  }
}

