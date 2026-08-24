// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/repository/work_registration_repository.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/models/work_registration_model.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
// Simple class to hold file info for display
class _AttachedFile {
  final File file; // null if it's a previously uploaded (network) file
  final String filePath;
  final String fileName;
  final int fileSize;
  final bool isNetwork;

  _AttachedFile({this.file, this.filePath, this.fileName, this.fileSize, this.isNetwork = false});
}

class WorkRegistrationCreateController extends GetxController {
  final WorkRegistrationRepository _repository = WorkRegistrationRepository();
  final String id;
  final String initialPatcId;

  WorkRegistrationCreateController({this.id, this.initialPatcId});

  var isLoading = false.obs;
  var isEdit = false;

  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final noteController = TextEditingController();
  final commanderNameController = TextEditingController();
  final commanderSafetyLevelController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final workContentController = TextEditingController();
  final workLocationController = TextEditingController();
  final workConditionController = TextEditingController();
  final workLeaderNameController = TextEditingController();
  final workLeaderSafetyLevelController = TextEditingController();
  final supervisorNameController = TextEditingController();
  final supervisorSafetyLevelController = TextEditingController();
  final guardNameController = TextEditingController();
  final guardSafetyLevelController = TextEditingController();
  final receiverNoteController = TextEditingController();
  final workUnitCountController = TextEditingController();
  final workerCountController = TextEditingController();

  // Controllers for date/time fields to prevent recreation on rebuild
  final registerDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  var startTime = Rx<DateTime>(DateTime.now());
  var endTime = Rx<DateTime>(DateTime.now());
  var workers = <WorkRegistrationWorkerModel>[].obs;
  var relatedUnits = <WorkRegistrationRelatedUnitModel>[].obs;
  var risks = <WorkRegistrationRiskModel>[].obs;

  var registerDate = Rx<DateTime>(DateTime.now());

  // Helper method to update date/time text controllers
  void updateDateTimeControllers() {
    registerDateController.text = registerDate.value.toStringFormat(RAppStrings.ddMMyyyy);
    startTimeController.text = startTime.value.toStringFormat(RAppStrings.ddmmyyyyHHmm);
    endTimeController.text = endTime.value.toStringFormat(RAppStrings.ddmmyyyyHHmm);
  }

  var patcId = ''.obs;
  var qlvhUnitName = ''.obs;
  var constructionName = ''.obs;
  var listApprovedPatc = <Map<String, dynamic>>[].obs;

  List<StringOptionModel> get patcOptions {
    final options = <StringOptionModel>[];
    options.addAll(listApprovedPatc.map((item) => StringOptionModel('${item['code']} - ${item['constructionName'] ?? ''}', item['id'].toString())));
    return options;
  }

  List<StringOptionModel> get safetyLevelOptions {
    final options = <StringOptionModel>[];
    options.addAll(['1', '2', '3', '4', '5'].map((e) => StringOptionModel(e, e)));
    return options;
  }

  // PATC related files (from patc-files API) for display only
  var patcSignedFilePath = ''.obs;
  var patcFileName = ''.obs;
  var bbksFiles = <BbksFileModel>[].obs;
  var patcAttachments = <WorkRegistrationAttachmentModel>[].obs; // Attachments from PATC

  // Files user attaches
  var localFiles = <File>[].obs; // New files user picks from phone
  var existingAttachments = <WorkRegistrationAttachmentModel>[].obs; // Previously saved files (edit mode)

  var basePdfPath = ''.obs;
  var signedPdfPath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    isEdit = id != null && id.isNotEmpty;
    if (initialPatcId != null && initialPatcId.isNotEmpty) {
      patcId.value = initialPatcId;
    }
    // Initialize date/time controllers
    updateDateTimeControllers();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    isLoading.value = true;

    final patcRes = await _repository.getApprovedPatc();
    if (patcRes.isLoadSuccess && patcRes.data != null) {
      listApprovedPatc.assignAll(patcRes.data);
    }

