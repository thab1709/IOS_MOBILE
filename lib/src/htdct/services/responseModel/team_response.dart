// @dart=2.9
import 'package:evnmobile/src/htdct/models/team_model.dart';
import 'package:g_json/g_json.dart';

class TeamResponse {
  TeamResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].listObject;
      list = data?.map((e) => TeamModel.fromJson(JSON(e)))?.toList();
    }
  }
  List<TeamModel> list = [];
}

