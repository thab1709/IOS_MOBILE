// @dart=2.9
import 'package:evnmobile/src/htld/models/paging.dart';
import 'package:evnmobile/src/qltnkd/models/form_info.dart';
import 'package:g_json/g_json.dart';

class FormInfoResponse {
  List<FormInfo> list;
  Paging paging;

  FormInfoResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      list = data?.map((e) => FormInfo.fromJson(JSON(e)))?.toList();
    }
  }
}

