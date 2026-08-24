// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/utils/connection.dart';
import 'package:evnmobile/src/qltnkd/delegate/list_delegate.dart';
import 'package:evnmobile/src/qltnkd/delegate/view_list_pdf_delegate.dart';
import 'package:evnmobile/src/qltnkd/dialog/popup.dart';
import 'package:evnmobile/src/qltnkd/enum/list.dart';
import 'package:evnmobile/src/qltnkd/models/certificate_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/certificate/pdf/pdf_view.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/certificate_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../list_certificate_controller.dart';


class TabReportController extends GetxController {
  RxList<CertificateModel> certificates = RxList.empty();
  final service = CertificateRepository();

  int page = 1;
  String statusCertificate = '0';
  final isHasLoadMore = false.obs;
  final isShowLoading = false.obs;
  bool isFirstLoad = false;
  String textBtn = '';
  bool isHasApproval = false;
  bool isHasReject = false;
  final ListCertificateController listCertificateController = Get.find();
  String content;
  ListDelegate delegate;
  Function actionApproval;
  Function actionReject;
  String inputFirst;
  String approvalPerson;
  ViewListPDFDelegate viewListPDFDelegate;

  Future sendApproval({bool isApproval}) async {
    final response = await service.sendApproval(
        formReportId: getReportIds(),
        content: content,
        status: statusCertificate,
        isApproval: isApproval);
    if (response.isLoadSuccess) {
      if (response.data.isNotEmpty) {
        if(statusCertificate == ReportStatusType.WaitingForCompanyApproval.toString()) {
          SnackBarHUD.show(RAppStrings.approvalAndDigitalSignSuccess);
        } else {
          await viewListPDFDelegate.showListPDF(response.data);
        }
      }
      await getCertificate(ListTypeLoad.load);
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  bool isHasItemSelected() {
    return certificates.firstWhere((element) => element.isSelected,
            orElse: () => null) !=
        null;
  }

  List<String> getReportIds() {
    return certificates
        .where((e) => e.isSelected)
        .toList()
        .map((e) => e.id)
        .toList();
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
                sendApproval(isApproval: true);
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
            actionText: 'Từ chối',
            isRequireNote: true,
            positiveAction: () {
              sendApproval(isApproval: false);
            });
      } else {
        rShowDialogOneButton('Bạn chưa chọn biên bản');
      }
    };
  }

  void renderTextBtn() {
    switch (statusCertificate) {
      case '${ReportStatusType.Implementing}':
        textBtn = 'Gửi phê duyệt';

        showApproval(
          title: textBtn,
          actionText: 'Gửi',
        );

        isHasApproval = AppShared.instance.getUserProfile().isHasCreateCertificate();
        isHasReject = false;

        break;

      case '${ReportStatusType.Rejected}':
        textBtn = 'Gửi phê duỵệt';
        showApproval(
          title: textBtn,
          actionText: 'Gửi',
        );

        isHasApproval = AppShared.instance.getUserProfile().isHasCreateCertificate();
        isHasReject = false;
        break;

      case '${ReportStatusType.WaitingForTeamApproval}':
        textBtn = 'Phê duyệt';
        showApproval(
          title: 'Phê duyệt cấp tổ đội',
          actionText: 'Phê duyệt',
        );

        showReject();

        isHasApproval = RUserRole.isCaptain;
        isHasReject = RUserRole.isCaptain;
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
          actionText: 'Duyệt và Ký',
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

  void selectItem(String reportId, {@required bool isSelected}) {
    certificates
        .firstWhere((element) => element.id == reportId, orElse: () => null)
        ?.isSelected = isSelected;

    certificates.refresh();
  }

  Future getCertificate(ListTypeLoad type) async {
    Future getReportsOnline() async {
      if (type == ListTypeLoad.loadMore) {
        page = page + 1;
      } else if (type == ListTypeLoad.load) {
        isShowLoading.value = true;
        page = 1;
      } else if (type == ListTypeLoad.refresh) {
        page = 1;
      }

      final response = await service.getListCertificate(
          status: statusCertificate,
          certificateType: listCertificateController.certificateType,
          teamId: listCertificateController.teamId,
          departmentId: listCertificateController.departmentId,
          userImp: listCertificateController.userId,
          fromDate: listCertificateController.fromDate,
          toDate: listCertificateController.toDate,
          content: '',
          location: listCertificateController.location,
          workType: '',
          unitId: listCertificateController.unit,
          pageIndex: page,
          isNotShowLoading: type == ListTypeLoad.load);
      isFirstLoad = true;

      if (type == ListTypeLoad.loadMore) {
        delegate.onLoadMoreSuccess();
      } else if (type == ListTypeLoad.refresh) {
        certificates.clear();
        delegate.onRefreshSuccess();
      } else if (type == ListTypeLoad.load) {
        certificates.clear();
      }

      if (response.isLoadSuccess) {
        isShowLoading.value = false;
        certificates.addAll(response.data.listCertificate ?? List.empty());
        certificates.refresh();
        update();
      } else {
        isShowLoading.value = false;
        await rShowDialogOneButton(response.message);
      }

      isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
    }

    // Future getReportsOffline(
    //     {int statusReports,
    //     String fromDate,
    //     String toDate,
    //     String reportType,
    //     String departmentId,
    //     String userId,
    //     String teamId,
    //     String locationReport,
    //     String contentReport}) async {
    //   certificates.clear();
    //   final response = await RLocalDataManager.instance.getReportsOffline(
    //           reportStatus: statusReports,
    //           fromDate: fromDate,
    //           toDate: toDate,
    //           reportType: reportType,
    //           departmentId: departmentId,
    //           userId: userId,
    //           teamId: teamId,
    //           locationReport: locationReport,
    //           contentReport: contentReport) ??
    //       List.empty();
    //   isFirstLoad = true;
    //   if (type == ListTypeLoad.loadMore) {
    //     delegate.onLoadMoreSuccess();
    //   } else if (type == ListTypeLoad.refresh) {
    //     delegate.onRefreshSuccess();
    //   } else if (type == ListTypeLoad.load) {}
    //
    //   certificates.assignAll(response);
    //   certificates.refresh();
    // }

    final isOnline = await RConnection.shared.checkConnection();

    if (isOnline) {
      await getReportsOnline();
    } else {
    //   await getReportsOffline(
    //       statusReports: int.parse(statusReport),
    //       fromDate: listReportController.fromDate,
    //       toDate: listReportController.toDate,
    //       reportType: listReportController.workType == '0'?'': listReportController.workType,
    //       departmentId: listReportController.departmentId =='0'?'': listReportController.departmentId,
    //       userId: listReportController.userId =='0'?'':listReportController.userId,
    //       teamId: listReportController.teamId=='0'?'':listReportController.teamId,
    //       locationReport: listReportController.locationReport == '0'?'':listReportController.locationReport,
    //       contentReport: listReportController.content);
    }
  }

  Future signatureCertificate(String id, String code) async {
    final response = await service.signatureCertificate(certificateId: id);
    if (response.isLoadSuccess) {
      await Get.to(() => RPdfCertificateScreen(id: id, code: code));
      await getCertificate(ListTypeLoad.load);
    } else {
      await rShowDialogOneButton(response.message);
    }
  }
}

