// @dart=2.9
import 'dart:async';
import 'tab_form_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/app_common/utils/utils.dart';
import 'package:evnmobile/src/htld/services/location_background_service.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/profile_model.dart';
import 'package:evnmobile/src/qltnkd/common/constance/field_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/utils/connection.dart';
import 'package:evnmobile/src/qltnkd/dialog/popup.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:evnmobile/src/qltnkd/models/report_model.dart';
import 'package:evnmobile/src/qltnkd/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/report_repository.dart';
import 'package:get/get.dart';

import '../../../../../routes.dart';

class ReportController extends GetxController {
  final service = ReportRepository();
  final reportModel = ReportModel().obs;
  final reportResponse = ReportModelResponse().obs;
  final selectedFiles = <File>[].obs;
  bool isCbm = false;
  bool isMonitor = false;
  bool isAllowApprove = false;
  bool isAllowEditing = false;
  var isLoading = true.obs;
  // Case 1: UploadFile (21) - đính kèm file, gửi kèm khi Lưu form
  Future<void> pickUploadFiles(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null && result.files.isNotEmpty) {
        final allowedExt = {'jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx', 'xls', 'xlsx'};
        final validPaths = result.files
            .where((f) => f.path != null && allowedExt.contains(f.extension?.toLowerCase()))
            .map((f) => File(f.path))
            .toList();

        debugPrint('=== pickUploadFiles ===');
        debugPrint('Tổng file chọn: ${result.files.length}');
        debugPrint('File hợp lệ: ${validPaths.length}');
        for (var f in validPaths) {
          debugPrint('  + ${f.path}');
        }

        if (validPaths.isNotEmpty) {
          selectedFiles.addAll(validPaths);
          debugPrint('selectedFiles hiện tại: ${selectedFiles.length} file(s)');
        } else {
          await rShowDialogOneButton(
              'Chỉ hỗ trợ định dạng: PDF, Word (doc/docx), Excel (xls/xlsx), Ảnh (jpg/jpeg/png)');
        }
      }
    } catch (e, stack) {
      debugPrint("Error in pickUploadFiles: $e");
      debugPrint(stack.toString());
      final confirm = await Get.dialog(
        AlertDialog(
          title: const Text('Lỗi chọn file'),
          content: Text('Chi tiết lỗi: $e\n\nỨng dụng cần quyền truy cập để có thể chọn file đính kèm. Vui lòng mở Cài đặt ứng dụng để kiểm tra quyền.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Đóng'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Mở Cài đặt', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
      if (confirm == true) {
        await openAppSettings();
      }
    }
  }

  // Case 2: ImportData (22) - chọn file xlsx → gọi API → mapping dữ liệu vào form ngay
  Future<void> pickImportExcelFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final ext = file.extension?.toLowerCase() ?? '';
        if ((ext == 'xls' || ext == 'xlsx') && file.path != null) {
          importedExcelFile.value = File(file.path);
          await importExcelData(File(file.path));
        } else {
          await rShowDialogOneButton('Chỉ hỗ trợ file Excel (.xls, .xlsx) để nhập dữ liệu');
        }
      }
    } catch (e, stack) {
      debugPrint("Error in pickImportExcelFile: $e");
      debugPrint(stack.toString());
      final confirm = await Get.dialog(
        AlertDialog(
          title: const Text('Lỗi chọn file'),
          content: Text('Chi tiết lỗi: $e'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Đóng'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Mở Cài đặt', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
      if (confirm == true) {
        await openAppSettings();
      }
    }
  }

  // Giữ lại pickFiles để tương thích ngược (deprecated)
  Future<void> pickFiles(BuildContext context) => pickUploadFiles(context);

  bool get hasAttachmentField {
    if (reportModel.value?.fieldsModel == null) return false;
    
    bool checkFields(List<FieldModel> fields) {
      if (fields == null) return false;
      for (var f in fields) {
        if (f.fieldType == FieldType.uploadFile || f.fieldType == FieldType.importData) {
          return true;
        }
        if (f.fieldModels != null && checkFields(f.fieldModels)) {
          return true;
        }
      }
      return false;
    }

    return checkFields(reportModel.value.fieldsModel);
  }

  void _updateFieldByName(List<FieldModel> fields, String name, String value) {
    if (fields == null) return;
    for (var f in fields) {
      if (f.fieldName == name) {
        f.value = value;
      }
      if (f.fieldModels != null && f.fieldModels.isNotEmpty) {
        _updateFieldByName(f.fieldModels, name, value);
      }
    }
  }

  Future<void> importExcelData(File file) async {
    final formId = reportResponse.value?.formId ?? reportId ?? '';
    final res = await service.importExcelData(file, formId);
    debugPrint('=== importExcelData result ===');
    debugPrint('statusCode: ${res == null ? 'null' : res['statusCode']}');
    debugPrint('data: ${res == null ? 'null' : res['data']}');
    debugPrint('message: ${res == null ? 'null' : res['message']}');
    if (res != null && res['statusCode'].integer == 200 && res['data'] != null) {
      final dataJson = res['data'];
      final dataMap = dataJson.mapObject;
      debugPrint('dataMap keys: ${dataMap?.keys?.toList()}');
      if (dataMap != null) {
        dataMap.forEach((key, value) {
          debugPrint('Mapping: $key => $value');
          _updateFieldByName(reportModel.value.fieldsModel, key.toString(), value?.toString() ?? '');
        });
      }
      await rShowDialogOneButton('Đọc dữ liệu Excel thành công');
      update();
    } else {
      final message = res != null ? res['message'].string : null;
      debugPrint('importExcelData failed: $message');
      await rShowDialogOneButton(message?.isNotEmpty == true ? message : 'Đọc dữ liệu Excel thất bại');
    }
  }

  void removeFile(int index) {
    selectedFiles.removeAt(index);
  }

  Rx<File> importedExcelFile = Rx<File>(null);

  String reportId;
  String userImpl;
  int reportType;
  bool isInitNetworkStateOnline = true;
  List<StringOptionModel> usersRoleOperationApproval = RxList.empty();
  UserProfileModel currentUser = AppShared.instance.getUserProfile();

  bool isHasEdit() {
    // if(isMonitor &&
    //     reportResponse.value.reportModel.reportType == WorkType.accreditation &&
    // RUserRole.isOperator){
    //   return false;
    // }
    //
    // if(isMonitor &&
    //     reportResponse.value.reportModel.reportType == WorkType.experiment &&
    // RUserRole.isWorker){
    //   return false;
    // }

    return isAllowEditing;

    // return (reportResponse.value.status == ReportStatusType.Implementing ||
    //         reportResponse.value.status == ReportStatusType.Rejected ||
    //         reportResponse.value.status ==
    //             ReportStatusType.WaitingForTeamApproval) &&
    //     (RUserRole.isWorker || (RUserRole.isOperator && (userImpl == null || currentUser.id == userImpl)));
  }

  Future getReport() async {
    Future getReportOnline() async {
      isLoading.value = true;
      final response = await service.getReportFormDetail(reportId);
      isLoading.value = false;
      if (response.isLoadSuccess) {
        reportModel.value = response.data.reportModel;
        reportResponse.value = response.data;
        renderTextBtn();
        update();
      } else {
        await rShowDialogOneButton(response?.message ?? '');
      }
    }

    Future getReportOffline() async {
      isLoading.value = true;
      final response =
          await RLocalDataManager.instance.getReportFormDetail(reportId);
      isLoading.value = false;
      if (response != null) {
        reportModel.value = response.reportModel;
        reportResponse.value = response;
        renderTextBtn();
        update();
      } else {
        await rShowDialogOneButton('Không tìm thấy biên bản');
      }
    }

    final isOnline = await RConnection.shared.checkConnection();
    isInitNetworkStateOnline = isOnline;

    if (isOnline) {
      await getReportOnline();
    } else {
      await getReportOffline();
    }
  }

  Function actionApproval;
  Function actionReject;
  String inputFirst;
  String approvalPerson;
  String textBtn = '';
  String content = '';

  bool isHasApproval = false;
  bool isHasReject = false;

  Future updateForm() async {
    final isLocationGranted = await LocationServiceBackground.shared.requestPermission();
    if (!isLocationGranted) return;

    ProgressHUD.show();
    // final isHasError = await fieldModel.value.validateDataModel();
    //
    // if (isHasError == true) {
    //   ProgressHUD.dismiss();
    //   await showDialogError('Vui lòng nhập đủ thông tin');
    //   fieldModel.refresh();
    //   update();
    // } else {
    //   ProgressHUD.dismiss();
    //   await updateForm();
    // }

    final isConclusionPositive = reportModel?.value?.fieldsModel
            ?.firstWhereOrNull((element) => element.fieldType == FieldType.taps)
            ?.fieldModels
            ?.last
            ?.fieldModels
            ?.firstWhereOrNull((element2) => element2.isConclusion() == true)
            ?.value ==
        '5f41ad19-4379-47af-a17b-d99175729c69';


    FieldModel fieldNumberStamp;

    if (isConclusionPositive) {

      fieldNumberStamp = reportModel?.value?.fieldsModel
          ?.firstWhere((element) => element.fieldType == FieldType.taps,
          orElse: () => null)
          ?.fieldModels[0]
          ?.fieldModels
          ?.firstWhere((element) => element.isStampNumber(),
          orElse: () => null);

      ProgressHUD.dismiss();
      if (fieldNumberStamp != null &&
          (fieldNumberStamp.value == null ||
              (fieldNumberStamp.value != null &&
                  fieldNumberStamp.value.isEmpty))) {
        await rShowDialogOneButton('Vui lòng nhập số tem kiểm định');
        return;
      }
    }

    Future updateFormOnline() async {
      await evaluateAllThresholds();
      
      // Tìm tất cả các file cục bộ trong form và đẩy vào selectedFiles để gửi qua putMultipart
      void _extractDynamicFiles(List<FieldModel> fields) {
        if (fields == null) return;
        for (var f in fields) {
          if (f.fieldType == FieldType.uploadFile && f.value != null && f.value.isNotEmpty) {
            try {
              List<dynamic> filesList = jsonDecode(f.value);
              bool changed = false;
              for (var i = 0; i < filesList.length; i++) {
                if (filesList[i]['isLocal'] == true && filesList[i]['path'] != null) {
                  File file = File(filesList[i]['path']);
                  if (file.existsSync()) {
                    // Thêm file vào mảng selectedFiles để gửi một lần qua /formreport
                    selectedFiles.add(file);
                    filesList[i].remove('isLocal');
                    filesList[i].remove('path');
                    changed = true;
                  }
                }
              }
              if (changed) {
                f.value = jsonEncode(filesList);
              }
            } catch (e) {
              debugPrint('Parse error for uploadFile: $e');
            }
          }
          if (f.fieldModels != null && f.fieldModels.isNotEmpty) {
            _extractDynamicFiles(f.fieldModels);
          }
        }
      }
      
      _extractDynamicFiles(reportModel.value.fieldsModel);

      final response = await service.updateReport(
          reportId.toString(),
          reportModel.value.fieldsModel.firstWhere(
              (element) => element.fieldType == FieldType.taps,
              orElse: () => null),
          files: selectedFiles);

      ProgressHUD.dismiss();

      if (response.isLoadSuccess) {
        if (response.data != null && response.data.fieldsModel != null) {
          void updateFieldValues(List<FieldModel> oldFields, List<FieldModel> newFields) {
            if (oldFields == null || newFields == null) return;
            final newFieldMap = { for (var e in newFields) e.id: e };
            for (var oldField in oldFields) {
              var newField = newFieldMap[oldField.id];
              if (newField != null) {
                if (oldField.value != newField.value) {
                  oldField.value = newField.value;
                }
                updateFieldValues(oldField.fieldModels, newField.fieldModels);
              }
            }
          }
          updateFieldValues(reportModel.value.fieldsModel, response.data.fieldsModel);
          update(); // Cập nhật UI chung
          reportModel.refresh(); // Cập nhật các component Obx (như cột tình trạng)
        }
        SnackBarHUD.show('Cập nhật biên bản thành công');
        
        // Theo yêu cầu mới, bỏ điều kiện isCbm, luôn gọi đồng bộ khi Lưu thành công
        final syncResponse = await service.syncPmisCbm(reportId.toString());
        if (syncResponse != null) {
          final msg = (syncResponse.message != null && syncResponse.message.isNotEmpty)
              ? syncResponse.message
              : 'Đồng bộ PMIS CBM thành công';
              
          // Nếu BE trả về message báo thành công thì hiện Toast cho nhanh
          // Còn nếu là câu cảnh báo/lỗi thì hiện Popup để user bắt buộc phải đọc
          if (msg.toLowerCase().contains('thành công')) {
            SnackBarHUD.show(msg);
          } else {
            await rShowDialogOneButton(msg);
          }
        }

        // Xóa danh sách file đã chọn sau khi gửi thành công để không bị gửi lại nếu nhấn Lưu lần nữa
        if (selectedFiles.isNotEmpty) {
          selectedFiles.clear();
          update(); // Cập nhật lại giao diện (ẩn danh sách file đã gửi)
        }
     final reportOffline =  await RLocalDataManager.instance.getReportFormDetail(reportId);

        if (reportOffline?.isSync == false) {
          reportOffline.isSync = true;
          await RLocalDataManager.instance.updateReportFormOffline(reportId.toString(),
              reportModel.value.fieldsModel.firstWhere(
                      (element) => element.fieldType == FieldType.taps,
                  orElse: () => null),
              reportResponse.value.scheduleId);
        }

        await service.sendLocation(reportId.toString(), type: 2);
        if (reportResponse.value.status ==
            ReportStatusType.WaitingForTeamApproval) {
          reportResponse.refresh();
          renderTextBtn();
          update();
        }
      } else {
        await rShowDialogOneButton(response?.message ?? '');
      }
    }

    Future updateFormOffline() async {
      if (fieldNumberStamp != null) {
        final message = await RLocalDataManager.instance
            .isDuplicateStamp(fieldNumberStamp.value, reportId);
        if (message != null) {
          await rShowDialogOneButton(message);
          return;
        }
      }

      await RLocalDataManager.instance.updateReportFormOffline(
          reportId.toString(),
          reportModel.value.fieldsModel.firstWhere(
              (element) => element.fieldType == FieldType.taps,
              orElse: () => null),
          reportResponse.value.scheduleId);
      ProgressHUD.dismiss();
      SnackBarHUD.show('Cập nhật biên bản offline thành công');
    }

    final isOnline = await RConnection.shared.checkConnection();
    if (isOnline && !isInitNetworkStateOnline) {
      await updateFormOffline();
    } else {
      if (isOnline) {
        await updateFormOnline();
      } else {
        await updateFormOffline();
      }
    }
  }

  Future sendApproval({bool isApproval}) async {
    if (reportResponse.value.status == ReportStatusType.Implementing ||
        reportResponse.value.status == ReportStatusType.Rejected) {
      ProgressHUD.show();
      final updateResponse = await service.updateReport(
          reportId.toString(),
          reportModel.value.fieldsModel.firstWhere(
              (element) => element.fieldType == FieldType.taps,
              orElse: () => null),
          isBackgroundMode: true,
          files: selectedFiles);
      if (updateResponse.isLoadSuccess) {
        if (isApproval == true) {
          final signResponse = await service.signatureReport(formReportId: reportId);
          if (!signResponse.isLoadSuccess) {
            ProgressHUD.dismiss();
            await rShowDialogOneButton(signResponse.message);
            return;
          }
        }
        final response = await service.sendApproval(
            formReportId: [reportId],
            content: content,
            isBackgroundMode: true,
            status: reportResponse.value.status.toString(),
            isApproval: isApproval);
        ProgressHUD.dismiss();
        if (response.isLoadSuccess) {
          reportResponse.value.status = ReportStatusType.WaitingForTeamApproval;
          reportResponse.refresh();
          renderTextBtn();
          update();
        } else {
          await rShowDialogOneButton(response.message);
        }
      } else {
        ProgressHUD.dismiss();
        await rShowDialogOneButton(updateResponse?.message ?? '');
      }
    } else {
      if (isApproval == true) {
        final signResponse = await service.signatureReport(formReportId: reportId);
        if (!signResponse.isLoadSuccess) {
          await rShowDialogOneButton(signResponse.message);
          return;
        }
      }
      final response = await service.sendApproval(
          formReportId: [reportId],
          content: content,
          status: reportResponse.value.status.toString(),
          isApproval: isApproval);
      if (response.isLoadSuccess) {
        await getReport();
      } else {
        await rShowDialogOneButton(response.message);
      }
    }
  }

  Future sendApprovalOperation(String approveId, String content) async {
    final signResponse = await service.signatureReport(formReportId: reportId);
    if (!signResponse.isLoadSuccess) {
      await rShowDialogOneButton(signResponse.message);
      return;
    }
    final response = await service.sendOperation(
        formReportId: reportId, content: content, approveId: approveId);
    if (response.isLoadSuccess) {
      await rShowDialogOneButton('Gửi phê duyệt thành công', action: () {
        Get.until((route) => [Routes.listReportScreen, Routes.detailWorkScreen]
            .contains(route.settings.name));
      });
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future approvalOperationTeam({bool isApproval}) async {
    if (isApproval == true) {
      final signResponse = await service.signatureReport(formReportId: reportId);
      if (!signResponse.isLoadSuccess) {
        await rShowDialogOneButton(signResponse.message);
        return;
      }
    }
    final response = await service.approvalOperationTeam(
        formReportId: reportId, content: content, isApproval: isApproval);
    if (response.isLoadSuccess) {
      await rShowDialogOneButton(
          isApproval ? 'Phê duyệt thành công' : 'Từ chối thành công',
          action: () {
        Get.until((route) => [Routes.listReportScreen, Routes.detailWorkScreen]
            .contains(route.settings.name));
      });
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future approvalOperationLeader({bool isApproval}) async {
    if (isApproval == true) {
      final signResponse = await service.signatureReport(formReportId: reportId);
      if (!signResponse.isLoadSuccess) {
        await rShowDialogOneButton(signResponse.message);
        return;
      }
    }
    final response = await service.approvalLeader(
        formReportIds: [reportId], content: content, isApproval: isApproval);
    if (response.isLoadSuccess) {
      await rShowDialogOneButton(
          isApproval ? 'Phê duyệt thành công' : 'Từ chối thành công',
          action: () {
        Get.until((route) => [Routes.listReportScreen, Routes.detailWorkScreen]
            .contains(route.settings.name));
      });
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  void showApproval({String title, String actionText}) {
    if ([ReportStatusType.Implementing, ReportStatusType.Rejected]
            .contains(reportResponse.value.status) &&
        RUserRole.isOperator) {
      actionApproval = () {
        showDialogSendOperation(
            positiveAction: (approvalId, content) {
              sendApprovalOperation(approvalId, content);
            },
            negativeAction: () {},
            options: usersRoleOperationApproval);
      };
      return;
    }
    actionApproval = () {
      showDialogApproval(
          title: title,
          onChangeContent: (value) {
            content = value;
          },
          negativeAction: () {
            content = '';
          },
          actionText: actionText,
          positiveAction: () {
            if (RUserRole.isOperator) {
              approvalOperationTeam(isApproval: true);
            } else if (RUserRole.isLeader) {
              approvalOperationLeader(isApproval: true);
            } else {
              sendApproval(isApproval: true);
            }
          });
    };
  }

  void showReject() {
    actionReject = () {
      showDialogApproval(
          title: 'Từ chối',
          onChangeContent: (value) {
            content = value;
          },
          negativeAction: () {
            content = '';
          },
          actionText: 'Từ chối',
          positiveAction: () {
            if (RUserRole.isOperator) {
              approvalOperationTeam(isApproval: false);
            } else if (RUserRole.isLeader) {
              approvalOperationLeader(isApproval: false);
            } else {
              sendApproval(isApproval: false);
            }
          });
    };
  }

  void renderTextBtn() {
    // if (isMonitor == true &&
    //     reportModel.value.reportType == WorkType.accreditation &&
    //     RUserRole.isOperator){
    //   return;
    // } else if(isMonitor == true &&
    //     reportModel.value.reportType == WorkType.experiment &&
    //     RUserRole.isWorker) {
    //   return;
    // }
    // switch (reportResponse.value.status.toString()) {
    //   case '${ReportStatusType.Implementing}':
    //     textBtn = 'Gửi phê duyệt';
    //     showApproval(
    //       title: textBtn,
    //       actionText: 'Gửi',
    //     );
    //
    //     isHasApproval = RUserRole.isWorker || (RUserRole.isOperator && (userImpl == null || currentUser.id == userImpl));
    //     isHasReject = false;
    //
    //     break;
    //
    //   case '${ReportStatusType.Rejected}':
    //     textBtn = 'Gửi phê duỵệt';
    //
    //     showApproval(
    //       title: textBtn,
    //       actionText: 'Gửi',
    //     );
    //
    //     isHasApproval = RUserRole.isWorker || (RUserRole.isOperator && (userImpl == null || currentUser.id == userImpl));
    //     isHasReject = false;
    //
    //     break;
    //
    //   case '${ReportStatusType.WaitingForTeamApproval}':
    //     textBtn = 'Phê duyệt';
    //     showApproval(
    //       title: 'Phê duyệt cấp tổ đội',
    //       actionText: 'Phê duyệt',
    //     );
    //
    //     showReject();
    //
    //     isHasApproval = RUserRole.isCaptain || RUserRole.isOperator && isAllowApprove;
    //     isHasReject = RUserRole.isCaptain || RUserRole.isOperator && isAllowApprove;
    //     if(isMonitor == true &&
    //         reportResponse.value.status ==
    //             ReportStatusType.WaitingForTeamApproval &&
    //         isAllowApprove == false){
    //       isHasApproval = false;
    //       isHasReject = false;
    //     }
    //     break;
    //   case '${ReportStatusType.WaitingForCenterApproval}':
    //     textBtn = 'Phê duyệt';
    //
    //     showApproval(
    //       title: 'Phê duyệt cấp trung tâm',
    //       actionText: 'Phê duyệt',
    //     );
    //
    //     showReject();
    //
    //     isHasApproval = RUserRole.isPresidentCenter;
    //     isHasReject = RUserRole.isPresidentCenter;
    //
    //     break;
    //   case '${ReportStatusType.WaitingForCompanyApproval}':
    //     textBtn = 'Phê duyệt';
    //
    //     showApproval(
    //       title: 'Phê duyệt cấp công ty',
    //       actionText: 'Phê duyệt',
    //     );
    //
    //     showReject();
    //
    //     isHasApproval = RUserRole.isPresidentCompany || RUserRole.isLeader;
    //     isHasReject = RUserRole.isPresidentCompany || RUserRole.isLeader;
    //     break;
    //
    //   case '${ReportStatusType.Completed}':
    //     textBtn = 'Hoàn thành';
    //     isHasApproval = false;
    //     isHasReject = false;
    //     break;
    //
    //   case '${ReportStatusType.all}':
    //     textBtn = 'Tất cả';
    //     isHasApproval = false;
    //     isHasReject = false;
    //     break;
    // }
  }

  Future getRoleOperationApprove() async {
    if (!RUserRole.isOperator) {
      return;
    }
    final response = await service.getRoleOperationApprove();
    if (response.isLoadSuccess) {
      response.data.forEach((element) {
        usersRoleOperationApproval
            .add(StringOptionModel(element.name, element.id));
      });
    }
  }

  Future<String> addGeneralData(String name, String type) async {
    final response =
        await service.addGeneralData(name, type, reportResponse.value.formId);
    if (response.isLoadSuccess) {
      return response.data;
    } else {
      await rShowDialogOneButton(response?.message ?? '');
      return null;
    }
  }

  List<FieldModel> _findAllEvaluateFields(List<FieldModel> fields) {
    List<FieldModel> list = [];
    if (fields == null) return list;
    for (var f in fields) {
      if (f.fieldType == 20 || f.fieldThresholdMappings != null) {
        list.add(f);
      }
      list.addAll(_findAllEvaluateFields(f.fieldModels));
    }
    return list;
  }

  FieldModel _findFieldById(List<FieldModel> fields, String id) {
    if (fields == null) return null;
    for (var f in fields) {
      if (f.id == id) return f;
      final found = _findFieldById(f.fieldModels, id);
      if (found != null) return found;
    }
    return null;
  }

  FieldModel _findFieldByName(List<FieldModel> fields, String name) {
    if (fields == null) return null;
    for (var f in fields) {
      if (f.fieldName == name) return f;
      final found = _findFieldByName(f.fieldModels, name);
      if (found != null) return found;
    }
    return null;
  }

  Timer _evaluateDebounce;

    Future<void> evaluateAllThresholds() async {
      debugPrint('Bắt đầu đánh giá toàn bộ tình trạng...');
      final evaluateFields = _findAllEvaluateFields(reportModel.value.fieldsModel);
      bool hasChanges = false;
      for (var evalField in evaluateFields) {
        if (evalField.fieldThresholdMappings == null || evalField.fieldThresholdMappings.isEmpty) continue;
        
        final dependentValues = <String, dynamic>{};
        String currentTempValue = '';

        for (var mapping in evalField.fieldThresholdMappings) {
          if (mapping is Map) {
            mapping.forEach((key, value) {
              if (key.toString().startsWith('measureId')) {
                String index = key.toString().replaceAll('measureId', '');
                String measureValuePlaceholder = mapping['measureValue$index']?.toString();
                String refId = value?.toString();
                if (measureValuePlaceholder != null && refId != null) {
                  FieldModel refField = _findFieldById(reportModel.value.fieldsModel, refId);
                  dependentValues[measureValuePlaceholder] = (refField?.value == null || refField.value.isEmpty) ? null : refField.value;
                }
              } else if (key.toString() == 'currentTemperature') {
                String tempFieldName = value?.toString();
                if (tempFieldName != null && tempFieldName.isNotEmpty) {
                  FieldModel tempField = _findFieldByName(reportModel.value.fieldsModel, tempFieldName);
                  currentTempValue = tempField?.value ?? '';
                  dependentValues[tempFieldName] = currentTempValue.isEmpty ? null : currentTempValue;
                }
              } else if (!key.toString().startsWith('measureValue')) {
                String measureValuePlaceholder = key.toString();
                String refId = value?.toString();
                if (measureValuePlaceholder.startsWith('[') && measureValuePlaceholder.endsWith(']')) {
                  FieldModel refField = _findFieldById(reportModel.value.fieldsModel, refId);
                  dependentValues[measureValuePlaceholder] = (refField?.value == null || refField.value.isEmpty) ? null : refField.value;
                }
              }
            });
          }
        }

        final payload = {
          "fieldId": evalField.id,
          "vectorGroup": evalField.vectorGroup?.isEmpty == true ? null : evalField.vectorGroup,
          "currentTemperature": double.tryParse(currentTempValue),
          "dependentValues": dependentValues
        };

        final res = await service.evaluateThreshold(payload, isBackgroundMode: true);
        if (res.data != null && res.data.toString().isNotEmpty && res.data.toString() != 'null') {
          if (evalField.value != res.data) {
            evalField.value = res.data;
            hasChanges = true;
          }
        }
      }
      
      if (hasChanges) {
        update();
        reportModel.refresh();
      }
    }

  Future<void> checkEvaluate(FieldModel changedField) async {
    if (_evaluateDebounce?.isActive ?? false) _evaluateDebounce.cancel();
    _evaluateDebounce = Timer(const Duration(milliseconds: 1000), () async {
       await evaluateAllThresholds();
    });
  }
}

