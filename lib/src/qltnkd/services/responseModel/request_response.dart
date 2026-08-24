// @dart=2.9
import 'package:evnmobile/src/qltnkd/models/workload/request_model.dart';
import 'package:g_json/g_json.dart';

import '../../../htld/models/paging.dart';

class RequestsResponse {
  RequestsResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      data?.forEach((element) {
        list.add(RequestModel.fromJson(JSON(element)));
      });
    }
  }

  List<RequestModel> list = <RequestModel>[];
  Paging paging;
}

