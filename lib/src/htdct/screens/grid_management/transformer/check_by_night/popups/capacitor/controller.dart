// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/night/capacitor_night.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';

class CapacitorNightController<T> extends BasePopupController {
  CapacitorNightController() {
    dataModel = CapacitorNightModel().obs;
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as CapacitorNightModel;
    switch (type) {
      case ImageProblems.muc1_0:
        {
          if (model.checkAbnormalDischarges == null ||
              model.soundCondenser == null) {
            if (model.checkBonded != null) {
              model.checkBonded = null;
              invalid.refresh();
            }
            break;
          }

          if (model.checkAbnormalDischarges != ContentOptions.normal.value ||
              model.soundCondenser != ContentOptions.normal.value) {
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
      default:
        break;
    }
  }

  @override
  bool checkValid() {
    final model = dataModel.value as CapacitorNightModel;
    if (model.validateData() && checkValidAbnormal()) return true;
    return false;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as CapacitorNightModel;

    if ((model.checkAbnormalDischarges != ContentOptions.normal.value &&
            (model.checkAbnormalDischargesAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_1).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.soundCondenser != ContentOptions.normal.value &&
            (model.soundCondenserAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_2).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2)
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
          ? CapacitorNightModel.fromJson(data['compensatingCapacitorNightTime'])
          : CapacitorNightModel();

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
    final model = dataModel.value as CapacitorNightModel;
    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'compensatingCapacitorNightTime');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory,
      ticketType: transformerTicketController.ticketType);

  @override
  Future copyData() async {
    final CapacitorNightModel originalModel =
        await getData(equipmentId: equipmentModel.id);
    final modelCurrent = CapacitorNightModel();
    setTile(modelCurrent);

    modelCurrent.soundCondenser =
        getValueCopySubstation(originalModel.soundCondenser);
    modelCurrent.checkAbnormalDischarges =
        getValueCopySubstation(originalModel.checkAbnormalDischarges);
    modelCurrent.checkBonded =
        getValueCopySubstation(originalModel.checkBonded);
    dataModel.value = modelCurrent;
    invalid.refresh();
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as CapacitorNightModel;
    if (equipmentsDestination.length > 1) {
      return model.checkBonded == ContentOptions.normal.value;
    }
    return true;
  }
}

