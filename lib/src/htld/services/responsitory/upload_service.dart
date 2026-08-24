// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htld/models/attach_image_model.dart';
import 'package:evnmobile/src/htld/services/server_response.dart';
import 'package:flutter/cupertino.dart';

class UploadService {
  final provider = ApiProvider();

  Future<ServerResponse<Images>> upload(File file, {bool isBackgroundMode = false}) async {
    try {
      final data = await provider.uploadFile(file, backgroundMode: isBackgroundMode);
      final response = ServerResponse<Images>.fromJson(data);
      response.setData(Images.fromJson(data['data']));
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

