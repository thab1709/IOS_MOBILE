// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htdct/services/responseModel/feedback_response.dart';
import 'package:flutter/material.dart';

import '../server_response.dart';

class FeedbackRepository {
  final _provider = ApiProvider();

  Future<ServerResponse<FeedBackResponse>> getListWork({
    String workId,
    String searchTerm,
    num pageIndex = 1,
    String orderBy = 'ASC',
    String orderByDesc,
    String fromDate,
    String toDate,
    num pageOffset,
    bool isNotShowLoading = false,
    bool isFilter = false
  }) async {

    final param = isFilter ? {
      'FromDate': fromDate,
      'ToDate': toDate,
      'orderBy': orderBy,
      'pageIndex': pageIndex.toString(),
      'orderByDesc': orderByDesc,
      'pageSize': '30',
      'pageOffset': pageOffset?.toString(),
      'SearchTerm': searchTerm ?? ''
    }:{
      'orderBy': orderBy,
      'pageIndex': pageIndex.toString(),
      'orderByDesc': orderByDesc,
      'pageSize': '30',
      'pageOffset': pageOffset?.toString(),
      'SearchTerm': searchTerm ?? ''
    };
    try {
      final data = await _provider.get('/feedback/$workId/line',
          params: param, isRequireAuth: true, backgroundMode: isNotShowLoading);
      final response = ServerResponse<FeedBackResponse>.fromJson(data);
      final works = FeedBackResponse.fromJson(data);
      response.setData(works);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<String>> creatFeedback({@required Map<String, dynamic> params}) async {

    final data = await _provider.post('/feedback/create', params, isRequireAuth: true);
    final response = ServerResponse<String>.fromJson(data);
    response.setData(data['data'].string);
    return response;
  }

  Future<ServerResponse<FeedBackDetailResponse>> getFeedbackDetail(
      {String id}) async {
    try {
      final data = await _provider.get('/feedback/${id}/detail/line',
          isRequireAuth: true);
      final response = ServerResponse<FeedBackDetailResponse>.fromJson(data);
      final lineInspectList = FeedBackDetailResponse.fromJson(data);
      response.setData(lineInspectList);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

