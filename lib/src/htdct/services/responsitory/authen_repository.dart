// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htdct/services/responseModel/login_response.dart';
import 'package:evnmobile/src/htdct/services/server_response.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final _provider = ApiProvider();

  Future<ServerResponse> logout() async {
    final data = await _provider.post('/user/logout', {}, isRequireAuth: true);
    final response = ServerResponse.fromJson(data);
    return response;
  }

  Future<ServerResponse<LoginResponse>> login(String phoneNumber, String password) async {
    final deviceToken = await FirebaseMessaging.instance.getToken();
    final params = {
      'username': phoneNumber,
      'password': password,
      'timezoneOffset': DateTime.now().timeZoneOffset.inDays - 420,
      'rememberMe': true,
      'firebaseRegistrationKey': deviceToken
    };
    try {
      final data = await _provider.post('/user/login', params);
      final response = ServerResponse<LoginResponse>.fromJson(data);
      if (response.isLoadSuccess) {
        response.setData(LoginResponse.fromJson(data));
      }
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<bool>> changePasswordExpired(String username,
      String oldPass, String newPass, String retypePass) async {
    final params = <String, String>{
      'userName': username,
      'oldPassword': oldPass,
      'newPassword': newPass,
      'confirmNewPassword': retypePass
    };
    final data = await _provider.put('/user/change-expire-password', params);
    final response = ServerResponse<bool>.fromJson(data);
    response.setData(data['data'].boolean);
    return response;
  }

  Future<ServerResponse<bool>> changePassword(
      {String username,
      String oldPass,
      String newPass,
      String retypePass,
      String userId}) async {
    final params = <String, String>{
      'userName': username,
      'oldPassword': oldPass,
      'newPassword': newPass,
      'confirmNewPassword': retypePass
    };
    final data = await _provider.put('/user/$userId/change-password', params);
    final response = ServerResponse<bool>.fromJson(data);
    response.setData(data['data'].boolean);
    return response;
  }
}

