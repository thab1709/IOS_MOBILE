// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/utils/connection.dart';
import 'package:evnmobile/src/qltnkd/models/report_approval_history_model.dart';
import 'package:evnmobile/src/qltnkd/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/merge_form_report_repository.dart';
import 'package:get/get.dart';

class ReportApprovalHistoryController extends GetxController{
  final service = MergerFormReportRepository();
  RxList<ApprovalHistoryModel> approvalHistory =  RxList.empty();


  Future getApprovalHistory({String formReportId}) async {
    Future getApprovalHistoryOnline() async {

      final response = await service.getApprovalHistory(
        id: formReportId,
          backgroundMode: false
      );
      if (response.isLoadSuccess) {
        approvalHistory
            .addAll(response?.data?.listHistory ?? RxList.empty());
      } else {
        await rShowDialogOneButton(response.message);
      }
    }

    Future getApprovalHistoryOffline({String formReportId}) async {
      approvalHistory.clear();
      final response = await RLocalDataManager.instance
          .getHistoryApproveOffline(workId: formReportId);
      if (response != null) {
        approvalHistory.assignAll(response);
      }
    }

    final isOnline = await RConnection.shared.checkConnection();

    if (isOnline) {
      await getApprovalHistoryOnline();
    } else {
      await getApprovalHistoryOffline(formReportId: formReportId);
    }
  }
}
