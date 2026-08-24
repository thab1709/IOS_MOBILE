// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/lightning_protection_valve_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/content_option.dart';
import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';

class LightningProtectionValveController<T> extends BasePopupController {
  LightningProtectionValveController() {
    dataModel = LightningProtectionValveModel().obs;
  }

  bool isGisOrHGis = false;

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as LightningProtectionValveModel;
    switch (type) {
      case 1:
        {
          if (model.groundingStatus == null ||
              (checkOutsite() &&
                  model.conditionContactsTerminalsInsulators == null) ||
              (isGisOrHGis && model.gasPressurSF6 == null)) {
            if (model.checkBonded != null) {
              model.checkBonded = null;
              invalid.refresh();
            }
            break;
          }

          if (model.groundingStatus != ContentOptions.normal.value ||
              (checkOutsite() &&
                  model.conditionContactsTerminalsInsulators !=
                      ContentOptions.normal.value) ||
              (isGisOrHGis &&
                  model.gasPressurSF6 != ContentOptions.normal.value)) {
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
      case 2:
        {
          if (checkOutsite() &&
              (model.leakageCurrentValue == null ||
                  model.lightningCounterIndicator == null)) {
            if (model.checkCSVPolesAbnormal != null) {
              model.checkCSVPolesAbnormal = null;
              invalid.refresh();
            }
            break;
          }

          if (checkOutsite() &&
              (model.leakageCurrentValue != ContentOptions.normal.value ||
                  model.lightningCounterIndicator !=
                      ContentOptions.normal.value)) {
            if (model.checkCSVPoles != ContentOptions.weirdo.value) //bất thuong
            {
              model.checkCSVPoles = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else if (model.checkCSVPoles !=
              ContentOptions.normal.value) //khong binh thuong
          {
            model.checkCSVPoles = ContentOptions.normal.value;
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  bool checkValid() {
    final model = dataModel.value as LightningProtectionValveModel;
    if (model.validateData() ||
        (checkOutsite() &&
            (model.checkCSVPoles == null ||
                model.conditionContactsTerminalsInsulators == null ||
                model.leakageCurrentValue == null ||
                model.lightningCounterIndicator == null)) ||
        !checkValidAbnormal()) return false;
    return true;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as LightningProtectionValveModel;

    if ((model.groundingStatus != ContentOptions.normal.value &&
            (model.groundingStatusAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_1).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (checkOutsite() &&
            model.conditionContactsTerminalsInsulators !=
                ContentOptions.normal.value &&
            (model.conditionContactsTerminalsInsulatorsAbnormal
                    .isNullOrEmpty() ||
                getImageByProblem(ImageProblems.muc1_2).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (isGisOrHGis &&
            model.gasPressurSF6 != ContentOptions.normal.value &&
            (model.gasPressurSF6Abnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_3).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_3)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (checkOutsite() &&
            ((model.leakageCurrentValue != ContentOptions.normal.value &&
                    (model.leakageCurrentValueAbnormal.isNullOrBlank() ||
                        getImageByProblem(ImageProblems.muc2_1).isEmpty ||
                        getAbnormalByCategoryIndex(ImageProblems.muc2_1)
                            .abnormalId
                            .isNullOrEmpty())) ||
                (model.lightningCounterIndicator !=
                        ContentOptions.normal.value &&
                    (model.lightningCounterIndicatorAbnormal.isNullOrBlank() ||
                        getImageByProblem(ImageProblems.muc2_2).isEmpty ||
                        getAbnormalByCategoryIndex(ImageProblems.muc2_2)
                            .abnormalId
                            .isNullOrEmpty()))))) {
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
      isGisOrHGis = data['isGisOrHGis'];

      invalid.refresh();
      final model = data != null
          ? LightningProtectionValveModel.fromJson(
              data['lightningProtectionValve'])
          : LightningProtectionValveModel();
      model.csvLocation ??= data['installationType'];
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
    final model = dataModel.value as LightningProtectionValveModel;
    if (!checkOutsite()) {
      model.checkCSVPoles = null;
      model.ir = null;
      model.leakageCurrentValue = null;
      model.leakageCurrentValueAbnormal = null;
      model.s = null;
      model.lightningCounterIndicator = null;
      model.lightningCounterIndicatorAbnormal = null;
      await removeImageOfProblem(ImageProblems.muc2_0);
      await removeImageOfProblem(ImageProblems.muc2_1);
      await removeImageOfProblem(ImageProblems.muc2_2);
    }
    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'lightningProtectionValve');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory);

  @override
  Future copyData() async {
    final LightningProtectionValveModel originalModel =
        await getData(equipmentId: equipmentModel.id);
    final modelCurrent = LightningProtectionValveModel();
    setTile(modelCurrent);

    modelCurrent.checkBonded =
        getValueCopySubstation(originalModel.checkBonded);
    modelCurrent.csvLocation = originalModel.csvLocation;
    modelCurrent.groundingStatus =
        getValueCopySubstation(originalModel.groundingStatus);
    modelCurrent.conditionContactsTerminalsInsulators = getValueCopySubstation(
        originalModel.conditionContactsTerminalsInsulators);
    if (isGisOrHGis) {
      modelCurrent.gasPressurSF6 =
          getValueCopySubstation(originalModel.gasPressurSF6);
    }
    modelCurrent.checkCSVPoles =
        getValueCopySubstation(originalModel.checkCSVPoles);
    modelCurrent.leakageCurrentValue =
        getValueCopySubstation(originalModel.leakageCurrentValue);
    modelCurrent.lightningCounterIndicator =
        getValueCopySubstation(originalModel.lightningCounterIndicator);
    if (modelCurrent.gasPressurSF6 != null) {
      modelCurrent.p = originalModel.p;
    }
    dataModel.value = modelCurrent;
    invalid.refresh();
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as LightningProtectionValveModel;
    if (equipmentsDestination.length > 1) {
      if (!checkOutsite()) {
        return model.checkBonded == ContentOptions.normal.value;
      } else {
        return model.checkBonded == ContentOptions.normal.value &&
            model.checkCSVPoles == ContentOptions.normal.value;
      }
    }
    return true;
  }

  bool checkOutsite() {
    final model = dataModel.value as LightningProtectionValveModel;
    if (model.csvLocation == ContentOptions.outSite.value) {
      return true;
    }
    return false;
  }
}

