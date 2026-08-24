import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/app_env.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photo_view/photo_view.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/repository/survey_report_repository.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_report_participant_model.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_report_model.dart';

class SurveyReportCreateController extends GetxController {
  final SurveyReportRepository _repository = SurveyReportRepository();
  final SurveyReportModel editModel;

  SurveyReportCreateController({this.editModel});

  // Form Fields
  var code = ''.obs;
  var name = ''.obs;
  var note = ''.obs;
  var uploadedFileName = ''.obs;
  var attachments = <dynamic>[].obs;

  var selectedConstructionId = ''.obs;
  var selectedConstructionName = ''.obs;
  var reportDate = DateTime.now().obs;
  final TextEditingController dateController = TextEditingController();

  var participants = <SurveyReportParticipantModel>[].obs;

  // Dropdown Data
  var constructions = <StringOptionModel>[].obs;
  var units = <StringOptionModel>[].obs;

  var isConstructionsLoading = true.obs;
  var isUnitsLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    
    if (editModel != null) {
      code.value = editModel.code ?? '';
      name.value = editModel.name ?? '';
      note.value = editModel.note ?? '';
      uploadedFileName.value = editModel.fileName ?? '';
      selectedConstructionId.value = editModel.constructionId ?? '';
      selectedConstructionName.value = editModel.constructionName ?? '';
      if (editModel.reportDate != null) {
        reportDate.value = editModel.reportDate;
      }
      if (editModel.participants != null && editModel.participants.isNotEmpty) {
        participants.assignAll(editModel.participants);
      } else {
        // Fetch detail to get participants because list API doesn't return them
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _fetchDetail();
        });
      }
      if (editModel.attachments != null) {
        attachments.assignAll(editModel.attachments);
      }
    }

    dateController.text = DateFormat('dd/MM/yyyy').format(reportDate.value);
    _fetchConstructions();
    _fetchUnits();
  }

  Future<void> _fetchDetail() async {
    ProgressHUD.show();
    final res = await _repository.getDetail(id: editModel.id);
    ProgressHUD.dismiss();
    if (res.isLoadSuccess && res.data != null) {
      if (res.data.participants != null) {
        participants.assignAll(res.data.participants);
      }
      if (res.data.attachments != null) {
        attachments.assignAll(res.data.attachments);
      }
    }
  }

  @override
  void onClose() {
    dateController.dispose();
    super.onClose();
  }

  Future<void> _fetchConstructions() async {
    isConstructionsLoading.value = true;
    final res = await _repository.getConstructions();
    if (res.isLoadSuccess && res.data != null) {
      constructions.assignAll(res.data);
    }
    isConstructionsLoading.value = false;
  }

  Future<void> _fetchUnits() async {
    isUnitsLoading.value = true;
    final res = await _repository.getUnits();
    if (res.isLoadSuccess && res.data != null) {
      units.assignAll(res.data);
    }
    isUnitsLoading.value = false;
  }

  // Add Participant logic (Bottom Sheet)
  Future<List<StringOptionModel>> getUnits() async {
    if (units.isNotEmpty) return units;
    await _fetchUnits();
    return units;
  }

  Future<List<StringOptionModel>> getEmployees(String unitId) async {
    if (unitId == null || unitId.isEmpty) return [];
    final res = await _repository.getEmployees(unitId);
    if (res.isLoadSuccess && res.data != null) {
      return res.data;
    }
    return [];
  }

  void addParticipant(SurveyReportParticipantModel model) {
    // Kiem tra xem co trung id khong (cung 1 user o cung 1 group)
    final isExist = participants.any((e) => e.userId == model.userId && e.groupType == model.groupType);
    if (isExist) {
      SnackBarHUD.show('Người dùng này đã tồn tại trong nhóm');
      return;
    }
    participants.add(model);
    Get.back(); // close bottom sheet
  }

  void removeParticipant(SurveyReportParticipantModel model) {
    participants.remove(model);
  }

  bool _validate() {
    if (code.value.trim().isEmpty) {
      SnackBarHUD.show('Vui lòng nhập Số biên bản');
      return false;
    }
    if (name.value.trim().isEmpty) {
      SnackBarHUD.show('Vui lòng nhập Tên biên bản');
      return false;
    }
    if (selectedConstructionId.value.isEmpty) {
      SnackBarHUD.show('Vui lòng chọn Công trình khảo sát');
      return false;
    }
    return true;
  }

  Future<void> save() async {
    if (!_validate()) return;

    final payload = <String, dynamic>{
      'code': code.value.trim(),
      'name': name.value.trim(),
      'constructionId': selectedConstructionId.value,
      'reportDate': reportDate.value.toIso8601String(),
      'note': note.value.trim(),
      'participants': participants.map((e) => {
        if (e.id != null) 'id': e.id,
        'unitId': e.unitId,
        'unitName': e.unitName,
        'userId': e.userId,
        'userName': e.fullName,
        'position': e.position ?? '',
        'groupType': e.groupType,
      }).toList(),
    };

    ProgressHUD.show();
    final res = editModel == null 
        ? await _repository.createSurveyReport(payload)
        : await _repository.updateSurveyReport(editModel.id, payload);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      rShowDialogOneButton(
        editModel == null ? 'Lưu biên bản khảo sát thành công!' : 'Cập nhật biên bản khảo sát thành công!',
        action: () {
          Get.back(); // Đóng thông báo
          Get.back(result: true); // Quay lại danh sách và truyền cờ reload
        }
      );
    } else {
      SnackBarHUD.show(res.message ?? 'Có lỗi xảy ra');
    }
  }

  Future<void> downloadTemplate() async {
    if (editModel == null) return;
    try {
      String savePath;
      if (Platform.isAndroid) {
        final dir = Directory('/storage/emulated/0/Download');
        if (!dir.existsSync()) dir.createSync(recursive: true);
        savePath = '${dir.path}/Template_BBKS_${editModel.code}.docx';
      } else {
        final dir = await getApplicationDocumentsDirectory();
        savePath = '${dir.path}/Template_BBKS_${editModel.code}.docx';
      }
      
      ProgressHUD.show();
      final res = await _repository.downloadTemplate(editModel.id, savePath);
      ProgressHUD.dismiss();
      
      if (res.isLoadSuccess) {
        if (Platform.isAndroid) {
           rShowDialogOneButton(
            'Tải file thành công!\nFile đã được tự động lưu vào thư mục Download (Tải xuống) trên điện thoại của bạn.',
            action: () {
              Get.back();
            }
          );
        } else {
          SnackBarHUD.show('Tải file thành công!');
          try {
            await Share.shareFiles([savePath], subject: 'File mẫu biên bản khảo sát');
          } catch (shareErr) {
            debugPrint(shareErr.toString());
          }
        }
      } else {
        SnackBarHUD.show(res.message ?? 'Tải file mẫu thất bại');
      }
    } catch (e) {
      ProgressHUD.dismiss();
      SnackBarHUD.show('Có lỗi xảy ra khi tải file');
    }
  }

  Future<void> uploadWordFile() async {
    if (editModel == null) return;
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['doc', 'docx'],
      );

      if (result != null) {
        File file = File(result.files.single.path);
        
        ProgressHUD.show();
        final res = await _repository.uploadWordFile(editModel.id, file);
        ProgressHUD.dismiss();

        if (res.isLoadSuccess) {
          uploadedFileName.value = result.files.single.name;
          SnackBarHUD.show('Tải lên file thành công');
        } else {
          SnackBarHUD.show(res.message ?? 'Tải lên file thất bại');
        }
      }
    } catch (e) {
      ProgressHUD.dismiss();
      SnackBarHUD.show('Có lỗi xảy ra khi chọn file');
    }
  }

  Future<void> onAddAttachment() async {
    if (editModel == null) {
      SnackBarHUD.show('Vui lòng lưu biên bản trước khi đính kèm file');
      return;
    }
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );
      if (result != null) {
        File file = File(result.files.single.path);
        ProgressHUD.show();
        final res = await _repository.uploadAttachment(editModel.id, file);
        ProgressHUD.dismiss();
        if (res.isLoadSuccess) {
          SnackBarHUD.show('Đính kèm file thành công');
          _fetchDetail(); // reload to get the new attachment
        } else {
          SnackBarHUD.show(res.message ?? 'Đính kèm file thất bại');
        }
      }
    } catch (e) {
      ProgressHUD.dismiss();
      SnackBarHUD.show('Có lỗi xảy ra khi chọn file');
    }
  }

  Future<void> downloadFile(String path) async {
    if (path == null || path.isEmpty) return;
    String url = path;
    if (path.startsWith('/')) {
       url = '${AppEnv.getServerUrl().replaceAll('/api', '')}$path';
    }
    
    if (!url.contains('access_token=')) {
      final token = AppShared.instance.getUserToken();
      final separator = url.contains('?') ? '&' : '?';
      url = '$url${separator}access_token=$token';
    }

    final nameLower = url.toLowerCase();
    final isImage = nameLower.endsWith('.jpg') || nameLower.endsWith('.jpeg') || nameLower.endsWith('.png');
    
    if (isImage) {
      Get.to(() => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Ảnh đính kèm', style: TextStyle(fontSize: 16)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        body: PhotoView(
          imageProvider: NetworkImage(url, headers: {
            'Authorization': 'Bearer ${AppShared.instance.getUserToken()}'
          }),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
        ),
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
}
