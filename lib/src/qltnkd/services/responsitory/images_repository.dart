// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/qltnkd/models/image_report.dart';
import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';

import '../server_response.dart';

class ImageRepository {
  final provider = ApiProvider();

  Future<ServerResponse<List<ImageReport>>> upload(List<File> files, {bool isBackgroundMode = false}) async {
    try {
      final data = await provider.uploadFiles(files, backgroundMode: isBackgroundMode);
      final response = ServerResponse<List<ImageReport>>.fromJson(data);
      final resultData = data['data']?.listObject?.map((e) => ImageReport.fromJson(JSON(e)))?.toList() ?? [];
      response.setData(resultData);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }

  Future<ServerResponse<List<ImageReport>>> getImagesByIDs(List<String> ids,
      {bool isBackgroundMode = false}) async {
    final param = {'ids': ids};

    try {
      final data = await provider.post('/common/images', param, backgroundMode: isBackgroundMode);
      final response = ServerResponse<List<ImageReport>>.fromJson(data);
      final images = data['data']?.listObject?.map((e) => ImageReport.fromJson(JSON(e)))?.toList() ?? [];
      response.setData(images);
      return response;
    } catch (error) {
      debugPrint(error.toString());
      return ServerResponse();
    }
  }
}

