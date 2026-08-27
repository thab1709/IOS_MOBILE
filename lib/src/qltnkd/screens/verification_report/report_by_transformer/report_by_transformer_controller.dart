import 'package:evnmobile/src/htdct/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:get/get.dart';


import '../../../../htdct/common/utils/snack_bar_h_u_d.dart';
import '../../../../htdct/screens/grid_management/base/list_delegate.dart';
import '../../../common/constance/r_user_role_type.dart';
import '../../../common/constance/report_work_status_type.dart';
import '../../../common/constance/strings.dart';
import '../../../common/utils/alert_dialog_utils.dart';
import '../../../common/utils/connection.dart';
import '../../../dialog/popup.dart';
import '../../../models/create_report_not_plan_model.dart';
import '../../../models/option_model.dart';
import '../../../models/report_merge_model.dart';
import '../../../models/work_merge_model.dart';
import '../../../offline_service/local_data_manager.dart';
import '../../../services/responsitory/certificate_repository.dart';
import '../../../services/responsitory/merge_form_report_repository.dart';
import '../../../services/responsitory/report_repository.dart';
import '../detail_report/detail_report_screen.dart';
import '../list_report/pdf_merge_report/pdf_merge_report_screen.dart';

class ReportByTransformerModel {
  ReportByTransformerModel(
      {this.transformerName, this.transformerId, this.mergeModels, this.isExpand = false});

  String transformerName;
  String transformerId;
  List<WorkMergeModel> mergeModels;
  bool isSelected;
  bool isExpand;

  void setChecked() {}
}

class ReportByTransformerController extends GetxController {
  final listReportByTransformerModel = <ReportByTransformerModel>[].obs;
  int page = 1;
  List<StringOptionModel> unitOptions = RxList.empty();
  final serviceReport = ReportRepository();
  final serviceCertificate = CertificateRepository();
  bool isSearched = false;


  final service = MergerFormReportRepository();
  final isShowLoading = false.obs;
  final searchTerm = ''.obs;
  final workGroupType = 0.obs;
  bool isFirstLoad = false;
  DateTime fromDateTime = DateTime.now();
  DateTime toDateTime = DateTime.now();
  List<StringOptionModel> usersRoleOperationApproval = RxList.empty();
  List<StringOptionModel> presidentCenters = RxList.empty();
  List<StringOptionModel> presidentCompanies = RxList.empty();

  String fromDate =  DateTime.now().formatFirstDate();
  String toDate = DateTime.now().formatSecondDate();
  String unit = '0';
  String workType = '0';
  String reportType = '0';
  String teamId = '0';
  String userId = '0';
  String locationReport = '0';
  String content = '';
  String departmentId = '0';
  final isPaperReport = false.obs;

  String equipmentType = '0';
  String detailEquipmentType;

  final isNewToOld = true.obs;
  final isFilter = true.obs;
  ListDelegate delegate;
  String qrFormReportId;

  String statusReport = ReportStatusType.all.toString();
  final isSearching = false.obs;

  final optionsStatus = [
    const IntOptionModel(RAppStrings.all, ReportStatusType.all),
    const IntOptionModel(
        RAppStrings.workImplementing, ReportStatusType.Implementing),
    const IntOptionModel(RAppStrings.rejected, ReportStatusType.Rejected),
    const IntOptionModel(RAppStrings.waitingForTeamApproval,
        ReportStatusType.WaitingForTeamApproval),
    const IntOptionModel(RAppStrings.waitingForCenterApproval,
        ReportStatusType.WaitingForCenterApproval),
    const IntOptionModel(RAppStrings.approvalCompany,
        ReportStatusType.WaitingForCompanyApproval),
    const IntOptionModel(RAppStrings.approved, ReportStatusType.Completed),
  ];

  List<EquipmentTypes> equipmentTypeList = RxList.empty();
  final detailEquipmentList = <StringOptionModel>[].obs;
  List<StringOptionModel> equipmentTypes = RxList.empty();

  void checkFiltered() {
    if (fromDate.isNotEmpty ||
        statusReport != ReportStatusType.all.toString() ||
        unit != '0' ||
        isPaperReport.value ||
        detailEquipmentType != null ||
        (equipmentType != null && equipmentType != '0')

    ) {
      isFilter.value = true;
    } else {
      isFilter.value = false;
    }
  }

