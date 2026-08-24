// @dart=2.9
import 'dart:async';

import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htdct/common/constance/work_status.dart';
import 'package:evnmobile/src/htdct/common/utils/common.dart';
import 'package:evnmobile/src/htdct/services/responsitory/test_plan_repository.dart';
import 'package:evnmobile/src/htdct/services/responsitory/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../htld/common/utils/global_app.dart';
import '../../../common/utils/alert_dialog_utils.dart';
import '../../../common/utils/progress_h_u_d.dart';
import '../../../models/day_night/ticket.dart';
import '../../../models/option_model.dart';
import '../../../services/responsitory/line_repository.dart';
import '../../../services/responsitory/tba_repository.dart';

abstract class HistoryCheckDelegate {
  void onRefreshSuccess();

  void onLoadMoreSuccess();
}

class TestPlanController extends GetxController {
  TestType testType;
  TicketType ticketType;
  String ticketIdNotify;
  String workIdNotify;
  final userProfile = AppShared.instance.getUserProfile();
  bool showAbnormalChecked = false;

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
  final _userRep = UserRepository();

  RxList<OptionModelString> listTBAorLine = RxList.empty();
  RxList<OptionModelString> listGroup = RxList.empty();
  RxList<OptionModelString> listTeam = RxList.empty();
  List<OptionModelString> listStatus = [
    OptionModelString('Chưa thực hiện', HWorkStatus.notImplement.toString()),
    OptionModelString('Đang thực hiện', HWorkStatus.implementing.toString()),
    OptionModelString('Hoàn Thành', HWorkStatus.completed.toString()),
  ];

  RxList<OptionModelString> groupID = RxList.empty();
  List<OptionModelString> userTeamID = List.empty();
  RxList<OptionModelString> worksStatus = RxList.empty();
  RxList<OptionModelString> subStationIDorLineID = RxList.empty();

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
    await getListOptionFilter();
    await getWorkCurrentUserList();
    if (ticketType == TicketType.tunnelCable && userProfile.position == 16) {
      await getTeamByIdGroup(userProfile.userGroupId);
    }
  }

  Future getType() async {
    testType = Get.find(tag: 'testType');
    ticketType = Get.find(tag: 'ticketType');
    ticketIdNotify = Get.find(tag: 'ticketIdNotify');
    workIdNotify = Get.find(tag: 'workIdNotify');
    workType = ticketType.workTypeCode(testType);
  }

  Future getWorkList({bool isPmis = true}) async {
    page.value = 1;
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
      isPMIS: isPmis,
      inspectId: ticketIdNotify,
      workId: workIdNotify,
      hasAbnormal: showAbnormalChecked,
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

  Future<String> createTicket(
    String idWork, {
    @required Position location,
  }) async {
    ProgressHUD.show();
    final res = await _workRep.createTicket(
      workId: idWork,
      workType: workType,
      location: location,
    );
    ProgressHUD.dismiss();
    if (res.isLoadSuccess) {

      if(App.humiValue != 0) {
        final _tbaRep = TBARepository();
        unawaited(_tbaRep.updateGeneralInfo(
            params: {
              'id': res.data.toString(),
              'temperature': roundDouble(App.tempValue, 1),
              'humidity': roundDouble(App.humiValue, 1),
            },
          isBackground: true
        ));
      }

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
      inspectId: ticketIdNotify,
      workId: workIdNotify,
      hasAbnormal: showAbnormalChecked,
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
      id: parseId(subStationIDorLineID),
      pageIndex: page.value,
      workType: workType,
      workStatus: parseId(worksStatus),
      fromDate: fromDate.value,
      toDate: toDate.value,
      userTeamID: parseId(userTeamID),
      groupID: parseId(groupID),
      inspectId: ticketIdNotify,
      workId: workIdNotify,
      hasAbnormal: showAbnormalChecked ?? false,
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

  Future getListOptionFilter() async {
    // if (testType == TestType.line) {
    //   listTBAorLine.assignAll(AppShared.instance
    //       .getListLineHTDCT()
    //       .map((e) => OptionModelString(e.name, e.id,)));
    // } else {
    //   listTBAorLine.assignAll(AppShared.instance
    //       .getListSubstationHTDCT()
    //       .map((e) => OptionModelString(e.name, e.id)));
    // }

    listGroup.assignAll(AppShared.instance
        .getGroupsHTDCT()
        .map((e) => OptionModelString(e.name, e.id)));
    // listTBAorLine.refresh();
    listGroup.refresh();
  }

  Future getTeamByIdGroup(String idGroup) async {
    listTeam = RxList.empty();
    userTeamID = <OptionModelString>[];
    isDisableSelectTeam = true;
    if (idGroup.isEmpty) {
      listTeam.refresh();
      return;
    }

    final responseTeam =
        await _userRep.getListTeam(idGroup: idGroup, isBackground: true);
    if (responseTeam.isLoadSuccess) {
      listTeam.value = responseTeam?.data?.list
              ?.map((e) => OptionModelString(e.name, e.id))
              ?.toList() ??
          [];
    } else {
      await hShowDialogOneButton(responseTeam.message);
    }
    if (listTeam.isNotEmpty) {
      isDisableSelectTeam = false;
    }
    listTeam.refresh();
  }

  Future<String> createNightLineTicket(
    String workId,
    String inspectionType, {
    @required Position location,
  }) async {
    ProgressHUD.show();
    final res = await _lineRep.createLineTicket(
      workId: workId,
      inspectionType: inspectionType,
      listEquipment: [],
      listNodes: [],
      location: location,
    );
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
      workType: ticketType.workTypeCode(testType),
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
}