    if (isEdit) {
      final res = await _repository.getDetail(id);
      if (res.isLoadSuccess && res.data != null) {
        final data = res.data;

        codeController.text = data.code ?? '';
        nameController.text = data.name ?? '';
        noteController.text = data.note ?? '';
        patcId.value = data.patcId ?? '';
        qlvhUnitName.value = data.qlvhUnitName ?? '';
        constructionName.value = data.constructionName ?? '';
        basePdfPath.value = data.basePdfPath ?? '';
        signedPdfPath.value = data.signedPdfPath ?? '';
        
        if (data.patcId != null && data.patcId.isNotEmpty) {
          bool exists = listApprovedPatc.any((element) => element['id'] == data.patcId);
          if (!exists) {
            listApprovedPatc.add({
              'id': data.patcId,
              'code': data.patcCode ?? '',
              'constructionName': data.constructionName ?? '',
              'constructionId': data.constructionId,
              'qlvhUnitName': data.qlvhUnitName ?? '',
              'qlvhUnitId': data.qlvhUnitId,
            });
          }
        }
        commanderNameController.text = data.commanderName ?? '';
        commanderSafetyLevelController.text = data.commanderSafetyLevel ?? '';
        phoneNumberController.text = data.phoneNumber ?? '';
        workContentController.text = data.workContent ?? '';
        workLocationController.text = data.workLocation ?? '';
        workConditionController.text = data.workCondition ?? '';
        workLeaderNameController.text = data.workLeaderName ?? '';
        workLeaderSafetyLevelController.text = data.workLeaderSafetyLevel ?? '';
        supervisorNameController.text = data.supervisorName ?? '';
        supervisorSafetyLevelController.text = data.supervisorSafetyLevel ?? '';
        guardNameController.text = data.guardName ?? '';
        guardSafetyLevelController.text = data.guardSafetyLevel ?? '';
        receiverNoteController.text = data.receiverNote ?? '';
        workUnitCountController.text = (data.workUnitCount ?? 0).toString();
        workerCountController.text = (data.workerCount ?? 0).toString();

        if (data.startTime != null && data.startTime.isNotEmpty) {
          startTime.value = DateTime.tryParse(data.startTime) ?? DateTime.now();
        }
        if (data.endTime != null && data.endTime.isNotEmpty) {
          endTime.value = DateTime.tryParse(data.endTime) ?? DateTime.now();
        }
        if (data.workers != null) workers.assignAll(data.workers);
        if (data.relatedUnits != null) relatedUnits.assignAll(data.relatedUnits);
        if (data.risks != null) risks.assignAll(data.risks);

        if (data.registerDate != null) {
          registerDate.value = DateTime.tryParse(data.registerDate) ?? DateTime.now();
        }

        // Update date/time controllers after loading data
        updateDateTimeControllers();

        if (data.attachments != null) {
          existingAttachments.assignAll(data.attachments);
        }
        _populatePatcFiles(data);
        
        if (data.patcId != null && data.patcId.isNotEmpty) {
          final patcRes = await _repository.getPatcFiles(data.patcId);
          if (patcRes.isLoadSuccess && patcRes.data != null && patcRes.data.attachments != null) {
            patcAttachments.assignAll(patcRes.data.attachments);
          }
        }
      }
    } else {
      receiverNoteController.text = '- Như trên;\n- Lưu: P7.2';
      if (patcId.value.isNotEmpty) {
        await _loadPatcFiles(patcId.value);
      }
    }

