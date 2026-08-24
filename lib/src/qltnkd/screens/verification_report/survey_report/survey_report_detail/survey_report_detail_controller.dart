// @dart=2.9
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/app_env.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_report_participant_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/common/external_signature/external_signature_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_report_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/repository/survey_report_repository.dart';

class SurveyReportDetailController extends GetxController {
  final SurveyReportRepository _repository = SurveyReportRepository();
  final String surveyReportId;
  final SurveyReportModel initialModel;

  var isLoading = true.obs;
  var model = Rx<SurveyReportModel>(null);
  var attachments = <dynamic>[].obs;

  SurveyReportDetailController({this.surveyReportId, this.initialModel});

  @override
  void onInit() {
    super.onInit();
    if (initialModel != null) {
      model.value = initialModel;
      if (initialModel.attachments != null) {
        attachments.assignAll(initialModel.attachments);
      }
      isLoading.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    if (model.value == null) {
      isLoading.value = true;
    }
    final res = await _repository.getDetail(id: surveyReportId);
    if (res.isLoadSuccess && res.data != null) {
      if (initialModel != null) {
        res.data.isAllowApprove = initialModel.isAllowApprove;
        res.data.isAllowReject = initialModel.isAllowReject;
        res.data.isAllowSend = initialModel.isAllowSend;
        res.data.isAllowEdit = initialModel.isAllowEdit;
        res.data.isAllowDelete = initialModel.isAllowDelete;
      }
      model.value = res.data;
      if (res.data.attachments != null) {
        attachments.assignAll(res.data.attachments);
      }
      model.refresh();
    } else {
      // API request failed
    }
    isLoading.value = false;
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

  Future<void> approveReport() async {
    bool confirm = await rShowDialogConfirm(
        'Xác nhận', 'Bạn có chắc chắn muốn xác nhận biên bản này?');
    if (!confirm) return;

    ProgressHUD.show();
    
    // Upload local attachments first
    List<dynamic> localFiles = attachments.where((e) => e['isLocal'] == true).toList();
    for (var loc in localFiles) {
       File f = File(loc['path']);
       if (f.existsSync()) {
          final uploadRes = await _repository.uploadAttachment(surveyReportId, f);
          if (!uploadRes.isLoadSuccess) {
             ProgressHUD.dismiss();
             SnackBarHUD.show('Tải file đính kèm thất bại, vui lòng thử lại sau');
             return;
          }
       }
    }

    final res = await _repository.approveSurveyReport(ids: [surveyReportId]);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      await rShowDialogOneButton('Xác nhận ${model.value?.name ?? "biên bản"} thành công');
      Get.back(result: true);
    } else {
      SnackBarHUD.show(res.message ?? 'Xác nhận biên bản thất bại');
    }
  }

  Future<void> onAddAttachment() async {
    if (surveyReportId == null) return;
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );
      if (result != null) {
        File file = File(result.files.single.path);
        
        final lowerPath = file.path.toLowerCase();
        if (lowerPath.endsWith('.jpg') || lowerPath.endsWith('.jpeg') || lowerPath.endsWith('.png')) {
          try {
            final properties = await FlutterNativeImage.getImageProperties(file.path);
            if (properties.width != null && properties.width > 1200) {
               file = await FlutterNativeImage.compressImage(
                   file.path,
                   quality: 85,
                   targetWidth: 1200,
                   targetHeight: (properties.height * 1200 / properties.width).round());
            } else {
               file = await FlutterNativeImage.compressImage(file.path, quality: 85);
            }
          } catch (e) {
            debugPrint('Error compressing image: $e');
          }
        }
        
        attachments.add({
          'name': result.files.single.name,
          'fileName': result.files.single.name,
          'url': '',
          'path': file.path,
          'isLocal': true,
        });
        attachments.refresh();
      }
    } catch (e) {
      ProgressHUD.dismiss();
      SnackBarHUD.show('Có lỗi xảy ra khi chọn file');
    }
  }

  void viewLocalImage(String path) {
    if (path == null || path.isEmpty) return;
    
    Get.to(() => StatefulBuilder(
          builder: (context, setState) {
            int rotationQuarter = 0;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: const Text('Ảnh đính kèm', style: TextStyle(fontSize: 16)),
                iconTheme: const IconThemeData(color: Colors.white),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.rotate_right),
                    onPressed: () {
                      setState(() {
                        rotationQuarter = (rotationQuarter + 1) % 4;
                      });
                    },
                  )
                ],
              ),
              backgroundColor: Colors.black,
              body: Center(
                child: RotatedBox(
                  quarterTurns: rotationQuarter,
                  child: PhotoView(
                    imageProvider: FileImage(File(path)),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  ),
                ),
              ),
            );
          },
        ));
  }

  Future<void> downloadFile(String path) async {
    if (path == null || path.isEmpty) return;
    String url = path.replaceAll('\\', '/');
    if (!url.startsWith('http')) {
      if (!url.startsWith('/')) {
        url = '/$url';
      }
      url = '${AppEnv.getServerUrl().replaceAll('/api', '')}$url';
    }
    
    if (!url.contains('access_token=')) {
      final token = AppShared.instance.getUserToken();
      final separator = url.contains('?') ? '&' : '?';
      url = '$url${separator}access_token=$token';
    }

    final nameLower = url.toLowerCase();
    final isImage = nameLower.endsWith('.jpg') || nameLower.endsWith('.jpeg') || nameLower.endsWith('.png');
    
    if (isImage) {
      Get.to(() => StatefulBuilder(
            builder: (context, setState) {
              int rotationQuarter = 0;
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  title: const Text('Ảnh đính kèm', style: TextStyle(fontSize: 16)),
                  iconTheme: const IconThemeData(color: Colors.white),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.rotate_right),
                      onPressed: () {
                        setState(() {
                          rotationQuarter = (rotationQuarter + 1) % 4;
                        });
                      },
                    )
                  ],
                ),
                backgroundColor: Colors.black,
                body: Center(
                  child: RotatedBox(
                    quarterTurns: rotationQuarter,
                    child: PhotoView(
                      imageProvider: NetworkImage(url, headers: {
                        'Authorization': 'Bearer ${AppShared.instance.getUserToken()}'
                      }),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    ),
                  ),
                ),
              );
            },
          ));
      return;
    }

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      SnackBarHUD.show('Không thể mở liên kết');
    }
  }

  Future<void> onRemoveAttachment(int index) async {
    try {
      final attachment = attachments[index];
      final attachmentId = attachment['id']?.toString();
      if (attachmentId != null) {
        ProgressHUD.show();
        final res = await _repository.deleteAttachment(attachmentId);
        ProgressHUD.dismiss();
        if (res.isLoadSuccess) {
          attachments.removeAt(index);
          SnackBarHUD.show('Xóa file thành công');
        } else {
          SnackBarHUD.show(res.message ?? 'Xóa file thất bại');
        }
      }
    } catch (e) {
      ProgressHUD.dismiss();
      SnackBarHUD.show('Có lỗi xảy ra khi xóa file');
    }
  }

  Future<void> rejectReport() async {
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
    final res = await _repository.rejectSurveyReport(ids: [surveyReportId], note: noteController.text);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      await rShowDialogOneButton('Từ chối ${model.value?.name ?? "biên bản"} thành công');
      Get.back(result: true);
    } else {
      SnackBarHUD.show(res.message ?? 'Từ chối biên bản thất bại');
    }
  }

  Future<void> handleExternalSign() async {
    final detailModel = model.value;
    if (detailModel == null) return;

    final participants = detailModel.participants ?? [];
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

  void _showExternalSignersPopup(List<SurveyReportParticipantModel> signers) {
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

  Future<void> _openExternalSignatureScreen(SurveyReportParticipantModel signer, List<SurveyReportParticipantModel> allSigners) async {
    final result = await Get.to(() => ExternalSignatureScreen(
      fullName: signer.fullName,
      position: signer.position,
    ));

    if (result != null && result is ExternalHandwrittenSignatureResult) {
      ProgressHUD.show();
      await Future.delayed(const Duration(milliseconds: 200));
      var res;
      try {
        res = await _repository.externalSign(surveyReportId, signer.id, result.signatureImageBytes);
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
              _showExternalSignersPopup(allSigners);
            });
          }
        }

        fetchDetail();
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
