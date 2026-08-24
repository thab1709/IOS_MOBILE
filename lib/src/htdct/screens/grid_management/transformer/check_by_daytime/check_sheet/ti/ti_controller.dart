// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/ti_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../../htdct/common/constance/content_option.dart';
import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../common/constance/strings.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../../common/utils/common.dart';

class TIController<T> extends BasePopupController {
  TIController() {
    dataModel = TIModel().obs;
  }

  RxDouble degreeDifferenceValue = 0.0.obs;

  bool triggerWaringValue = true;

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as TIModel;
    switch (type) {
      case ImageProblems.muc1_0:
        {
          if (model.operatingCurrent == null) {
            if (model.operatingParameters != null) {
              model.operatingParameters = null;
              invalid.refresh();
            }
            break;
          }

          if (model.operatingCurrent != ContentOptions.normal.value) {
            if (model.operatingParameters != ContentOptions.weirdo.value) {
              //bất thuong
              model.operatingParameters = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else {
            if (model.operatingParameters != ContentOptions.normal.value) {
              //khong binh thuong
              model.operatingParameters = ContentOptions.normal.value;
            }
          }
        }
        break;

      case ImageProblems.muc2_0:
        {
          if ((model.insulationClassificationGISCompartment ==
                      ContentOptions.oil.value &&
                  model.insulationOilLevelStatus == null) ||
              (checkOutsite() &&
                  model.conditionContactsTerminalsInsulators == null) ||
              model.groundingStatus == null) {
            if (model.checkBonded != null) {
              model.checkBonded = null;
              invalid.refresh();
            }
            break;
          }

          if ((model.insulationClassificationGISCompartment ==
                      ContentOptions.oil.value &&
                  model.insulationOilLevelStatus !=
                      ContentOptions.normal.value) ||
              (checkOutsite() &&
                  model.conditionContactsTerminalsInsulators !=
                      ContentOptions.normal.value) ||
              model.groundingStatus != ContentOptions.normal.value) {
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
    final model = dataModel.value as TIModel;
    if (model.validateData() ||
        (checkOutsite() &&
            model.conditionContactsTerminalsInsulators == null) ||
        !checkValidAbnormal()) return false;
    return true;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as TIModel;

    if ((model.operatingCurrent != ContentOptions.normal.value &&
            (model.operatingCurrentAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_1).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.insulationClassificationGISCompartment ==
                ContentOptions.oil.value &&
            model.insulationOilLevelStatus != ContentOptions.normal.value &&
            (model.insulationOilLevelStatusAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc2_1).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc2_1)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (checkOutsite() &&
            model.conditionContactsTerminalsInsulators !=
                ContentOptions.normal.value &&
            (model.conditionContactsTerminalsInsulatorsAbnormal
                    .isNullOrEmpty() ||
                getImageByProblem(ImageProblems.muc2_2).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc2_2)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.groundingStatus != ContentOptions.normal.value &&
            (model.groundingStatusAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc2_3).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc2_3)
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
      if (data['isEqual110'] == true) {
        equipmentModel.equipmentCategoryEx = 'TI 110';
      }

      invalid.refresh();
      final model = data != null ? TIModel.fromJson(data['ti']) : TIModel();
      model.tiLocation ??= data['installationType'];
      degreeDifferenceValue.value = model.degreeDifference;
      if (model.operatingCurrent != null) {
        triggerWaringValue = false;
      }

      model.title = '${equipmentModel.name}';
      model.equipmentId = equipmentId;
      // setValueTemperatureAndHumidity(data);
      if (equipmentsDestination == null) {
        dataModel.value = model;
        if (model.operatingCurrent != null) {
          checkValidPattern(ImageProblems.muc1_0);
        }
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
    final model = dataModel.value as TIModel;

    if (model.insulationClassificationGISCompartment !=
        ContentOptions.oil.value) {
      model.insulationOilLevelStatus = null;
      model.insulationOilLevelStatusAbnormal = null;
      await removeImageOfProblem(ImageProblems.muc2_1);
    }
    if (!checkOutsite()) {
      model.conditionContactsTerminalsInsulators = null;
      model.conditionContactsTerminalsInsulatorsAbnormal = null;
      await removeImageOfProblem(ImageProblems.muc2_2);
    }

    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'ti');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory);

  @override
  Future copyData() async {
    final TIModel originalModel = await getData(equipmentId: equipmentModel.id);
    final modelCurrent = TIModel();
    setTile(modelCurrent);
    if (originalModel == null) {
      return;
    }

    modelCurrent.operatingCurrent =
        getValueCopySubstation(originalModel.operatingCurrent);
    modelCurrent.tiLocation = originalModel.tiLocation;
    modelCurrent.insulationOilLevelStatus =
        getValueCopySubstation(originalModel.insulationOilLevelStatus);
    modelCurrent.conditionContactsTerminalsInsulators = getValueCopySubstation(
        originalModel.conditionContactsTerminalsInsulators);
    modelCurrent.groundingStatus =
        getValueCopySubstation(originalModel.groundingStatus);
    modelCurrent.operatingParameters =
        getValueCopySubstation(originalModel.operatingParameters);
    modelCurrent.checkBonded =
        getValueCopySubstation(originalModel.checkBonded);
    modelCurrent.operatingCurrent =
        getValueCopySubstation(originalModel.operatingCurrent);
    if (modelCurrent.operatingCurrent != null) {
      modelCurrent.irole = originalModel.irole;
      modelCurrent.iMeter = originalModel.iMeter;
      modelCurrent.degreeDifference = originalModel.degreeDifference;
      degreeDifferenceValue.value = originalModel.degreeDifference;
    }

    dataModel.value = modelCurrent;
    invalid.refresh();
  }

  void updateDegreeDifference() {
    final model = dataModel.value as TIModel;
    if (model.irole != null && model.iMeter != null) {
      model.degreeDifference = roundDouble(model.irole - model.iMeter, 2);
    } else if (model.iMeter != null) {
      model.degreeDifference = roundDouble(-model.iMeter, 2);
    } else if (model.irole != null) {
      model.degreeDifference = roundDouble(model.irole, 2);
    } else {
      model.degreeDifference = null;
    }

    if (model.degreeDifference != null) {
      if (model.degreeDifference > 10) {
        model.operatingCurrent = ContentOptions.weirdo.value;
      }
      if (triggerWaringValue == true && model.degreeDifference > 50) {
        triggerWaringValue = false;
        hShowDialogOneButton(HighElectricStrings.warningInputValue);
      }
    }
    checkValidPattern(ImageProblems.muc1_0);
    degreeDifferenceValue.value = model.degreeDifference;
    degreeDifferenceValue.refresh();
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as TIModel;
    if (equipmentsDestination.length > 1) {
      return model.operatingParameters == ContentOptions.normal.value &&
          model.checkBonded == ContentOptions.normal.value;
    }
    return true;
  }

  bool checkOutsite() {
    final model = dataModel.value as TIModel;
    if (model.tiLocation == ContentOptions.outSite.value) {
      return true;
    }
    return false;
  }
}

