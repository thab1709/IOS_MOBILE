// @dart=2.9
import 'dart:io';
import 'dart:convert';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';

import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/report_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:path_provider/path_provider.dart';

class RPdfController extends GetxController {
  RxBool isSuccess = false.obs;
  final service = ReportRepository();
  String urlPdf;
  bool isMonitor;
  bool isViewPDFUnscheduled;

  MethodChannel pdfMethodChanel = const MethodChannel('com.evn.pmis/pdf');
  List<String> parts;

  Future getPdf(String id, {bool isCbm = false}) async {
    final response = await service.getPdf(formReportId: id, isGroup: !isMonitor, isViewPDFUnscheduled: isViewPDFUnscheduled, isCbm: isCbm);

    if (response.isLoadSuccess && response.data != null) {
      urlPdf = response.data;
      if (urlPdf != null && urlPdf.startsWith('http://')) {
        urlPdf = urlPdf.replaceFirst('http://', 'https://');
      }
      // Bỏ qua việc gọi native code để convert PDF sang ảnh vì quá chậm
      // Sử dụng SfPdfViewer.network cho cả Android và iOS
      isSuccess.value = true;
      update();
      return;
    } else {
      await rShowDialogOneButton(response?.message);
    }
    isSuccess.value = true;
    update();
  }

  Future showPDF(String link) async {
    urlPdf = link;
    if (urlPdf != null && urlPdf.startsWith('http://')) {
      urlPdf = urlPdf.replaceFirst('http://', 'https://');
    }
    // Bỏ qua việc gọi native code để convert PDF sang ảnh vì quá chậm
    // Sử dụng SfPdfViewer.network cho cả Android và iOS
    isSuccess.value = true;
    update();
    return;
    // isSuccess.value = true;
    // update();
  }

  Future<File> _createFileOfPdfUrl() async {
    String cleanUrl = urlPdf;
    if (cleanUrl.contains('?')) {
      cleanUrl = cleanUrl.split('?').first;
    }
    
    // Hash URL để làm tên file cache (chỉ lấy phần đường dẫn, bỏ qua query param chứa token thay đổi)
    final encodedUrl = base64Url.encode(utf8.encode(cleanUrl));
    // Rút gọn bớt tên file tránh lỗi quá dài trên OS
    final shortName = encodedUrl.length > 50 ? encodedUrl.substring(encodedUrl.length - 50) : encodedUrl;
    final filename = '$shortName.pdf';
    
    final dir = (await getApplicationDocumentsDirectory()).path;
    final file = File('$dir/$filename');

    // Xóa file cũ nếu đã tồn tại để luôn tải bản mới nhất (fix lỗi cache chữ ký cũ)
    if (await file.exists()) {
      await file.delete();
    }

    String fetchUrl = urlPdf;
    if (fetchUrl.startsWith('http://') && fetchUrl.contains('evnhanoi.com.vn')) {
      fetchUrl = fetchUrl.replaceFirst('http://', 'https://');
    }
    final request = await HttpClient().getUrl(Uri.parse(fetchUrl)).timeout(const Duration(seconds: 30)).catchError((e) {
      ProgressHUD.dismiss();
      rShowDialogOneButton('Có lỗi xảy ra khi tải file pdf');
      return null;
    });

    if (request == null) return null;

    final token = AppShared.instance.getUserToken();
    if (token != null && token.isNotEmpty) {
      request.headers.add(HttpHeaders.authorizationHeader, 'Bearer $token');
    }
    
    // Prevent network caching
    request.headers.add('Cache-Control', 'no-cache, no-store, must-revalidate');
    request.headers.add('Pragma', 'no-cache');

    final response = await request.close();
    if (response.statusCode != 200) {
      ProgressHUD.dismiss();
      rShowDialogOneButton('Không thể tải file PDF (Mã lỗi: ${response.statusCode})');
      return null;
    }
    final bytes = await consolidateHttpClientResponseBytes(response);
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> _pdfResultFromNative(MethodCall call) async {
    if (call.method == 'pdfResult') {
      final String data = call.arguments;
      parts?.clear();
      String cleanData = data.replaceAll('[', '').replaceAll(']', '');
      if (cleanData.isEmpty) {
        parts = [];
        ProgressHUD.dismiss();
        rShowDialogOneButton('File PDF bị lỗi hoặc không thể hiển thị');
        return;
      }
      parts = cleanData.split(', ').toList();
      isSuccess.value = true;
      update();
      debugPrint('_pdfResultFromNative $data');
      ProgressHUD.dismiss();
    }
  }
}

