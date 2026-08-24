// @dart=2.9
import 'package:evnmobile/src/htld/services/responseModel/login_response.dart';
import 'package:evnmobile/src/htld/services/server_response.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';

import '../networking/api_provider.dart';

class AppAuthRepository {
  final _provider = ApiProvider();

  Future<ServerResponse<LoginResponse>> login(
      String phoneNumber, String password) async {
    String deviceToken;
    try {
      deviceToken = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint('FCM getToken failed (ignored): $e');
    }    // String deviceToken;
    // try {
    //   deviceToken = await FirebaseMessaging.instance.getToken();
    // } catch (e) {
    //   debugPrint('Firebase getToken error: ${e.toString()}');
    //   deviceToken = ''; // Fallback to empty string if Firebase token fails
    // }

    debugPrint('Firebase TOKEN : ${deviceToken}');
    final params = {
      'username': phoneNumber,
      'password': password,
      'timezoneOffset': DateTime.now().timeZoneOffset.inDays - 420,
      'rememberMe': true,
      'firebaseRegistrationKey': deviceToken
    };
    try {
      final data =
          await _provider.post('/user/login', params, isRequireAuth: false);
      final response = ServerResponse<LoginResponse>.fromJson(data);

      // response.setData(LoginResponse.fromJson(JSON(data['data'])));
      // debugPrint('Firebase TOKEN SUCCESS : ${response.toString()}');

      if (response.statusCode == 200) {
        response.setData(LoginResponse.fromJson(JSON(data['data'])));
        debugPrint('LOGIN SUCCESS: ${response.data}');
      } else {
        debugPrint(
            'LOGIN FAILED: ${response.message} (code: ${response.statusCode})');
        response.setData(null);
      }

      return response;
    } catch (error) {
      debugPrint("Firebase TOKEN Error ${error.toString()}");
      return ServerResponse();
    }
  }

  Future<ServerResponse<LoginResponse>> loginSSO(
      String ticket, String appCode) async {
    final params = {
      'ticket': ticket,
      'appCode': appCode,
      'timezoneOffset': DateTime.now().timeZoneOffset.inDays - 420,
    };
    try {
      final data =
          await _provider.post('/user/sso-login', params, isRequireAuth: false);
      final response = ServerResponse<LoginResponse>.fromJson(data);
      response.setData(LoginResponse.fromJson(JSON(data['data'])));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

