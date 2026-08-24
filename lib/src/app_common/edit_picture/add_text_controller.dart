// @dart=2.9
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'add_text_page.dart';

class AddTextController extends GetxController {
  List<File> files = <File>[];
  List<GlobalKey<FlutterPainterExampleState>> globalKeys =
      <GlobalKey<FlutterPainterExampleState>>[];
  List<File> filesCopy = <File>[];

  Future<bool> copyFile() async {
    Future resizeImage(File element) async {
      final properties = await FlutterNativeImage.getImageProperties(element.path);
      final compressedFile = await FlutterNativeImage.compressImage(
          element.path,
          quality: 90,
          targetWidth: 600,
          targetHeight: (properties.height * 600 / properties.width).round());
      final file = await changeFileNameOnly(compressedFile, p.basename(element.path));
      filesCopy.add(file);
    }

    final futures = <Future>[];
    files.forEach((element) {
      globalKeys.add(GlobalKey<FlutterPainterExampleState>());
      futures.add(resizeImage(element));
    });

    await Future.wait(futures);
    return true;
  }

  String getFileName(File file) {
    return p.basename(file.path);
  }

  Future<File> changeFileNameOnly(File file, String newFileName) async {
    final path = file.path;
    final lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    final newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.rename(newPath);
  }
}

