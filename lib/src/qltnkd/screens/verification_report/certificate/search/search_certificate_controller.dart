// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/utils/connection.dart';
import 'package:evnmobile/src/qltnkd/delegate/list_delegate.dart';
import 'package:evnmobile/src/qltnkd/enum/list.dart';
import 'package:evnmobile/src/qltnkd/models/certificate_model.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/certificate_repository.dart';
import 'package:get/get.dart';

class SearchCertificateController extends GetxController {
  final service = CertificateRepository();
  final searchTerm = ''.obs;
  final isHasLoadMore = false.obs;
  final page = 1.obs;
  ListDelegate delegate;
  RxList<CertificateModel> certificates = RxList.empty();
  bool isFirstLoad = false;

  Future getCertificate(ListTypeLoad type) async {
    Future searchOnline() async {
      if (type == ListTypeLoad.loadMore) {
        page.value = page.value + 1;
      } else {
        page.value = 1;
      }

      final response =
          await service.getListCertificate(searchTerm: searchTerm.value);
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
        certificates.addAll(response.data?.listCertificate ?? RxList.empty());
        certificates.refresh();
        update();
      } else {
        await rShowDialogOneButton(response.message);
      }

      isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
    }

    // Future searchOffline({String searchTerm}) async {
    //   certificates.clear();
    //   final response = await RLocalDataManager.instance
    //           .getReportsOffline(searchTerm: searchTerm) ??
    //       List.empty();
    //   if (response != null) {
    //     isFirstLoad = true;
    //     if (type == ListTypeLoad.loadMore) {
    //       delegate.onLoadMoreSuccess();
    //     } else if (type == ListTypeLoad.refresh) {
    //       delegate.onRefreshSuccess();
    //     } else if (type == ListTypeLoad.load) {}
    //
    //     certificates.assignAll(response);
    //     certificates.refresh();
    //   }
    // }

    final isOnline = await RConnection.shared.checkConnection();

    if (isOnline) {
      await searchOnline();
    } else {
      //await searchOffline(searchTerm: searchTerm.value.toString());
    }
  }

  Future signatureCertificate(String id) async {
    final response = await service.signatureCertificate(certificateId: id);
    if (response.isLoadSuccess) {
      await getCertificate(ListTypeLoad.load);
    } else {
      await rShowDialogOneButton(response.message);
    }
  }
}

