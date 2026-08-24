// @dart=2.9
class UserImp {
  UserImp({
      this.id, 
      this.name,});

  UserImp.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  String id;
  String name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}
