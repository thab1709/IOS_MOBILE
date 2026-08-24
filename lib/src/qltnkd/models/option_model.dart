// @dart=2.9
import 'package:g_json/g_json.dart';

class IntOptionModel {
  const IntOptionModel(this.title, this.value);

  factory IntOptionModel.fromJSON(JSON json) {
    return IntOptionModel(json['title'].stringValue, json['value'].integer);
  }

  final int value;
  final String title;
}

class StringOptionModel {
   StringOptionModel(this.title, this.value, [this.subtitle]);

  factory StringOptionModel.fromJSON(JSON json) {
    return StringOptionModel(
      json['title'].stringValue,
      json['value'].string,
      json['SubTitle'].string,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['value'] = value;
    map['SubTitle'] = subtitle;
    return map;
  }

  final String value;
  final String title;
  final String subtitle;
  bool isSelected;
}


