// @dart=2.9
import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

class SignatureImageHelper {
  static const int _maxImageBytes = 5 * 1024 * 1024;
  static const String _cacheKeyPrefix = 'workload_consultants_signature_';

  static String toPngDataUri(Uint8List bytes) {
    return 'data:image/png;base64,${base64Encode(bytes)}';
  }

  static Uint8List decodeConsultantsImage(String value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    try {
      var base64Value = value.trim();
      final commaIndex = base64Value.indexOf(',');
      if (base64Value.startsWith('data:image') && commaIndex >= 0) {
        base64Value = base64Value.substring(commaIndex + 1);
      }
      base64Value = base64Value.replaceAll(RegExp(r'\s+'), '');
      final bytes = base64Decode(base64Value);
      if (bytes == null || bytes.isEmpty || bytes.length > _maxImageBytes) {
        return null;
      }
      return bytes;
    } catch (_) {
      return null;
    }
  }

  static bool isValidConsultantsImage(String value) {
    return decodeConsultantsImage(value) != null;
  }

  static Future saveConsultantsImage(String workloadId, String value) async {
    if (workloadId == null || workloadId.isEmpty || !isValidConsultantsImage(value)) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_cacheKeyPrefix$workloadId', value);
  }

  static Future<String> getCachedConsultantsImage(String workloadId) async {
    if (workloadId == null || workloadId.isEmpty) {
      return null;
    }
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('$_cacheKeyPrefix$workloadId');
    return isValidConsultantsImage(value) ? value : null;
  }
}