  Future getRoleOperationApprove() async {
    if (!RUserRole.isOperator) {
      return;
    }
    final response = await serviceReport.getRoleOperationApprove();
    if (response.isLoadSuccess) {
      response.data.forEach((element) {
        usersRoleOperationApproval
            .add(StringOptionModel(element.name, element.id));
      });
    }
  }

  Future getListPresidentCenter() async {
    Future getOnline() async {
      final response = await serviceReport.getListPersidentCenter();
      if (response.isLoadSuccess) {
        presidentCenters.add(StringOptionModel(RAppStrings.pleaseSelect, '0'));
        response.data.forEach((element) {
          presidentCenters.add(StringOptionModel(element.name, element.id));
        });
      }
    }

    // Future getOffline() async {
    //   users.clear();
    //   final response = await RLocalDataManager.instance.getPerformerOffline() ??
    //       List.empty();
    //   users.add(StringOptionModel(RAppStrings.all, '0'));
    //   response.forEach((e) => users.add(StringOptionModel(e.name, e.id)));
    // }

    final isOnline = await RConnection.shared.checkConnection();

    if (isOnline) {
      await getOnline();
    } else {
      // await getListUserOffline();
    }
  }

  void clearFilter() {
    fromDate = '';
    toDate = '';
    userId = '0';
    locationReport = '0';
    departmentId = '0';
    content = '';
    teamId = '0';
    isPaperReport.value = false;
    statusReport = '0';
    equipmentType = '0';
    detailEquipmentType = null;
  }

  Future getListPresidentCompanies() async {
    Future getOnline() async {
      final response = await serviceReport.getListPresidentCompany(
          userPosition: UserPosition.KDTN_PresidentCompany.toString());
      if (response.isLoadSuccess) {
        presidentCompanies
            .add(StringOptionModel(RAppStrings.pleaseSelect, '0'));
        response.data.forEach((element) {
          presidentCompanies.add(StringOptionModel(element.name, element.id));
        });
      }
    }

    // Future getOffline() async {
    //   users.clear();
    //   final response = await RLocalDataManager.instance.getPerformerOffline() ??
    //       List.empty();
    //   users.add(StringOptionModel(RAppStrings.all, '0'));
    //   response.forEach((e) => users.add(StringOptionModel(e.name, e.id)));
    // }

    final isOnline = await RConnection.shared.checkConnection();

    if (isOnline) {
      await getOnline();
    } else {
      // await getListUserOffline();
    }
  }

  Future searchByFormReportId(String formReportId) async {
    final value = formReportId?.trim() ?? '';
    if (value.isEmpty) {
      return;
    }

    searchTerm.value = value;
    qrFormReportId = value;
    fromDate = '';
    toDate = '';
    unit = '0';
    workType = '0';
    reportType = '0';
    teamId = '0';
    userId = '0';
    locationReport = '0';
    departmentId = '0';
    equipmentType = '0';
    detailEquipmentType = null;
    isPaperReport.value = false;
    statusReport = ReportStatusType.all.toString();
    isSearched = true;
    isSearching.value = false;
    await getWorkMerge();
  }

  void clearQrSearch() {
    qrFormReportId = null;
  }

