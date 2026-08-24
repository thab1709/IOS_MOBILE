// @dart=2.9
import 'package:evnmobile/src/qltnkd/models/workload/workload_model.dart';
import 'package:g_json/g_json.dart';

import '../../../htld/models/paging.dart';

class WorkloadRequestsResponse {
  WorkloadRequestsResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      data?.forEach((element) {
        list.add(WorkloadModel.fromJson(JSON(element)));
      });
    }
  }

  List<WorkloadModel> list = <WorkloadModel>[];
  Paging paging;
}

