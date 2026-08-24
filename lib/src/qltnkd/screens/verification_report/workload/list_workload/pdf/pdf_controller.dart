// @dart=2.9
import 'dart:io';
import 'dart:typed_data';

import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/certificate_repository.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/workload_repository.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/list_workload/signature/signature_image_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class PDFWorkloadController extends GetxController {
  RxBool isSuccess = false.obs;
  final service = WorkloadRepository();
  String urlPdf;
  MethodChannel pdfMethodChanel = const MethodChannel('com.evn.pmis/pdf');
  List<String> parts;
  Uint8List consultantsSignatureBytes;

  Future getPdf(String id, {String consultantsImage}) async {
    isSuccess.value = false;
    parts?.clear();
    consultantsSignatureBytes =
        SignatureImageHelper.decodeConsultantsImage(consultantsImage);
    consultantsSignatureBytes ??=
        SignatureImageHelper.decodeConsultantsImage(
            await SignatureImageHelper.getCachedConsultantsImage(id));
    await _getConsultantsSignature(id);
    final response = await service.getPdf(id: id);

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

  Future _getConsultantsSignature(String id) async {
    final response = await service.getDetailWorkLoad(
        workloadId: id, fromDate: '', toDate: '');
    if (response.isLoadSuccess) {
      final bytes =
          SignatureImageHelper.decodeConsultantsImage(response.data?.consultantsImage);
      if (bytes != null) {
        consultantsSignatureBytes = bytes;
        await SignatureImageHelper.saveConsultantsImage(
            id, response.data.consultantsImage);
      }
    }
  }

  Future<File> _createFileOfPdfUrl() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filename = '${timestamp}_${urlPdf.substring(urlPdf.lastIndexOf('/') + 1)}';
    
    String fetchUrl = urlPdf;
    if (fetchUrl.startsWith('http://') && fetchUrl.contains('evnhanoi.com.vn')) {
      fetchUrl = fetchUrl.replaceFirst('http://', 'https://');
    }
    if (fetchUrl.contains('?')) {
      fetchUrl += '&_t=$timestamp';
    } else {
      fetchUrl += '?_t=$timestamp';
    }

    final request = await HttpClient().getUrl(Uri.parse(fetchUrl)).timeout(const Duration(seconds: 30)).catchError((e) {
      ProgressHUD.dismiss();
      rShowDialogOneButton('Có lỗi xảy ra khi tải file pdf');
      return null;
    });
    
    request.headers.add('Cache-Control', 'no-cache, no-store, must-revalidate');
    request.headers.add('Pragma', 'no-cache');

    final response = await request.close();
    final bytes = await consolidateHttpClientResponseBytes(response);
    final dir = (await getApplicationDocumentsDirectory()).path;
    final file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> _pdfResultFromNative(MethodCall call) async {
    if (call.method == 'pdfResult') {
      final String data = call.arguments;
      parts?.clear();
      parts = data.replaceAll('[', '').replaceAll(']', '').split(', ').toList();
      isSuccess.value = true;
      update();
      debugPrint('_pdfResultFromNative $data');
      ProgressHUD.dismiss();
    }
  }
}