  Future getWorkMerge() async {

    listReportByTransformerModel.clear();
    final List<WorkMergeModel> workMergeModelItems = [];
    
    // Nếu user nhập thủ công 1 UUID vào ô tìm kiếm, tự động coi nó như là quét QR
    String effectiveQr = qrFormReportId;
    if (effectiveQr == null && searchTerm.value.trim().length == 36 && searchTerm.value.contains('-')) {
       effectiveQr = searchTerm.value.trim();
    }

    Future getReportsOnline() async {
      ProgressHUD.show();
      var isQrFallback = false;

      // Xử lý tự động: effectiveQr có thể là Schedule ID hoặc Form Report ID
      // Ta ưu tiên query bằng ID trước
      // Tự động nhận diện QR là Schedule ID hay Form Report ID
      String effectiveScheduleId = effectiveQr;
      String effectiveFormReportId = effectiveQr;
      
      if (effectiveQr != null) {
        final detailRes = await serviceReport.getReportFormDetail(effectiveQr, isNotShowLoading: true);
        if (detailRes.isLoadSuccess && detailRes.data != null && detailRes.data.scheduleId != null && detailRes.data.scheduleId.isNotEmpty) {
          // QR là Form Report ID, lấy được Schedule ID
          effectiveScheduleId = detailRes.data.scheduleId;
        } else {
          // QR có thể là Schedule ID, không dùng nó cho formReportId
          effectiveFormReportId = null; 
        }
      }

      Future getWorkByPage(int page) async {
        final response = await service.getReports(
            id: isQrFallback ? null : effectiveScheduleId,
            formReportId: isQrFallback ? null : effectiveFormReportId,
            workingStatus: statusReport,
            fromDate: (searchTerm.value.isNotEmpty) ? null : fromDate,
            searchTerm: isQrFallback
                ? effectiveScheduleId // Nếu fallback, thử tìm bằng ID (hoặc QR) trong SearchTerm
                : (effectiveScheduleId == null ? searchTerm.value : null),
            equipmentType: equipmentType,
            detailEquipmentType: detailEquipmentType,
            toDate: (searchTerm.value.isNotEmpty) ? null : toDate,
            isPaperReport: isPaperReport.value ? true : null,
            pageIndex: page,
            orderBy: isNewToOld.value ? 'ascend' : 'descend',
            unitId: unit,
            isNotShowLoading: true);

        if(response.isLoadSuccess && response.data.listReport.isNotEmpty) {
          workMergeModelItems.addAll(response.data.listReport);
        }
      }

      var response = await service.getReports(
          id: effectiveScheduleId,
          formReportId: effectiveFormReportId,
          workingStatus: statusReport,
          fromDate: (searchTerm.value.isNotEmpty) ? null : fromDate,
          searchTerm: effectiveScheduleId == null ? searchTerm.value : null,
          equipmentType: equipmentType,
          detailEquipmentType: detailEquipmentType,
          toDate: (searchTerm.value.isNotEmpty) ? null : toDate,
          isPaperReport: isPaperReport.value ? true : null,
          pageIndex: 1,
          orderBy: isNewToOld.value ? 'ascend' : 'descend',
          unitId: unit,
          isNotShowLoading: true);

      if (qrFormReportId != null &&
          response.isLoadSuccess &&
          (response.data?.listReport?.isEmpty ?? true)) {
        isQrFallback = true;
        response = await service.getReports(
            workingStatus: statusReport,
            fromDate: fromDate,
            searchTerm: qrFormReportId,
            equipmentType: equipmentType,
            detailEquipmentType: detailEquipmentType,
            toDate: toDate,
            isPaperReport: isPaperReport.value ? true : null,
            pageIndex: 1,
            orderBy: isNewToOld.value ? 'ascend' : 'descend',
            unitId: unit,
            isNotShowLoading: true);
      }

      isFirstLoad = true;

      if (response.isLoadSuccess && response.data.listReport.isNotEmpty) {
        workMergeModelItems.addAll(response.data.listReport);
        var totalPages = response.data.paging?.totalPages?.toInt() ?? 1;
        if (qrFormReportId != null && totalPages > 20) {
          totalPages = 20;
        }
        if(totalPages > 1) {
          final futures = <Future>[];
          for(int i = 2; i <= totalPages; i++) {
            futures.add(getWorkByPage(i));
          }

          await Future.wait(futures);
        }

        final listItems = _filterQrFormReportItems(workMergeModelItems);
        listReportByTransformerModel.clear();
        for (final element in listItems) {
          final reportByTransformerModel = listReportByTransformerModel
              .firstWhereOrNull((e) => e.mergeModels.any((i) {
            if (i.substationId != null) {
              return i.substationId == element.substationId;
            } else if (i.location != null) {
              return i.location == element.location;
            } else {
              return false;
            }
          }));

          if (reportByTransformerModel != null) {
            if (!reportByTransformerModel.mergeModels.any((m) => m.id == element.id && m.formReportId == element.formReportId)) {
              reportByTransformerModel.mergeModels.add(element);
            }
          } else {
            listReportByTransformerModel.add(ReportByTransformerModel(
                transformerName: element.location,
                transformerId: element.substationId,
                mergeModels: [element]));
          }
        }
        
        ProgressHUD.dismiss();

        // Tự động chuyển qua màn chi tiết nếu quét QR camera ngoài
        if (qrFormReportId != null && listReportByTransformerModel.isEmpty) {
          ProgressHUD.show();
          final reportRes = await serviceReport.getReportFormDetail(qrFormReportId, isNotShowLoading: true);
          ProgressHUD.dismiss();
          if (reportRes.isLoadSuccess && reportRes.data != null) {
            await Get.to(() => DetailReportScreen(reportId: qrFormReportId));
          }
        }
      } else {
        ProgressHUD.dismiss();
        await rShowDialogOneButton(response.message);
      }


      listReportByTransformerModel.refresh();
    }

    Future getOffline() async {
      listReportByTransformerModel.clear();
      final response = await RLocalDataManager.instance.getMergeReportsOffline(
        reportStatus: statusReport,
        fromDate: fromDate,
        toDate: toDate,
        searchTerm: qrFormReportId == null ? searchTerm.value : '',
        //orderBy: reportDirectorCompanyController.isNewToOld ? 'descend' : 'ascend',
        unitId: unit,
      );
      if (response != null) {
        final listItems = _filterQrFormReportItems(response);
        listItems.forEach((element) {
          if (listReportByTransformerModel.isEmpty) {
            listReportByTransformerModel.add(ReportByTransformerModel(
                transformerName: element.location,
                transformerId: element.substationId,
                mergeModels: [element]));
          } else {
            final reportByTransformerModel = listReportByTransformerModel
                .firstWhereOrNull((e) => e.mergeModels.any((i) {
                      if (i.substationId != null) {
                        return i.substationId == element.substationId;
                      } else if (i.location != null) {
                        return i.location == element.location;
                      } else {
                        return false;
                      }
                    }));

            if (reportByTransformerModel != null) {
              reportByTransformerModel.mergeModels.add(element);
            } else {
              listReportByTransformerModel.add(ReportByTransformerModel(
                  transformerName: element.location,
                  transformerId: element.substationId,
                  mergeModels: [element]));
            }
          }
        });
      }
      listReportByTransformerModel.refresh();
    }

    final isOnline = await RConnection.shared.checkConnection();

    if (isOnline) {
      await getReportsOnline();
    } else {
      await getOffline();
    }
  }

