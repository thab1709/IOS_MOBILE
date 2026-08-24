// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/underground_cable_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/content_option.dart';
import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';

class UndergroundCableController<T> extends BasePopupController {
  UndergroundCableController() {
    dataModel = UndergroundCableModel().obs;
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as UndergroundCableModel;
    switch (type) {
      case 1:
        {
          if (model.cableConditionCable == null ||
              model.conditionCableAndCableCanopyCable == null ||
              model.conditionCableSheathGroundingSystem == null ||
              model.bracketCondition == null ||
              model.cableTunnelStatus == null) {
            if (model.checkBonded != null) {
              model.checkBonded = null;
              invalid.refresh();
            }
            break;
          }

          if (model.cableConditionCable != ContentOptions.normal.value ||
              model.conditionCableAndCableCanopyCable !=
                  ContentOptions.normal.value ||
              model.conditionCableSheathGroundingSystem !=
                  ContentOptions.normal.value ||
              model.bracketCondition != ContentOptions.normal.value ||
              model.cableTunnelStatus != ContentOptions.normal.value) {
            if (model.checkBonded != ContentOptions.weirdo.value) //bất thuong
            {
              model.checkBonded = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else if (model.checkBonded !=
              ContentOptions.normal.value) //khong binh thuong
          {
            model.checkBonded = ContentOptions.normal.value;
            // invalid.refresh();
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  bool checkValid() {
    final model = dataModel.value as UndergroundCableModel;
    if (model.validateData() || !checkValidAbnormal()) return false;
    return true;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as UndergroundCableModel;

    if ((model.cableConditionCable != ContentOptions.normal.value &&
            (model.cableConditionCableAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_1).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.conditionCableAndCableCanopyCable !=
                ContentOptions.normal.value &&
            (model.conditionCableAndCableCanopyCableAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_2).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.conditionCableSheathGroundingSystem !=
                ContentOptions.normal.value &&
            (model.conditionCableSheathGroundingSystemAbnormal
                    .isNullOrEmpty() ||
                getImageByProblem(ImageProblems.muc1_3).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_3)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.bracketCondition != ContentOptions.normal.value &&
            (model.bracketConditionAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_4).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_4)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.cableTunnelStatus != ContentOptions.normal.value &&
            (model.cableTunnelStatusAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_5).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_5)
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
          ? UndergroundCableModel.fromJson(data['undergroundCable'])
          : UndergroundCableModel();

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
    final model = dataModel.value as UndergroundCableModel;
    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'undergroundCables');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory);

  @override
  Future copyData() async {
    final UndergroundCableModel originalModel =
        await getData(equipmentId: equipmentModel.id);
    final modelCurrent = UndergroundCableModel();
    setTile(modelCurrent);

    modelCurrent.checkBonded =
        getValueCopySubstation(originalModel.checkBonded);
    modelCurrent.cableConditionCable =
        getValueCopySubstation(originalModel.cableConditionCable);
    modelCurrent.conditionCableAndCableCanopyCable =
        getValueCopySubstation(originalModel.conditionCableAndCableCanopyCable);
    modelCurrent.conditionCableSheathGroundingSystem = getValueCopySubstation(
        originalModel.conditionCableSheathGroundingSystem);
    modelCurrent.bracketCondition =
        getValueCopySubstation(originalModel.bracketCondition);
    modelCurrent.cableTunnelStatus =
        getValueCopySubstation(originalModel.cableTunnelStatus);

    dataModel.value = modelCurrent;
    invalid.refresh();
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as UndergroundCableModel;
    if (equipmentsDestination.length > 1) {
      return model.checkBonded == ContentOptions.normal.value;
    }
    return true;
  }
}

