// @dart=2.9
import 'package:evnmobile/src/htdct/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/utils/connection.dart';
import 'package:evnmobile/src/qltnkd/delegate/list_delegate.dart';
import 'package:evnmobile/src/qltnkd/dialog/popup.dart';
import 'package:evnmobile/src/qltnkd/enum/list.dart';
import 'package:evnmobile/src/qltnkd/models/work_merge_model.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/certificate_repository.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/merge_form_report_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../report_director_company_controller.dart';

class ReportDirectorCompanyTabController extends GetxController {
  RxList<WorkMergeModel> workMerges = RxList.empty();
  final service = MergerFormReportRepository();
  final serviceCertificate = CertificateRepository();

  final reportDirectorCompanyController = Get.put(ReportDirectorCompanyController());

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
  String approvalPerson;
  int loadType;

  String getLoadType() {
    if(loadType == StatusReportForDirectorCompany.implement) {
      return 'processing';
    } else if(loadType == StatusReportForDirectorCompany.needSign) {
      return 'to-sign';
    } else {
      return 'complete';
    }
  }

  bool isHasItemSelected() {
    return workMerges.firstWhere((element) => element.isSelected == true, orElse: () => null) !=
        null;
  }

  List<String> _getIds() {
    return workMerges?.where((element) => element.isSelected)?.toList()?.map((e) => e.id)?.toList();
  }

  Future _approvalCompany() async {
    final response = await service.approvalCompany(
        ids: _getIds(),
        content: content);
    if (response.isLoadSuccess) {
      await getWorkMerge(ListTypeLoad.refresh);
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future _rejectReport() async {
    final res = await service.reject(ids: _getIds(), content: content);
    if(res.isLoadSuccess) {
      await getWorkMerge(ListTypeLoad.refresh);
    } else {
      await rShowDialogOneButton(res?.message ?? '');
    }
  }

  void showApproval({String title, String actionText}) {
    actionApproval = () {
      if (isHasItemSelected()) {
        showDialogApproval(
            title: title,
            onChangeContent: (value) {
              content = value;
            },
            actionText: actionText,
            positiveAction: () {
              _approvalCompany();
            },
            negativeAction: () {
              content = '';
            });
      } else {
        rShowDialogOneButton('Bạn chưa chọn biên bản');
      }
    };
  }

  void showReject() {
    actionReject = () {
      if (isHasItemSelected()) {
        showDialogApproval(
            title: 'Từ chối',
            onChangeContent: (value) {
              content = value;
            },
            negativeAction: () {
              content = '';
            },
            isRequireNote: true,
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
    textBtn = 'Phê duyệt';
    isHasApproval = true;
    isHasReject = true;
    showApproval(
      title: 'Phê duyệt cấp công ty',
      actionText: 'Phê duyệt',
    );

    showReject();
  }

  void selectItem(String workId, {@required bool isChecked}) {
    workMerges.firstWhere((element) => element.id == workId, orElse: () => null).isSelected = isChecked;
    workMerges.refresh();
  }

  void selectAllReportInWork(WorkMergeModel workMergeModel, {bool isChecked}) {
    workMergeModel.isSelected = isChecked;
    workMergeModel?.reportMergeModels?.forEach((element) {
      if(element.workingStatus == ReportStatusType.WaitingForCompanyApproval) element.isSelected = isChecked;
    });
    workMerges.refresh();
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

  Future getDetailWork(WorkMergeModel workMergeModel) async {
    final res = await service.getDetailMergeWork(workMergeModel.id);
    if(res.isLoadSuccess) {
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
      
      final trimmedTerm = searchTerm.value?.trim() ?? '';
      final isGuid = RegExp(
              r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')
          .hasMatch(trimmedTerm);

      final response = await service.getReportForLeader(
          endPoint: getLoadType(),
          id: isGuid ? trimmedTerm : null,
          searchTerm: isGuid ? null : (trimmedTerm.isNotEmpty ? trimmedTerm : null),
          fromDate: reportDirectorCompanyController.fromDate,
          toDate: reportDirectorCompanyController.toDate,
          pageIndex: requestedPage,
          orderBy: reportDirectorCompanyController.isNewToOld ? 'descend' : 'ascend',
          unitId: reportDirectorCompanyController.unitId,
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

    try {
      final isOnline = await RConnection.shared.checkConnection();

      if (isOnline) {
        await getReportsOnline();
      } else {
        await rShowDialogOneButton('Không có kết mạng');
      }
    } finally {
      isShowLoading.value = false;
      _isLoadingReports = false;
    }
  }

  Future recall(String id) async {
    final res = await service.recallReport(id);
    if (res.isLoadSuccess) {
      SnackBarHUD.show('Thu hồi biên bản thành công');
      await getWorkMerge(ListTypeLoad.refresh);
    } else {
      await rShowDialogOneButton(res?.message ?? '');
    }
  }
}

