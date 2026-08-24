// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../../models/day_night/popups/night/transformer_auto_night_model.dart';

class TransformerAutoNightController<T> extends BasePopupController {
  TransformerAutoNightController() {
    dataModel = TransformerAutoNightModel().obs;
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as TransformerAutoNightModel;
    switch (type) {
      case ImageProblems.muc1_0:
        {
          if (model.testHeatGeneration == null ||
              model.checkAbnormalDischarge == null ||
              model.chirp == null) {
            if (model.checkBonded != null) {
              model.checkBonded = null;
              invalid.refresh();
            }
            break;
          }

          if (model.testHeatGeneration != ContentOptions.normal.value ||
              model.checkAbnormalDischarge != ContentOptions.normal.value ||
              model.chirp != ContentOptions.normal.value) {
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
    final model = dataModel.value as TransformerAutoNightModel;
    if (!model.validateData() || !checkValidAbnormal()) return false;
    return true;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as TransformerAutoNightModel;

    if ((model.chirp != ContentOptions.normal.value &&
            (model.chirpAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_1).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.testHeatGeneration != ContentOptions.normal.value &&
            (model.testHeatGenerationAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_2).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.checkAbnormalDischarge != ContentOptions.normal.value &&
            (model.checkAbnormalDischargeAbnormal.isNullOrBlank() ||
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
      final model = data != null
          ? TransformerAutoNightModel.fromJson(data['seftUseNightTime'])
          : TransformerAutoNightModel();

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
    final model = dataModel.value as TransformerAutoNightModel;
    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'seftUseNightTime');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory,
      ticketType: transformerTicketController.ticketType);

  @override
  Future copyData() async {
    final TransformerAutoNightModel originalModel =
        await getData(equipmentId: equipmentModel.id);
    final modelCurrent = TransformerAutoNightModel();
    setTile(modelCurrent);

    modelCurrent.chirp = getValueCopySubstation(originalModel.chirp);
    modelCurrent.checkAbnormalDischarge =
        getValueCopySubstation(originalModel.checkAbnormalDischarge);
    modelCurrent.testHeatGeneration =
        getValueCopySubstation(originalModel.testHeatGeneration);
    modelCurrent.checkBonded =
        getValueCopySubstation(originalModel.checkBonded);
    dataModel.value = modelCurrent;
    invalid.refresh();
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as TransformerAutoNightModel;
    if (equipmentsDestination.length > 1) {
      return model.checkBonded == ContentOptions.normal.value;
    }
    return true;
  }
}

