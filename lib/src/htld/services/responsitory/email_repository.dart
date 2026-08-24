// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htld/models/email_model.dart';
import 'package:evnmobile/src/htld/services/server_response.dart';
import 'package:flutter/material.dart';

class EmailRepository {
  final provider = ApiProvider();

  Future<ServerResponse> addEmail(String email) async {
    try {
      final params = {
        'email': email,
      };
      final data = await provider.post('/user/addemail', params,
          isRequireAuth: true, backgroundMode: false);
      final response = ServerResponse.fromJson(data);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<EmailModel>>> getEmails() async {
    try {
      final data = await provider.get('/user/emails',
          isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<EmailModel>>.fromJson(data);
      final list = data['data']
              .listValue
              ?.map((e) => EmailModel.fromJson(e))
              ?.toList() ??
          [];
      response.setData(list);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse> deleteEmail(String id) async {
    try {
      final params = {
        'id': id,
      };
      final data = await provider.post('/user/deleteemail', params,
          isRequireAuth: true, backgroundMode: false);
      final response = ServerResponse.fromJson(data);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

