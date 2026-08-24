// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/repository/patc_repository.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/common/external_signature/external_signature_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/models/patc_participant_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/models/patc_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/pdf_view/pdf_view.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/app_env.dart';
import 'package:url_launcher/url_launcher.dart';

class PatcDetailController extends GetxController {
  final String patcId;
  final PatcModel initialModel;
  final PatcRepository _repository = PatcRepository();

  var isLoading = false.obs;
  PatcModel model;

  PatcDetailController({this.patcId, this.initialModel});

  @override
  void onInit() {
    super.onInit();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    isLoading.value = true;
    final res = await _repository.getPatcDetail(patcId);
    isLoading.value = false;
    
    if (res.isLoadSuccess && res.data != null) {
      if (initialModel != null) {
        res.data.isAllowApprove = initialModel.isAllowApprove;
        res.data.isAllowReject = initialModel.isAllowReject;
        res.data.isAllowSend = initialModel.isAllowSend;
        res.data.isAllowEdit = initialModel.isAllowEdit;
        res.data.isAllowDelete = initialModel.isAllowDelete;
      }
      model = res.data;
      update();
    } else {
      SnackBarHUD.show(res.message ?? 'Lỗi tải chi tiết PATC');
    }
  }

  Future<void> downloadWord() async {
    ProgressHUD.show();
    final res = await _repository.getPatcTemplate(id: patcId);
    ProgressHUD.dismiss();
    if (res.isLoadSuccess && res.data != null && res.data.isNotEmpty) {
       final url = Uri.parse(res.data);
       if (await canLaunchUrl(url)) {
         await launchUrl(url, mode: LaunchMode.externalApplication);
       } else {
         SnackBarHUD.show('Không thể mở đường dẫn tải mẫu');
       }
    } else {
      SnackBarHUD.show('Không thể lấy đường dẫn tải mẫu');
    }
  }

  Future<void> viewPdf() async {
    if (model == null) return;
    final getPdfUrl = AppEnv.isDev() ? 'http://125.212.226.94:5006/tnkd/api/constructionplan/${model.id}/pdf?access_token=${AppShared.instance.getUserToken()}' : '${AppEnv.getServerUrl()}/constructionplan/${model.id}/pdf?access_token=${AppShared.instance.getUserToken()}';
    debugPrint('--- patc_detail_controller PDF url: $getPdfUrl ---');
    Get.to(() => RPdfScreen(
      link: getPdfUrl,
      code: 'Phương án thi công',
    ));
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

  Future<void> approvePatc() async {
    if (model == null) return;
    bool confirm = await Get.dialog<bool>(
      AlertDialog(
        titlePadding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Xác nhận ký duyệt', style: TextStyle(fontSize: 16)),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () => Get.back(result: false),
            )
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 14),
            children: [
              const TextSpan(text: 'Bạn có chắc chắn muốn tiến hành '),
              const TextSpan(text: 'ký số và phê duyệt', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' cho Phương án thi công số: ${model.code ?? ''}? Hành động này sẽ áp dụng chữ ký số của bạn vào các vị trí neo (anchor text) tương ứng.'),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Hủy bỏ', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF000033)),
            child: const Text('Ký duyệt', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;
    if (!confirm) return;

    ProgressHUD.show();
    try {
      final res = await _repository.approvePatc(ids: [model.id]);
      ProgressHUD.dismiss();

      if (res.isLoadSuccess) {
        await rShowDialogOneButton('Xác nhận PATC thành công');
        Get.back(result: true);
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

  Future<void> rejectPatc() async {
    if (model == null) return;
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
                    const Text('Từ chối phê duyệt', style: TextStyle(fontSize: 16)),
                    InkWell(
                      onTap: () => Get.back(result: false),
                      child: const Icon(Icons.close, color: Colors.grey),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      const TextSpan(text: 'Xác nhận từ chối phê duyệt đối với: '),
                      TextSpan(text: 'Phương án thi công số: ${model.code ?? ''}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: '. Vui lòng nhập lý do từ chối chi tiết dưới đây:'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text.rich(TextSpan(children: [TextSpan(text: '*', style: TextStyle(color: Colors.red)), TextSpan(text: ' Lý do từ chối', style: TextStyle(color: Colors.black54))])),
                const SizedBox(height: 8),
                TextFormField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    hintText: 'Nhập lý do chi tiết để gửi trả người lập...',
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
                    OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text('Hủy bỏ', style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          Get.back(result: true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4D4D),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Từ chối phê duyệt'),
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
    final res = await _repository.rejectPatc(ids: [model.id], note: noteController.text);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      await rShowDialogOneButton('Từ chối PATC thành công');
      Get.back(result: true);
    } else {
      SnackBarHUD.show(res.message ?? 'Từ chối PATC thất bại');
    }
  }

  Future<void> sendPatc() async {
    if (model == null) return;
    bool confirm = await rShowDialogConfirm('Gửi xác nhận', 'Bạn có chắc chắn muốn gửi phương án thi công này không?');
    if (!confirm) return;

    ProgressHUD.show();
    final res = await _repository.sendPatc(model.id);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      await rShowDialogOneButton('Gửi xác nhận PATC thành công');
      Get.back(result: true);
    } else {
      SnackBarHUD.show(res.message ?? 'Gửi xác nhận PATC thất bại');
    }
  }

  Future<void> handleExternalSign() async {
    if (model == null) return;

    final participants = model.participants ?? [];
    final allExternalSigners = participants.where((p) => p.isExternal == true).toList();
    final unsignedSigners = allExternalSigners.where((p) => p.isSigned != true).toList();

    if (unsignedSigners.isEmpty) {
      SnackBarHUD.show('Không có người ký ngoài nào đang chờ ký');
      return;
    }

    if (allExternalSigners.length == 1) {
      _openExternalSignatureScreen(unsignedSigners.first, allExternalSigners);
    } else {
      _showExternalSignersPopup(allExternalSigners);
    }
  }

  void _showExternalSignersPopup(List<PatcParticipantModel> signers) {
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
                      _openExternalSignatureScreen(signer, signers);
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

  Future<void> _openExternalSignatureScreen(PatcParticipantModel signer, List<PatcParticipantModel> allSigners) async {
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
              _showExternalSignersPopup(allSigners);
            });
          }
        }

        _loadDetail();
      } else {
        SnackBarHUD.show(res?.message ?? 'Ký thất bại');
        if (allSigners.length > 1) {
           Future.delayed(const Duration(milliseconds: 300), () {
             _showExternalSignersPopup(allSigners);
           });
        }
      }
    } else {
       if (allSigners.length > 1) {
         _showExternalSignersPopup(allSigners);
       }
    }
  }
}
