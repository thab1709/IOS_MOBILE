// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/breadker.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/cutting_machine.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/distribution_building_structure.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/distribution_grounding_system.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/distribution_power_cable.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/fall_of_fuses.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/insulation.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_alternating_current_system.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_battery.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_cable_head.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_clamp_row.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_construction_structure.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_content_night.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_cutter_lbs.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_cutting_machine_model.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_disconnectors_switches.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_electric_cabinet.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_fall_of_fuse.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_filling_cabinet.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_grounding_system.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_high_pressure_cable.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_immediary_station_cleaning.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_insulation.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_lightning_conductor.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_measuring_system.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_recloser_model.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_resistance_temperature_detector.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_substation_model.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_substation_room_model.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_variable_current.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_variable_voltage.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/joint.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/joint_night.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/light_system_night.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/low_pressure_cable.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/one_way_system.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/substation_room_night.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/joint_night_time.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/lighting_system_night_time.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/lightning_conductor.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/low_pressure_cabinet.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/low_voltage_capacito.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/rmu.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/substation.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/substation_night_time.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/substation_room.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/ti.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/tu.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/distribution_inspect_model.dart';
import 'package:evnmobile/src/htld/models/general_data_model.dart';
import 'package:evnmobile/src/htld/models/intermediate_content.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_beam_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_breaker.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_capacitor_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_cutting_machine_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_disconnectors_switch_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_earthing_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_fundament_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_fuse_cut_out_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_insulation_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_lightning_arrester_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_measure_the_boundary_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_pole_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_recloser_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_rmu.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_rod_gap_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_ti.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_tu.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_underground_cable.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_wire_model.dart';
import 'package:evnmobile/src/htld/models/result_model.dart';
import 'package:evnmobile/src/htld/services/responseModel/distribution_content_day_response.dart';
import 'package:evnmobile/src/htld/services/responseModel/distribution_content_night_response.dart';
import 'package:evnmobile/src/htld/services/responseModel/general_infomation_response.dart';
import 'package:evnmobile/src/htld/services/responseModel/result_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:g_json/g_json.dart';

import '../server_response.dart';

class TicketRepository {
  final provider = ApiProvider();

