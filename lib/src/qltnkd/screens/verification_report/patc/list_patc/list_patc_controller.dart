// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/repository/patc_repository.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/models/patc_model.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/pdf_view/pdf_view.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/repository/survey_report_repository.dart';
import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/common/external_signature/external_signature_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/models/patc_participant_model.dart';
class ListPatcController extends GetxController {
  final PatcRepository _repository = PatcRepository();

  var isLoading = false.obs;
  var isLoadMore = false.obs;
  var canLoadMore = true.obs;
  
  var patcs = <PatcModel>[].obs;
  
  int pageIndex = 1;
  int pageSize = 15;

  var currentTabIndex = 0.obs;

  var searchTerm = ''.obs;
  var fromDate = Rx<DateTime>(null);
  var toDate = Rx<DateTime>(null);
  var confirmFromDate = Rx<DateTime>(null);
  var confirmToDate = Rx<DateTime>(null);
  var constructionName = ''.obs;
  var constructionId = ''.obs;
  var qlvhUnitId = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Pre-fetch data for the filter screen to improve UX
    final _surveyRepo = SurveyReportRepository();
    _surveyRepo.getUnits();
    _surveyRepo.getConstructions();
  }

  void onTabChanged(int index) {
    if (currentTabIndex.value == index) return;
    currentTabIndex.value = index;
    refreshData();
  }

  Future<void> refreshData() async {
    pageIndex = 1;
    canLoadMore.value = true;
    patcs.clear();
    await fetchData();
  }

  Future<void> loadMore() async {
    if (!canLoadMore.value || isLoading.value || isLoadMore.value) return;
    pageIndex++;
    isLoadMore.value = true;
    await fetchData(isLoadMoreMode: true);
  }

  Future<void> fetchData({bool isLoadMoreMode = false}) async {
    if (!isLoadMoreMode) isLoading.value = true;

    // TODO: Determine status from currentTabIndex if there are tabs
    int status = 0; // 0 = all
    String apiCreatedBy = '';
    if (currentTabIndex.value == 1) {
      status = 1; // Mới
      apiCreatedBy = AppShared.instance.getUserProfile()?.id;
    }
    else if (currentTabIndex.value == 2) status = 4; // Từ chối
    else if (currentTabIndex.value == 3) status = 2; // Chờ xác nhận
    else if (currentTabIndex.value == 4) status = 3; // Đã xác nhận

    final res = await _repository.getListPatc(
      searchTerm: searchTerm.value,
      fromDate: fromDate.value,
      toDate: toDate.value,
      constructionName: constructionName.value,
      constructionId: constructionId.value,
      qlvhUnitId: qlvhUnitId.value,
      confirmDateFrom: confirmFromDate.value,
      confirmDateTo: confirmToDate.value,
      createdBy: apiCreatedBy,
      status: status,
      pageIndex: pageIndex,
      pageSize: pageSize,
      isBackgroundMode: isLoadMoreMode,
    );

    if (!isLoadMoreMode) isLoading.value = false;
    isLoadMore.value = false;

    if (res.isLoadSuccess && res.data != null) {
      var items = res.data;
      final currentUserId = AppShared.instance.getUserProfile()?.id;
      // Ẩn các phiếu Mới (status == 1) nếu không phải do mình tạo (áp dụng cho tab Tất cả)
      items = items.where((e) {
        if (e.status == 1) {
          return e.createdBy?.toLowerCase() == currentUserId?.toLowerCase();
        }
        return true;
      }).toList();

      if (!isLoadMoreMode) {
        patcs.assignAll(items);
      } else {
        patcs.addAll(items);
      }
      if (res.data.length < pageSize) {
        canLoadMore.value = false;
      }
    } else {
      canLoadMore.value = false;
    }
  }

  Future<bool> rShowDialogConfirm(String title, String content) async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Hủy')),
          TextButton(onPressed: () => Get.back(result: true), child: const Text('Đồng ý')),
        ],
      ),
    ) ?? false;
  }

  Future<void> deletePatc(String id) async {
    bool confirm = await rShowDialogConfirm('Xóa PATC', 'Bạn có chắc chắn muốn xóa phương án thi công này?');
    if (!confirm) return;

    ProgressHUD.show();
    final res = await _repository.deletePatc(id);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      await rShowDialogOneButton('Xóa PATC thành công');
      patcs.removeWhere((element) => element.id == id);
      update();
    } else {
      SnackBarHUD.show(res.message ?? 'Xóa PATC thất bại');
    }
  }

  Future<void> sendPatc(String id) async {
    bool confirm = await rShowDialogConfirm('Gửi xác nhận', 'Bạn có chắc chắn muốn gửi xác nhận phương án thi công này?');
    if (!confirm) return;

    ProgressHUD.show();
    final res = await _repository.sendPatc(id);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      await rShowDialogOneButton('Gửi xác nhận PATC thành công');
      refreshData();
    } else {
      SnackBarHUD.show(res.message ?? 'Gửi xác nhận PATC thất bại');
    }
  }

  Future<void> approvePatc(String id) async {
    bool confirm = await rShowDialogConfirm('Xác nhận', 'Bạn có chắc chắn muốn xác nhận phương án thi công này?');
    if (!confirm) return;

    ProgressHUD.show();
    try {
      final res = await _repository.approvePatc(ids: [id]);
      ProgressHUD.dismiss();

      if (res.isLoadSuccess) {
        await rShowDialogOneButton('Xác nhận PATC thành công');
        refreshData();
      } else {
        SnackBarHUD.show(res.message ?? 'Xác nhận PATC thất bại');
      }
    } catch (e) {
      debugPrint('Error approvePatc: $e');
      SnackBarHUD.show('Có lỗi xảy ra khi xác nhận PATC');
    } finally {
      ProgressHUD.dismiss();
    }
  }

  Future<void> rejectPatc(String id) async {
    TextEditingController noteController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool confirm = await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Từ chối PATC', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    InkWell(
                      onTap: () => Get.back(result: false),
                      child: const Icon(Icons.close, color: Colors.grey),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'Lý do từ chối *',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập lý do từ chối';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          Get.back(result: true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Từ chối'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text('Đóng lại'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )
    ) ?? false;
    
    if (!confirm) return;

    ProgressHUD.show();
    final res = await _repository.rejectPatc(ids: [id], note: noteController.text);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      await rShowDialogOneButton('Từ chối PATC thành công');
      refreshData();
    } else {
      SnackBarHUD.show('Từ chối PATC thất bại');
    }
  }

  Future<void> viewPdf(PatcModel model) async {
    final getPdfUrl = AppEnv.isDev() ? 'http://125.212.226.94:5006/tnkd/api/constructionplan/${model.id}/pdf?access_token=${AppShared.instance.getUserToken()}' : '${AppEnv.getServerUrl()}/constructionplan/${model.id}/pdf?access_token=${AppShared.instance.getUserToken()}';
    debugPrint('--- list_patc_controller PDF url: $getPdfUrl ---');
    Get.to(() => RPdfScreen(
      link: getPdfUrl,
      code: 'Phương án thi công',
    ));
  }

  Future<void> downloadFiles(PatcModel model) async {
    if (model.filePath == null || model.filePath.isEmpty) {
      SnackBarHUD.show('Không có file đính kèm');
      return;
    }
    
    String fullUrl = model.filePath;
    if (!fullUrl.startsWith('http')) {
      if (fullUrl.startsWith('125.212')) {
        fullUrl = 'http://$fullUrl';
      } else {
        final domain = AppEnv.getServerUrl().replaceAll('/api', '');
        if (fullUrl.startsWith('/')) {
          fullUrl = '$domain$fullUrl';
        } else {
          fullUrl = '$domain/$fullUrl';
        }
      }
    }

    final url = Uri.parse(fullUrl);

    ProgressHUD.show();
    try {
      final response = await http.head(url).timeout(const Duration(seconds: 5));
      ProgressHUD.dismiss();
      if (response.statusCode == 404) {
        SnackBarHUD.show('File đính kèm chưa được đồng bộ trên máy chủ (Lỗi 404). Vui lòng thử lại sau.');
        return;
      }
    } catch (e) {
      ProgressHUD.dismiss();
      // Ignore other errors (e.g., timeout or HEAD not allowed) and just try to launch
    }

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      SnackBarHUD.show('Không thể mở đường dẫn tải file');
    }
  }

  Future<void> exportExcel() async {
    ProgressHUD.show();
    try {
      int status = 0; // 0 = all
      if (currentTabIndex.value == 1) status = 1; // Mới
      else if (currentTabIndex.value == 2) status = 4; // Từ chối
      else if (currentTabIndex.value == 3) status = 2; // Chờ xác nhận
      else if (currentTabIndex.value == 4) status = 3; // Đã xác nhận

      final res = await _repository.getListPatc(
        searchTerm: searchTerm.value,
        fromDate: fromDate.value,
        toDate: toDate.value,
        constructionName: constructionName.value,
        constructionId: constructionId.value,
        confirmDateFrom: confirmFromDate.value,
        confirmDateTo: confirmToDate.value,
        status: status,
        pageIndex: 1,
        pageSize: 9999,
        isBackgroundMode: false,
      );

      if (!res.isLoadSuccess || res.data == null || res.data.isEmpty) {
        ProgressHUD.dismiss();
        SnackBarHUD.show('Không có dữ liệu để xuất');
        return;
      }

      final items = res.data;
      String savePath;
      if (Platform.isAndroid) {
        final dir = Directory('/storage/emulated/0/Download');
        if (!dir.existsSync()) dir.createSync(recursive: true);
        savePath = '${dir.path}/Danh_sach_PATC.csv';
      } else {
        final dir = await getApplicationDocumentsDirectory();
        savePath = '${dir.path}/Danh_sach_PATC.csv';
      }
      final file = File(savePath);

      final List<int> bom = [0xEF, 0xBB, 0xBF];
      final sink = file.openWrite();
      sink.add(bom);

      sink.writeln('STT,Số PATC,Tên PATC,Công trình,Ngày lập,Người lập,Trạng thái');

      for (int i = 0; i < items.length; i++) {
        final r = items[i];
        final code = (r.code ?? '').replaceAll(',', ' ');
        final name = (r.name ?? '').replaceAll(',', ' ');
        final consName = (r.constructionName ?? '').replaceAll(',', ' ');
        final date = r.createdDate?.toStringFormat(RAppStrings.ddMMyyyy) ?? '';
        final createdBy = (r.createdByName ?? '').replaceAll(',', ' ');
        final statusName = (r.statusName ?? '').replaceAll(',', ' ');
        sink.writeln('${i + 1},$code,$name,$consName,$date,$createdBy,$statusName');
      }

      await sink.close();
      ProgressHUD.dismiss();

      if (Platform.isAndroid) {
         rShowDialogOneButton(
          'Xuất dữ liệu thành công!\nFile "Danh_sach_PATC.csv" đã được lưu vào thư mục Download (Tải xuống).',
          action: () {
            Get.back();
          }
        );
      } else {
        SnackBarHUD.show('Xuất dữ liệu thành công!');
        try {
          await Share.shareFiles([savePath], subject: 'Danh sách PATC');
        } catch (shareErr) {
          debugPrint(shareErr.toString());
        }
      }
    } catch (e) {
      ProgressHUD.dismiss();
      debugPrint('Lỗi xuất Excel: $e');
      SnackBarHUD.show('Có lỗi xảy ra khi xuất dữ liệu');
    }
  }

  Future<void> handleExternalSign(String patcId) async {
    ProgressHUD.show();
    final detailRes = await _repository.getPatcDetail(patcId);
    ProgressHUD.dismiss();

    if (!detailRes.isLoadSuccess || detailRes.data == null) {
      SnackBarHUD.show('Không thể lấy thông tin phương án thi công');
      return;
    }

    final participants = detailRes.data.participants ?? [];
    final allExternalSigners = participants.where((p) => p.isExternal == true).toList();
    final unsignedSigners = allExternalSigners.where((p) => p.isSigned != true).toList();

    if (unsignedSigners.isEmpty) {
      SnackBarHUD.show('Không có người ký ngoài nào đang chờ ký');
      return;
    }

    if (allExternalSigners.length == 1) {
      _openExternalSignatureScreen(patcId, unsignedSigners.first, allExternalSigners);
    } else {
      _showExternalSignersPopup(patcId, allExternalSigners);
    }
  }

  void _showExternalSignersPopup(String patcId, List<PatcParticipantModel> signers) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Chọn người ký', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: signers.length,
                itemBuilder: (context, index) {
                  final signer = signers[index];
                  final isSigned = signer.isSigned == true;
                  return ListTile(
                    title: Text(signer.fullName ?? '', style: TextStyle(color: isSigned ? Colors.grey : Colors.black)),
                    subtitle: Text(signer.position ?? '', style: TextStyle(color: isSigned ? Colors.grey : Colors.grey.shade700)),
                    trailing: isSigned ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.chevron_right),
                    onTap: isSigned ? null : () {
                      Get.back();
                      _openExternalSignatureScreen(patcId, signer, signers);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openExternalSignatureScreen(String patcId, PatcParticipantModel signer, List<PatcParticipantModel> allSigners) async {
    final result = await Get.to(() => ExternalSignatureScreen(
      fullName: signer.fullName,
      position: signer.position,
    ));

    if (result != null && result is ExternalHandwrittenSignatureResult) {
      ProgressHUD.show();
      await Future.delayed(const Duration(milliseconds: 200));
      var res;
      try {
        res = await _repository.externalSign(patcId, signer.id, result.signatureImageBytes);
      } finally {
        ProgressHUD.dismiss();
        await Future.delayed(const Duration(milliseconds: 200));
      }
      
      if (res != null && res.isLoadSuccess) {
        SnackBarHUD.show('Ký thành công');
        signer.isSigned = true;
        if (allSigners.length > 1) {
          final unsignedSigners = allSigners.where((p) => p.isSigned != true).toList();
          if (unsignedSigners.isNotEmpty) {
            Future.delayed(const Duration(milliseconds: 300), () {
              _showExternalSignersPopup(patcId, allSigners);
            });
          }
        }

        refreshData();
      } else {
        SnackBarHUD.show(res?.message ?? 'Ký thất bại');
        if (allSigners.length > 1) {
           Future.delayed(const Duration(milliseconds: 300), () {
             _showExternalSignersPopup(patcId, allSigners);
           });
        }
      }
    } else {
       if (allSigners.length > 1) {
         _showExternalSignersPopup(patcId, allSigners);
       }
    }
  }
}
