// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/work_status.dart';
import 'package:evnmobile/src/htdct/services/responsitory/test_plan_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../common/utils/alert_dialog_utils.dart';
import '../../../../common/utils/progress_h_u_d.dart';
import '../../../../models/day_night/ticket.dart';
import '../../../../models/option_model.dart';
import '../../../../models/work_model.dart';
import '../../../../services/responsitory/line_repository.dart';
import '../../../../services/responsitory/non_pmis_repository.dart';

abstract class HistoryCheckDelegate {
  void onRefreshSuccess();

  void onLoadMoreSuccess();
}

class TestPlanController extends GetxController {
  TestType testType;
  TicketType ticketType;
  String ticketIdNotify;
  String workIdNotify;

  final _nonPmisRep = NonPmisRepository();
  final refreshController = RefreshController(initialRefresh: false);
  RxBool isSearching = false.obs;
  final timeController = TextEditingController().obs;
  bool isFirstLoad = true;
  bool isDisableSelectTeam = true;
  DateTime fromDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime toDateTime =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  final _workRep = TestPlanRepository();
  final _lineRep = LineRepository();

  RxList<OptionModelString> listTBAorLine = RxList.empty();
  List<OptionModelString> listStatus = [
    OptionModelString('Chưa thực hiện', HWorkStatus.notImplement.toString()),
    OptionModelString('Đang thực hiện', HWorkStatus.implementing.toString()),
    OptionModelString('Hoàn Thành', HWorkStatus.completed.toString()),
  ];

  RxList<OptionModelString> groupID = RxList.empty();
  List<OptionModelString> userTeamID = List.empty();
  RxList<OptionModelString> worksStatus = RxList.empty();
  RxList<OptionModelString> subStationIDorLineID = RxList.empty();

  RxList<OptionModelString> scheduleTypeOptionValue = RxList.empty();
  RxList<OptionModelString> scheduleTypeOption = RxList.empty();
  RxList<OptionModelString> createdUerOptionValue = RxList.empty();
  RxList<OptionModelString> createdUerOption = RxList.empty();

  final searchTerm = ''.obs;
  RxString fromDate = ''.obs;
  RxString toDate = ''.obs;

  final more = false.obs;
  final page = 1.obs;
  final isHasLoadMore = false.obs;
  HistoryCheckDelegate delegate;

  final workList = RxList.empty();

  String workType = '0';

  Future<void> initData() async {
    worksStatus = [listStatus[0], listStatus[1]].obs;
    await getType();
    await getWorkCurrentUserList();
    await getScheduleAndUser();
  }

  Future getType() async {
    // testType = Get.find(tag: 'testType');
    // ticketType = Get.find(tag: 'ticketType');
    workType = ticketType.workTypeCode(testType);
  }

  Future getWorkList() async {
    if (isSearching.value) page.value = 1;

    var createdUserIds = '';
    for (var i = 0; i < createdUerOptionValue.length; i++) {
      createdUserIds +=
          '${createdUerOptionValue.value[i].value}${i != createdUerOptionValue.value.length - 1 ? ',' : ''}';
    }
    // createdUerOptionValue.map((element) => createdUserIds+='${element.value};');

    var scheduleType = '';
    for (var i = 0; i < scheduleTypeOptionValue.length; i++) {
      scheduleType +=
          '${scheduleTypeOptionValue.value[i].value}${i != scheduleTypeOptionValue.value.length - 1 ? ',' : ''}';
    }

    final res = await _workRep.getWorkList(
      testType: testType,
      searchTerm: searchTerm.value?.trim(),
      pageIndex: page.value,
      workType: workType,
      id: parseId(subStationIDorLineID),
      isBackground: false,
      workStatus: parseId(worksStatus),
      fromDate: fromDate.value,
      toDate: toDate.value,
      userTeamID: parseId(userTeamID),
      groupID: parseId(groupID),
      isPMIS: false,
      createdUserIds: createdUserIds,
      scheduleTypeId: scheduleType,
      inspectId: ticketIdNotify,
      workId: workIdNotify
    );

    isFirstLoad = false;

    if (res.isLoadSuccess) {
      workList.assignAll(res.data.list);
    } else {
      await hShowDialogOneButton(res.message);
    }
    isHasLoadMore.value = res?.data?.paging?.isHasLoadMore();
    update();
  }

