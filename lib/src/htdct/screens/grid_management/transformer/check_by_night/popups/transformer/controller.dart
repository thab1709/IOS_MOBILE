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
import '../../../../../../models/day_night/popups/night/transformer_night_model.dart';

class TransformerNightController<T> extends BasePopupController {
  TransformerNightController() {
    dataModel = TransformerNightModel().obs;
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as TransformerNightModel;
    switch (type) {
      case ImageProblems.muc1_0:
        {
          if (model.operatingStatusResult == null ||
              model.outdoorLightingCondition == null ||
              model.checkDischarge == null ||
              model.chirp == null) {
            if (model.checkBonded != null) {
              model.checkBonded = null;
              invalid.refresh();
            }
            break;
          }

          if (model.operatingStatusResult != ContentOptions.normal.value ||
              model.outdoorLightingCondition != ContentOptions.enough.value ||
              model.checkDischarge != ContentOptions.normal.value ||
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

  void setOperatorValue(String value) {
    final model = dataModel.value as TransformerNightModel;
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
    final model = dataModel.value as TransformerNightModel;
    final dateSelected = model.operationSeparationDate
        .toDate(format: HighElectricStrings.utcFormat);
    if (dateSelected != null) {
      final dateCompare = DateTime.now().add(const Duration(days: 90));
      final dateAfterCompare = DateTime.now().add(const Duration(days: -90));
      if (dateSelected.isAfter(dateCompare) ||
          dateSelected.isBefore(dateAfterCompare)) {
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
  bool checkValid() {
    final model = dataModel.value as TransformerNightModel;
    if (model.validateData() && checkValidAbnormal()) return true;
    return false;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as TransformerNightModel;

    if ((model.chirp != ContentOptions.normal.value &&
            (model.chirpAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_1).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.checkDischarge != ContentOptions.normal.value &&
            (model.checkDischargeAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_2).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.outdoorLightingCondition != ContentOptions.enough.value &&
            (model.outdoorLightingConditionAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_3).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_3)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.operatingStatus == ContentOptions.unOperation.value &&
            model.operationSeparationDate.isNullOrEmpty()) ||
        (model.operatingStatusResult != ContentOptions.normal.value &&
            (model.operatingStatusAbnormal.isNullOrBlank() ||
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
          ? TransformerNightModel.fromJson(data['transformersNightTime'])
          : TransformerNightModel();

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
    final model = dataModel.value as TransformerNightModel;
    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'transformersNightTime');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory,
      ticketType: transformerTicketController.ticketType);

  @override
  Future copyData() async {
    final TransformerNightModel originalModel =
        await getData(equipmentId: equipmentModel.id);
    final modelCurrent = TransformerNightModel();
    setTile(modelCurrent);

    modelCurrent.chirp = getValueCopySubstation(originalModel.chirp);
    modelCurrent.checkDischarge =
        getValueCopySubstation(originalModel.checkDischarge);
    dataModel.value = modelCurrent;
    invalid.refresh();
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as TransformerNightModel;
    if (equipmentsDestination.length > 1) {
      return model.checkBonded == ContentOptions.normal.value;
    }
    return true;
  }
}

