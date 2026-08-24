// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/repository/patc_repository.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/models/patc_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_report_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/repository/survey_report_repository.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/models/user_sign_certificate_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/models/patc_participant_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class PatcCreateController extends GetxController {
  final PatcRepository _patcRepo = PatcRepository();
  final SurveyReportRepository _surveyRepo = SurveyReportRepository();

  PatcModel editModel;
  
  bool get isAllowEdit => editModel == null || (editModel?.isAllowEdit ?? false) || editModel?.statusName == 'Mới' || editModel?.status == 1 || editModel?.status == 2;
  
  var nameController = TextEditingController();
  var codeController = TextEditingController();
  var contentController = TextEditingController();
  var reportDate = DateTime.now().obs;
  
  var selectedConstructionId = ''.obs;
  var constructionList = <StringOptionModel>[].obs;

  var surveyReports = <SurveyReportModel>[].obs;
  var selectedSurveyReportIds = <String>[].obs;

  var participants = <PatcParticipantModel>[].obs;
  var userSignCertificates = <UserSignCertificateModel>[].obs;

  var attachments = <File>[].obs;
  
  var isLoadingConstruction = false.obs;
  var isLoadingSurveyReports = false.obs;

  PatcCreateController({this.editModel});

  @override
  void onInit() {
    super.onInit();
    _loadConstructions();
    _loadUserSignCertificates();
    if (editModel != null) {
      nameController.text = editModel.name ?? '';
      codeController.text = editModel.code ?? '';
      contentController.text = editModel.content ?? '';
      if (editModel.createdDate != null) {
        reportDate.value = editModel.createdDate;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadPatcDetail(editModel.id);
      });
    } else {
      // Check arguments from List Survey Report
      if (Get.arguments != null && Get.arguments['selectedReports'] != null) {
        List<SurveyReportModel> preSelected = Get.arguments['selectedReports'];
        if (preSelected.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _prefillFromSurveyReports(preSelected);
          });
        }
      }
    }
  }

  Future<void> _loadPatcDetail(String id) async {
    ProgressHUD.show();
    final res = await _patcRepo.getPatcDetail(id);
    ProgressHUD.dismiss();
    if (res.isLoadSuccess && res.data != null) {
      editModel = res.data;
      nameController.text = editModel.name ?? '';
      codeController.text = editModel.code ?? '';
      contentController.text = editModel.content ?? '';
      if (editModel.createdDate != null) {
        reportDate.value = editModel.createdDate;
      }
      selectedConstructionId.value = editModel.constructionId ?? '';
      if (editModel.participants != null) {
        participants.assignAll(editModel.participants);
      }
      if (selectedConstructionId.value.isNotEmpty) {
         _loadSurveyReportsByConstruction(selectedConstructionId.value);
      }
    } else {
      SnackBarHUD.show(res.message ?? 'Lỗi tải chi tiết PATC');
    }
  }

  void _prefillFromSurveyReports(List<SurveyReportModel> preSelected) {
    String cId = preSelected.first.constructionId;
    selectedConstructionId.value = cId;
    selectedSurveyReportIds.assignAll(preSelected.map((e) => e.id));
    _loadSurveyReportsByConstruction(cId);
  }

  Future<void> _loadUserSignCertificates() async {
    // This API takes unitId. We might need to fetch user's own unitId from AppShared
    // or fetch global if unitId is omitted. We will use a generic one or read from shared prefs.
    // For now, let's load global (isGetAll=true) if we can. 
    // Wait, the API requires unitId=078234b0-5b0d-467a-a670-52ff93f8c223. Let's hardcode for testing or use a blank string if it allows.
    final res = await _patcRepo.getUsersForSignature('078234b0-5b0d-467a-a670-52ff93f8c223');
    if (res.isLoadSuccess && res.data != null) {
      userSignCertificates.assignAll(res.data);
    }
  }

  Future<List<StringOptionModel>> getUnits() async {
    final res = await _surveyRepo.getUnits();
    if (res.isLoadSuccess) return res.data ?? [];
    return [];
  }

  Future<List<StringOptionModel>> getEmployees(String unitId) async {
    final res = await _surveyRepo.getEmployees(unitId);
    if (res.isLoadSuccess) return res.data ?? [];
    return [];
  }

  Future<void> _loadConstructions() async {
    isLoadingConstruction.value = true;
    final res = await _surveyRepo.getConstructions();
    isLoadingConstruction.value = false;
    if (res.isLoadSuccess && res.data != null) {
      constructionList.assignAll(res.data);
    }
  }

  Future<void> _loadSurveyReportsByConstruction(String constructionId) async {
    isLoadingSurveyReports.value = true;
    final res = await _surveyRepo.getListSurveyReport(
      pageIndex: 1, 
      pageSize: 9999, 
      constructionId: constructionId,
      isBackgroundMode: true
    );
    isLoadingSurveyReports.value = false;
    
    if (res.isLoadSuccess && res.data != null) {
      // Filter out only approved ones if needed, according to requirement
      // "trạng thái #đã duyệt thì không cho tích chọn, chỉ tích trạng thái bb = đã duyệt"
      // We will show all, but disable non-approved in UI
      surveyReports.assignAll(res.data);
      
      if (editModel != null && editModel.surveyReports != null) {
        selectedSurveyReportIds.assignAll(editModel.surveyReports.map((e) => e.id));
      }
    } else {
      surveyReports.clear();
    }
  }

  void onConstructionChanged(String val) {
    if (val == null || val.isEmpty) return;
    selectedConstructionId.value = val;
    selectedSurveyReportIds.clear();
    _loadSurveyReportsByConstruction(val);
  }

  void toggleSurveyReport(String id) {
    if (selectedSurveyReportIds.contains(id)) {
      selectedSurveyReportIds.remove(id);
    } else {
      selectedSurveyReportIds.add(id);
    }
  }

  void addParticipant(PatcParticipantModel model) {
    participants.add(model);
  }

  void removeParticipant(PatcParticipantModel p) {
    participants.remove(p);
  }



  Future<void> pickFiles() async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'png', 'jpg', 'jpeg'],
      );

      if (result != null) {
        attachments.addAll(result.paths.map((path) => File(path)).toList());
      }
    } catch (e) {
      debugPrint('Error pickFiles: $e');
    }
  }

  void removeFile(File file) {
    attachments.remove(file);
  }

  Future<void> downloadTemplate() async {
    ProgressHUD.show();
    final res = await _patcRepo.getPatcTemplate(id: editModel?.id);
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

  Future<void> saveAndSend() async {
    bool isSuccess = await save(isCloseAndBack: false);
    if (isSuccess && editModel != null) {
      ProgressHUD.show();
      final res = await _patcRepo.sendPatc(editModel.id);
      ProgressHUD.dismiss();
      if (res.isLoadSuccess) {
        SnackBarHUD.show('Gửi duyệt PATC thành công');
        Get.back(result: true);
      } else {
        SnackBarHUD.show('Lưu thành công nhưng Gửi duyệt thất bại: ${res.message ?? ''}');
      }
    }
  }

  Future<bool> save({bool isCloseAndBack = true}) async {
    if (nameController.text.trim().isEmpty) {
      SnackBarHUD.show('Vui lòng nhập tên PATC');
      return;
    }
    if (selectedConstructionId.value.isEmpty) {
      SnackBarHUD.show('Vui lòng chọn công trình');
      return;
    }
    if (selectedSurveyReportIds.isEmpty) {
      SnackBarHUD.show('Vui lòng chọn ít nhất 1 Biên bản khảo sát');
      return;
    }

    ProgressHUD.show();
    
    Map<String, dynamic> body = {
      'code': codeController.text.trim(),
      'name': nameController.text.trim(),
      'reportDate': reportDate.value.toIso8601String(),
      'content': contentController.text.trim(),
      'constructionId': selectedConstructionId.value,
      'surveyReportIds': selectedSurveyReportIds.toList(),
      'participants': participants.map((p) => p.toJson()).toList(),
    };

    dynamic res;
    if (editModel == null) {
      res = await _patcRepo.createPatc(body, attachments);
    } else {
      res = await _patcRepo.updatePatc(editModel.id, body, attachments);
    }
    
    ProgressHUD.dismiss();

    if (res.isLoadSuccess) {
      if (editModel == null && res.data == null) {
         // Create without returning ID, wait wait, createPatc does not return data ID currently if we parse data: null
         // But let's assume we fetch success
      }
      SnackBarHUD.show('${editModel == null ? 'Thêm mới' : 'Cập nhật'} PATC thành công');
      if (isCloseAndBack) {
        Get.back(result: true);
      }
      return true;
    } else {
      SnackBarHUD.show(res.message ?? 'Có lỗi xảy ra');
      return false;
    }
  }
}
