// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/utils/connection.dart';
import 'package:evnmobile/src/qltnkd/delegate/list_delegate.dart';
import 'package:evnmobile/src/qltnkd/dialog/popup.dart';
import 'package:evnmobile/src/qltnkd/enum/list.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../app_common/shared/app_shared.dart';
import '../../../../models/report_meter_model.dart';
import '../../../../services/responsitory/bb_cong_to_repository.dart';
import '../list_report_meter_controller.dart';

class TabReportMeterController extends GetxController {
  RxList<ReportMeterModel> workMerges = RxList.empty();
  final service = BBCongToRepository();
  final listReportController = Get.put(ListReportMeterController());
  int page = 1;

  final isHasLoadMore = false.obs;
  final isShowLoading = false.obs;
  final searchTerm = ''.obs;
  bool isFirstLoad = false;
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

  Future expandItem(ReportMeterModel workMergeModel) async {
    if (workMergeModel.reportMergeModels == null && !workMergeModel.isExpand) {
      await getDetailWork(workMergeModel);
    } else {
      workMergeModel.isExpand = !workMergeModel.isExpand;
      workMerges.refresh();
      update();
    }
  }

  Future _approvalTeam(String note,
      [String presidentCenterUserId]) async {
    final response = await service.approvalTeam(
        id: _getIds().first,
        presidentCenterUserId: presidentCenterUserId,
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

          if (statusReport == ReportStatusType.WaitingForTeamApproval.toString()) {
            await showDialogApprovalTeam(
              title: 'Phê duyệt',
              actionText: 'Phê duyệt',
              isReportNormal: false,
              positiveAction: (note, centerId, companyId) async {
                await _approvalTeam(note, centerId);
              },
              negativeAction: () {
                content = '';
              },
              presidentCenters: listReportController.presidentCenters,);
          } else {
            await showDialogApproval(
                title: 'Gửi phê duyệt',
                onChangeContent: (value) {
                  content = value;
                },
                actionText: 'Gửi',
                positiveAction: () async {
                  await _sendToTeam();
                },
                negativeAction: () {
                  content = '';
                });
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
                await _approvalTeam(note, centerId);
              },
              isReportNormal: false,
              negativeAction: () {
                content = '';
              },
              presidentCenters: listReportController.presidentCenters);
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

  Future _rejectReport() async {
    final res = await service.reject(ids: _getIds(), content: content);
    if (res.isLoadSuccess) {
      await getWorkMerge(ListTypeLoad.refresh);
    } else {
      await rShowDialogOneButton(res?.message ?? '');
    }
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
        isHasReject = RUserRole.isCaptain || RUserRole.isOperator;
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

  Future getDetailWork(ReportMeterModel reportMeterModel) async {
    final res = await service.getDetailMergeWork(reportMeterModel.id);
    if (res.isLoadSuccess) {
      reportMeterModel.reportMergeModels = res.data;
      reportMeterModel.isExpand = true;
      workMerges.refresh();
      update();
    } else {
      await rShowDialogOneButton(res?.message ?? '');
    }
  }

  Future getWorkMerge(ListTypeLoad type) async {
    Future getReportsOnline() async {
      if (type == ListTypeLoad.loadMore) {
        page = page + 1;
      } else if (type == ListTypeLoad.load) {
        isShowLoading.value = true;
        page = 1;
      } else if (type == ListTypeLoad.refresh) {
        page = 1;
      }

      final trimmedTerm = searchTerm.value?.trim() ?? '';
      final isGuid = RegExp(
              r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')
          .hasMatch(trimmedTerm);
      final response = await service.getReports(
          id: isGuid ? trimmedTerm : null,
          workingStatus: statusReport,
          fromDate: listReportController.fromDate,
          toDate: listReportController.toDate,
          searchTerm: isGuid ? null : (trimmedTerm.isNotEmpty ? trimmedTerm : null),
          pageIndex: page,
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


    final isOnline = await RConnection.shared.checkConnection();

    if (isOnline) {
      await getReportsOnline();
    } else {
      SnackBarHUD.show('Vui lòng kiểm tra mạng');
    }
  }

  Future cancelReport(String id) async {
    await rShowMyDialogOkCancel('Bạn có chắc muốn xóa biên bản?',
        secondFunction: () async {
      final res = await service.deleteMeter(id);
      if (res.isLoadSuccess) {
        SnackBarHUD.show('Xóa biên bản thành công');
        await getWorkMerge(ListTypeLoad.refresh);
      } else {
        await rShowDialogOneButton(res?.message ?? '');
      }
    });
  }

  Future search(ListTypeLoad type) async {
    Future getReportsOnline() async {
      if (type == ListTypeLoad.loadMore) {
        page = page + 1;
      } else if (type == ListTypeLoad.load) {
        isShowLoading.value = true;
        page = 1;
      } else if (type == ListTypeLoad.refresh) {
        page = 1;
      }

      final trimmedTerm = searchTerm.value?.trim() ?? '';
      final isGuid = RegExp(
              r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')
          .hasMatch(trimmedTerm);
      final response = await service.getReports(
          id: isGuid ? trimmedTerm : null,
          searchTerm: isGuid ? null : (trimmedTerm.isNotEmpty ? trimmedTerm : null),
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


    final isOnline = await RConnection.shared.checkConnection();

    if (isOnline) {
      await getReportsOnline();
    } else {
      await rShowDialogOneButton('Vui lòng kiểm tra mạng');
    }
  }


}

