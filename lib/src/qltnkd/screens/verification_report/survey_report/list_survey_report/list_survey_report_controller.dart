// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/repository/survey_report_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/common/external_signature/external_signature_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_report_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_report_participant_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/common/enum/enum_survey_report.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/list_survey_report/filter/survey_report_filter.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/patc_create/patc_create_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/pdf_view/pdf_view.dart';
import 'package:intl/intl.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';

class ListSurveyReportController extends GetxController {
  final _repository = SurveyReportRepository();
  
  var isLoading = false.obs;
  var isLoadMore = false.obs;
  var canLoadMore = true.obs;
  var pageIndex = 1;
  var pageSize = 10;
  
  var currentTabIndex = 0.obs;
  var surveyReports = <SurveyReportModel>[].obs;

  // Filter params
  var searchTerm = ''.obs;
  var fromDate = Rx<DateTime>(null);
  var toDate = Rx<DateTime>(null);
  var constructionName = ''.obs;
  var confirmFromDate = Rx<DateTime>(null);
  var confirmToDate = Rx<DateTime>(null);
  var hasPatc = Rx<bool>(null);
  var qlvhUnitId = ''.obs;
  var constructionId = ''.obs;

  // Selection state for creating PATC
  var isSelectMode = false.obs;
  var selectedReports = <SurveyReportModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Preload data for the filter screen
    _repository.getUnits();
    _repository.getConstructions();
    fetchData();
  }

  void onTabChanged(int index) {
    if (currentTabIndex.value == index) return;
    currentTabIndex.value = index;
    refreshData();
  }

  Future<void> refreshData() async {
    pageIndex = 1;
    canLoadMore.value = true;
    surveyReports.clear();
    isSelectMode.value = false;
    selectedReports.clear();
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

    final currentEnum = EnumSurveyReport.values[currentTabIndex.value];
    final status = currentEnum.getCode();

    String apiCreatedBy = '';
    if (status == 1) { // Mới
      apiCreatedBy = AppShared.instance.getUserProfile()?.id ?? '';
    }

    final dateFormat = DateFormat('yyyy-MM-dd');
    final res = await _repository.getListSurveyReport(
      searchTerm: searchTerm.value,
      fromDate: fromDate.value != null ? dateFormat.format(fromDate.value) : '',
      toDate: toDate.value != null ? dateFormat.format(toDate.value) : '',
      constructionName: constructionName.value,
      constructionId: constructionId.value,
      qlvhUnitId: qlvhUnitId.value,
      confirmDateFrom: confirmFromDate.value != null ? dateFormat.format(confirmFromDate.value) : '',
      confirmDateTo: confirmToDate.value != null ? dateFormat.format(confirmToDate.value) : '',
      status: status,
      hasPatc: hasPatc.value,
      createdBy: apiCreatedBy,
      pageIndex: pageIndex,
      pageSize: pageSize,
      isBackgroundMode: true, // Ngăn chặn ProgressHUD hiển thị đè lên nhau gây lỗi stuck loading
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
        surveyReports.assignAll(items);
      } else {
        surveyReports.addAll(items);
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
      )
    ) ?? false;
  }

  Future<void> approveReport(String id) async {
    bool confirm = await rShowDialogConfirm(
        'Xác nhận', 'Bạn có chắc chắn muốn xác nhận biên bản này?');
    if (!confirm) return;

    ProgressHUD.show();
    final res = await _repository.approveSurveyReport(ids: [id]);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      SnackBarHUD.show('Xác nhận biên bản thành công');
      refreshData();
    } else {
      SnackBarHUD.show('Xác nhận biên bản thất bại');
    }
  }

  Future<void> rejectReport(String id) async {
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
                    const Text('Từ chối biên bản khảo sát?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    InkWell(
                      onTap: () => Get.back(result: false),
                      child: const Icon(Icons.close, color: Colors.grey),
                    )
                  ],
                ),
                const Divider(height: 24),
                RichText(
                  text: const TextSpan(
                    text: '* ',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    children: [
                      TextSpan(
                        text: 'Ghi chú',
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: noteController,
                  decoration: InputDecoration(
                    hintText: '',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập ghi chú';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Từ chối'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
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
    final res = await _repository.rejectSurveyReport(ids: [id], note: noteController.text);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      SnackBarHUD.show('Từ chối biên bản thành công');
      refreshData();
    } else {
      SnackBarHUD.show('Từ chối biên bản thất bại');
    }
  }

  Future<void> sendReport(String id) async {
    TextEditingController noteController = TextEditingController();
    bool confirm = await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Gửi phê duyệt biên bản', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () => Get.back(result: false),
                    child: const Icon(Icons.close, color: Colors.grey),
                  )
                ],
              ),
              const Divider(height: 24),
              const Text('Ghi chú gửi duyệt', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  hintText: 'Nhập ghi chú gửi duyệt biên bản...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                  contentPadding: const EdgeInsets.all(12),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Get.back(result: false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Hủy bỏ'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => Get.back(result: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000033), // dark blue
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Gửi phê duyệt'),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    ) ?? false;
    
    if (!confirm) return;

    ProgressHUD.show();
    final res = await _repository.sendSurveyReport(id: id, note: noteController.text);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      SnackBarHUD.show('Gửi duyệt biên bản thành công');
      refreshData();
    } else {
      SnackBarHUD.show('Gửi duyệt biên bản thất bại');
    }
  }

  Future<void> exportPdf(String id) async {
    ProgressHUD.show();
    final res = await _repository.getPdf(id: id);
    ProgressHUD.dismiss();
    if (res.isLoadSuccess && res.data != null && res.data.isNotEmpty) {
       debugPrint('--- list_survey_report_controller exportPdf: ${res.data} ---');
       Get.to(() => RPdfScreen(
         link: res.data,
         code: 'Biên bản khảo sát',
       ));
    } else {
      SnackBarHUD.show('Lấy PDF thất bại');
    }
  }

  void toggleSelectMode() {
    isSelectMode.value = !isSelectMode.value;
    if (!isSelectMode.value) {
      selectedReports.clear();
    }
  }

  void toggleSelect(SurveyReportModel item) {
    if (selectedReports.any((e) => e.id == item.id)) {
      selectedReports.removeWhere((e) => e.id == item.id);
    } else {
      selectedReports.add(item);
    }
  }

  Future<void> handleCreatePatc() async {
    if (selectedReports.isEmpty) {
      SnackBarHUD.show('Vui lòng chọn ít nhất 1 biên bản khảo sát');
      return;
    }

    // Check condition 1: All reports must belong to the same construction
    final firstConstructionId = selectedReports.first.constructionId;
    bool isSameConstruction = selectedReports.every((r) => r.constructionId == firstConstructionId);
    if (!isSameConstruction) {
      rShowDialogOneButton('Biên bản khảo sát đã chọn không cùng 1 công trình, vui lòng kiểm tra lại');
      return;
    }

    bool allApproved = selectedReports.every((r) => r.status == EnumSurveyReport.confirmed.getCode());
    if (!allApproved) {
      rShowDialogOneButton('Biên bản khảo sát cần được duyệt trước khi lập PATC, vui lòng kiểm tra lại');
      return;
    }

    // Pass to Create PATC screen
    final result = await Get.to(() => const PatcCreateScreen(), arguments: {'selectedReports': selectedReports.toList()});
    if (result == true) refreshData();
  }

  Future<void> deleteReport(String id) async {
    bool confirm = await rShowDialogConfirm(
        'Xóa biên bản', 'Bạn có chắc chắn muốn xóa biên bản khảo sát này?');
    if (!confirm) return;

    ProgressHUD.show();
    final res = await _repository.deleteSurveyReport(id);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      SnackBarHUD.show('Xóa biên bản thành công');
      surveyReports.removeWhere((element) => element.id == id);
    } else {
      SnackBarHUD.show(res.message ?? 'Xóa biên bản thất bại');
    }
  }

  Future<void> exportExcel() async {
    ProgressHUD.show();
    try {
      final currentEnum = EnumSurveyReport.values[currentTabIndex.value];
      final status = currentEnum.getCode();
      final dateFormat = DateFormat('yyyy-MM-dd');
      // Fetch all records
      final res = await _repository.getListSurveyReport(
        searchTerm: searchTerm.value,
        fromDate: fromDate.value != null ? dateFormat.format(fromDate.value) : '',
        toDate: toDate.value != null ? dateFormat.format(toDate.value) : '',
        constructionName: constructionName.value,
        constructionId: constructionId.value,
        qlvhUnitId: qlvhUnitId.value,
        confirmDateFrom: confirmFromDate.value != null ? dateFormat.format(confirmFromDate.value) : '',
        confirmDateTo: confirmToDate.value != null ? dateFormat.format(confirmToDate.value) : '',
        status: status,
        hasPatc: hasPatc.value,
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
        savePath = '${dir.path}/Danh_sach_BB_khao_sat.csv';
      } else {
        final dir = await getApplicationDocumentsDirectory();
        savePath = '${dir.path}/Danh_sach_BB_khao_sat.csv';
      }
      final file = File(savePath);

      // Add UTF-8 BOM so Excel opens it with correct encoding
      final List<int> bom = [0xEF, 0xBB, 0xBF];
      final sink = file.openWrite();
      sink.add(bom);

      // Header
      sink.writeln('STT,Số biên bản,Tên biên bản,Công trình,Ngày lập,Đơn vị QLVH,Trạng thái,Người duyệt cuối');

      // Data
      for (int i = 0; i < items.length; i++) {
        final r = items[i];
        final code = (r.code ?? '').replaceAll(',', ' ');
        final name = (r.name ?? '').replaceAll(',', ' ');
        final consName = (r.constructionName ?? '').replaceAll(',', ' ');
        final date = r.createdDate?.toStringFormat(RAppStrings.ddMMyyyy) ?? '';
        final unitName = (r.qlvhUnitName ?? '').replaceAll(',', ' ');
        final statusName = (r.statusName ?? '').replaceAll(',', ' ');
        final confirmByName = (r.confirmByName ?? '').replaceAll(',', ' ');
        sink.writeln('${i + 1},$code,$name,$consName,$date,$unitName,$statusName,$confirmByName');
      }

      await sink.close();
      ProgressHUD.dismiss();

      if (Platform.isAndroid) {
         rShowDialogOneButton(
          'Xuất dữ liệu thành công!\nFile "Danh_sach_BB_khao_sat.csv" đã được lưu vào thư mục Download (Tải xuống).',
          action: () {
            Get.back();
          }
        );
      } else {
        SnackBarHUD.show('Xuất dữ liệu thành công!');
        try {
          await Share.shareFiles([savePath], subject: 'Danh sách BB khảo sát');
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

  Future<void> handleExternalSign(String reportId) async {
    ProgressHUD.show();
    final detailRes = await _repository.getDetail(id: reportId);
    ProgressHUD.dismiss();

    if (!detailRes.isLoadSuccess || detailRes.data == null) {
      SnackBarHUD.show('Không thể lấy thông tin biên bản');
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
      _openExternalSignatureScreen(reportId, unsignedSigners.first, allExternalSigners);
    } else {
      _showExternalSignersPopup(reportId, allExternalSigners);
    }
  }

  void _showExternalSignersPopup(String reportId, List<SurveyReportParticipantModel> signers) {
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
                      _openExternalSignatureScreen(reportId, signer, signers);
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

  Future<void> _openExternalSignatureScreen(String reportId, SurveyReportParticipantModel signer, List<SurveyReportParticipantModel> allSigners) async {
    final result = await Get.to(() => ExternalSignatureScreen(
      fullName: signer.fullName,
      position: signer.position,
    ));

    if (result != null && result is ExternalHandwrittenSignatureResult) {
      ProgressHUD.show();
      await Future.delayed(const Duration(milliseconds: 200));
      var res;
      try {
        res = await _repository.externalSign(reportId, signer.id, result.signatureImageBytes);
      } finally {
        ProgressHUD.dismiss();
        await Future.delayed(const Duration(milliseconds: 200));
      }
      
      if (res.isLoadSuccess) {
        SnackBarHUD.show('Ký thành công');
        signer.isSigned = true;
                if (allSigners.length > 1) {
          final unsignedSigners = allSigners.where((p) => p.isSigned != true).toList();
          if (unsignedSigners.isNotEmpty) {
            Future.delayed(const Duration(milliseconds: 300), () {
              _showExternalSignersPopup(reportId, allSigners);
            });
          }
        }
        
        refreshData();
      } else {
        SnackBarHUD.show(res?.message ?? 'Ký thất bại');
        if (allSigners.length > 1) {
           Future.delayed(const Duration(milliseconds: 300), () {
             _showExternalSignersPopup(reportId, allSigners);
           });
        }
      }
    } else {
       if (allSigners.length > 1) {
         _showExternalSignersPopup(reportId, allSigners);
       }
    }
  }
}
