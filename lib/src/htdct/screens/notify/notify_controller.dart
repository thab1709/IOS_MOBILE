// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../common/enum/list.dart';
import '../../common/utils/alert_dialog_utils.dart';
import '../../models/notify/notify_model.dart';
import '../../services/responsitory/notify_respository.dart';
import '../grid_management/base/list_delegate.dart';

class NotifyController extends GetxController {
  RxList<NotifyModel> notifications = RxList.empty();
  final paging = Paging(totalPages: null, pageSize: null, pageIndex: null, totalCount: null).obs;

  final isHasLoadMore = false.obs;

  String fromDate = '';
  String toDate = '';
  String workId = '';

  final isShowLoading = false.obs;

  bool isFirstLoad = false;

  final page = 1.obs;
  ListDelegate delegate;

  // //for filter
  RxBool isFilter = false.obs;
  final searchTerm = ''.obs;

  final timeController = TextEditingController().obs;
  final searchController = TextEditingController();
  DateTime fromDateTime =
  DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime toDateTime =
  DateTime(DateTime.now().year, DateTime.now().month + 1, 0);


  final service = NotifyRepository();

  Future loadData(ListTypeLoad type, {int typeNotify = NotifyModel.type_sent}) async {

      if (type == ListTypeLoad.loadMore) {
        page.value = page.value + 1;
      } else if (type == ListTypeLoad.load) {
        isShowLoading.value = true;
        page.value = 1;
      } else if (type == ListTypeLoad.refresh) {
        page.value = 1;
      }

      final response = await service.getNotify(
          type:typeNotify,
          fromDate: fromDate,
          toDate: toDate,
          pageIndex: page.value,
          searchTerm: searchTerm.value,
      );

      isFirstLoad = true;

      if (type == ListTypeLoad.loadMore) {
        delegate.onLoadMoreSuccess();
      } else if (type == ListTypeLoad.refresh) {
        notifications.clear();
        delegate.onRefreshSuccess();
      } else if (type == ListTypeLoad.load) {
        notifications.clear();
      }

      if (response.isLoadSuccess) {
        isShowLoading.value = false;
        notifications.addAll(response.data.list);
        paging.value = response.data.paging;
        notifications.refresh();
        update();
      } else {
        isShowLoading.value = false;
        await hShowDialogOneButton(response.message);
      }

      isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
  }

  bool hasFilter() {
    return toDateTime != null ||
        fromDateTime != null;
  }

  Future seenNotify(String id) async {
    final response = await service.seenNotify(
      notifyId: id,
      isBackground: true,
    );
    if (response.isLoadSuccess) {
    } else {
      await hShowDialogOneButton(response.message);
      return;
    }
  }

}

