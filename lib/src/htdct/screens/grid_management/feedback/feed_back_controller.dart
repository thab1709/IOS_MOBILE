// @dart=2.9
import 'package:evnmobile/src/htdct/models/feed_back.dart';
import 'package:evnmobile/src/htdct/models/work_model.dart';
import 'package:evnmobile/src/htdct/services/responsitory/feed_back_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../common/enum/list.dart';
import '../../../common/utils/alert_dialog_utils.dart';
import '../base/list_delegate.dart';

class FeedBackController extends GetxController {
  RxList<FeedBack> works = RxList.empty();
  final paging = Paging(totalPages: null, pageSize: null, pageIndex: null, totalCount: null).obs;

  final isHasLoadMore = false.obs;

  String fromDate = '';
  String toDate = '';
  var workId = '';

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


  final service = FeedbackRepository();

  Future loadData(ListTypeLoad type) async {

      if (type == ListTypeLoad.loadMore) {
        page.value = page.value + 1;
      } else if (type == ListTypeLoad.load) {
        isShowLoading.value = true;
        page.value = 1;
      } else if (type == ListTypeLoad.refresh) {
        page.value = 1;
      }

      final response = await service.getListWork(
          workId: workId,
          fromDate: fromDate,
          toDate: toDate,
          pageIndex: page.value,
          isNotShowLoading: type == ListTypeLoad.load,
          isFilter: isFilter.value,
          searchTerm: searchTerm.value
      );

      isFirstLoad = true;

      if (type == ListTypeLoad.loadMore) {
        delegate.onLoadMoreSuccess();
      } else if (type == ListTypeLoad.refresh) {
        works.clear();
        delegate.onRefreshSuccess();
      } else if (type == ListTypeLoad.load) {
        works.clear();
      }

      if (response.isLoadSuccess) {
        isShowLoading.value = false;
        works.addAll(response.data.list);
        paging.value = response.data.paging;
        works.refresh();
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

}

