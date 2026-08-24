// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/substation_seft_use_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/content_option.dart';
import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';

class SubstationSeftUseController<T> extends BasePopupController {
  SubstationSeftUseController() {
    dataModel = SubstationSeftUseModel().obs;
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as SubstationSeftUseModel;
    switch (type) {
      case 1:
        {
          if (model.chirpMBA == null ||
              model.conditionOilLevel == null ||
              model.conditionBodyMBAContent == null ||
              model.statusGroundingSystemMBA == null ||
              model.conditionContacts == null) {
            if (model.checkBonded != null) {
              model.checkBonded = null;
              invalid.refresh();
            }
            break;
          }

          if (model.chirpMBA != ContentOptions.normal.value ||
              model.conditionOilLevel != ContentOptions.normal.value ||
              model.conditionBodyMBAContent != ContentOptions.normal.value ||
              model.statusGroundingSystemMBA != ContentOptions.normal.value ||
              model.conditionContacts != ContentOptions.normal.value) {
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
    final model = dataModel.value as SubstationSeftUseModel;
    if (model.validateData() || !checkValidAbnormal()) return false;
    return true;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as SubstationSeftUseModel;

    if ((model.chirpMBA != ContentOptions.normal.value &&
            (model.chirpMBAAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_1).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.conditionOilLevel != ContentOptions.normal.value &&
            (model.conditionOilLevelAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_2).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.conditionBodyMBAContent != ContentOptions.normal.value &&
            (model.conditionBodyMBAContentAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_3).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_3)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.statusGroundingSystemMBA != ContentOptions.normal.value &&
            (model.statusGroundingSystemMBAAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_4).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_4)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.conditionContacts != ContentOptions.normal.value) &&
            (model.conditionContactsAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_5).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_5)
                    .abnormalId
                    .isNullOrEmpty())) {
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
          ? SubstationSeftUseModel.fromJson(data['substationSeftUse'])
          : SubstationSeftUseModel();

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
    final model = dataModel.value as SubstationSeftUseModel;
    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'substationSeftUse');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory);

  @override
  Future copyData() async {
    final originalModel = await getData(equipmentId: equipmentModel.id);
    final modelCurrent = SubstationSeftUseModel();
    setTile(modelCurrent);

    modelCurrent.chirpMBA = getValueCopySubstation(originalModel.chirpMBA);
    modelCurrent.conditionOilLevel =
        getValueCopySubstation(originalModel.conditionOilLevel);
    modelCurrent.conditionContacts =
        getValueCopySubstation(originalModel.conditionContacts);
    modelCurrent.conditionBodyMBAContent =
        getValueCopySubstation(originalModel.conditionBodyMBAContent);
    modelCurrent.statusGroundingSystemMBA =
        getValueCopySubstation(originalModel.statusGroundingSystemMBA);

    modelCurrent.checkBonded =
        getValueCopySubstation(originalModel.checkBonded);

    dataModel.value = modelCurrent;
    invalid.refresh();
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as SubstationSeftUseModel;
    if (equipmentsDestination.length > 1) {
      return model.checkBonded == ContentOptions.normal.value;
    }
    return true;
  }
}

