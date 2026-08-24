// @dart=2.9
import 'package:g_json/g_json.dart';

class UserOptionModel {
  String title;
  String value;
  bool isSelected;
  UserOptionModel(this.title, this.value, {this.isSelected = false});
}

class OptionModel {
  OptionModel(this.title, this.value);

  factory OptionModel.fromJSON(JSON json) {
    return OptionModel(json['title'].stringValue, json['value'].integer);
  }

  int value;
  String title;
  //user for dropdown_search
  @override
  String toString() => title;
}

class OptionModelString {
  OptionModelString(this.title, this.value);

  factory OptionModelString.fromJSON(JSON json) {
    return OptionModelString(json['title'].stringValue, json['value'].string);
  }

  String value;
  String title;

  //user for dropdown_search
  @override
  String toString() => title;
}
