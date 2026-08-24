// @dart=2.9
import 'package:g_json/g_json.dart';

class TotalCheckModel {
  int countCheckNote;
  int countCheckOperationNote;

  TotalCheckModel({
    this.countCheckNote,
    this.countCheckOperationNote,
  });

  TotalCheckModel.fromJson(JSON json) {
    countCheckNote = json['countCheckNote'].integer;
    countCheckOperationNote = json['countCheckOperationNote'].integer;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['countCheckNote'] = countCheckNote;
    data['countCheckOperationNote'] = countCheckOperationNote;

    return data;
  }
}

