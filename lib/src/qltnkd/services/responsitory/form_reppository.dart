// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/qltnkd/common/utils/constance.dart';
import 'package:evnmobile/src/qltnkd/models/report_model.dart';
import 'package:evnmobile/src/qltnkd/models/stamp_model.dart';
import 'package:evnmobile/src/qltnkd/services/responseModel/form_info_response.dart';
import 'package:flutter/material.dart';

import '../server_response.dart';

class FormRepository {
  final _provider = ApiProvider();


  Future<ServerResponse<FormInfoResponse>> getForms({int pageIndex = 1}) async {
    try {
      final params = <String, dynamic>{'pageSize': '$rAppPageSize', 'pageIndex': '$pageIndex'};
      final data = await _provider.get('/form',
          params: params, isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<FormInfoResponse>.fromJson(data);
      return response..setData(FormInfoResponse.fromJson(data));
    } catch (_) {
      debugPrint(_.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<StampModel>>> getsTamp() async {
    try {
      //final params = <String, dynamic>{'pageSize': '9999', 'pageIndex': '1'};
      final data = await _provider.get('/form/get-stamp', isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<StampModel>>.fromJson(data);
      return response..setData(data['data']?.list?.map((e) => StampModel.fromJson(e))?.toList() ?? List.empty());
    } catch (_) {
      debugPrint(_.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<ReportModel>> getForm(String formId) async {
    try {
      final data = await _provider.get('/form/$formId',
          isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<ReportModel>.fromJson(data);
      response.setData(ReportModel.fromJson(data['data']));
      return response;
    } catch (_) {
      debugPrint(_.toString());
      return ServerResponse();
    }
  }
}