  List<WorkMergeModel> _filterQrFormReportItems(List<WorkMergeModel> items) {
    final value = qrFormReportId?.trim()?.toLowerCase();
    if (value == null || value.isEmpty) {
      return items;
    }

    return items.where((element) {
      if (element.formReportId?.trim()?.toLowerCase() == value) return true;
      if (element.id?.trim()?.toLowerCase() == value) return true;
      if (element.reportMergeModels != null) {
         if (element.reportMergeModels.any((child) => child.id?.trim()?.toLowerCase() == value)) return true;
      }
      return false;
    }).toList();
  }

  Future getDetailWork(WorkMergeModel workMergeModel) async {
    final res = await service.getDetailMergeWork(workMergeModel.id,
        isBackgroundMode: false);
    if (res.isLoadSuccess) {
      workMergeModel.reportMergeModels = res.data;
      listReportByTransformerModel.refresh();
    } else {
      workMergeModel.reportMergeModels = [];
      listReportByTransformerModel.refresh();
      await rShowDialogOneButton(res?.message ?? '');
    }
  }

  void checkSubstation(ReportByTransformerModel trans) {
    trans.isSelected = !(trans.isSelected ?? false);
    trans.mergeModels.forEach((element) {
      element.isSelected = trans.isSelected;
    });

    listReportByTransformerModel.refresh();
  }

  void checkEquipment(
      ReportByTransformerModel trans, WorkMergeModel workMergeModel) {
    workMergeModel.isSelected = !workMergeModel.isSelected;
    final isAllItemSelected =
        trans.mergeModels.every((element) => element.isSelected == true);
    trans.isSelected = isAllItemSelected;

    listReportByTransformerModel.refresh();
  }