    isLoading.value = false;
  }

  void _populatePatcFiles(WorkRegistrationDetailModel data, {bool isFromPatcApi = false}) {
    patcSignedFilePath.value = data.patcSignedFilePath ?? '';
    patcFileName.value = data.patcFileName ?? '';
    if (data.bbksFiles != null) {
      bbksFiles.assignAll(data.bbksFiles);
    } else {
      bbksFiles.clear();
    }
    if (isFromPatcApi && data.attachments != null) {
      patcAttachments.assignAll(data.attachments);
    } else if (isFromPatcApi) {
      patcAttachments.clear();
    }
  }

  Future<void> onPatcSelected(String newPatcId) async {
    if (newPatcId == null || newPatcId.isEmpty || newPatcId == patcId.value) return;
    patcId.value = newPatcId;
    final selectedPatc = listApprovedPatc.firstWhere((element) => element['id'].toString() == newPatcId, orElse: () => null);
    if (selectedPatc != null) {
      qlvhUnitName.value = selectedPatc['qlvhUnitName'] ?? '';
      constructionName.value = selectedPatc['constructionName'] ?? '';
    }
    await _loadPatcFiles(newPatcId);
  }

  Future<void> _loadPatcFiles(String selectedPatcId) async {
    ProgressHUD.show();
    final res = await _repository.getPatcFiles(selectedPatcId);
    ProgressHUD.dismiss();

    if (res.isLoadSuccess && res.data != null) {
      _populatePatcFiles(res.data, isFromPatcApi: true);
    } else {
      patcSignedFilePath.value = '';
      patcFileName.value = '';
      bbksFiles.clear();
      patcAttachments.clear();
    }
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        localFiles.add(File(result.files.single.path));
      }
    } catch (e) {
      debugPrint('pickFile error: $e');
    }
  }

  void removeLocalFile(int index) {
    localFiles.removeAt(index);
  }

  void removeExistingFile(int index) {
    existingAttachments.removeAt(index);
  }

  Future<void> save() async {
    if (codeController.text.trim().isEmpty) {
      SnackBarHUD.show('Vui lòng nhập số ĐKCT');
      return;
    }
    if (patcId.value.isEmpty) {
      SnackBarHUD.show('Vui lòng chọn PATC');
      return;
    }
    if (startTime.value.isAfter(endTime.value)) {
      SnackBarHUD.show('Thời gian bắt đầu phải trước thời gian kết thúc');
      return;
    }

    ProgressHUD.show();

    // Upload new files first
    List<Map<String, dynamic>> finalAttachments = [];

    // Keep existing attachments
    for (var att in existingAttachments) {
      finalAttachments.add({
        'fileName': att.fileName,
        'filePath': att.filePath,
        'fileSize': att.fileSize,
        'contentType': att.contentType,
      });
    }

    // Upload local files
    if (localFiles.isNotEmpty) {
      final uploadRes = await _repository.uploadFiles(localFiles.toList());
      if (uploadRes.isLoadSuccess && uploadRes.data != null) {
        for (var uploaded in uploadRes.data) {
          finalAttachments.add({
            'fileName': uploaded.fileName,
            'filePath': uploaded.filePath,
            'fileSize': uploaded.fileSize,
            'contentType': uploaded.contentType,
          });
        }
      } else {
        ProgressHUD.dismiss();
        SnackBarHUD.show('Upload file thất bại: ${uploadRes.message}');
        return;
      }
    }

    final selectedPatc = listApprovedPatc.firstWhere((element) => element['id'].toString() == patcId.value, orElse: () => null);

    final workUnitCountValue = workUnitCountController.text.trim().isNotEmpty
        ? (int.tryParse(workUnitCountController.text.trim()) ?? 0)
        : 0;
    final workerCountValue = workerCountController.text.trim().isNotEmpty
        ? (int.tryParse(workerCountController.text.trim()) ?? 0)
        : 0;

    final body = <String, dynamic>{
      'code': codeController.text.trim(),
      'name': nameController.text.trim(),
      'note': noteController.text.trim(),
      'patcId': patcId.value,
      'constructionId': selectedPatc != null ? selectedPatc['constructionId'] : null,
      'qlvhUnitId': selectedPatc != null ? selectedPatc['qlvhUnitId'] : null,
      'registerDate': registerDate.value.toIso8601String(),
      'attachments': finalAttachments,
      'commanderName': commanderNameController.text.trim(),
      'commanderSafetyLevel': commanderSafetyLevelController.text.trim(),
      'phoneNumber': phoneNumberController.text.trim(),
      'workContent': workContentController.text.trim(),
      'workLocation': workLocationController.text.trim(),
      'workCondition': workConditionController.text.trim(),
      'startTime': startTime.value.toIso8601String(),
      'endTime': endTime.value.toIso8601String(),
      'workLeaderName': workLeaderNameController.text.trim(),
      'workLeaderSafetyLevel': workLeaderSafetyLevelController.text.trim(),
      'supervisorName': supervisorNameController.text.trim(),
      'supervisorSafetyLevel': supervisorSafetyLevelController.text.trim(),
      'guardName': guardNameController.text.trim(),
      'guardSafetyLevel': guardSafetyLevelController.text.trim(),
      'receiverNote': receiverNoteController.text.trim(),
      'workUnitCount': workUnitCountValue,
      'workerCount': workerCountValue,
      'workers': workers.map((e) => e.toJson()).toList(),
      'relatedUnits': relatedUnits.map((e) => e.toJson()).toList(),
      'risks': risks.map((e) => e.toJson()).toList(),
    };

    if (isEdit) {
      body['id'] = id;
    }

    var res;
    if (isEdit) {
      res = await _repository.update(id, body);
    } else {
      res = await _repository.create(body);
    }

    ProgressHUD.dismiss();

    // Đợi 1 chút để ProgressHUD đóng hẳn
    await Future.delayed(const Duration(milliseconds: 300));

    if (res != null && res.isLoadSuccess) {
      Get.back(result: true);
      SnackBarHUD.show('Lưu thành công');
    } else {
      SnackBarHUD.show(res?.message ?? 'Lưu thất bại');
    }
  }

  @override
  void onClose() {
    codeController.dispose();
    nameController.dispose();
    noteController.dispose();
    commanderNameController.dispose();
    commanderSafetyLevelController.dispose();
    phoneNumberController.dispose();
    workContentController.dispose();
    workLocationController.dispose();
    workConditionController.dispose();
    workLeaderNameController.dispose();
    workLeaderSafetyLevelController.dispose();
    supervisorNameController.dispose();
    supervisorSafetyLevelController.dispose();
    guardNameController.dispose();
    guardSafetyLevelController.dispose();
    receiverNoteController.dispose();
    workUnitCountController.dispose();
    workerCountController.dispose();
    registerDateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.onClose();
  }
}
