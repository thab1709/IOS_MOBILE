// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/delegate/list_delegate.dart';
import 'package:evnmobile/src/qltnkd/enum/list.dart';
import 'package:get/get.dart';

import '../../../../../models/workload/request_model.dart';
import '../../../../../services/responsitory/workload_repository.dart';

class SearchRequestController extends GetxController {
  final isHasLoadMore = false.obs;
  int requestStatus;
  final searchTerm = ''.obs;

  final isShowLoading = false.obs;

  final requests = RxList<RequestModel>.empty();

  final repo = WorkloadRepository();

  bool isFirstLoad = false;

  final page = 1.obs;
  ListDelegate delegate;

  Future loadData(ListTypeLoad type) async {
    if (type == ListTypeLoad.loadMore) {
      page.value = page.value + 1;
    } else if (type == ListTypeLoad.load) {
      isShowLoading.value = true;
      page.value = 1;
    } else if (type == ListTypeLoad.refresh) {
      page.value = 1;
    }

    final response = await repo.getListRequest(
        pageIndex: page.value, searchTerm: searchTerm.value);

    isFirstLoad = true;

    if (type == ListTypeLoad.loadMore) {
      delegate.onLoadMoreSuccess();
    } else if (type == ListTypeLoad.refresh) {
      requests.clear();
      delegate.onRefreshSuccess();
    } else if (type == ListTypeLoad.load) {
      requests.clear();
    }

    if (response.isLoadSuccess) {
      isShowLoading.value = false;
      requests.addAll(response.data.list);
      requests.refresh();
      update();
    } else {
      isShowLoading.value = false;
      await rShowDialogOneButton(response.message);
    }

    isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
  }
}

