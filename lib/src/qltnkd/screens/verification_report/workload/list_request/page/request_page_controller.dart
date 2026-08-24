// @dart=2.9
import 'package:evnmobile/src/qltnkd/models/workload/request_model.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/workload_repository.dart';
import 'package:get/get.dart';

import '../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../delegate/list_delegate.dart';
import '../../../../../enum/list.dart';
import '../list_request_controller.dart';

class RequestPageController extends GetxController {
  final isHasLoadMore = false.obs;
  int requestStatus;

  final ListRequestController listWorkloadController = Get.find();

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
        status: requestStatus,
        unitId: listWorkloadController.unit,
        fromDate: listWorkloadController.fromDate,
        toDate: listWorkloadController.toDate,
        requestType: listWorkloadController.ticketRequestType.toString(),
        pageIndex: page.value,
        isBackgroundMode: type == ListTypeLoad.load);

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

