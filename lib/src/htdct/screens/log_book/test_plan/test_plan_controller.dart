// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../qltnkd/common/utils/alert_dialog_utils.dart';
import '../../../common/constance/strings.dart';
import '../../../common/utils/alert_dialog_utils.dart';
import '../../../models/day_night/ticket.dart';
import '../../../models/option_model.dart';
import '../../../services/responsitory/log_book_repository.dart';
import '../common/option_type.dart';

abstract class HistoryCheckDelegate {
  void onRefreshSuccess();

  void onLoadMoreSuccess();
}

class TestPlanController extends GetxController {
  final userProfile = AppShared.instance.getUserProfile();
  TestType testType;
  TicketType ticketType;

  final refreshController = RefreshController(initialRefresh: false);
  RxBool isSearching = false.obs;

  var isFirstLoad = true;
  bool isDisableSelectTeam = true;

  final timeController = TextEditingController().obs;
  DateTime fromDateTime;
  DateTime toDateTime;

  final timeWorkController = TextEditingController().obs;
  DateTime fromDateTimeWork =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime toDateTimeWork =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  RxString fromWorkDate = ''.obs;
  RxString toWorkDate = ''.obs;

  RxList<OptionModelString> listGroup = RxList.empty();
  List<OptionModelString> listGroupSelected = List.empty();

  RxList<OptionModelString> listUser = RxList.empty();
  List<OptionModelString> listUserSelected = List.empty();

  RxList<OptionModelString> listTBA = RxList.empty();
  List<OptionModelString> listTBASelected = List.empty();

  RxList<OptionModelString> listLine = RxList.empty();
  List<OptionModelString> listLineSelected = List.empty();

  List<OptionModelString> listTypeEvents = List.empty();
  List<OptionModelString> listTypeEventsSelected = List.empty();

  final searchTerm = ''.obs;

  final more = false.obs;
  final page = 1.obs;
  final isHasLoadMore = false.obs;
  HistoryCheckDelegate delegate;

  final workList = RxList.empty();
  final workCurrentUserList = RxList.empty();

  String workType = '0';
  final _logBookRep = LogBookRepository();

  Future<void> initData() async {
    await getType();
    getDateTime();
    if (ticketType == TicketType.operationLog) {
      listTypeEvents = OptionsType.EventType.getStringOptions;
      listTypeEventsSelected = [
        listTypeEvents[0],
        listTypeEvents[1],
        listTypeEvents[2],
        listTypeEvents[3],
        listTypeEvents[4],
        listTypeEvents[5],
        listTypeEvents[6],
      ].obs;
    } else {
      listTypeEvents = OptionsType.TeamCheck.getStringOptions;
    }

    listUser.assignAll(AppShared.instance
        .getListUser()
        .map((e) => OptionModelString(e.name, e.id)));
    listUser.refresh();

    listTBA.assignAll(AppShared.instance
        .getListAllSubstationHTDCT()
        .map((e) => OptionModelString(e.name, e.id)));
    listTBA.refresh();

    listLine.assignAll(AppShared.instance
        .getListAllLineHTDCT()
        .map((e) => OptionModelString(e.name, e.id)));
    listLine.refresh();

    listGroup.assignAll(AppShared.instance
        .getGroupsHTDCT()
        .map((e) => OptionModelString(e.name, e.id)));
    listGroup.refresh();
  }

  Future getType() async {
    testType = Get.find(tag: 'testType');
    ticketType = Get.find(tag: 'ticketType');
    workType = ticketType.workTypeCode(testType);
  }

  void getDateTime() {
    final now = DateTime.now();
    if (ticketType == TicketType.operationLog) {
      fromDateTime = now;
      toDateTime = now;
    } else {
      fromDateTime = DateTime(now.year, now.month, 1);
      toDateTime = DateTime(now.year, now.month + 1, 0);
    }
  }

