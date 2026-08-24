// @dart=2.9
class CreateGroupRequest {
  List<Groups> _groups;

  List<Groups> get groups => _groups;

  CreateGroupRequest({
      List<Groups> groups}){
    _groups = groups;
}

  CreateGroupRequest.fromJson(json) {
    if (json['groups'] != null) {
      _groups = [];
      json['groups'].forEach((v) {
        _groups.add(Groups.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_groups != null) {
      map['groups'] = _groups.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Groups {
  String _userId;

  String get userId => _userId;

  Groups({
    String userId}){
    _userId = userId;
  }

  Groups.fromJson(json) {
    _userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = _userId;
    return map;
  }

}
