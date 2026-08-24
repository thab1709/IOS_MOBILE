// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htld/services/responseModel/login_response.dart';
import 'package:evnmobile/src/htld/services/server_response.dart';

class ReportAuthRepository {
  final _provider = ApiProvider();

  Future<ServerResponse> logout() async {
    final data = await _provider.post('/user/logout', {}, isRequireAuth: true);
    final response = ServerResponse.fromJson(data);
    return response;
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