  Future recall(String id) async {
    await rShowMyDialogOkCancel('Bạn có chắc muốn thu hồi biên bản?',
        secondFunction: () async {
      final res = await service.recallReport(id);
      if (res.isLoadSuccess) {
        SnackBarHUD.show('Thu hồi biên bản thành công');
        await getWorkMerge();
      } else {
        await rShowDialogOneButton(res?.message ?? '');
      }
    });
  }

  Future cancelReport(String id) async {
    await showDialogCancelReport((note) async {
      final res = await service.cancelReport(id, note);
      if (res.isLoadSuccess) {
        SnackBarHUD.show('Hủy biên bản thành công');
        await getWorkMerge();
      } else {
        await rShowDialogOneButton(res?.message ?? '');
      }
    });
  }

  Future getUnits() async {
    Future getUnitsOnline() async {
      final response = await serviceReport.getUnits();
      if (response.isLoadSuccess) {
        unitOptions =
            response.data.map((e) => StringOptionModel(e.name, e.id)).toList();
        unit = response?.data?.first?.id ?? '';
      } else {
        await rShowDialogOneButton(response.message);
      }
    }

    Future getUnitsOffline() async {
      unitOptions.clear();
      final response =
          await RLocalDataManager.instance.getUnitWorkOffline() ?? List.empty();
      response.forEach((element) {
        unitOptions.add(StringOptionModel(element.name, element.id));
      });
    }

    final isOnline = await RConnection.shared.checkConnection();
    if (isOnline) {
      await getUnitsOnline();
    } else {
      await getUnitsOffline();
    }
  }

  Future exportCertificate(
      String id, int type, WorkMergeModel workMergeModel) async {
    final res = await serviceCertificate.exportCertificate(id: id, type: type);
    if (res.isLoadSuccess) {
      await getDetailWork(workMergeModel);
      SnackBarHUD.show(res.message);
    } else {
      await rShowDialogOneButton(res?.message);
    }
  }

