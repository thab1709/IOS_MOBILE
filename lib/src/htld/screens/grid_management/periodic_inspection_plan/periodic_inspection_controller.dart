// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/option_model.dart';
import 'package:evnmobile/src/htld/models/profile_model.dart';
import 'package:evnmobile/src/htld/models/work_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/history_check/controller/history_check_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/htld/services/responsitory/work_repository.dart';
import 'package:evnmobile/src/htld/shared_preferences/app_shared.dart';
import 'package:get/get.dart';
import 'package:tiengviet/tiengviet.dart';

import '../grid_management_controller.dart';

class PeriodicInspectionPlanController extends GetxController
    with StateMixin<List<WorkModel>> {
  RxList<WorkModel> works = RxList.empty();
  final service = WorkRepository();
  TicketScreenArgument ticketScreenArgument;
  final gridManagementController = Get.put(GridManagementController());
  List<UserOptionModel> units = MAppShared.shared.units
      .map((e) => UserOptionModel(e.name, e.id))
      .toList();
  RxList<UserOptionModel> groups = RxList.empty();
  final listGroups = MAppShared.shared.groups;

  RxString fromDate = ''.obs;
  RxString toDate = ''.obs;
  DateTime fromDateTime = DateTime.now();
  DateTime toDateTime = DateTime.now();
  final isAbnormal = false.obs;

  final more = false.obs;
  final page = 1.obs;
  final isHasLoadMore = false.obs;
  final searchTerm = ''.obs;
  final workType = ''.obs;
  final workStatus = 0.obs;
  final inspectType = ''.obs;
  int defaultWordType = 1;

  String unitId = '0';
  String groupId = '0';
  final isFilter = false.obs;

  UserProfileModel userProfile = AppShared.instance.getUserProfile();
  HistoryCheckDelegate delegate;

  @override
  void onInit() {
    super.onInit();
  }

  Future prepareData() async {
    if (userProfile?.unitId != null) {
      unitId = userProfile.unitId;

      groups.assignAll(listGroups
              .firstWhere((element) => element.unitId == unitId,
                  orElse: () => null)
              ?.groups
              ?.map((e) => UserOptionModel(e.name, e.id)) ??
          []);
    } else {
      if (listGroups != null && listGroups.isEmpty) {
        return;
      }
      groups.assignAll(
          listGroups?.first?.groups?.map((e) => UserOptionModel(e.name, e.id)));
    }
  }

  void setIsAbnormal() {
    isAbnormal.value = !isAbnormal.value;
  }

  void setUnitId(String id) {
    unitId = id;

    groups.assignAll(listGroups
        .firstWhere((element) => element.unitId == unitId)
        .groups
        .map((e) => UserOptionModel(e.name, e.id)));
    groupId = '0';
    groups.refresh();
  }

  Future searchOffline() async {
    final wType = workType.value;
    final wStatus = workStatus.value;
    final fDate = fromDate.value;
    final tDate = toDate.value;

    final term = TiengViet.parse(searchTerm.value.toLowerCase());
    final workDefault = await LocalDataManager.shared
        .getWorks(ticketScreenArgument.subStationType, wType);

    // Default (No search && No filter)
    if (term.isEmpty == true && wStatus == 0) {
      works.value = workDefault.where((workModel) {
        if (fDate.isEmpty || tDate.isEmpty) {
          return true;
        }
        return DateTime.parse(workModel.planDate)
                .isAfter(DateTime.parse(fDate)) &&
            DateTime.parse(workModel.planDate).isBefore(DateTime.parse(tDate));
      }).toList();
      works.refresh();
      return;
    }

    // Filter then Search
    works.value = workDefault.where((workModel) {
      // ignore: avoid_bool_literals_in_conditional_expressions
      final wstatus = wStatus == 0 ? true : workModel.workStatus == wStatus;
      var dateRule = false;
      if (fDate.isEmpty) {
        dateRule = true;
      } else {
        dateRule = DateTime.parse(workModel.planDate)
                .isAfter(DateTime.parse(fDate)) &&
            DateTime.parse(workModel.planDate).isBefore(DateTime.parse(tDate));
      }
      // ignore: prefer_typing_uninitialized_variables
      var valid;
      if (workModel.substationModel.name != null) {
        valid = (TiengViet.parse(workModel.substationModel?.name?.toLowerCase())
                    .contains(term) ||
                TiengViet.parse(workModel.description.toLowerCase())
                    .contains(term)) &&
            wstatus &&
            dateRule;
      } else {
        valid = (TiengViet.parse(workModel.line?.name?.toLowerCase())
                    .contains(term) ||
                TiengViet.parse(workModel.description.toLowerCase())
                    .contains(term)) &&
            wstatus &&
            dateRule;
      }
      return valid;
    }).toList();

    works.refresh();
  }

  void setTicketType() {
    var ticketType = TicketType.periodicDay;
    switch (int.parse(workType.value)) {
      case 1:
        ticketType = TicketType.periodicDay;
        break;
      case 3:
        ticketType = TicketType.periodicDay;
        break;
      case 5:
        ticketType = TicketType.periodicDay;
        break;
      default:
        ticketType = TicketType.periodicNight;
    }

    ticketScreenArgument.ticketType = ticketType;
    gridManagementController.setTicketType(
        ticketScreenArgument.subStationType, ticketScreenArgument.ticketType);
  }

  Future clearFilter() async {
    workType.value = defaultWordType.toString();
    fromDate.value = '';
    unitId = '0';
    workStatus.value = 0;
    fromDateTime = DateTime.now();
    toDateTime = DateTime.now();
    groupId = '0';
    isAbnormal.value = false;
    toDate.value = '';
    isFilter.value = false;
    setTicketType();
    Get.back();
    await getData();
  }

  Future getData() async {
    if (workType.value != defaultWordType.toString() ||
        workStatus?.value != 0 ||
        fromDate.value != '' ||
        unitId != '0' ||
        groupId != '0') {
      isFilter.value = true;
    }

    if (workType.value == defaultWordType.toString() &&
        workStatus?.value == 0 &&
        fromDate.value == '' &&
        unitId == '0' &&
        groupId == '0') {
      isFilter.value = false;
    }
    final connection = await Connection.shared.checkConnection();
    if (connection) {
      unitId = MAppShared?.shared?.units
          ?.firstWhere((element) => element.id == unitId, orElse: () => null)
          ?.id;
      final response = await service.getListWork(
          workType: workType.value,
          workStatus: '${workStatus?.value == 0 ? '' : workStatus.value}',
          subStationType: ticketScreenArgument.subStationType,
          fromDate: fromDate.value,
          toDate: toDate.value,
          isAbnormal: isAbnormal.value,
          searchTerm: searchTerm.value,
          unitId: unitId,
          pageSize: 16.toString(),
          groupId: groupId);
      if (response.isLoadSuccess) {
        works.assignAll(response?.data?.list?.obs);
        works.refresh();
      } else {
        await showDialogError(response.message);
      }

      isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
    } else {
      await searchOffline();
    }
  }

  Future refreshList() async {
    page.value = 1;
    final response = await service.getListWork(
        workType: workType.value,
        workStatus: '${workStatus?.value == 0 ? '' : workStatus.value}',
        subStationType: ticketScreenArgument.subStationType,
        fromDate: fromDate.value,
        toDate: toDate.value,
        isAbnormal: isAbnormal.value,
        pageSize: 10.toString(),
        searchTerm: searchTerm.value,
        pageIndex: page.value,
        unitId: unitId);
    delegate.onRefreshSuccess();

    if (response.isLoadSuccess) {
      works.assignAll(response.data.list.obs ?? RxList.empty());
      works.refresh();
    } else {
      await showDialogError(response.message);
    }
    isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
  }

  Future<void> loadMore() async {
    page.value = page.value + 1;
    final response = await service.getListWork(
        workType: workType.value,
        workStatus: '${workStatus?.value == 0 ? '' : workStatus.value}',
        subStationType: ticketScreenArgument.subStationType,
        fromDate: fromDate.value,
        toDate: toDate.value,
        isAbnormal: isAbnormal.value,
        pageSize: 10.toString(),
        searchTerm: searchTerm.value,
        pageIndex: page.value,
        unitId: unitId);
    delegate.onLoadMoreSuccess();
    if (response.isLoadSuccess) {
      works.addAll(response?.data?.list?.obs ?? RxList.empty());
      works.refresh();
    } else {
      await showDialogError(response.message);
    }
    isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
  }
}