  Future<String> createTicket(String idWork, {@required Position location}) async {
    ProgressHUD.show();
    final res = await _workRep.createTicket(workId: idWork, workType: workType, location: location);
    ProgressHUD.dismiss();
    if (res.isLoadSuccess) {
      return res.data.toString();
    } else {
      await hShowDialogOneButton(res.message);
    }
    return '';
  }

  Future<String> createTicketUnknow(String idWork) async {
    ProgressHUD.show();
    final res = await _workRep.createTicketUnknow(workId: idWork);
    ProgressHUD.dismiss();
    if (res.isLoadSuccess) {
      return res.data.toString();
    } else {
      await hShowDialogOneButton(res.message);
    }
    return '';
  }

  Future refreshList() async {
    page.value = 1;
    final res = await _workRep.getWorkList(
      testType: testType,
      searchTerm: searchTerm.value?.trim(),
      pageIndex: page.value,
      id: parseId(subStationIDorLineID),
      workStatus: parseId(worksStatus),
      workType: workType,
      fromDate: fromDate.value,
      toDate: toDate.value,
      userTeamID: parseId(userTeamID),
      groupID: parseId(groupID),
      isPMIS: false,
      inspectId: ticketIdNotify,
        workId: workIdNotify
    );

    if (res.isLoadSuccess) {
      workList.assignAll(res.data.list ?? RxList.empty());
      workList.refresh();
    } else {
      await hShowDialogOneButton(res.message);
    }
    delegate.onRefreshSuccess();
    isHasLoadMore.value = res?.data?.paging?.isHasLoadMore();
    update();
  }

  Future<void> loadMore() async {
    page.value = page.value + 1;
    final response = await _workRep.getWorkList(
      testType: testType,
      searchTerm: searchTerm.value?.trim(),
      pageIndex: page.value,
      workType: workType,
      workStatus: parseId(worksStatus),
      fromDate: fromDate.value,
      toDate: toDate.value,
      userTeamID: parseId(userTeamID),
      groupID: parseId(groupID),
      isPMIS: false,
      inspectId: ticketIdNotify,
        workId: workIdNotify
    );
    delegate.onLoadMoreSuccess();
    if (response.isLoadSuccess) {
      workList.addAll(response?.data?.list?.obs ?? RxList.empty());
      workList.refresh();
    } else {
      await hShowDialogOneButton(response.message);
    }
    isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
    update();
  }

  Future<String> createNightLineTicket(
      String workId, String inspectionType, {@required Position location}) async {
    ProgressHUD.show();
    final res = await _lineRep.createLineTicket(
        workId: workId,
        inspectionType: inspectionType,
        listEquipment: [],
        listNodes: [], location: location);
    ProgressHUD.dismiss();
    if (res.isLoadSuccess) {
      return res.data.toString();
    } else {
      await hShowDialogOneButton(res.message);
    }
    return null;
  }

  String parseId(List<OptionModelString> listId) {
    var result = '';
    if (listId != null) {
      result = listId.map((e) => e.value).join(',');
    }
    return result;
  }

  Future getWorkCurrentUserList() async {
    final res = await _workRep.getWorkCurrentUserList(
      testType: testType,
      isBackground: true,
      workType: ticketType.testTypeCode(),
    );

    isFirstLoad = false;

    if (res.isLoadSuccess) {

      listTBAorLine
          .assignAll(res.data.list.map((e) => OptionModelString(e.name, e.id)));
      listTBAorLine.refresh();
    } else {
      await hShowDialogOneButton(res.message);
    }
    update();
  }

  bool hasFilter() {
    return toDateTime != null ||
        fromDateTime != null ||
        worksStatus.isNotEmpty ||
        userTeamID.isNotEmpty ||
        groupID.isNotEmpty ||
        subStationIDorLineID.isNotEmpty;
  }

  Future getScheduleAndUser() async {
    final res = await _nonPmisRep.getScheduleType();
    if (res.isLoadSuccess) {
      scheduleTypeOption.value = res.data.list;
      scheduleTypeOptionValue.value = scheduleTypeOption;
      scheduleTypeOption.refresh();
    } else {
      await hShowDialogOneButton(res.message);
    }
    final res1 = await _nonPmisRep.getScheduleType();
    if (res1.isLoadSuccess) {
      createdUerOption.value = res1.data.list;
      // scheduleTypeOption.refresh();
    } else {
      await hShowDialogOneButton(res1.message);
    }
  }

  List<Users> getMaxPosition(List<Users> users) {
    var max = -1;
    users.forEach((element) {
      if (max < element.userPosition) {
        max = element.userPosition;
      }
    });
    return users.where((e) => e.userPosition==max).toList();
  }
}

