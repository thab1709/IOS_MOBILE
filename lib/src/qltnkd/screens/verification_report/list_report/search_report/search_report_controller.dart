// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/utils/connection.dart';
import 'package:evnmobile/src/qltnkd/delegate/list_delegate.dart';
import 'package:evnmobile/src/qltnkd/enum/list.dart';
import 'package:evnmobile/src/qltnkd/models/list_report_model.dart';
import 'package:evnmobile/src/qltnkd/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/certificate/list_certificate_screen.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/report_repository.dart';
import 'package:get/get.dart';

class SearchReportController extends GetxController {
  final service = ReportRepository();
  final searchTerm = ''.obs;
  final isHasLoadMore = false.obs;
  final page = 1.obs;
  ListDelegate delegate;
  RxList<ListReportModel> listReport = RxList.empty();
  bool isFirstLoad = false;

  Future getFormReport(ListTypeLoad type) async {
    Future searchOnline() async {
      if (type == ListTypeLoad.loadMore) {
        page.value = page.value + 1;
      } else {
        page.value = 1;
      }

      final response =
          await service.getFormReport(searchTerm: searchTerm.value);
      isFirstLoad = true;

      if (type == ListTypeLoad.loadMore) {
        delegate.onLoadMoreSuccess();
      } else if (type == ListTypeLoad.refresh) {
        listReport.clear();
        delegate.onRefreshSuccess();
      } else if (type == ListTypeLoad.load) {
        listReport.clear();
      }

      if (response.isLoadSuccess) {
        listReport.addAll(response.data?.listReport ?? RxList.empty());
        listReport.refresh();
        update();
      } else {
        await rShowDialogOneButton(response.message);
      }

      isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
    }

    Future searchOffline({String searchTerm}) async {
      listReport.clear();
      final response = await RLocalDataManager.instance
              .getReportsOffline(searchTerm: searchTerm) ??
          List.empty();
      if (response != null) {
        isFirstLoad = true;
        if (type == ListTypeLoad.loadMore) {
          delegate.onLoadMoreSuccess();
        } else if (type == ListTypeLoad.refresh) {
          delegate.onRefreshSuccess();
        } else if (type == ListTypeLoad.load) {}

        listReport.assignAll(response);
        listReport.refresh();
      }
    }

    final isOnline = await RConnection.shared.checkConnection();

    if (isOnline) {
      await searchOnline();
    } else {
      await searchOffline(searchTerm: searchTerm.value.toString());
    }
  }

  Future signatureReport(String id) async {
    final response = await service.signatureReport(formReportId: id);
    if (response.isLoadSuccess) {
      await getFormReport(ListTypeLoad.load);
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future createCertificate(String id, int type) async {
    final response = await service.createCertificate(id, type);
    if (response.isLoadSuccess) {
      await Get.to(() => ListCertificateScreen());
      await getFormReport(ListTypeLoad.load);
    } else {
      await rShowDialogOneButton(response.message);
    }
  }
}

