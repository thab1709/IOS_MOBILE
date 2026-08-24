// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/dialog/popup.dart';
import 'package:evnmobile/src/qltnkd/models/merge_report_pdf_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/list_report_controller.dart';
import 'package:get/get.dart';

import '../../../../../app_common/shared/app_shared.dart';
import '../../../../models/report_meter_model.dart';
import '../../../../services/responsitory/bb_cong_to_repository.dart';

class PDFMeterSendReportController extends GetxController {
  final mergeReportPDFs = <MergeReportPDFModel>[].obs;
  final service = BBCongToRepository();
  final listReportController = Get.put(ListReportController());
  ReportMeterModel workMergeModel;
  String content;
  String statusReport;
  bool isHasApproval = false;
  bool isHasReject = false;
  String textBtn = '';
  Function actionApproval;
  Function actionReject;

  // Future<void> getMergeReportPDF(String workId, Function() setupTabController) async {
  //   final res = await service.getPdf(workId);
  //   if (res.isLoadSuccess) {
  //     mergeReportPDFs.assignAll(res.data);
  //     setupTabController();
  //     mergeReportPDFs.refresh();
  //   } else {
  //     await rShowDialogOneButton(res?.message ?? '');
  //   }
  // }

  Future _sendToTeam({String approvalId}) async {
    final response =
        await service.sendToTeam(id: workMergeModel.id, approveId: approvalId, content: content);
    if (response.isLoadSuccess) {
      Get.back(result: true);
      SnackBarHUD.show('Phê duyệt thành công');
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future _approvalTeam(String note,
      [String presidentCenterUserId]) async {
    final response = await service.approvalTeam(
        id: workMergeModel.id,
        presidentCenterUserId: presidentCenterUserId,
        content: content);
    if (response.isLoadSuccess) {
      Get.back(result: true);
      SnackBarHUD.show('Phê duyệt thành công');
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future showApproval() async {
    actionApproval = () async {
      if (statusReport == ReportStatusType.WaitingForTeamApproval.toString()) {
        await showDialogApprovalTeam(
            title: 'Phê duyệt',
            actionText: 'Phê duyệt',
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
    };
  }

  Future _rejectReport() async {
    final res = await service.reject(ids: [workMergeModel.id], content: content);
    if (res.isLoadSuccess) {
      SnackBarHUD.show('Từ chối thành công');
      Get.back(result: true);
    } else {
      await rShowDialogOneButton(res?.message ?? '');
    }
  }

  void showReject() {
    actionReject = () {
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
    };
  }

  void renderTextBtn() {
    switch (statusReport) {
      case '${ReportStatusType.Implementing}':
        textBtn = 'Gửi phê duyệt';

        showApproval();

        isHasApproval = AppShared.instance.getUserProfile().isHasCreateFormReport();
        isHasReject = false;

        break;

      case '${ReportStatusType.Rejected}':
        textBtn = 'Gửi phê duỵệt';
        showApproval();

        isHasApproval = AppShared.instance.getUserProfile().isHasCreateFormReport();
        isHasReject = false;
        break;

      case '${ReportStatusType.WaitingForTeamApproval}':
        textBtn = 'Gửi duyệt';
        showApproval();
        showReject();
        isHasApproval = RUserRole.isCaptain || RUserRole.isOperator;
        isHasReject = true;
        break;
    }
  }
}