  Future _approvalTeam(String note, WorkMergeModel work,
      [String presidentCenterUserId, String presidentCompanyUserId]) async {
    final response = await service.approvalTeam(
        id: work.id,
        presidentCenterUserId: presidentCenterUserId,
        presidentCompanyUserId: presidentCompanyUserId,
        content: content);
    if (response.isLoadSuccess) {
      await getWorkMerge();
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future _approvalCenter() async {
    final response =
        await service.approvalCenter(ids: _getIds(), content: content);
    if (response.isLoadSuccess) {
      SnackBarHUD.show('Phê duyệt thành công');
      await getWorkMerge();
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future _sendToTeam(WorkMergeModel work, {String approvalId}) async {
    final response = await service.sendToTeam(
        id: work.id, approveId: approvalId, content: content);
    if (response.isLoadSuccess) {
      await getWorkMerge();
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future _approvalCompany() async {
    final response =
        await service.approvalCompany(ids: _getIds(), content: content);
    if (response.isLoadSuccess) {
      await getWorkMerge();
      SnackBarHUD.show('Phê duyệt thành công');
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future _rejectReport() async {
    final res = await service.reject(ids: _getIds(), content: content);
    if (res.isLoadSuccess) {
      SnackBarHUD.show('Từ chối thành công');
      await getWorkMerge();
    } else {
      await rShowDialogOneButton(res?.message ?? '');
    }
  }

  List<String> _getIds() {
    final ids = <String>[];
    listReportByTransformerModel.forEach((element) => ids.addAll(element
        .mergeModels
        .where(
            (e) => e.isSelected == true && e.isAllowApprovedOrRejected == true)
        .toList()
        .map((e) => e.id)));
    return ids;
  }

  Future showApproval({WorkMergeModel work}) async {
    if (work.reportMergeModels == null || work.reportMergeModels.isEmpty) {
      await getDetailWork(work);
    }

    final status = work.reportMergeModels.first.workingStatus.toString();
    if (!RUserRole.isOperator &&
        [
          ReportStatusType.Implementing.toString(),
          ReportStatusType.Rejected.toString(),
          ReportStatusType.WaitingForTeamApproval.toString()
        ].contains(status)) {
      final result = await Get.to(PDFMergeReportScreen(
        workMergeModel: work,
        statusReport: status,
      ));

      if (result == true) {
        await getWorkMerge();
      }
      return;
    }

    if (RUserRole.isOperator &&
        [
          ReportStatusType.Implementing.toString(),
          ReportStatusType.Rejected.toString()
        ].contains(status)) {
      await showDialogSendOperation(
          positiveAction: (approvalId, content) async {
            this.content = content;
            await _sendToTeam(work, approvalId: approvalId);
          },
          negativeAction: () {},
          options: usersRoleOperationApproval);
      return;
    }

    if (status == ReportStatusType.WaitingForTeamApproval.toString() &&
        !RUserRole.isOperator) {
      await showDialogApprovalTeam(
          title: 'Phê duyệt',
          actionText: 'Xác nhận',
          positiveAction: (note, centerId, companyId) async {
            await _approvalTeam(note, work, centerId, companyId);
          },
          negativeAction: () {
            content = '';
          },
          presidentCenters: presidentCenters,
          presidentCompanies: presidentCompanies);
    } else {
      await showDialogApproval(
          title: 'Phê duyệt',
          onChangeContent: (value) {
            content = value;
          },
          actionText: 'Xác nhận',
          positiveAction: () async {
            switch (status) {
              case '${ReportStatusType.Implementing}':
              case '${ReportStatusType.Rejected}':
                await _sendToTeam(work);
                break;
              case '${ReportStatusType.WaitingForTeamApproval}':
                await _approvalTeam(content, work);
                break;
              case '${ReportStatusType.WaitingForCenterApproval}':
                await _approvalCenter();
                break;
              case '${ReportStatusType.WaitingForCompanyApproval}':
                await _approvalCompany();
                break;
            }
          },
          negativeAction: () {
            content = '';
          });
    }
  }

  void showReject({WorkMergeModel work}) {
    showDialogApproval(
        title: 'Từ chối',
        isRequireNote: true,
        onChangeContent: (value) {
          content = value;
        },
        negativeAction: () {
          content = '';
        },
        actionText: 'Từ chối',
        positiveAction: () {
          _rejectReport();
        });
  }

  Future getDataEquipmentReport() async {
    final isOnline = await RConnection.shared.checkConnection();
    if (isOnline) {
      final response = await serviceReport.getDataUnscheduled();
      if (response.isLoadSuccess) {
        equipmentTypes.clear();
        detailEquipmentList.clear();
        equipmentTypes.add(StringOptionModel(RAppStrings.all, '0'));
        response.data.equipmentTypes.forEach((element) {
          equipmentTypes.add(StringOptionModel(element.name, element.id));
          equipmentTypeList.add(EquipmentTypes(
            id: element.id,
            name: element.name,
            equipmentDetails: element.equipmentDetails,
          ));
        });
      }
    } else {
      equipmentTypes.clear();
      final response = await RLocalDataManager.instance.getUnscheduledReportOffline();
      equipmentTypes.clear();
      detailEquipmentList.clear();
      equipmentTypes.add(StringOptionModel(RAppStrings.all, '0'));

      response?.equipmentTypes?.forEach((element) {
        equipmentTypes.add(StringOptionModel(element.name, element.id));
        equipmentTypeList.add(EquipmentTypes(
          id: element.id,
          name: element.name,
          equipmentDetails: element.equipmentDetails,
        ));
      });
    }
  }

  void renderEquipmentDetail(String idEquipmentType) {
    detailEquipmentList.clear();

    if (idEquipmentType != '0') {
      final equipmentType = equipmentTypeList.firstWhere(
              (element) => idEquipmentType == element.id,
          orElse: () => null);
      for (final element in equipmentType?.equipmentDetails ?? List.empty()) {
        detailEquipmentList.add(StringOptionModel(element.name, element.id));
      }
    }
    detailEquipmentType = detailEquipmentList.firstOrNull?.value;
    detailEquipmentList.refresh();
  }


}
