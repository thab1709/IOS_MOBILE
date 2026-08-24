// @dart=2.9
import 'package:evnmobile/src/htld/models/paging.dart';
import 'package:evnmobile/src/qltnkd/models/stamp_model.dart';
import 'package:g_json/g_json.dart';

class StampsResponse {
  List<StampModel> list;
  Paging paging;

  StampsResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      list = data?.map((e) => StampModel.fromJson(JSON(e)))?.toList();
    }
  }
}
