// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/isolation_knife_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/content_option.dart';
import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';

class IsolationKnifeController<T> extends BasePopupController {
  IsolationKnifeController() {
    dataModel = IsolationKnifeModel().obs;
  }

  bool isGisOrHGis = false;

  //type - mục lớn
  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as IsolationKnifeModel;
    switch (type) {
      case 1:
        {
          if ((isGisOrHGis && model.gasPressureSF6 == null) ||
              (model.locationIsolators == ContentOptions.outSite.value &&
                  model.statusContactPoints == null) ||
              model.mechanicalStructureGrounding == null ||
              (model.locationIsolators == ContentOptions.outSite.value &&
                  model.conditionTransmissionCabinet == null)) {
            if (model.checkBonded != null) {
              model.checkBonded = null;
              invalid.refresh();
            }
            break;
          }

          if ((isGisOrHGis &&
                  model.gasPressureSF6 != ContentOptions.normal.value) ||
              (model.locationIsolators == ContentOptions.outSite.value &&
                  model.statusContactPoints != ContentOptions.normal.value) ||
              model.mechanicalStructureGrounding !=
                  ContentOptions.normal.value ||
              (model.locationIsolators == ContentOptions.outSite.value &&
                  model.conditionTransmissionCabinet !=
                      ContentOptions.normal.value)) {
            if (model.checkBonded != ContentOptions.weirdo.value) //bất thuong
            {
              model.checkBonded = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else if (model.checkBonded !=
              ContentOptions.normal.value) //khong binh thuong
          {
            model.checkBonded = ContentOptions.normal.value;
            invalid.refresh();
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  bool checkValid() {
    final model = dataModel.value as IsolationKnifeModel;
    if (model.validateData() ||
        !checkValidAbnormal() ||
        (isGisOrHGis &&
            ((model.insulationClassificationGISCompartment ==
                        ContentOptions.sf6.value &&
                    model.phaseA == null) ||
                model.insulationClassificationGISCompartment == null ||
                model.gasPressureSF6 == null))) return false;
    return true;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as IsolationKnifeModel;

    if ((isGisOrHGis &&
            model.gasPressureSF6 != ContentOptions.normal.value &&
            (model.gasPressureSF6Abnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_1).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.locationIsolators == ContentOptions.outSite.value &&
            model.statusContactPoints != ContentOptions.normal.value &&
            (model.statusContactPointsAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_2).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.mechanicalStructureGrounding != ContentOptions.normal.value &&
            (model.mechanicalStructureGroundingAbnormal.isNullOrBlank() ||
                getImageByProblem(ImageProblems.muc1_3).isEmpty ||
                getAbnormalByCategoryIndex(ImageProblems.muc1_3)
                    .abnormalId
                    .isNullOrEmpty())) ||
        (model.locationIsolators == ContentOptions.outSite.value &&
            model.conditionTransmissionCabinet != ContentOptions.normal.value &&
            (model.conditionTransmissionCabinetAbnormal.isNullOrBlank() ||
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
      isGisOrHGis = data['isGisOrHGis'];
      invalid.refresh();
      final model = data != null
          ? IsolationKnifeModel.fromJson(data['isolationKnife'])
          : IsolationKnifeModel();

      model.locationIsolators ??= data['installationType'];

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
    final model = dataModel.value as IsolationKnifeModel;
    if (isGisOrHGis &&
        model.insulationClassificationGISCompartment !=
            ContentOptions.sf6.value) {
      model.phaseA = null;
      model.phaseB = null;
      model.phaseC = null;
    }
    if (model.locationIsolators != ContentOptions.outSite.value) {
      model.statusContactPoints = null;
      model.statusContactPointsAbnormal = null;
      await removeImageOfProblem(ImageProblems.muc1_2);
      model.conditionTransmissionCabinet = null;
      model.conditionTransmissionCabinetAbnormal = null;
      await removeImageOfProblem(ImageProblems.muc1_4);
    }

    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'isolationKnife');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory);

  @override
  Future copyData() async {
    final originalModel = await getData(equipmentId: equipmentModel.id);
    final modelCurrent = IsolationKnifeModel();
    setTile(modelCurrent);

    if (isGisOrHGis) {
      modelCurrent.gasPressureSF6 =
          getValueCopySubstation(originalModel.gasPressureSF6);
      if (modelCurrent.gasPressureSF6 != null) {
        modelCurrent.insulationClassificationGISCompartment =
            originalModel.insulationClassificationGISCompartment;
        modelCurrent.phaseA = originalModel.phaseA;
        modelCurrent.phaseB = originalModel.phaseB;
        modelCurrent.phaseC = originalModel.phaseC;
      }
    }
    modelCurrent.statusContactPoints =
        getValueCopySubstation(originalModel.statusContactPoints);
    modelCurrent.mechanicalStructureGrounding =
        getValueCopySubstation(originalModel.mechanicalStructureGrounding);
    modelCurrent.conditionTransmissionCabinet =
        getValueCopySubstation(originalModel.conditionTransmissionCabinet);
    modelCurrent.checkBonded =
        getValueCopySubstation(originalModel.checkBonded);

    modelCurrent.locationIsolators = originalModel.locationIsolators;

    dataModel.value = modelCurrent;
    invalid.refresh();
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as IsolationKnifeModel;
    if (equipmentsDestination.length > 1) {
      return model.checkBonded == ContentOptions.normal.value;
    }
    return true;
  }

  bool checkOutsite() {
    final model = dataModel.value as IsolationKnifeModel;
    if (model.locationIsolators == ContentOptions.outSite.value) {
      return true;
    }
    return false;
  }
}

