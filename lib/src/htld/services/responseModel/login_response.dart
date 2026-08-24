// @dart=2.9
import 'package:g_json/g_json.dart';

class LoginResponse {
  String accessToken;
  String refreshToken;
  String expires;
  String refreshExpires;
  String userId;
  int tokenLifeTime;
  int appType;

  LoginResponse(
      {this.accessToken,
      this.refreshToken,
      this.expires,
      this.refreshExpires,
      this.userId,
      this.tokenLifeTime,
      this.appType});

  LoginResponse.fromJson(JSON json) {
    accessToken = json['accessToken'].string;
    refreshToken = json['refreshToken'].string;
    expires = json['expires'].string;
    refreshExpires = json['refreshExpires'].string;
    userId = json['userId'].string;
    tokenLifeTime = json['tokenLifeTime'].integer;
    appType = json['appType'].integer;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['accessToken'] = accessToken;
    map['refreshToken'] = refreshToken;
    map['expires'] = expires;
    map['refreshExpires'] = refreshExpires;
    map['userId'] = userId;
    map['tokenLifeTime'] = tokenLifeTime;
    map['appType'] = appType;
    return map;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

