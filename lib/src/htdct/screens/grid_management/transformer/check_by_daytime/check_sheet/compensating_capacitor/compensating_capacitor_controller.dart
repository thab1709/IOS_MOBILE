// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/compensating_capacitor_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/content_option.dart';
import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';

class CompensatingCapacitorController<T> extends BasePopupController {
  CompensatingCapacitorController() {
    dataModel = CompensatingCapacitorModel().obs;
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as CompensatingCapacitorModel;
    switch (type) {
      case 1:
        {
          if (model.operatingParameters == null ||
              model.conditionPorcelainInsulator == null ||
              model.seepageCondition == null ||
              model.condenserGroundingStatus == null) {
            if (model.checkBonded != null) {
              model.checkBonded = null;
              invalid.refresh();
            }
            break;
          }
          if (model.operatingParameters != ContentOptions.normal.value ||
              model.conditionPorcelainInsulator !=
                  ContentOptions.normal.value ||
              model.seepageCondition != ContentOptions.normal.value ||
              model.condenserGroundingStatus != ContentOptions.normal.value) {
            if (model.checkBonded != ContentOptions.weirdo.value) //bất thuong
            {
              model.checkBonded = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else if (model.checkBonded !=
              ContentOptions.normal.value) //khong binh thuong
          {
            model.checkBonded = ContentOptions.normal.value;
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  bool checkValid() {
    final model = dataModel.value as CompensatingCapacitorModel;
    if (model.validateData() || !checkValidAbnormal()) return false;
    return true;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as CompensatingCapacitorModel;

    if ((model.operatingParameters != ContentOptions.normal.value &&
            (model.operatingParametersAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_1).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.conditionPorcelainInsulator != ContentOptions.normal.value &&
            (model.conditionPorcelainInsulatorAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_2).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.seepageCondition != ContentOptions.normal.value &&
            (model.seepageConditionAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_3).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_3)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.condenserGroundingStatus != ContentOptions.normal.value &&
            (model.condenserGroundingStatusAbnormal.isNullOrBlank() ||
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
          ? CompensatingCapacitorModel.fromJson(data['compensatingCapacitor'])
          : CompensatingCapacitorModel();

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
    final model = dataModel.value as CompensatingCapacitorModel;
    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'compensatingCapacitor');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory);

  @override
  Future copyData() async {
    final CompensatingCapacitorModel originalModel =
        await getData(equipmentId: equipmentModel.id);
    final modelCurrent = CompensatingCapacitorModel();
    setTile(modelCurrent);

    modelCurrent.operatingParameters =
        getValueCopySubstation(originalModel.operatingParameters);
    if (modelCurrent.operatingParameters != null) {
      modelCurrent.u = originalModel.u;
      modelCurrent.i = originalModel.i;
      modelCurrent.q = originalModel.q;
    }

    modelCurrent.conditionPorcelainInsulator =
        getValueCopySubstation(originalModel.conditionPorcelainInsulator);
    modelCurrent.seepageCondition =
        getValueCopySubstation(originalModel.seepageCondition);
    modelCurrent.condenserGroundingStatus =
        getValueCopySubstation(originalModel.condenserGroundingStatus);
    modelCurrent.checkBonded =
        getValueCopySubstation(originalModel.checkBonded);

    dataModel.value = modelCurrent;
    invalid.refresh();
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as CompensatingCapacitorModel;
    if (equipmentsDestination.length > 1) {
      return model.checkBonded == ContentOptions.normal.value;
    }
    return true;
  }
}

