// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../../../htld/common/utils/alert_dialog_utils.dart';
import '../../../../../../services/responsitory/line_repository.dart';
import '../../../../periodic_inspection_plan/periodic_inspection_plan_controller.dart';
import '../../../../transformer/transformer_ticket_controller.dart';

class ViolateInspectionListController extends GetxController {
  RxBool isSearching = false.obs;
  RxBool isFilter = false.obs;
  String violateName = '';
  int typeViolation;
  final lineRepository = LineRepository();
  final TransformerTicketController transformerTicketController = Get.find();
  final violateList = RxList.empty();

  //for search
  RxInt trackingStatus = 0.obs;
  final searchTerm = ''.obs;
  final timeController = TextEditingController().obs;
  DateTime fromDateTime = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime toDateTime = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  RxString fromDate = ''.obs;
  RxString toDate = ''.obs;

  //loadmore
  final refreshController = RefreshController(initialRefresh: false);
  var isFirstLoad = true;
  final more = false.obs;
  final page = 1.obs;
  final isHasLoadMore = false.obs;
  HistoryCheckDelegate delegate;

  Future getListViolate() async {
    if (isSearching.value) page.value = 1;
    final res = await lineRepository.getListViolateInspect(
        typeViolation: typeViolation,
        idTicket: transformerTicketController.ticketId,
        fromDate: fromDate.value,
        pageIndex: page.value,
        toDate: toDate.value,
        isFilter: isFilter.value,
        trackingStatus: trackingStatus.value.toString() ?? '',
        searchTerm: searchTerm.value?.trim());
    isFirstLoad = false;
    if (res.isLoadSuccess) {
      violateList.assignAll(res.data.list);
    } else {
      await showDialogOneButton(res.message);
    }
    isHasLoadMore.value = res?.data?.paging?.isHasLoadMore();
    update();
  }

  Future deleteViolate({String id}) async {
    final res = await lineRepository.deleteViolateInspection(id: id);

    if (res.isLoadSuccess) {
      await getListViolate();
    } else {
      await showDialogOneButton(res.message);
    }
    update();
  }

  Future refreshList() async {
    page.value = 1;
    final res = await lineRepository.getListViolateInspect(
        typeViolation: typeViolation,
        idTicket: transformerTicketController.ticketId,
        fromDate: fromDate.value,
        pageIndex: page.value,
        toDate: toDate.value,
        isFilter: isFilter.value,
        trackingStatus: trackingStatus.value.toString() ?? '',
        searchTerm: searchTerm.value?.trim());

    if (res.isLoadSuccess) {
      violateList.assignAll(res.data.list ?? RxList.empty());
      violateList.refresh();
    } else {
      await showDialogOneButton(res.message);
    }

    delegate.onRefreshSuccess();
    isHasLoadMore.value = res?.data?.paging?.isHasLoadMore();
    update();
  }
  Future<void> loadMore() async {
    page.value = page.value + 1;
    final res = await lineRepository.getListViolateInspect(
        typeViolation: typeViolation,
        idTicket: transformerTicketController.ticketId,
        fromDate: fromDate.value,
        pageIndex: page.value,
        toDate: toDate.value,
        isFilter: isFilter.value,
        trackingStatus: trackingStatus.value.toString() ?? '',
        searchTerm: searchTerm.value?.trim());

    delegate.onLoadMoreSuccess();
    if (res.isLoadSuccess) {
      violateList.assignAll(res.data.list ?? RxList.empty());
      violateList.refresh();
    } else {
      await showDialogOneButton(res.message);
    }
    isHasLoadMore.value = res?.data?.paging?.isHasLoadMore();
    update();
  }
  bool hasFilter() {
    return toDateTime != null ||
        fromDateTime != null ||
        trackingStatus.value !=null;

  }
}

