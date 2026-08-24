// @dart=2.9
import '../../../models/option_model.dart';
import 'content_option.dart';

enum OptionsType {
  EventType,
  WorkBase,
  Classify,
  EquipmentInstallation,
  Handle,
  Schedule,
  Measurements,
  Operation,
  InspectionTeam,
  TypeAbnormal,
  ProtectType,
  TroubleTypeSubstation,
  TroubleTypeLine,
  CauseImpact,
  TeamCheck,
  Cutting,
  TypeInspect,
}

extension Options on OptionsType {
  List<OptionModel> get getOptions {
    switch (this) {
      case OptionsType.EventType:
        return [
          ContentOptions.workUnit,
          ContentOptions.abnormal,
          ContentOptions.MCTTN,
          ContentOptions.fullLoad,
          ContentOptions.troubleshot,
          ContentOptions.guaranteeElectricity,
          ContentOptions.other,
        ];
      case OptionsType.WorkBase:
        return [
          ContentOptions.productionPlan,
          ContentOptions.unExpected,
          ContentOptions.scheduleWeek,
          ContentOptions.assignmentText,
          ContentOptions.other,
        ];
      case OptionsType.Classify:
        return [
          ContentOptions.equipmentInstallation,
          ContentOptions.handle,
          ContentOptions.schedule,
          ContentOptions.measurements,
          ContentOptions.operation,
          ContentOptions.inspectionTeam,
          ContentOptions.classify_other,
        ];

      case OptionsType.TypeAbnormal:
        return [
          ContentOptions.first,
          ContentOptions.second,
          ContentOptions.scada,
          ContentOptions.htOneDirection,
          ContentOptions.channel,
          ContentOptions.line,
          ContentOptions.otherAbnormalType,
        ];
      case OptionsType.TroubleTypeSubstation:
        return [
          ContentOptions.TBA110,
          ContentOptions.TBATA,
          ContentOptions.TBAMBA,
          ContentOptions.TBAOTHER,
        ];
        case OptionsType.TroubleTypeLine:
        return [
          ContentOptions.DZGlimpse,
          ContentOptions.DZLong,
        ];
      case OptionsType.CauseImpact:
        return [
          ContentOptions.secondCircuit,
          ContentOptions.TuTi,
          ContentOptions.Role,
          ContentOptions.settingValue,
          ContentOptions.InstallWork,
          ContentOptions.MC,
          ContentOptions.Undefined,
        ];
      case OptionsType.EquipmentInstallation:
        return [
          ContentOptions.newAssembly,
          ContentOptions.replace,
          ContentOptions.recall,
          ContentOptions.electric,
        ];
        break;

      case OptionsType.Handle:
        return [
          ContentOptions.heatUp,
          ContentOptions.exist,
          ContentOptions.oilFilter,
          ContentOptions.replaceCable,
        ];

      case OptionsType.Schedule:
        return [
          ContentOptions.VSHotline,
          ContentOptions.TNKD,
          ContentOptions.CBM,
          ContentOptions.checkBinary,
        ];

      case OptionsType.Measurements:
        return [
          ContentOptions.lineMeasure,
          ContentOptions.resistanceMeasure,
          ContentOptions.PDMeasure,
          ContentOptions.csv,
          ContentOptions.tsq,
          ContentOptions.getOil,
        ];
      case OptionsType.Operation:
        return [
          ContentOptions.lossSeparation,
          ContentOptions.role,
        ];
      case OptionsType.InspectionTeam:
        return [
          ContentOptions.company,
          ContentOptions.bigCompany,
          ContentOptions.electricCompany,
          ContentOptions.otherUnit,
        ];
      case OptionsType.TeamCheck:
        return [
          ContentOptions.x6,
          ContentOptions.evn_hn,
          ContentOptions.evn,
          // ContentOptions.otherTeam,
        ];
      case OptionsType.ProtectType:
        return [
          ContentOptions.IFirst,
          ContentOptions.ISecond,
          ContentOptions.IThird,
          ContentOptions.INFirst,
          ContentOptions.INSecond,
          ContentOptions.INThird,
          ContentOptions.ISef,
          ContentOptions.F81First,
          ContentOptions.F81Second,
          ContentOptions.F81Third,
          ContentOptions.F27First,
          ContentOptions.F27Second,
          ContentOptions.F59First,
          ContentOptions.F59Second,
          ContentOptions.U3,
          ContentOptions.otherProtectType,
        ];
      case OptionsType.Cutting:
        return [
          ContentOptions.DongNhayNgay,
          ContentOptions.KP_Tot,
          ContentOptions.TDL_Tot,
          ContentOptions.TDL_Xau,
          ContentOptions.TramDongNhayNgay,
          ContentOptions.TramKPTOT,
        ];
      case OptionsType.TypeInspect:
        return [
          ContentOptions.subStationInspect,
          ContentOptions.lineInspect,
        ];
      default:
        return [];
    }
  }

  List<OptionModelString> get getStringOptions {
    switch (this) {
      case OptionsType.EventType:
        return OptionsType.EventType.getOptions
            .map((e) => OptionModelString(e.title, e.value.toString()))
            .toList();
        break;

      case OptionsType.EquipmentInstallation:
        return OptionsType.EquipmentInstallation.getOptions
            .map((e) => OptionModelString(e.title, e.value.toString()))
            .toList();
        break;

      case OptionsType.Handle:
        return OptionsType.Handle.getOptions
            .map((e) => OptionModelString(e.title, e.value.toString()))
            .toList();
        break;

      case OptionsType.Schedule:
        return OptionsType.Schedule.getOptions
            .map((e) => OptionModelString(e.title, e.value.toString()))
            .toList();
        break;

      case OptionsType.Measurements:
        return OptionsType.Measurements.getOptions
            .map((e) => OptionModelString(e.title, e.value.toString()))
            .toList();
        break;
      case OptionsType.Operation:
        return OptionsType.Operation.getOptions
            .map((e) => OptionModelString(e.title, e.value.toString()))
            .toList();
        break;
      case OptionsType.InspectionTeam:
        return OptionsType.InspectionTeam.getOptions
            .map((e) => OptionModelString(e.title, e.value.toString()))
            .toList();
        break;
      case OptionsType.ProtectType:
        return OptionsType.ProtectType.getOptions
            .map((e) => OptionModelString(e.title, e.value.toString()))
            .toList();
        break;
      case OptionsType.TeamCheck:
        return OptionsType.TeamCheck.getOptions
            .map((e) => OptionModelString(e.title, e.value.toString()))
            .toList();
        break;
      case OptionsType.Cutting:
        return OptionsType.Cutting.getOptions
            .map((e) => OptionModelString(e.title, e.value.toString()))
            .toList();
        break;
      default:
        return [];
    }
  }
}

