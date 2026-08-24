// @dart=2.9
import 'package:g_json/g_json.dart';

class Node {
  String substationId;
  int position;

  Node({
      this.substationId, 
      this.position,

  });

  Node.fromJson(JSON json) {
    substationId = json['substationId'].string;
    position = json['position'].integer;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['substationId'] = substationId;
    map['position'] = position;
    return map;
  }

}
