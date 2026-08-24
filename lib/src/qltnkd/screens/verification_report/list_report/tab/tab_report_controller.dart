// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/utils/connection.dart';
import 'package:evnmobile/src/qltnkd/delegate/list_delegate.dart';
import 'package:evnmobile/src/qltnkd/dialog/popup.dart';
import 'package:evnmobile/src/qltnkd/enum/list.dart';
import 'package:evnmobile/src/qltnkd/models/work_merge_model.dart';
import 'package:evnmobile/src/qltnkd/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/pdf_merge_report/pdf_merge_report_screen.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/certificate_repository.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/merge_form_report_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../app_common/shared/app_shared.dart';
import '../list_report_controller.dart';

class TabReportController extends GetxController {
  RxList<WorkMergeModel> workMerges = RxList.empty();
  final service = MergerFormReportRepository();
  final serviceCertificate = CertificateRepository();
  final listReportController = Get.put(ListReportController());
  int page = 1;

  final isHasLoadMore = false.obs;
  final isShowLoading = false.obs;
  final searchTerm = ''.obs;
  bool isFirstLoad = false;
  bool _isLoadingReports = false;
  String textBtn = '';
  bool isHasApproval = false;
  bool isHasReject = false;
  String content;
  ListDelegate delegate;
  Function actionApproval;
  Function actionReject;
  String inputFirst;
  String statusReport;
  String approvalPerson;

  bool isHasItemSelected() {
    return workMerges.firstWhere((element) => element.isSelected == true,
            orElse: () => null) !=
        null;
  }

  List<String> _getIds() {
    return workMerges
        ?.where((element) => element.isSelected)
        ?.toList()
        ?.map((e) => e.id)
        ?.toList();
  }

  WorkMergeModel _getWorkSelected() {
    return workMerges?.firstWhere((element) => element.isSelected);
  }

  Future expandItem(WorkMergeModel workMergeModel) async {
    if (workMergeModel.reportMergeModels == null && !workMergeModel.isExpand) {
      await getDetailWork(workMergeModel);
    } else {
      workMergeModel.isExpand = !workMergeModel.isExpand;
      workMerges.refresh();
      update();
    }
  }