  Future getWorkList() async {
    if (isSearching.value) page.value = 1;
    final res = await _logBookRep.getOperationCheckList(
        searchTerm: searchTerm.value?.trim(),
        isBackground: false,
        fromDate: fromDateTime == null
            ? ''
            : fromDateTime.toStringFormat(HighElectricStrings.yyyyMMdd),
        toDate: toDateTime == null
            ? ''
            : toDateTime.toStringFormat(HighElectricStrings.yyyyMMdd),
        eventTypes: parseId(listTypeEventsSelected),
        lines: parseId(listLineSelected),
        substations: parseId(listTBASelected),
        userGroups: parseId(listGroupSelected),
        beginDate: '',
        endDate: '',
        createdUserId: parseId(listUserSelected),
        ticketType: ticketType);

    isFirstLoad = false;

    if (res.isLoadSuccess) {
      workList.assignAll(res.data.list);
    } else {
      await hShowDialogOneButton(res.message);
    }
    // isHasLoadMore.value = res?.data?.paging?.isHasLoadMore();
    update();
  }

  Future refreshList() async {
    page.value = 1;
    final res = await _logBookRep.getOperationCheckList(
        searchTerm: searchTerm.value?.trim(),
        isBackground: false,
        fromDate: fromDateTime == null
            ? ''
            : fromDateTime.toStringFormat(HighElectricStrings.yyyyMMdd),
        toDate: toDateTime == null
            ? ''
            : toDateTime.toStringFormat(HighElectricStrings.yyyyMMdd),
        eventTypes: parseId(listTypeEventsSelected),
        lines: parseId(listLineSelected),
        substations: parseId(listTBASelected),
        userGroups: parseId(listGroupSelected),
        beginDate: '',
        endDate: '',
        createdUserId: parseId(listUserSelected),
        ticketType: ticketType);

    if (res.isLoadSuccess) {
      workList.assignAll(res.data.list ?? RxList.empty());
      workList.refresh();
    } else {
      await hShowDialogOneButton(res.message);
    }
    delegate.onRefreshSuccess();
    // isHasLoadMore.value = res?.data?.paging?.isHasLoadMore();
    update();
  }

  Future<void> loadMore() async {
    page.value = page.value + 1;
    final response = await _logBookRep.getOperationCheckList(
        searchTerm: searchTerm.value?.trim(),
        isBackground: false,
        fromDate: fromDateTime == null
            ? ''
            : fromDateTime.toStringFormat(HighElectricStrings.yyyyMMdd),
        toDate: toDateTime == null
            ? ''
            : toDateTime.toStringFormat(HighElectricStrings.yyyyMMdd),
        eventTypes: parseId(listTypeEventsSelected),
        lines: parseId(listLineSelected),
        substations: parseId(listTBASelected),
        userGroups: parseId(listGroupSelected),
        beginDate: '',
        endDate: '',
        createdUserId: parseId(listUserSelected),
        ticketType: ticketType);

    delegate.onLoadMoreSuccess();
    if (response.isLoadSuccess) {
      workList.addAll(response?.data?.list?.obs ?? RxList.empty());
      workList.refresh();
    } else {
      await hShowDialogOneButton(response.message);
    }
    // isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
    update();
  }

  String parseId(List<OptionModelString> listId) {
    var result = '';
    if (listId != null) {
      result = listId.map((e) => e.value).join(',');
    }
    return result;
  }

  bool hasFilter() {
    return toDateTime != null ||
        fromDateTime != null ||
        toDateTimeWork != null ||
        fromDateTimeWork != null ||
        listUserSelected.isNotEmpty ||
        listGroupSelected.isNotEmpty ||
        listTBASelected.isNotEmpty ||
        listLineSelected.isNotEmpty;
  }

  Future<void> delete({String id}) async {
    if (ticketType == TicketType.operationLog) {
      final response = await _logBookRep.deleteCheckOperation(id: id);
      if (response.isLoadSuccess) {
        await getWorkList();
      } else {
        await rShowDialogOneButton(response.message);
      }
    } else {
      final response = await _logBookRep.deleteCheckNote(id: id);
      if (response.isLoadSuccess) {
        await getWorkList();
      } else {
        await rShowDialogOneButton(response.message);
      }
    }
  }

  String getNameEvent(String value) {
    return listTypeEvents.firstWhereOrNull((item) => item.value == value).title;
  }
}

