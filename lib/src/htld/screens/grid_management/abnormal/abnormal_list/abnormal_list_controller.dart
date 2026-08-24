// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htdct/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../common/constance/abnormal_constance.dart';
import '../../../../common/constance/inspection_category.dart';
import '../../../../models/abnormal/abnormal_info_model.dart';
import '../../../../models/day_night/ticket.dart';
import '../../../../models/option_model.dart';
import '../../../../services/responsitory/abnormal_repository.dart';

abstract class HistoryCheckDelegate {
  void onRefreshSuccess();

  void onLoadMoreSuccess();
}

class AbnormalListController extends GetxController {
  SubStationType subStationType;
  TicketType ticketType;
  String ticketId;
  final userProfile = AppShared.instance.getUserProfile();
  final isCheckAll = false.obs;

  final refreshController = RefreshController(initialRefresh: false);
  RxBool isSearching = false.obs;
  final timeController = TextEditingController().obs;
  bool isFirstLoad = true;
  DateTime fromDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime toDateTime =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  final _abnormalRep = TAbnormalRepository();

  Rx<Paging> paging = Paging().obs;

  RxList<OptionModelString> worksStatus = RxList.empty();
  RxList<OptionModelString> equipments = RxList.empty();
  List<OptionModelString> equipmentsSelected = [];

  final disDayOptions = InspectionCategory.getDisTechOrDay();
  final disNightOptions = InspectionCategory.getDistributionNight();
  final interDayOptions = InspectionCategory.getIntermediateDay();
  final interNightOptions = InspectionCategory.getIntermediateNight();
  final lineDayOptions = InspectionCategory.getDisTechOrDay();
  final lineNightOptions = InspectionCategory.getLineNight();

  int equipment = 0;

  List<OptionModel> getEquipmentType() {
    if (subStationType == SubStationType.distribution) {
      if (ticketType == TicketType.periodicNight) {
        return disNightOptions;
      } else {
        return disDayOptions;
      }
    } else if (subStationType == SubStationType.intermediate) {
      if (ticketType == TicketType.periodicNight) {
        return interNightOptions;
      } else {
        return interDayOptions;
      }
    } else if (subStationType == SubStationType.mediumVoltage) {
      if (ticketType == TicketType.periodicNight) {
        return lineNightOptions;
      } else {
        return lineDayOptions;
      }
    }
    return [];
  }

  Future getEquipments() async {
    equipments.clear();
    equipmentsSelected.clear();
    final res = await _abnormalRep.getEquipments(
        id: ticketId,
        entityType: subStationType.code.toString(),
        equipmentCategory: equipment.toString());
    if (res.isLoadSuccess) {
      equipments.assignAll(res.data);
    } else {
      await showDialogOneButton(res?.message);
    }
    equipments.refresh();
  }

  final searchTerm = ''.obs;
  RxString fromDate = ''.obs;
  RxString toDate = ''.obs;

  final more = false.obs;
  final page = 1.obs;
  final isHasLoadMore = false.obs;
  HistoryCheckDelegate delegate;

  final workList = RxList.empty();
  final workCurrentUserList = RxList.empty();

  String workType = '0';

  Future<void> initData() async {
    worksStatus =
        [AbnormalStatus.listStatus[0], AbnormalStatus.listStatus[1]].obs;
  }

  Future getWorkList() async {
    if (isSearching.value) page.value = 1;

    final response = await _abnormalRep.getAbnormalList(
      isBackground: false,
      searchTerm: searchTerm.value?.trim(),
      id: ticketId,
      inspectionCategory: equipment != 0 ? equipment.toString() : '',
      equipmentIds: equipmentsSelected.map((e) => e.value).join(','),
      entityType: subStationType.code.toString(),
      fromDate: fromDate.value,
      toDate: toDate.value,
      workStatus: parseId(worksStatus),
    );

    isFirstLoad = false;

    if (response.isLoadSuccess) {
      workList.assignAll(response.data.list);
      paging.value = response.data.paging;
    } else {
      await hShowDialogOneButton(response.message);
    }
    isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
    update();
  }

  Future refreshList() async {
    page.value = 1;

    final response = await _abnormalRep.getAbnormalList(
      isBackground: false,
      inspectionCategory: equipment != 0 ? equipment.toString() : '',
      equipmentIds: equipmentsSelected.map((e) => e.value).join(','),
      searchTerm: searchTerm.value?.trim(),
      id: ticketId,
      entityType: subStationType.code.toString(),
      fromDate: fromDate.value,
      toDate: toDate.value,
      workStatus: parseId(worksStatus),
    );

    if (response.isLoadSuccess) {
      workList.assignAll(response.data.list ?? RxList.empty());
      paging.value = response.data.paging;
      workList.refresh();
    } else {
      await hShowDialogOneButton(response.message);
    }
    delegate.onRefreshSuccess();
    isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
    update();
  }

  Future<void> loadMore() async {
    page.value = page.value + 1;
    final response = await _abnormalRep.getAbnormalList(
      isBackground: false,
      inspectionCategory: equipment != 0 ? equipment.toString() : '',
      equipmentIds: equipmentsSelected.map((e) => e.value).join(','),
      searchTerm: searchTerm.value?.trim(),
      id: ticketId,
      entityType: subStationType.code.toString(),
      fromDate: fromDate.value,
      toDate: toDate.value,
      workStatus: parseId(worksStatus),
      pageIndex: page.value,
    );

    delegate.onLoadMoreSuccess();
    if (response.isLoadSuccess) {
      workList.addAll(response?.data?.list?.obs ?? RxList.empty());
      paging.value = response.data.paging;
      workList.refresh();
    } else {
      await hShowDialogOneButton(response.message);
    }
    isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
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
    return toDateTime != null || fromDateTime != null || worksStatus.isNotEmpty;
  }
}

