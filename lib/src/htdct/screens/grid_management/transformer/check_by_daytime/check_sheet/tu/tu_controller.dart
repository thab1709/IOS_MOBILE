// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/tu_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../../htdct/common/constance/content_option.dart';
import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../common/constance/strings.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../../common/utils/common.dart';

class TUController<T> extends BasePopupController {
  TUController() {
    dataModel = TUModel().obs;
  }

  RxDouble degreeDifferenceValue = 0.0.obs;
  bool triggerWaringValue = true;

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as TUModel;
    switch (type) {
      case ImageProblems.muc1_0:
        {
          if (model.operatingCurrent == null) {
            if (model.voltageEachPhase != null) {
              model.voltageEachPhase = null;
              invalid.refresh();
            }
            break;
          }

          if (model.operatingCurrent != ContentOptions.normal.value) {
            if (model.voltageEachPhase != ContentOptions.weirdo.value) {
              //bất thuong
              model.voltageEachPhase = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else {
            if (model.voltageEachPhase != ContentOptions.normal.value) {
              //khong binh thuong
              model.voltageEachPhase = ContentOptions.normal.value;
            }
          }
        }
        break;

      case ImageProblems.muc2_0:
        {
          if ((checkOutsite() && model.insulationOilLevelStatus == null) ||
              (checkOutsite() &&
                  model.conditionContactsTerminalsInsulators == null) ||
              model.gasPressurSF6 == null ||
              model.groundingStatus == null) {
            if (model.checkBonded != null) {
              model.checkBonded = null;
              invalid.refresh();
            }
            break;
          }

          if ((checkOutsite() &&
                  model.insulationOilLevelStatus !=
                      ContentOptions.normal.value) ||
              (checkOutsite() &&
                  model.conditionContactsTerminalsInsulators !=
                      ContentOptions.normal.value) ||
              model.gasPressurSF6 != ContentOptions.normal.value ||
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
    final model = dataModel.value as TUModel;
    if ((checkOutsite() &&
            (model.insulationOilLevelStatus == null ||
                model.conditionContactsTerminalsInsulators == null)) ||
        model.validateData() ||
        !checkValidAbnormal()) return false;
    return true;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as TUModel;

    if ((model.operatingCurrent != ContentOptions.normal.value &&
            (model.operatingCurrentAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_1).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (checkOutsite() &&
            model.insulationOilLevelStatus != ContentOptions.normal.value &&
            (model.insulationOilLevelStatusAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc2_1).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc2_1)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.gasPressurSF6 != ContentOptions.normal.value &&
            (model.gasPressurSF6Abnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc2_2).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc2_2)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (checkOutsite() &&
            model.conditionContactsTerminalsInsulators !=
                ContentOptions.normal.value &&
            (model.conditionContactsTerminalsInsulatorsAbnormal
                    .isNullOrEmpty() ||
                getImageByProblem(ImageProblems.muc2_3).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc2_3)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.groundingStatus != ContentOptions.normal.value &&
            (model.groundingStatusAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc2_4).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc2_4)
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
        equipmentModel.equipmentCategoryEx = 'TU 110';
      }
      degreeDifferenceValue.value = null;

      invalid.refresh();
      final model = data != null ? TUModel.fromJson(data['tu']) : TUModel();
      degreeDifferenceValue.value = model.degreeDifference;
      model.tuLocation ??= data['installationType'];
      if (model.voltageEachPhase != null) {
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
    final model = dataModel.value as TUModel;
    if (model.insulationClassificationGISCompartment !=
        ContentOptions.sf6.value) {
      model.p = null;
    }

    if (!checkOutsite()) {
      model.insulationOilLevelStatus = null;
      model.insulationOilLevelStatusAbnormal = null;
      await removeImageOfProblem(ImageProblems.muc2_1);

      model.conditionContactsTerminalsInsulators = null;
      model.conditionContactsTerminalsInsulatorsAbnormal = null;
      await removeImageOfProblem(ImageProblems.muc2_3);
    }

    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'tu');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory);

  @override
  Future copyData() async {
    final originalModel = await getData(equipmentId: equipmentModel.id);
    final modelCurrent = TUModel();
    setTile(modelCurrent);

    modelCurrent.tuLocation = originalModel.tuLocation;

    modelCurrent.insulationOilLevelStatus =
        getValueCopySubstation(originalModel.insulationOilLevelStatus);

    modelCurrent.gasPressurSF6 =
        getValueCopySubstation(originalModel.gasPressurSF6);
    modelCurrent.conditionContactsTerminalsInsulators = getValueCopySubstation(
        originalModel.conditionContactsTerminalsInsulators);
    modelCurrent.groundingStatus =
        getValueCopySubstation(originalModel.groundingStatus);
    modelCurrent.checkBonded =
        getValueCopySubstation(originalModel.checkBonded);
    modelCurrent.voltageEachPhase =
        getValueCopySubstation(originalModel.voltageEachPhase);

    modelCurrent.operatingCurrent =
        getValueCopySubstation(originalModel.operatingCurrent);
    if (modelCurrent.operatingCurrent != null) {
      modelCurrent.urole = originalModel.urole;
      modelCurrent.uMeter = originalModel.uMeter;
      modelCurrent.degreeDifference = originalModel.degreeDifference;
      degreeDifferenceValue.value = originalModel.degreeDifference;
    }
    if (modelCurrent.gasPressurSF6 != null) {
      modelCurrent.p = originalModel.p;
      modelCurrent.insulationClassificationGISCompartment =
          originalModel.insulationClassificationGISCompartment;
    }

    dataModel.value = modelCurrent;
    invalid.refresh();
  }

  void updateDegreeDifference() {
    final model = dataModel.value as TUModel;

    if (model.urole != null && model.uMeter != null) {
      model.degreeDifference = roundDouble(model.urole - model.uMeter, 2);
    } else if (model.uMeter != null) {
      model.degreeDifference = roundDouble(-model.uMeter, 2);
    } else if (model.urole != null) {
      model.degreeDifference = roundDouble(model.urole, 2);
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
    final model = dataModel.value as TUModel;
    if (equipmentsDestination.length > 1) {
      return model.voltageEachPhase == ContentOptions.normal.value &&
          model.checkBonded == ContentOptions.normal.value;
    }
    return true;
  }

  bool checkOutsite() {
    final model = dataModel.value as TUModel;
    if (model.tuLocation == ContentOptions.outSite.value) {
      return true;
    }
    return false;
  }
}

