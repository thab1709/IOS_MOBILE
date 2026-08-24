// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/utils/connection.dart';
import 'package:evnmobile/src/qltnkd/models/report_work.dart';
import 'package:evnmobile/src/qltnkd/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/report_repository.dart';
import 'package:get/get.dart';

class DetailWorkController extends GetxController {
  final service = ReportRepository();
  Rx<ReportWorkItem> reportWorkItem = ReportWorkItem().obs;

  Future getReportDetail(String workId) async {
    Future getWorkDetailOnline() async {
      final response = await service.getWorkDetail(workId);
      if (response.isLoadSuccess) {
        reportWorkItem.value = response.data;
        update();
      } else {
        await rShowDialogOneButton(response?.message);
      }
    }

    Future getWorkDetailOffline({String workId}) async {
      final response =
          await RLocalDataManager.instance.getWorkDetailOffline(workId: workId);
      if (response != null) {
        reportWorkItem.value = response;
      }
    }

    final isOnline = await RConnection.shared.checkConnection();

    if (isOnline) {
      await getWorkDetailOnline();
    } else {
      await getWorkDetailOffline(workId: workId);
    }
  }
}