  Future<JSON> getDistributionDayPopup(
    String ticketId,
    String equipmentId,
    String endPoint, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final json = data['data'];
      return json;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  Future<JSON> getDistributionNightPopup(
    String ticketId,
    String equipmentId,
    String endPoint, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/night-time/$endPoint',
          params: param,
          backgroundMode: isBackgroundMode,
          isRequireAuth: true);
      final json = data['data'];
      return json;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  Future<JSON> getIntermediateDayPopup(
    String ticketId,
    String equipmentId,
    String endPoint, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/intermediateinspect/$ticketId/content/$endPoint',
          params: param,
          backgroundMode: isBackgroundMode,
          isRequireAuth: true);
      final json = data['data'];
      return json;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  Future<JSON> getIntermediateNightPopup(
    String ticketId,
    String equipmentId,
    String endPoint, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/intermediateinspect/$ticketId/content/night-time/$endPoint',
          params: param,
          backgroundMode: isBackgroundMode,
          isRequireAuth: true);
      final json = data['data'];
      return json;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  Future<ServerResponse<GeneralInfoResponse>> create(
    DistributionInspectModel model,
    SubStationType type, {
    bool isBackgroundMode = false,
  }) async {
    final params = model.toJSON();
    try {
      final data = await provider.post('/${type.endPoint}', params,
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<GeneralInfoResponse>.fromJson(data);
      response.setData(GeneralInfoResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<GeneralInfoResponse>> update(
    DistributionInspectModel model,
    SubStationType type,
    String ticketId, {
    bool isBackgroundMode = false,
  }) async {
    final params = {
      'weather': model.weather_1 ?? '',
      'temperature': model.temperature_1 ?? '',
      'weather2': model.weather_2 ?? '',
      'temperature2': model.temperature_2 ?? '',
      'equipments': model.equipments?.map((e) {
        return {
          'equipmentId': e.id,
        };
      })?.toList()
    };

    try {
      final data = await provider.put('/${type.endPoint}/$ticketId', params,
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<GeneralInfoResponse>.fromJson(data);
      response.setData(GeneralInfoResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<GeneralInfoResponse>> updateContentDayInter(
    Map params,
    String ticketId, {
    bool isBackgroundMode = false,
  }) async {
    try {
      final data = await provider.put(
          '/immediaryinspect/$ticketId/content/day-time', params,
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<GeneralInfoResponse>.fromJson(data);
      response.setData(GeneralInfoResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<GeneralInfoResponse>> updateContentNightInter(
    Map params,
    String ticketId, {
    bool isBackgroundMode = false,
  }) async {
    try {
      final data = await provider.put(
          '/immediaryinspect/$ticketId/content/night-time', params,
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<GeneralInfoResponse>.fromJson(data);
      response.setData(GeneralInfoResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<GeneralInfoResponse>> createContentNightTime(
    Map params,
    String ticketId, {
    bool isBackgroundMode = false,
  }) async {
    try {
      final data = await provider.put(
          '/distributioninspect/$ticketId/content/night-time', params,
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<GeneralInfoResponse>.fromJson(data);
      response.setData(GeneralInfoResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<GeneralInfoResponse>> updateContentDayDistribution(
    Map params,
    String ticketId, {
    bool isBackgroundMode = false,
  }) async {
    try {
      final data = await provider.put(
          '/distributioninspect/$ticketId/content/day-time', params,
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<GeneralInfoResponse>.fromJson(data);
      response.setData(GeneralInfoResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<GeneralDataModel>> getGeneralInfo(
    String ticketId,
    SubStationType type, {
    bool isBackgroundMode = false,
  }) async {
    try {
      final data = await provider.get('/${type.endPoint}/$ticketId',
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<GeneralDataModel>.fromJson(data);
      response.setData(GeneralDataModel.fromJson(data['data']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  //MARK: Content Trạm biến áp phân phối

  Future<ServerResponse<DistributionContentNightResponse>> getContentNight(
    String ticketId, {
    bool isBackgroundMode = false,
  }) async {
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/night-time',
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final response =
          ServerResponse<DistributionContentNightResponse>.fromJson(data);
      response.setData(DistributionContentNightResponse.fromJSON(data['data']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<String>>> getAbnormalPhenomenon(
      String ticketId, String endPoint) async {
    try {
      final data = await provider.get(
          '/$endPoint/$ticketId/content/abnormal-phenomenon',
          isRequireAuth: true);
      final response = ServerResponse<List<String>>.fromJson(data);
      response.setData(data['data'].list.map((e) => JSON(e).string).toList());
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<DistributionContentDayResponse>>
      getContentDistributionDayTime(
    String ticketId, {
    bool isBackgroundMode = false,
  }) async {
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/day-time',
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final response =
          ServerResponse<DistributionContentDayResponse>.fromJson(data);
      response.setData(DistributionContentDayResponse.fromJson(data['data']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<IntermediateContentModel>> getContentInterDayTime(
    String ticketId, {
    bool isBackgroundMode = false,
  }) async {
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/day-time',
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final response = ServerResponse<IntermediateContentModel>.fromJson(data);
      response.setData(IntermediateContentModel.fromJson(data['data']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<IntermediateContentNightModel>>
      getContentInterNightTime(
    String ticketId, {
    bool isBackgroundMode = false,
  }) async {
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/night-time',
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final response =
          ServerResponse<IntermediateContentNightModel>.fromJson(data);
      response.setData(IntermediateContentNightModel.fromJson(data['data']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<GeneralInfoResponse>> saveResult(
    Map params,
    String ticketId,
    String endpoint, {
    bool isBackgroundMode = false,
  }) async {
    try {
      final data = await provider.put('/$endpoint/$ticketId/result', params,
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<GeneralInfoResponse>.fromJson(data);
      response.setData(GeneralInfoResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<GeneralInfoResponse>> saveLineResult(
    LineResultModel lineResultModel,
    String ticketId, {
    bool isBackgroundMode = false,
  }) async {
    final body = {
      'settlementTime': lineResultModel.settlementTime,
    };
    try {
      final data = await provider.post('/lineinspect/$ticketId/result', body,
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<GeneralInfoResponse>.fromJson(data);
      response.setData(GeneralInfoResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<ResultResponse>> getResult(
    String ticketId,
    String endpoint, {
    bool isBackgroundMode = false,
  }) async {
    try {
      final data = await provider.get('/$endpoint/$ticketId/result',
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<ResultResponse>.fromJson(data);
      response.setData(ResultResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineResultResponse>> getLineResult(
    String ticketId, {
    bool isBackgroundMode = false,
  }) async {
    try {
      final data = await provider.get('/lineinspect/$ticketId/result',
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<LineResultResponse>.fromJson(data);
      response.setData(LineResultResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<GeneralInfoResponse>> completeTicket(
    String ticketId,
    String endpoint, {
    bool isBackgroundMode = false,
  }) async {
    try {
      final data = await provider.post('/$endpoint/$ticketId/complete', {},
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<GeneralInfoResponse>.fromJson(data);
      response.setData(GeneralInfoResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<GeneralInfoResponse>> completeLineTicket(
      String ticketId) async {
    try {
      final data = await provider.put('/lineinspect/$ticketId/complete', {},
          isRequireAuth: true);
      final response = ServerResponse<GeneralInfoResponse>.fromJson(data);
      response.setData(GeneralInfoResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<GeneralInfoResponse>> completeLineTicketHT(
      String ticketId, bool isForceMajeure) async {
    final param = {'force_majeure': isForceMajeure ? 1 : 0};
    try {
      final data = await provider.put('/lineinspect/$ticketId/complete', param,
          isRequireAuth: true);
      final response = ServerResponse<GeneralInfoResponse>.fromJson(data);
      response.setData(GeneralInfoResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  //MARK: - Distribution - Content Day Popup
  Future<ServerResponse<SubstationRoom>> getSubstationRoom(
      String ticketId, String equipmentId) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/substation-room',
          params: param,
          isRequireAuth: true);
      final response = ServerResponse<SubstationRoom>.fromJson(data);
      response.setData(SubstationRoom.fromJson(data['data']['substationRoom']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<Substation>> getSubstation(
      String ticketId, String equipmentId) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/substation',
          params: param,
          isRequireAuth: true);
      final response = ServerResponse<Substation>.fromJson(data);
      response.setData(Substation.fromJson(data['data']['substation']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<CuttingMachine>> getCuttingMachine(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final response = ServerResponse<CuttingMachine>.fromJson(data);
      response.setData(CuttingMachine.fromJson(data['data']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<Rmu>> getRmu(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final response = ServerResponse<Rmu>.fromJson(data);
      response.setData(Rmu.fromJson(data['data']['rmu']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<Breaker>> getBreaker(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final response = ServerResponse<Breaker>.fromJson(data);
      response.setData(Breaker.fromJson(data['data']['breaker']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<FallOfFuses>> getFallOffFuses(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final response = ServerResponse<FallOfFuses>.fromJson(data);
      response.setData(FallOfFuses.fromJson(data['data']['fallOffFuses']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LightningConductor>> getLightningConductor(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final json = data['data']['lightningConductor'];
      final response = ServerResponse<LightningConductor>.fromJson(data);
      response.setData(LightningConductor.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LowPressureCabinetModel>> getLowPressureCabinet(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final json = data['data'];
      final response = ServerResponse<LowPressureCabinetModel>.fromJson(data);
      response.setData(
          LowPressureCabinetModel.fromJson(json['lowPressureCabinet']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LowVoltageCapacitoModel>> getLowVoltageCapacito(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final json = data['data'];
      final response = ServerResponse<LowVoltageCapacitoModel>.fromJson(data);
      response.setData(
          LowVoltageCapacitoModel.fromJson(json['lowVoltageCapacito']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<TUModel>> getTU(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final json = data['data'];
      final response = ServerResponse<TUModel>.fromJson(data);
      response.setData(TUModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<DistributionPowerCableModel>> getDistributionPowerCable(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final json = data['data'];
      final response =
          ServerResponse<DistributionPowerCableModel>.fromJson(data);
      response.setData(DistributionPowerCableModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InsulationModel>> getInsulation(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final json = data['data']['insulation'];
      final response = ServerResponse<InsulationModel>.fromJson(data);
      response.setData(InsulationModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<GeneralInfoResponse>> updateInterPopup(
    String ticketId,
    String path,
    Map<String, dynamic> params, {
    bool isBackgroundMode = false,
  }) async {
    try {
      final data = await provider.put(
          '/immediaryinspect/$ticketId/content/$path', params,
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<GeneralInfoResponse>.fromJson(data);
      response.setData(GeneralInfoResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<GeneralInfoResponse>> updateInterNightPopup(
    String ticketId,
    String path,
    Map<String, dynamic> params, {
    bool isBackgroundMode = false,
  }) async {
    try {
      final data = await provider.put(
          '/immediaryinspect/$ticketId/content-night-time/$path', params,
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<GeneralInfoResponse>.fromJson(data);
      response.setData(GeneralInfoResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<DistributionGroundingSystem>> getGroundingSystem(
      String ticketId, String endPoint) async {
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/$endPoint',
          isRequireAuth: true);
      final json = data['data']['groundingSystem'];
      final response =
          ServerResponse<DistributionGroundingSystem>.fromJson(data);
      response.setData(DistributionGroundingSystem.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<TiModel>> getTI(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final json = data['data']['ti'];
      final response = ServerResponse<TiModel>.fromJson(data);
      response.setData(TiModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<GeneralInfoResponse>> updatePopup(
    String ticketId,
    String path,
    Map<String, dynamic> params, {
    bool isBackgroundMode = false,
  }) async {
    try {
      final data = await provider.put(
          '/distributioninspect/$ticketId/content/$path', params,
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<GeneralInfoResponse>.fromJson(data);
      response.setData(GeneralInfoResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<GeneralInfoResponse>> updateLinePopup(
    String ticketId,
    String path,
    Map<String, dynamic> params,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    try {
      final data = await provider.put(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$path', params,
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<GeneralInfoResponse>.fromJson(data);
      response.setData(GeneralInfoResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  // Tram bien ap phan phoi
  Future<ServerResponse<DistributionBuildingStructureModel>>
      getBuildingStructure(String ticketId, String endPoint) async {
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/$endPoint',
          isRequireAuth: true);
      final json = data['data']['buildingStructure'];
      final response =
          ServerResponse<DistributionBuildingStructureModel>.fromJson(data);
      response.setData(DistributionBuildingStructureModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  // Trạm biến áp trung gian

  Future<ServerResponse<HighPressureCable>> getHighPressureCable(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final response = ServerResponse<HighPressureCable>.fromJson(data);
      response.setData(
          HighPressureCable.fromJson(data['data']['highPressureCable']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LowPressureCable>> getPressureCable(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final response = ServerResponse<LowPressureCable>.fromJson(data);
      response
          .setData(LowPressureCable.fromJson(data['data']['lowPressureCable']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<OneWaySystem>> getOneWaySystem(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};

    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final response = ServerResponse<OneWaySystem>.fromJson(data);
      response.setData(OneWaySystem.fromJson(data['data']['oneWaySystem']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<AlternatingCurrentSystem>> getAlternatingCurrentSystem(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};

    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final response = ServerResponse<AlternatingCurrentSystem>.fromJson(data);
      response.setData(AlternatingCurrentSystem.fromJson(
          data['data']['alternatingCurrentSystem']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterBattery>> getInterBattery(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};

    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final response = ServerResponse<InterBattery>.fromJson(data);
      response.setData(InterBattery.fromJson(data['data']['battery']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<FillingCabinet>> getFillingCabinet(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};

    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final response = ServerResponse<FillingCabinet>.fromJson(data);
      response.setData(FillingCabinet.fromJson(data['data']['fillingCabinet']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterGroundingSystem>> getInterGroundingSystem(
      String ticketId, String endPoint) async {
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          isRequireAuth: true);
      final response = ServerResponse<InterGroundingSystem>.fromJson(data);
      response.setData(
          InterGroundingSystem.fromJson(data['data']['groundingSystem']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterMeasuringSystem>> getInterMeasuringSystem(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final response = ServerResponse<InterMeasuringSystem>.fromJson(data);
      response.setData(
          InterMeasuringSystem.fromJson(data['data']['measuringSystem']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterElectricCabinet>> getInterElectricCabinet(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final response = ServerResponse<InterElectricCabinet>.fromJson(data);
      response.setData(
          InterElectricCabinet.fromJson(data['data']['electricCabinet']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterClampRow>> getInterClampRow(
      String ticketId, String endPoint) async {
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          isRequireAuth: true);
      final response = ServerResponse<InterClampRow>.fromJson(data);
      response.setData(InterClampRow.fromJson(data['data']['clampRow']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterJoint>> getInterJoint(
      String ticketId, String endPoint) async {
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          isRequireAuth: true);
      final response = ServerResponse<InterJoint>.fromJson(data);
      response.setData(InterJoint.fromJson(data['data']['joint']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterResistanceTemperatureDetector>>
      getInterResistanceTemperatureDetector(
          String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final response =
          ServerResponse<InterResistanceTemperatureDetector>.fromJson(data);
      response.setData(InterResistanceTemperatureDetector.fromJson(
          data['data']['resistanceTemperatureDetector']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterConstructionStructure>>
      getInterConstructionStructure(String ticketId, String endPoint) async {
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          isRequireAuth: true);
      final response =
          ServerResponse<InterConstructionStructure>.fromJson(data);
      response.setData(InterConstructionStructure.fromJson(
          data['data']['constructionStructure']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterImmediaryStationCleaning>>
      getInterImmediaryStationCleaning(
          String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final response =
          ServerResponse<InterImmediaryStationCleaning>.fromJson(data);
      response.setData(InterImmediaryStationCleaning.fromJson(
          data['data']['stationCleaning']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterSubstationModel>> getInterSubstation(
      String ticketId, String equipmentId) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/substation',
          params: param,
          isRequireAuth: true);
      final json = data['data']['substation'];
      final response = ServerResponse<InterSubstationModel>.fromJson(data);
      response.setData(InterSubstationModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterSubstationRoomModel>> getInterSubstationRoom(
      String ticketId) async {
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/substation-room',
          isRequireAuth: true);
      final json = data['data']['substationRoom'];
      final response = ServerResponse<InterSubstationRoomModel>.fromJson(data);
      response.setData(InterSubstationRoomModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterCuttingMachineModel>> getInterCuttingMachine(
      String ticketId, String equipmentId, String endpoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endpoint',
          params: param,
          isRequireAuth: true);
      final json = data['data']['cuttingMachine'];
      final response = ServerResponse<InterCuttingMachineModel>.fromJson(data);
      response.setData(InterCuttingMachineModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterRecloserModel>> getInterRecloser(
      String ticketId, String equipmentId, String endpoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endpoint',
          params: param,
          isRequireAuth: true);
      final json = data['data']['recloser'];
      final response = ServerResponse<InterRecloserModel>.fromJson(data);
      response.setData(InterRecloserModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterDisconnectorsSwitches>>
      getInterDisconnectorsSwitches(
          String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final json = data['data']['disconnectorsSwitches'];
      final response =
          ServerResponse<InterDisconnectorsSwitches>.fromJson(data);
      response.setData(InterDisconnectorsSwitches.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterCutterLBS>> getInterCutterLBS(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final json = data['data']['cutterLbs'];
      final response = ServerResponse<InterCutterLBS>.fromJson(data);
      response.setData(InterCutterLBS.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterFallOfFuse>> getInterFallOfFuse(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final json = data['data']['fallofFuse'];
      final response = ServerResponse<InterFallOfFuse>.fromJson(data);
      response.setData(InterFallOfFuse.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterVariableVoltage>> getInterVariableVoltage(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final json = data['data']['variableVoltage'];
      final response = ServerResponse<InterVariableVoltage>.fromJson(data);
      response.setData(InterVariableVoltage.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterVariableCurrent>> getInterVariableCurrent(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final json = data['data']['currentTransformer'];
      final response = ServerResponse<InterVariableCurrent>.fromJson(data);
      response.setData(InterVariableCurrent.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterLightningConductor>> getInterLightningConductor(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final json = data['data']['lightningConductor'];
      final response = ServerResponse<InterLightningConductor>.fromJson(data);
      response.setData(InterLightningConductor.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterCableHead>> getInterCableHead(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final json = data['data']['cableHead'];
      final response = ServerResponse<InterCableHead>.fromJson(data);
      response.setData(InterCableHead.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InterInsulation>> getInterInsulation(
      String ticketId, String equipmentId, String endPoint) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content/$endPoint',
          params: param,
          isRequireAuth: true);
      final json = data['data']['insulation'];
      final response = ServerResponse<InterInsulation>.fromJson(data);
      response.setData(InterInsulation.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<JointNight>> getInterJointNight(
      String ticketId, String endPoint) async {
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content-night-time/$endPoint',
          isRequireAuth: true);
      final response = ServerResponse<JointNight>.fromJson(data);
      if (response.isLoadSuccess) {
        final json = data['data']['jointNightTime'];
        response.setData(JointNight.fromJson(json));
      }
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<SubstationRoomNight>> getInterSubstationNight(
      String ticketId, String endPoint) async {
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content-night-time/$endPoint',
          isRequireAuth: true);
      final json = data['data']['substation'];
      final response = ServerResponse<SubstationRoomNight>.fromJson(data);
      response.setData(SubstationRoomNight.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LightSystemNight>> getInterLightSystemNight(
      String ticketId, String endPoint) async {
    try {
      final data = await provider.get(
          '/immediaryinspect/$ticketId/content-night-time/$endPoint',
          isRequireAuth: true);
      final response = ServerResponse<LightSystemNight>.fromJson(data);
      if (response.isLoadSuccess) {
        final json = data['data']['lightingSystemNightTime'];
        response.setData(LightSystemNight.fromJson(json));
      }
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<SubstationNightTime>> getTransformerNightTime(
      String ticketId, String endPoint) async {
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/night-time/$endPoint',
          isRequireAuth: true);
      final response = ServerResponse<SubstationNightTime>.fromJson(data);
      response.setData(
          SubstationNightTime.fromJson(data['data']['substationNightTime']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<JointNightTime>> getJointNightTime(
      String ticketId, String endPoint) async {
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/night-time/$endPoint',
          isRequireAuth: true);
      final response = ServerResponse<JointNightTime>.fromJson(data);
      response.setData(JointNightTime.fromJson(data['data']['jointNightTime']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LightingSystemNightTime>> getLightingSystemNightTime(
      String ticketId, String endPoint) async {
    try {
      final data = await provider.get(
          '/distributioninspect/$ticketId/content/night-time/$endPoint',
          isRequireAuth: true);
      final response = ServerResponse<LightingSystemNightTime>.fromJson(data);
      response.setData(LightingSystemNightTime.fromJson(
          data['data']['lightingSystemNightTime']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<GeneralInfoResponse>> updateDistributionNightPopup(
    String ticketId,
    String endPoint,
    Map<String, dynamic> params, {
    bool isBackgroundMode = false,
  }) async {
    try {
      final data = await provider.put(
          '/distributioninspect/$ticketId/content/night-time/$endPoint', params,
          isRequireAuth: true, backgroundMode: isBackgroundMode);
      final response = ServerResponse<GeneralInfoResponse>.fromJson(data);
      response.setData(GeneralInfoResponse.fromJson(data));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  // Line
  Future<ServerResponse<LinePoleModel>> getLinePole(
    String ticketId,
    String equipmentId,
    String endPoint,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final json = data['data']['linePole'];
      final response = ServerResponse<LinePoleModel>.fromJson(data);
      response.setData(LinePoleModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineCapacitorModel>> getLineCapacitor(
    String ticketId,
    String equipmentId,
    String endPoint,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final json = data['data']['lineCapacitor'];
      final response = ServerResponse<LineCapacitorModel>.fromJson(data);
      response.setData(LineCapacitorModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineBeamModel>> getLineBeam(
    String ticketId,
    String equipmentId,
    String endPoint,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final json = data['data']['lineBeam'];
      final response = ServerResponse<LineBeamModel>.fromJson(data);
      response.setData(LineBeamModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineCuttingMachineModel>> getLineCuttingMachine(
    String ticketId,
    String equipmentId,
    String endPoint,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final json = data['data']['cuttingMachine'];
      final response = ServerResponse<LineCuttingMachineModel>.fromJson(data);
      response.setData(LineCuttingMachineModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineDisconnectorsSwitchModel>>
      getLineDisconnectorsSwitch(
    String ticketId,
    String equipmentId,
    String endPoint,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final json = data['data']['lineDisconnectorsSwitch'];
      final response =
          ServerResponse<LineDisconnectorsSwitchModel>.fromJson(data);
      response.setData(LineDisconnectorsSwitchModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineEarthingModel>> getLineEarthing(
    String ticketId,
    String equipmentId,
    String endPoint,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final json = data['data']['lineEarthing'];
      final response = ServerResponse<LineEarthingModel>.fromJson(data);
      response.setData(LineEarthingModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineFundamentModel>> getLineFundament(
    String ticketId,
    String equipmentId,
    String endPoint,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final json = data['data']['lineFundament'];
      final response = ServerResponse<LineFundamentModel>.fromJson(data);
      response.setData(LineFundamentModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineFuseCutOutModel>> getLineFuseCutOut(
    String ticketId,
    String equipmentId,
    String endPoint,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final json = data['data']['lineFuseCutOut'];
      final response = ServerResponse<LineFuseCutOutModel>.fromJson(data);
      response.setData(LineFuseCutOutModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineInsulationModel>> getLineInsulation(
    String ticketId,
    String equipmentId,
    String endPoint,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final json = data['data']['lineInsulation'];
      final response = ServerResponse<LineInsulationModel>.fromJson(data);
      response.setData(LineInsulationModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineLightningArresterModel>> getLineLightningArrester(
    String ticketId,
    String equipmentId,
    String endPoint,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final json = data['data']['lineLightningArrester'];
      final response =
          ServerResponse<LineLightningArresterModel>.fromJson(data);
      response.setData(LineLightningArresterModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineMeasureTheBoundaryModel>> getLineMeasureTheBoundary(
    String ticketId,
    String equipmentId,
    String endPoint,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final json = data['data']['lineMeasureTheBoundary'];
      final response =
          ServerResponse<LineMeasureTheBoundaryModel>.fromJson(data);
      response.setData(LineMeasureTheBoundaryModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineRecloserModel>> getLineRecloser(
    String ticketId,
    String equipmentId,
    String endPoint,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final json = data['data']['lineRecloser'];
      final response = ServerResponse<LineRecloserModel>.fromJson(data);
      response.setData(LineRecloserModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineRodGadModel>> getLineRodGap(
    String ticketId,
    String equipmentId,
    String endPoint,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final json = data['data']['lineRodGap'];
      final response = ServerResponse<LineRodGadModel>.fromJson(data);
      response.setData(LineRodGadModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineWireModel>> getLineWire(
    String ticketId,
    String equipmentId,
    String endPoint,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final json = data['data']['lineWire'];
      final response = ServerResponse<LineWireModel>.fromJson(data);
      response.setData(LineWireModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineUndergroundCable>> getLineUndergroundCable(
    String ticketId,
    String equipmentId,
    String endPoint,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final json = data['data']['undergroundCable'];
      final response = ServerResponse<LineUndergroundCable>.fromJson(data);
      response.setData(LineUndergroundCable.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineBreaker>> getLineBreaker(
    String ticketId,
    String equipmentId,
    String endPoint,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final response = ServerResponse<LineBreaker>.fromJson(data);
      response.setData(LineBreaker.fromJson(data['data']['lineBreaker']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineRmu>> getLineRmu(
    String ticketId,
    String equipmentId,
    String endPoint,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final response = ServerResponse<LineRmu>.fromJson(data);
      response.setData(LineRmu.fromJson(data['data']['lineRmu']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineTiModel>> getLineTI(
    String ticketId,
    String equipmentId,
    String endPoint,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final json = data['data']['lineTi'];
      final response = ServerResponse<LineTiModel>.fromJson(data);
      response.setData(LineTiModel.fromJson(json));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<LineTUModel>> getLineTU(
    String ticketId,
    String equipmentId,
    String endPoint,
    String lineBranchInfo, {
    bool isBackgroundMode = false,
  }) async {
    final param = {'equipmentId': equipmentId};
    try {
      final data = await provider.get(
          '/lineinspect/$ticketId/$lineBranchInfo/content/$endPoint',
          params: param,
          isRequireAuth: true,
          backgroundMode: isBackgroundMode);
      final json = data['data'];
      final response = ServerResponse<LineTUModel>.fromJson(data);
      response.setData(LineTUModel.fromJson(json['lineTu']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

