// @dart=2.9
import 'package:evnmobile/src/htdct/models/group_model.dart';
import 'package:g_json/g_json.dart';

class GroupResponse {
  GroupResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].listObject;
      if(data != null) {
        list = data?.map((e) => GroupModel.fromJson(JSON(e)))?.toList();
      }

    }
  }
  List<GroupModel> list = [];
}

