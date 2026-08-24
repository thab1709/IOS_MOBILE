// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/content_option.dart';

import '../../models/option_model.dart';

enum OptionsType {
  normal_weirdo,
  oil,
  enough_lack,
  good_bad,
  normal_unNormal,
  phase_number,
  insulation_oil_level,
  following_finished,
  material_heat,
  position,
  status_operation,
  status_operation_cutting_machine,
  insulation_electric,
  electrical_cabinet,
  close_cut,
  operation_lock,
  notInstall_lock_f1_f2_f3,
  operation_lock_notInstall,
  summary_line,
  coefficient_material,
  cutting_sf6,
  isolation_knife_sf6,
  tu_sf6,
  location,
  log_book,
  calendar_type,
  work_status,
  abnormal_chart,
  unusual_classification,
}

extension Options on OptionsType {
  List<OptionModel> get getOptions {
    switch (this) {
      case OptionsType.normal_weirdo:
        return [
          ContentOptions.normal,
          ContentOptions.weirdo,
        ];
      case OptionsType.oil:
        return [
          ContentOptions.good,
          ContentOptions.rustCover,
          ContentOptions.oilSpill,
        ];
      case OptionsType.enough_lack:
        return [
          ContentOptions.enough,
          ContentOptions.lack,
        ];
      case OptionsType.good_bad:
        return [
          ContentOptions.good,
          ContentOptions.bad,
        ];
      case OptionsType.normal_unNormal:
        return [
          ContentOptions.normal,
          ContentOptions.notNormal,
        ];
      case OptionsType.phase_number:
        return [
          ContentOptions.onePhase,
          ContentOptions.threePhase,
        ];
      case OptionsType.insulation_oil_level:
        return [
          ContentOptions.oil,
          ContentOptions.dry,
        ];
      case OptionsType.following_finished:
        return [
          ContentOptions.following,
          ContentOptions.finished,
        ];
      case OptionsType.material_heat:
        return [
          ContentOptions.following,
          ContentOptions.finished,
        ];
      case OptionsType.position:
        return [
          ContentOptions.inSite,
          ContentOptions.outSite,
        ];
      case OptionsType.status_operation:
        return [
          ContentOptions.inOperation,
          ContentOptions.unOperation,
        ];
      case OptionsType.status_operation_cutting_machine:
        return [
          ContentOptions.inOperation,
          ContentOptions.unOperation,
          ContentOptions.nothing,
        ];
      case OptionsType.insulation_electric:
        return [
          ContentOptions.dryElectric,
          ContentOptions.oilElectric,
          ContentOptions.SF6Electric,
        ];
      case OptionsType.electrical_cabinet:
        return [
          ContentOptions.AcElectricCabinet,
          ContentOptions.DcElectricCabinet,
          ContentOptions.ScadaElectricCabinet,
          ContentOptions.MkElectricCabinet,
          ContentOptions.CtElectricCabinet,
          ContentOptions.BvdkElectricCabinet,
        ];
      case OptionsType.close_cut:
        return [
          ContentOptions.closed,
          ContentOptions.cut,
        ];
      case OptionsType.operation_lock:
        return [
          ContentOptions.operating,
          ContentOptions.lock,
        ];
      case OptionsType.notInstall_lock_f1_f2_f3:
        return [
          ContentOptions.notInstall,
          ContentOptions.lock,
          ContentOptions.f1,
          ContentOptions.f2,
          ContentOptions.f3,
        ];
      case OptionsType.operation_lock_notInstall:
        return [
          ContentOptions.operating,
          ContentOptions.lock,
          ContentOptions.notInstall,
        ];

      case OptionsType.summary_line:
        return [
          ContentOptions.summary,
          ContentOptions.line,
        ];
      case OptionsType.coefficient_material:
        return [
          ContentOptions.electricalTape,
          ContentOptions.paint,
          ContentOptions.rubber,
          ContentOptions.glazed,
          ContentOptions.concrete,
          ContentOptions.paper,
          ContentOptions.brick,
          ContentOptions.copperOx,
          ContentOptions.cement,
          ContentOptions.aluminumOx,
          ContentOptions.stainless,
          ContentOptions.aluminum,
          ContentOptions.copper,
        ];
      case OptionsType.cutting_sf6:
        return [
          ContentOptions.vacuum,
          ContentOptions.sf6,
        ];
      case OptionsType.isolation_knife_sf6:
        return [
          ContentOptions.air,
          ContentOptions.sf6,
        ];
      case OptionsType.tu_sf6:
        return [
          ContentOptions.sf6,
          ContentOptions.oil,
          ContentOptions.dry,
        ];
      case OptionsType.location:
        return [
          ContentOptions.outSite,
          ContentOptions.inSite,
          ContentOptions.ZeroThree,
          ContentOptions.EMICVN,
          ContentOptions.StackingCompartments,
          ContentOptions.AntiTTArk,
          ContentOptions.MachineFacePoleBox,
          ContentOptions.RoundaboutType,
          ContentOptions.LowVoltageDrawers,
          ContentOptions.Distributors,
          ContentOptions.AtMBAPole,
          ContentOptions.TBA,
          ContentOptions.InOutdoorLowVoltageCabinet,
          ContentOptions.InAntiLossBox,
          ContentOptions.InAntiTTBox,
          ContentOptions.InMeterBox,
          ContentOptions.InBoxCTT,
          ContentOptions.InBoxTT,
          ContentOptions.InAntilossCompartment,
          ContentOptions.InAntiTTCompartment,
          ContentOptions.InCTTPane,
          ContentOptions.InCompartmentLowVoltageCabinet,
          ContentOptions.InCabinet04kV,
          ContentOptions.InElectricalCabinet04kV,
          ContentOptions.InMeasuringCabinet,
          ContentOptions.InLowVoltageCabinet,
          ContentOptions.InLowVoltageCabinetHouse,
          ContentOptions.InHTCabinet,
          ContentOptions.InCommunicationCabinet,
          ContentOptions.InCabinetAtIntermediateStation,
          ContentOptions.InCabinetTT,
          ContentOptions.TotalLowVoltageCabinet,
          ContentOptions.MediumVoltageCabinetsSet,
          ContentOptions.InDistributionCabinet,
          ContentOptions.StationTopBreaker,
          ContentOptions.IsolationKnife,
          ContentOptions.KnifeRemoteControl,
          ContentOptions.OddMixingKnife,
          ContentOptions.LoadKnife,
          ContentOptions.ABB,
          ContentOptions.StandingSlash,
          ContentOptions.KnifeInStation,
          ContentOptions.BacAnKhanh,
          ContentOptions.InCabinet,
          ContentOptions.InRMUCabinet,
          ContentOptions.InMiddleVoltageCabinet,
          ContentOptions.FittingLowerJawSI,
          ContentOptions.MountedTGSupport,
          ContentOptions.MountPoleToStation,
          ContentOptions.InstallUndergroundCable,
          ContentOptions.PorcelainThroughWall,
          ContentOptions.FittingMBA,
          ContentOptions.Substation,
          ContentOptions.InstalledTGBeam,
          ContentOptions.IntermediateSupportBeams,
          ContentOptions.LightningRods,
          ContentOptions.FittingMachinePoleBA,
          ContentOptions.MountingAtTBA,
          ContentOptions.InstallCableEnd,
          ContentOptions.MountTopStation,
          ContentOptions.MountedIntermediateBeamTBA,
          ContentOptions.CableHead,
          ContentOptions.MountMachinePole,
          ContentOptions.OnTheRopeSupport,
          ContentOptions.LightningProtectionTUTI,
          ContentOptions.ExternalWallMountingMBA,
          ContentOptions.FittingAfterSI,
          ContentOptions.LowerJawSI,
          ContentOptions.InstalledEndUndergroundCable,
          ContentOptions.LightningProtectionTD1,
          ContentOptions.Undefined,
          ContentOptions.NoWire,
          ContentOptions.InstallTGBeamBelowSI,
          ContentOptions.SubterraneanCableFeeder,
          ContentOptions.InstallIntermediateBeams,
          ContentOptions.LowerJawFuseSI,
          ContentOptions.IntermediateBarBelowSI,
          ContentOptions.InstalledIntermediateBeam,
          ContentOptions.MountOnWall,
          ContentOptions.UndergroundCableHead,
          ContentOptions.Busbar,
          ContentOptions.IntermediateBeam,
          ContentOptions.FittingFrontSI,
          ContentOptions.AboveSI,
          ContentOptions.InstallProtectionTU,
          ContentOptions.IndoorInstallation,
          ContentOptions.Ten,
          ContentOptions.ExtremelyHighVoltageMBA,
          ContentOptions.InstallLowerJawFuseSI,
          ContentOptions.MountOnSI,
          ContentOptions.LowVoltageCabinetBar,
          ContentOptions.StationHead,
          ContentOptions.ScoreColumn,
          ContentOptions.MountedMandibularMedialBeamSI,
          ContentOptions.InstallCapacitorPole,
          ContentOptions.InstallBusbars,
          ContentOptions.LightningProtectionRafters,
          ContentOptions.MountedUpperIntermediateBeamSI,
          ContentOptions.MachinePole,
          ContentOptions.IntermediateBarOnSI,
          ContentOptions.Dz,
          ContentOptions.Zero,
          ContentOptions.MountedTGBeamBelowSI,
          ContentOptions.AfterSI,
        ];
      case OptionsType.log_book:
        return [
          // ContentOptions.handingOverWork,
          ContentOptions.workUnit,
          // ContentOptions.operationUnit,
          ContentOptions.abnormal,
          ContentOptions.MCMedium,
          ContentOptions.fullOperation,
          ContentOptions.trouble,
          ContentOptions.ensure,
          ContentOptions.other,
        ];
      case OptionsType.calendar_type:
        return [
          ContentOptions.calendarDay,
          ContentOptions.calendarWeek,
          ContentOptions.calendarMonth,
          ContentOptions.calendarYear,
        ];
      case OptionsType.work_status:
        return [
          ContentOptions.workSumHandle,
          ContentOptions.workNotHandle,
          ContentOptions.workAllStatus,
        ];
      case OptionsType.abnormal_chart:
        return [
          ContentOptions.dashboardAbmorderSynthetic,
          ContentOptions.dashboardAbmorder,
          ContentOptions.dashboardAbmorderLog,
        ];
      case OptionsType.unusual_classification:
        return [
          ContentOptions.first,
          ContentOptions.second,
        ];
      default:
        return [
          ContentOptions.normal,
          ContentOptions.weirdo,
        ];
    }
  }
}

