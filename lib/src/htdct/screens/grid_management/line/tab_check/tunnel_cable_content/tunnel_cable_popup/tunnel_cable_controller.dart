// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/content_option.dart';
import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../common/utils/common.dart';
import '../../../../../../models/line/popups/line_underground_cables_system_model.dart';

class TunnelCableController<T> extends BasePopupController {
  TunnelCableController() {
    dataModel = LineUndergroundCablesSystem().obs;
    final model = dataModel.value as LineUndergroundCablesSystem;
    model.images = [];
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as LineUndergroundCablesSystem;
    switch (type) {
      case ImageProblems.muc1_0:
        {
          if (model.violationUndergroundCableSafetyCorridor == null
              || model.conditionWaterConnectingTunnel == null
              || model.cableHolderCondition == null
              || model.signStatus == null
              || model.cableCondition == null
              || model.conditionCableGroundWire == null
              || model.statusLinkBox == null
          ) {
            if (model.checkBondedAbnormal != null) {
              model.checkBondedAbnormal = null;
              invalid.refresh();
            }
            return;
          }

          if (model.violationUndergroundCableSafetyCorridor != ContentOptions.normal.value ||
              model.conditionWaterConnectingTunnel != ContentOptions.normal.value ||
              model.cableHolderCondition != ContentOptions.normal.value ||
              model.signStatus != ContentOptions.normal.value ||
              model.cableCondition != ContentOptions.normal.value ||
              model.conditionCableGroundWire != ContentOptions.normal.value ||
              model.statusLinkBox != ContentOptions.normal.value
          ) {
            //bất thường
            if (model.checkBondedAbnormal != ContentOptions.weirdo.value) {
              model.checkBondedAbnormal = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else {
            model.checkBondedAbnormal = ContentOptions.normal.value;
            removeImageOfProblem(ImageProblems.muc1_0);
            invalid.refresh();
          }
        }
        break;
      case ImageProblems.muc2_0:
        {
          if (model.cableBoxHeatEmissionCoefficientMaterialOptions == null
              || model.measuringTemperature == null
              || model.actualTemperature == null
          ) {
            if (model.cableBoxHeatEmission != null) {
              model.cableBoxHeatEmission = null;
              invalid.refresh();
            }
            return;
          }

          if (model.cableBoxHeatEmissionCoefficientMaterialOptions != ContentOptions.normal.value ||
              model.measuringTemperature != ContentOptions.normal.value ||
              model.actualTemperature != ContentOptions.normal.value
          ) {
            //bất thường
            if (model.cableBoxHeatEmission != ContentOptions.weirdo.value) {
              model.cableBoxHeatEmission = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else {
            model.cableBoxHeatEmission = ContentOptions.normal.value;
            removeImageOfProblem(ImageProblems.muc2_0);
            invalid.refresh();
          }
        }
        break;
      case ImageProblems.muc3_0:
        {
          if (model.linkboxCableHeatEmissionCoefficientOptions == null
              || model.linkboxCableTemperature == null
              || model.cableSheathInducedMeasurement == null
          ) {
            if (model.linkboxCableHeatEmission != null) {
              model.linkboxCableHeatEmission = null;
              invalid.refresh();
            }
            return;
          }

          if (model.linkboxCableHeatEmissionCoefficientOptions != ContentOptions.normal.value ||
              model.linkboxCableTemperature != ContentOptions.normal.value ||
              model.cableSheathInducedMeasurement != ContentOptions.normal.value
          ) {
            //bất thường
            if (model.linkboxCableHeatEmission != ContentOptions.weirdo.value) {
              model.linkboxCableHeatEmission = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else {
            model.linkboxCableHeatEmission = ContentOptions.normal.value;
            removeImageOfProblem(ImageProblems.muc2_0);
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
    final model = dataModel.value as LineUndergroundCablesSystem;
    if (model.validateData() && checkValidAbnormal()) return true;
    return false;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as LineUndergroundCablesSystem;

    if (
    (model.violationUndergroundCableSafetyCorridor != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_1).isEmpty ||
                model.violationUndergroundCableSafetyCorridorAbnormal.isNullOrBlank()) ) ||
    (model.conditionWaterConnectingTunnel != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_2).isEmpty ||
                model.conditionWaterConnectingTunnelAbnormal.isNullOrBlank()) ) ||
    (model.cableHolderCondition != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_3).isEmpty ||
                model.cableHolderConditionAbnormal.isNullOrBlank()) ) ||
    (model.signStatus != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_4).isEmpty ||
                model.signStatusAbnormal.isNullOrBlank()) ) ||
    (model.cableCondition != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_5).isEmpty ||
                model.cableConditionAbnormal.isNullOrBlank()) ) ||
    (model.conditionCableGroundWire != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_6).isEmpty ||
                model.conditionCableGroundWireAbnormal.isNullOrBlank()) ) ||
    (model.statusLinkBox != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_7).isEmpty ||
                model.statusLinkBoxAbnormal.isNullOrBlank()) ) ||

    (model.cableBoxHeatEmissionCoefficientMaterialOptions != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc2_1).isEmpty ||
                model.cableBoxHeatEmissionAbnormal.isNullOrBlank()) ) ||
    (model.measuringTemperature != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc2_2).isEmpty ||
                model.measuringTemperatureAbnormal.isNullOrBlank()) ) ||
    (model.actualTemperature != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc2_3).isEmpty ||
                model.actualTemperatureAbnormal.isNullOrBlank()) ) ||


    (model.linkboxCableHeatEmissionCoefficientOptions != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc3_1).isEmpty ||
                model.linkboxCableHeatEmissionAbnormal.isNullOrBlank()) ) ||
    (model.linkboxCableTemperature != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc3_2).isEmpty ||
                model.linkboxCableTemperatureAbnormal.isNullOrBlank()) ) ||
    (model.cableSheathInducedMeasurement != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc3_3).isEmpty ||
                model.cableSheathInducedMeasurementAbnormal.isNullOrBlank()) )

    ) {
      return false;
    }
    return true;
  }

  @override
  Future getData({String equipmentId}) async {
    return getDataLine('lineUndergroundCablesSystemModel', equipmentId: equipmentId);
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as LineUndergroundCablesSystem;
    // if (equipmentsDestination.length > 1) {
    //   return model.lineLightingAbnormal == ContentOptions.normal.value;
    // }
    return true;
  }

  @override
  Future updateData() async {
    final model = dataModel.value as LineUndergroundCablesSystem;
    model.autoTunerCableGenAbnormalType();
    await updateEquipment(model.toJson(), 'lineUndergroundCablesSystem');
  }

  @override
  String getEndPoint() => 'underground-cables';

  @override
  Future copyData() async {
    final originalModel =
        await getData(equipmentId: equipmentModel.id) as LineUndergroundCablesSystem;
    originalModel.images = [];
    final modelCurrent = LineUndergroundCablesSystem();
    setTile(modelCurrent);

    modelCurrent.cableHolderCondition =getValueCopySubstation(originalModel.cableHolderCondition);
    modelCurrent.signStatus =getValueCopySubstation(originalModel.signStatus);

    modelCurrent.linkboxCableHeatEmissionMaterial = originalModel.linkboxCableHeatEmissionMaterial;
    modelCurrent.linkboxCableHeatEmissionCoefficient= originalModel.linkboxCableHeatEmissionCoefficient;
    modelCurrent.cableBoxHeatEmissionCoefficientMaterial= originalModel.cableBoxHeatEmissionCoefficientMaterial;
    modelCurrent.cableBoxHeatEmissionCoefficient= originalModel.cableBoxHeatEmissionCoefficient;

    dataModel.value = modelCurrent;
    invalid.refresh();
  }

  void changeCoefficientMaterial(){
    final model = dataModel.value as LineUndergroundCablesSystem;
    if(model.cableBoxHeatEmissionCoefficient!=null)
    {
      model.cableBoxHeatEmissionCoefficientMaterial=getCoefficientMaterial(model.cableBoxHeatEmissionCoefficient);
    }
    else{
      model.cableBoxHeatEmissionCoefficientMaterial=null;
    }
    if(model.linkboxCableHeatEmissionMaterial!=null)
    {
      model.linkboxCableHeatEmissionCoefficient=getCoefficientMaterial(model.linkboxCableHeatEmissionMaterial);
    }
    else{
      model.linkboxCableHeatEmissionCoefficient=null;
    }
    invalid.refresh();
  }

  double getCoefficientMaterial(int type)
  {
    if(type == ContentOptions.electricalTape.value)
      {
        return 0.95;
      }
    else if(type == ContentOptions.paint.value)
      {
        return 0.94;
      }
    else if(type == ContentOptions.rubber.value)
      {
        return 0.93;
      }
    else if(type == ContentOptions.glazed.value)
      {
        return 0.92;
      }
    else if(type == ContentOptions.concrete.value)
      {
        return 0.92;
      }
    else if(type == ContentOptions.paper.value)
      {
        return 0.9;
      }
    else if(type == ContentOptions.brick.value)
      {
        return 0.85;
      }
    else if(type == ContentOptions.copperOx.value)
      {
        return 0.65;
      }
    else if(type == ContentOptions.cement.value)
      {
        return 0.6;
      }
    else if(type == ContentOptions.aluminumOx.value)
      {
        return 0.25;
      }
    else if(type == ContentOptions.stainless.value)
      {
        return 0.1;
      }
    else if(type == ContentOptions.aluminum.value)
      {
        return 0.05;
      }
    else if(type == ContentOptions.copper.value)
      {
        return 0.02;
      }

    return null;
  }

  void updateTem()
  {
    final model = dataModel.value as LineUndergroundCablesSystem;
    if(model.cableBoxHeatEmissionCoefficientMaterial!=null)
      {
        if(model.measuringTemperaturePhaseA!=null)
          {
            model.actualTemperaturePhaseA = roundDouble( model.measuringTemperaturePhaseA/model.cableBoxHeatEmissionCoefficientMaterial,2);
          }
        else
          {
            model.actualTemperaturePhaseA = null;
          }
        if(model.measuringTemperaturePhaseB!=null)
        {
          model.actualTemperaturePhasB = roundDouble( model.measuringTemperaturePhaseB/model.cableBoxHeatEmissionCoefficientMaterial,2);
        }
        else
        {
          model.actualTemperaturePhasB = null;
        }
        if(model.measuringTemperaturePhaseC!=null)
        {
          model.actualTemperaturePhasC = roundDouble( model.measuringTemperaturePhaseC/model.cableBoxHeatEmissionCoefficientMaterial,2);
        }
        else
        {
          model.actualTemperaturePhasC = null;
        }
      }
    else{
      model.actualTemperaturePhaseA=null;
      model.actualTemperaturePhasB=null;
      model.actualTemperaturePhasC=null;
    }
    invalid.refresh();
  }
}

