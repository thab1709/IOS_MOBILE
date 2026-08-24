// @dart=2.9
import 'package:g_json/g_json.dart';

class WeirdoMessage {
  String equipmentId;
  int index;
  String message = '';

  WeirdoMessage(this.index, {this.message, this.equipmentId});

  WeirdoMessage.fromJson(JSON json) {
    index = json['index'].integer;
    message = json['message'].string;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['index'] = index;
    map['message'] = message;
    return map;
  }
}

class LineWeirdoMessage {

  int index;
  String option;
  String equipmentId;
  int optionValue;
  String problem = '';
  String message = '';

  LineWeirdoMessage(this.index, {this.message, this.problem, this.optionValue, this.option, this.equipmentId});
}
