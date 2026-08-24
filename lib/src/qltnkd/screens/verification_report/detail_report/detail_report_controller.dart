// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/models/profile_model.dart';
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/utils/connection.dart';
import 'package:evnmobile/src/qltnkd/dialog/popup.dart';
import 'package:evnmobile/src/qltnkd/models/list_report_model.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:evnmobile/src/qltnkd/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/report_repository.dart';
import 'package:get/get.dart';

class DetailReportController extends GetxController {
  final service = ReportRepository();
  Rx<ListReportModel> listReportModel = ListReportModel().obs;
  List<StringOptionModel> usersRoleOperationApproval = RxList.empty();

  Function actionApproval;
  Function actionReject;
  String inputFirst;
  String approvalPerson;
  String textBtn = '';
  String content = '';

  bool isHasApproval = false;
  bool isHasReject = false;
  UserProfileModel currentUser = AppShared.instance.getUserProfile();

  Future getReportDetail(String reportId) async {
    Future getDetailOnline() async {
      final response = await service.getReportInfoDetail(reportId);

      if (response.isLoadSuccess) {
        listReportModel.value = response.data;
        if (listReportModel?.value?.isMonitor == true &&
            listReportModel.value.reportType == WorkType.accreditation &&
            RUserRole.isOperator){
          //nothing
        } else if(listReportModel.value.isMonitor == true &&
            listReportModel.value.reportType == WorkType.experiment &&
            RUserRole.isWorker) {
          //nothing
        } else if (listReportModel?.value?.isMonitor == true &&
            listReportModel?.value?.workingStatus ==
                ReportStatusType.WaitingForTeamApproval &&
            listReportModel?.value?.isAllowApprove == false) {

        } else {
          renderTextBtn();
        }
      } else {
        await rShowDialogOneButton(response.message);
      }
    }

    Future getDetailOffline({String reportId}) async {
      final response = await RLocalDataManager.instance
          .getReportDetailOffline(reportId: reportId);
      if (response != null) {
        listReportModel.value = response;
      }
    }

    final isOnline = await RConnection.shared.checkConnection();

    if (isOnline) {
      await getDetailOnline();
    } else {
      await getDetailOffline(reportId: reportId);
    }
  }

  Future sendApproval({bool isApproval}) async {
    if (isApproval == true) {
      final signResponse = await service.signatureReport(formReportId: listReportModel.value.id);
      if (!signResponse.isLoadSuccess) {
        await rShowDialogOneButton(signResponse.message);
        return;
      }
    }
    final response = await service.sendApproval(
        formReportId: [listReportModel.value.id],
        content: content,
        status: listReportModel.value.workingStatus.toString(),
        isApproval: isApproval);
    if (response.isLoadSuccess) {
      await getReportDetail(listReportModel.value.id);
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future sendApprovalOperation(String approveId, String content) async {
    final signResponse = await service.signatureReport(formReportId: listReportModel.value.id);
    if (!signResponse.isLoadSuccess) {
      await rShowDialogOneButton(signResponse.message);
      return;
    }
    final response = await service.sendOperation(
        formReportId: listReportModel.value.id,
        content: content,
        approveId: approveId);
    if (response.isLoadSuccess) {
      await rShowDialogOneButton('Gửi phê duyệt thành công', action: () {
        Get.back(result: true);
      });
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future approvalOperationTeam({bool isApproval}) async {
    if (isApproval == true) {
      final signResponse = await service.signatureReport(formReportId: listReportModel.value.id);
      if (!signResponse.isLoadSuccess) {
        await rShowDialogOneButton(signResponse.message);
        return;
      }
    }
    final response = await service.approvalOperationTeam(
        formReportId: listReportModel.value.id,
        content: content,
        isApproval: isApproval);
    if (response.isLoadSuccess) {
      await rShowDialogOneButton(
          isApproval ? 'Phê duyệt thành công' : 'Từ chối thành công',
          action: () {
        Get.back(result: true);
      });
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future approvalOperationLeader({bool isApproval}) async {
    if (isApproval == true) {
      final signResponse = await service.signatureReport(formReportId: listReportModel.value.id);
      if (!signResponse.isLoadSuccess) {
        await rShowDialogOneButton(signResponse.message);
        return;
      }
    }
    final response = await service.approvalLeader(
        formReportIds: [listReportModel.value.id],
        content: content,
        isApproval: isApproval);
    if (response.isLoadSuccess) {
      await rShowDialogOneButton(
          isApproval ? 'Phê duyệt thành công' : 'Từ chối thành công',
          action: () {
            Get.back(result: true);
          });
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  void showApproval({String title, String actionText}) {
    if ([ReportStatusType.Implementing, ReportStatusType.Rejected]
            .contains(listReportModel.value.workingStatus) &&
        RUserRole.isOperator) {
      actionApproval = () {
        showDialogSendOperation(
            positiveAction: (approvalId, content){
              sendApprovalOperation(approvalId, content);
            },
            negativeAction: (){

            },
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
    switch (listReportModel.value.workingStatus.toString()) {
      case '${ReportStatusType.Implementing}':
        textBtn = 'Gửi phê duyệt';
        showApproval(
          title: textBtn,
          actionText: 'Gửi',
        );

        isHasApproval = RUserRole.isOperator
            ? currentUser.id == listReportModel.value.userImpId
            : AppShared.instance.getUserProfile().isHasCreateFormReport();
        isHasReject = false;

        break;

      case '${ReportStatusType.Rejected}':
        textBtn = 'Gửi phê duỵệt';

        showApproval(
          title: textBtn,
          actionText: 'Gửi',
        );

        isHasApproval = RUserRole.isOperator
            ? currentUser.id == listReportModel.value.userImpId
            : AppShared.instance.getUserProfile().isHasCreateFormReport();
        isHasReject = false;

        break;

      case '${ReportStatusType.WaitingForTeamApproval}':
        textBtn = 'Phê duyệt';
        showApproval(
          title: 'Phê duyệt cấp tổ đội',
          actionText: 'Phê duyệt',
        );

        showReject();

        isHasApproval = RUserRole.isCaptain || RUserRole.isOperator && listReportModel.value.isApprover;
        isHasReject = RUserRole.isCaptain || RUserRole.isOperator  && listReportModel.value.isApprover;
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

  Future getRoleOperationApprove() async {
    if(!RUserRole.isOperator){
      return;
    }
    final response = await service.getRoleOperationApprove();
    if (response.isLoadSuccess) {
      response.data.forEach((element) {
        usersRoleOperationApproval.add(StringOptionModel(element.name, element.id));
      });
    }
  }
}

