// @dart=2.9
import 'package:g_json/g_json.dart';

class UserSignCertificateModel {
  String id;
  String name;
  String userName;
  String userPositionName;
  bool enableRedSignature;
  String type;

  UserSignCertificateModel({
    this.id,
    this.name,
    this.userName,
    this.userPositionName,
    this.enableRedSignature,
    this.type,
  });

  factory UserSignCertificateModel.fromJson(JSON json) {
    if (json == null) return null;
    return UserSignCertificateModel(
      id: json['id'].string,
      name: json['name'].string,
      userName: json['userName'].string,
      userPositionName: json['userPositionName'].string,
      enableRedSignature: json['enableRedSignature'].boolean ?? false,
      type: json['type'].string,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'userName': userName,
      'userPositionName': userPositionName,
      'enableRedSignature': enableRedSignature,
      'type': type,
    };
  }
}
