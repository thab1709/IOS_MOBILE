// @dart=2.9
import 'package:evnmobile/src/htld/models/group_model.dart';
import 'package:g_json/g_json.dart';

import '../server_response.dart';

class GroupResponse extends ServerResponse {
  GroupResponse.fromJson(JSON json) : super.fromJson(json) {
    group = GroupModel.fromJson(json['data']);
  }

  GroupModel group;
}

