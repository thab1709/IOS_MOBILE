// @dart=2.9
import 'package:evnmobile/src/htld/models/person_performing_model.dart';
import 'package:g_json/g_json.dart';


class GroupModel {
  String _id;
  List<PersonPerformingModel> _groups;

  String get id => _id;
  List<PersonPerformingModel> get groups => _groups;

  GroupModel({
      String id, 
      List<PersonPerformingModel> groups}){
    _id = id;
    _groups = groups;
}

  GroupModel.fromJson(JSON json) {
    _id = json['id'].string;
    if (json['groups'] != null) {
      _groups = json['groups']?.listObject?.map((e) =>
          PersonPerformingModel.fromJson(JSON(e)))?.toList();
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_groups != null) {
      map['groups'] = _groups.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