  Future _approvalTeam(String note,
      [String presidentCenterUserId, String presidentCompanyUserId]) async {
    final response = await service.approvalTeam(
        id: _getIds().first,
        presidentCenterUserId: presidentCenterUserId,
        presidentCompanyUserId: presidentCompanyUserId,
        content: content);
    if (response.isLoadSuccess) {
      await getWorkMerge(ListTypeLoad.refresh);
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future _approvalCenter() async {
    final response =
        await service.approvalCenter(ids: _getIds(), content: content);
    if (response.isLoadSuccess) {
      await getWorkMerge(ListTypeLoad.refresh);
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future _sendToTeam({String approvalId}) async {
    final response = await service.sendToTeam(
        id: _getIds().first, approveId: approvalId, content: content);
    if (response.isLoadSuccess) {
      await getWorkMerge(ListTypeLoad.refresh);
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future _approvalCompany() async {
    final response =
        await service.approvalCompany(ids: _getIds(), content: content);
    if (response.isLoadSuccess) {
      await getWorkMerge(ListTypeLoad.refresh);
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future _rejectReport() async {
    final res = await service.reject(ids: _getIds(), content: content);
    if (res.isLoadSuccess) {
      await getWorkMerge(ListTypeLoad.refresh);
    } else {
      await rShowDialogOneButton(res?.message ?? '');
    }
  }

  void selectItem(String workId, {@required bool isChecked}) {
    if (isChecked) {
      if ([
        '${ReportStatusType.Implementing}',
        '${ReportStatusType.Rejected}',
        '${ReportStatusType.WaitingForTeamApproval}'
      ].contains(statusReport)) {
        final model = workMerges.firstWhere(
            (element) => element.isSelected == true,
            orElse: () => null);
        if (model != null) {
          model.isSelected = false;
        }
      }
    }

    workMerges
        .firstWhere((element) => element.id == workId, orElse: () => null)
        .isSelected = isChecked;
    workMerges.refresh();
  }

  Future showApproval({String title, String actionText}) async {
    actionApproval = () async {
      if (isHasItemSelected()) {
        if (!RUserRole.isOperator &&
            [
              ReportStatusType.Implementing.toString(),
              ReportStatusType.Rejected.toString(),
              ReportStatusType.WaitingForTeamApproval.toString()
            ].contains(statusReport)) {
          final result = await Get.to(PDFMergeReportScreen(
            workMergeModel: _getWorkSelected(),
            statusReport: statusReport,
          ));

          if (result == true) {
            await getWorkMerge(ListTypeLoad.refresh);
          }
          return;
        }

        if (RUserRole.isOperator &&
            [
              ReportStatusType.Implementing.toString(),
              ReportStatusType.Rejected.toString()
            ].contains(statusReport)) {
          await showDialogSendOperation(
              positiveAction: (approvalId, content) async {
                this.content = content;
                await _sendToTeam(approvalId: approvalId);
              },
              negativeAction: () {},
              options: listReportController.usersRoleOperationApproval);
          return;
        }

        if (statusReport ==
                ReportStatusType.WaitingForTeamApproval.toString() &&
            !RUserRole.isOperator) {
          await showDialogApprovalTeam(
              title: title,
              actionText: actionText,
              positiveAction: (note, centerId, companyId) async {
                await _approvalTeam(note, centerId, companyId);
              },
              negativeAction: () {
                content = '';
              },
              presidentCenters: listReportController.presidentCenters,
              presidentCompanies: listReportController.presidentCompanies);
        } else {
          await showDialogApproval(
              title: title,
              onChangeContent: (value) {
                content = value;
              },
              actionText: actionText,
              positiveAction: () async {
                switch (statusReport) {
                  case '${ReportStatusType.Implementing}':
                    await _sendToTeam();
                    break;
                  case '${ReportStatusType.Rejected}':
                    await _sendToTeam();
                    break;
                  case '${ReportStatusType.WaitingForTeamApproval}':
                    await _approvalTeam(content);
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
      } else {
        await rShowDialogOneButton('Bạn chưa chọn biên bản');
      }
    };
  }

  void showReject() {
    actionReject = () {
      if (isHasItemSelected()) {
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
      } else {
        rShowDialogOneButton('Bạn chưa chọn biên bản');
      }
    };
  }

  void renderTextBtn() {
    switch (statusReport) {
      case '${ReportStatusType.Implementing}':
        textBtn = 'Gửi phê duyệt';

        showApproval(
          title: textBtn,
          actionText: 'Gửi',
        );

        isHasApproval =
            AppShared.instance.getUserProfile().isHasCreateFormReport();
        isHasReject = false;

        break;

      case '${ReportStatusType.Rejected}':
        textBtn = 'Gửi phê duỵệt';
        showApproval(
          title: textBtn,
          actionText: 'Gửi',
        );

        isHasApproval =
            AppShared.instance.getUserProfile().isHasCreateFormReport();
        isHasReject = false;
        break;

      case '${ReportStatusType.WaitingForTeamApproval}':
        textBtn = 'Gửi duyệt';
        showApproval(
          title: 'Phê duyệt cấp tổ đội',
          actionText: 'Phê duyệt',
        );

        showReject();

        isHasApproval = RUserRole.isCaptain || RUserRole.isOperator;
        isHasReject = RUserRole.isOperator;
        break;
      case '${ReportStatusType.WaitingForCenterApproval}':
        textBtn = 'Phê duyệt';
        showApproval(
          title: 'Phê duyệt cấp trung tâm',
          actionText: 'Phê duyệt',
        );

        showReject();

        isHasApproval = RUserRole.isPresidentCenter;
        isHasReject = RUserRole.isPresidentCenter;

        break;
      case '${ReportStatusType.WaitingForCompanyApproval}':
        textBtn = 'Phê duyệt';
        showApproval(
          title: 'Phê duyệt cấp công ty',
          actionText: 'Phê duyệt',
        );

        showReject();

        isHasApproval = RUserRole.isPresidentCompany || RUserRole.isLeader;
        isHasReject = RUserRole.isPresidentCompany || RUserRole.isLeader;
        break;

      case '${ReportStatusType.Completed}':
        textBtn = 'Hoàn thành';
        isHasApproval = false;
        isHasReject = false;
        break;

      case '${ReportStatusType.all}':
        textBtn = 'Tất cả';
        isHasApproval = false;
        isHasReject = false;
        break;
    }
  }

  Future getDetailWork(WorkMergeModel workMergeModel) async {
    final res = await service.getDetailMergeWork(workMergeModel.id);
    if (res.isLoadSuccess) {
      workMergeModel.reportMergeModels = res.data;
      workMergeModel.isExpand = true;
      workMerges.refresh();
      update();
    } else {
      await rShowDialogOneButton(res?.message ?? '');
    }
  }

  Future getWorkMerge(ListTypeLoad type) async {
    if (_isLoadingReports) {
      return;
    }
    if (type == ListTypeLoad.loadMore && !isHasLoadMore.value) {
      delegate?.onLoadMoreSuccess();
      return;
    }

    _isLoadingReports = true;
    Future getReportsOnline() async {
      final requestedPage =
          type == ListTypeLoad.loadMore ? page + 1 : 1;
      if (type == ListTypeLoad.load) {
        isShowLoading.value = true;
        isHasLoadMore.value = false;
      }

      final effectiveSearchTerm = searchTerm.value.isNotEmpty
          ? searchTerm.value
          : listReportController.searchTerm;
      final trimmedTerm = effectiveSearchTerm?.trim() ?? '';
      final isGuid = RegExp(
              r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')
          .hasMatch(trimmedTerm);
      final response = await service.getReports(
          id: isGuid ? trimmedTerm : null,
          workingStatus: statusReport ?? ReportStatusType.all.toString(),
          fromDate: listReportController.fromDate,
          toDate: listReportController.toDate,
          searchTerm:
              isGuid ? null : (trimmedTerm.isNotEmpty ? trimmedTerm : null),
          pageIndex: requestedPage,
          orderBy: listReportController.isNewToOld ? 'descend' : 'ascend',
          unitId: listReportController.unit,
          isNotShowLoading: type == ListTypeLoad.load);
      isFirstLoad = true;

      if (type == ListTypeLoad.loadMore) {
        delegate.onLoadMoreSuccess();
      } else if (type == ListTypeLoad.refresh) {
        workMerges.clear();
        delegate.onRefreshSuccess();
      } else if (type == ListTypeLoad.load) {
        workMerges.clear();
      }

      if (response.isLoadSuccess) {
        page = requestedPage;
        isShowLoading.value = false;
        workMerges.addAll(response.data.listReport ?? List.empty());
        workMerges.refresh();
        update();
      } else {
        isShowLoading.value = false;
        await rShowDialogOneButton(response.message);
      }

      isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
    }

    Future getOffline() async {
      if (type == ListTypeLoad.loadMore) {
        delegate.onLoadMoreSuccess();
        return;
      }

      if (type == ListTypeLoad.load) {
        isShowLoading.value = true;
      }

      workMerges.clear();
      final effectiveSearchTerm = searchTerm.value.isNotEmpty
          ? searchTerm.value
          : listReportController.searchTerm;
      final response = await RLocalDataManager.instance.getMergeReportsOffline(
        reportStatus: statusReport ?? ReportStatusType.all.toString(),
        fromDate: listReportController.fromDate,
        searchTerm: effectiveSearchTerm,
        toDate: listReportController.toDate,
        //orderBy: reportDirectorCompanyController.isNewToOld ? 'descend' : 'ascend',
        unitId: listReportController.unit,
      );
      isFirstLoad = true;
      isShowLoading.value = false;
      isHasLoadMore.value = false;

      if (response != null) {
        if (type == ListTypeLoad.refresh) {
          delegate.onRefreshSuccess();
        } else if (type == ListTypeLoad.load) {}

        workMerges.assignAll(response);

        workMerges.refresh();
      }
      update();
    }

    try {
      final isOnline = await RConnection.shared.checkConnection();
      final effectiveSearchTerm = searchTerm.value.isNotEmpty
          ? searchTerm.value
          : listReportController.searchTerm;
      final trimmedTerm = effectiveSearchTerm?.trim() ?? '';
      final isGuid = RegExp(
              r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')
          .hasMatch(trimmedTerm);

      if (isOnline) {
        await getReportsOnline();
      } else if (isGuid) {
        isFirstLoad = true;
        workMerges.clear();
        isHasLoadMore.value = false;
        update();
        await rShowDialogOneButton(
            'Vui lòng kết nối mạng để tra cứu biên bản từ mã QR');
      } else {
        await getOffline();
      }
    } finally {
      isShowLoading.value = false;
      _isLoadingReports = false;
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

  Future recall(String id) async {
    await rShowMyDialogOkCancel('Bạn có chắc muốn thu hồi biên bản?',
        secondFunction: () async {
      final res = await service.recallReport(id);
      if (res.isLoadSuccess) {
        SnackBarHUD.show('Thu hồi biên bản thành công');
        await getWorkMerge(ListTypeLoad.refresh);
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
        await getWorkMerge(ListTypeLoad.refresh);
      } else {
        await rShowDialogOneButton(res?.message ?? '');
      }
    });
  }
}
