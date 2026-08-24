// @dart=2.9
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htld/models/notification_model.dart';
import 'package:evnmobile/src/htld/services/server_response.dart';
import 'package:flutter/material.dart';

class NotificationRepository {
  final provider = ApiProvider();

  /// Lấy số lượng notification chưa đọc
  Future<ServerResponse<int>> getUnreadCount() async {
    try {
      final data = await provider.get('/user/countNotification',
          isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<int>.fromJson(data);
      final count = data['data']?.integer ?? 0;
      response.setData(count);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  /// Lấy danh sách notification
  Future<ServerResponse<List<NotificationModel>>> getNotifications() async {
    try {
      final data = await provider.get('/user/notification',
          isRequireAuth: true, backgroundMode: true);
      final response = ServerResponse<List<NotificationModel>>.fromJson(data);
      final list = data['data']
              .listValue
              ?.map((e) => NotificationModel.fromJson(e))
              ?.toList() ??
          [];
      response.setData(list);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

