// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htdct/models/day_night/ticket.dart';
import 'package:evnmobile/src/htdct/services/server_response.dart';
import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';
import 'package:geolocator/geolocator.dart';
import '../../common/utils/common.dart';
import '../responseModel/dashboard_response/abnormal_dashboard_response.dart';
import '../responseModel/dashboard_response/guarantee_electricity_response.dart';
import '../responseModel/dashboard_response/inspect_dashboard_response.dart';
import 'package:http/http.dart' as http;

class DashboardRepository {
  final _provider = ApiProvider();

  Future<ServerResponse<GuaranteeElectricityResponse>> getGuaranteeElectricity({
    bool isBackground = true,
  }) async {
    try {
      final data = await _provider.get('/dashboard/guarantee-electricity',
          isRequireAuth: true, backgroundMode: isBackground);

      final response =
          ServerResponse<GuaranteeElectricityResponse>.fromJson(data);
      final works = GuaranteeElectricityResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> getNumberAbnormalInDay({
    bool isBackground = true,
  }) async {
    try {
      final data = await _provider.get('/dashboard/abnormal-in-day',
          isRequireAuth: true, backgroundMode: isBackground);

      final response = ServerResponse<String>.fromJson(data);
      final total = JSON(data['data']['total'])?.string;
      if (total != null) {
        response.setData(total);
      }

      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> getPerformOnGrid({
    bool isBackground = true,
  }) async {
    try {
      final data = await _provider.get('/dashboard/dashboard-violate',
          isRequireAuth: true, backgroundMode: isBackground);

      final response = ServerResponse<String>.fromJson(data);
      final completeGraphData = data['data']['completeGraphData'];
      final totalGrapData = data['data']['totalGraphData'];
      if (completeGraphData != null && completeGraphData != null) {
        response.setData('$completeGraphData/$totalGrapData');
      }

      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<AbnormalDashboardResponse>> getAbnormal({
    String fromDate,
    String toDate,
    bool isSubstation = true,
    bool isBackground = false,
  }) async {
    final params = {
      'FromDate': fromDate ?? '',
      'ToDate': toDate ?? '',
      'IsSubstation': isSubstation.toString()
    };

    try {
      final data = await _provider.get('/dashboard/abnormal',
          params: params, isRequireAuth: true, backgroundMode: isBackground);

      final response = ServerResponse<AbnormalDashboardResponse>.fromJson(data);
      final works = AbnormalDashboardResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<InspectDashboardResponse>> getInspect({
    Map <String, dynamic> params,
    bool isBackground = false,
  }) async {

    // final params ={
    //   'FromDate':fromDate??'',
    //   'ToDate':toDate??'',
    // };

    try {
      final data = await _provider.get('/dashboard/inspectdetail',
          params: params, isRequireAuth: true, backgroundMode: isBackground);

      final response = ServerResponse<InspectDashboardResponse>.fromJson(data);
      final works = InspectDashboardResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future getWeather() async {
    try {
      final location = await getCurrentPosition(isShowLoading: false);
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${location?.latitude}&lon=${location?.longitude}&appId=56d503f2af6c64d9fd20b23bd337f180'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
      //
      // final location = await getCurrentPosition();
      //
      // final data = await _provider.get('https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appId=56d503f2af6c64d9fd20b23bd337f180',
      //     isRequireAuth: true);
      // final response = ServerResponse<String>.fromJson(data);
      // return response;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }
}

