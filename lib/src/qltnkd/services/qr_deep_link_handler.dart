import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/routes.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/qltnkd/models/qr_report_result.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report_by_transformer/report_by_transformer_controller.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/detail_report/detail_report_screen.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/report_repository.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class QrDeepLinkHandler {
  static const MethodChannel _channel = MethodChannel('com.evn.pmis/deepLink');
  static bool _initialized = false;
  static bool _isOpeningReport = false;
  static String _pendingFormReportId;

  static Future<void> init() async {
    if (_initialized) {
      return;
    }

    _initialized = true;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'deepLink' || call.method == 'deepLinkFirst') {
        await handle(call.arguments?.toString());
      }
    });

    try {
      final initialLink = await _channel.invokeMethod<String>('getInitialLink');
      await handle(initialLink);
    } catch (_) {}
  }

  static Future<void> handle(String url) async {
    final result = _parseQrDeepLink(url);
    final formReportId = result?.searchValue?.trim();
    if (formReportId == null || formReportId.isEmpty) {
      return;
    }

    if (formReportId == _pendingFormReportId && _isOpeningReport) {
      return;
    }

    _pendingFormReportId = formReportId;
    await _openReportList(formReportId);
  }

  static Future<void> openPendingReport() async {
    final formReportId = _pendingFormReportId;
    if (formReportId == null || formReportId.isEmpty) {
      return;
    }
    await _openReportList(formReportId);
  }

  static QRReportResult _parseQrDeepLink(String url) {
    if (url == null || url.isEmpty) {
      return null;
    }

    Uri uri;
    try {
      uri = Uri.parse(url);
    } catch (_) {
      return null;
    }

    final isAppScheme = uri.scheme == 'com.evn.pmis' && uri.host == 'open';
    final isHttpLink = (uri.scheme == 'http' || uri.scheme == 'https') &&
        (uri.host == 'appqthtuat.evnhanoi.com.vn' || uri.host == 'localhost') &&
        uri.path.contains('/tnkd/qr');

    if (!isAppScheme && !isHttpLink) {
      return null;
    }

    final formReportId = uri.queryParameters['formReportId'];
    if (formReportId == null || formReportId.trim().isEmpty) {
      return null;
    }

    return QRReportResult(
      rawCode: url,
      reportId: formReportId,
    );
  }

  static Future<void> _openReportList(String formReportId) async {
    if (_isOpeningReport) {
      return;
    }

    _isOpeningReport = true;
    try {
      await AppShared.instance.persistentAppType(AppType.KDTN);
      final token = AppShared.instance.getUserToken();
      if (token == null || token.isEmpty) {
        if (Get.currentRoute != Routes.login) {
          await Get.toNamed(Routes.login);
        }
        return;
      }

      // Trả lại luồng cũ: luôn mở màn hình Danh sách biên bản
      if (Get.currentRoute == Routes.listReportScreen &&
          Get.isRegistered<ReportByTransformerController>()) {
        Get.find<ReportByTransformerController>().searchByFormReportId(formReportId);
      } else {
        await Get.toNamed(
          Routes.listReportScreen,
          arguments: {'formReportId': formReportId},
        );
      }
      _pendingFormReportId = null;
    } finally {
      _isOpeningReport = false;
    }
  }
}
