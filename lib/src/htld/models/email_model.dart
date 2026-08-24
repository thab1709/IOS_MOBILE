// @dart=2.9
import 'package:g_json/g_json.dart';

class EmailModel {
  String id;
  String email;

  EmailModel({this.id, this.email});

  factory EmailModel.fromJson(JSON json) {
    return EmailModel(
      id: json['id'].string,
      email: json['email'].string,
    );
  }
}

