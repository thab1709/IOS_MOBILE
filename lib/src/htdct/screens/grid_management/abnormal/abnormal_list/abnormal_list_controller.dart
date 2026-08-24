// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htdct/common/constance/work_status.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/services/responsitory/test_plan_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../common/utils/alert_dialog_utils.dart';
import '../../../../models/abnormal/abnormal_info_model.dart';
import '../../../../models/day_night/ticket.dart';
import '../../../../models/option_model.dart';
import '../../../../services/responsitory/abnormal_repository.dart';
import '../../../../services/responsitory/line_repository.dart';
import '../../transformer/transformer_ticket_controller.dart';

abstract class HistoryCheckDelegate {
  void onRefreshSuccess();

  void onLoadMoreSuccess();
}

class AbnormalListController extends GetxController {
  TestType testType;
  TicketType ticketType;
  String ticketIdNotify;
  String workIdNotify;
  final userProfile = AppShared.instance.getUserProfile();
  final TransformerTicketController transformerTicketController = Get.find();
  final isCheckAll = false.obs;

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
  final _abnormalRep = AbnormalRepository();
  final _lineRep = LineRepository();
  bool isViolate = false;


  RxList<OptionModelString> listNode = RxList.empty();
  RxList<OptionModelString> listCategory = RxList.empty();
  RxList<OptionModelString> listEquipment = RxList.empty();

  Rx<Paging> paging = Paging().obs;



  List<OptionModelString> listStatus = [
    OptionModelString('Chưa xử lý', HWorkStatus.notImplement.toString()),
    OptionModelString('Đã xử lý', HWorkStatus.implementing.toString()),
  ];

  RxList<OptionModelString> categories = RxList.empty();
  RxList<OptionModelString> equipments = RxList.empty();
  RxList<OptionModelString> worksStatus = RxList.empty();
  RxList<OptionModelString> nodes = RxList.empty();

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
    worksStatus = [listStatus[0], listStatus[1]].obs;
    await getType();
    await getNodesList();
    if(testType == TestType.subStation) {
      await getCategoryList();
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
    if (isSearching.value) page.value = 1;

    final response = await _abnormalRep.getAbnormalList(
      isBackground: false,
      searchTerm: searchTerm.value?.trim(),
      id: transformerTicketController.ticketId,
      fromDate: fromDate.value,
      toDate: toDate.value,
      equipmentIds: parseId(equipments),
      workStatus: parseId(worksStatus),
      X6InspectType: transformerTicketController.testType == TestType.subStation?1:2,
      isViolate: isViolate,
      nodeIds: parseId(nodes),
      equipmentCategories: parseId(categories),
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
      searchTerm: searchTerm.value?.trim(),
      id: transformerTicketController.ticketId,
      fromDate: fromDate.value,
      toDate: toDate.value,
      equipmentIds: parseId(equipments),
      workStatus: parseId(worksStatus),
      X6InspectType: transformerTicketController.testType == TestType.subStation?1:2,
      isViolate: isViolate,
      nodeIds: parseId(nodes),
      equipmentCategories: parseId(categories),
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
      searchTerm: searchTerm.value?.trim(),
      id: transformerTicketController.ticketId,
      fromDate: fromDate.value,
      toDate: toDate.value,
      equipmentIds: parseId(equipments),
      workStatus: parseId(worksStatus),
      pageIndex: page.value,
      X6InspectType: transformerTicketController.testType == TestType.subStation?1:2,
      isViolate: isViolate,
      nodeIds: parseId(nodes),
      equipmentCategories: parseId(categories),
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

  Future getNodesList() async {
    if (transformerTicketController.ticketId.isNotEmpty == true) {
      final res = await _lineRep.getLineInspect(
          idLine: transformerTicketController.lineId,
          idTicket: transformerTicketController.ticketId,
          isUnderSystem: transformerTicketController.ticketType==TicketType.tunnelCable,
          isUpdate: true);
      if (res.isLoadSuccess) {
        listNode.value = res.data.list?.map((e) => OptionModelString(e.name, e.id))?.toList()??[];
        listNode.refresh();
      } else {
        await hShowDialogOneButton(res.message);
      }
    }
    update();
  }

  Future getCategoryList({String listNodeId}) async {
    if(testType == TestType.subStation)
      {
        final res = await _workRep.getListCategoryBySubstation(
          lineOrSubstationID: transformerTicketController.lineId,
          isNightTime: transformerTicketController.ticketType == TicketType.periodicNight,
          isLine: transformerTicketController.testType == TestType.line,
          isBackground: false,
        );
        if (res.isLoadSuccess) {
          listCategory.value = res.data.list?.map((e) => OptionModelString(e.name, e.id))?.toList()??[];
          listNode.refresh();

        } else {
          await hShowDialogOneButton(res.message);
        }
      }
    else
      {
        final res = await _workRep.getListCategoryByNode(
          ids: listNodeId,
          isBackground: false,
        );
        if (res.isLoadSuccess) {
          listCategory.value = res.data.list?.map((e) => OptionModelString(e.name, e.id))?.toList()??[];
          listNode.refresh();

        } else {
          await hShowDialogOneButton(res.message);
        }
      }
  }

  Future getListEquipmentTBAorLine({String category}) async {
    listEquipment = RxList.empty();
    if (category.isNullOrEmpty()) {
      listEquipment.refresh();
      return;
    }
    final categories = category.split(',');
    categories.forEach((element) async {
      final res = await _workRep.listEquipmentByCategory(
        lineOrSubstationID: transformerTicketController.lineId,
        isSubStationInspect:transformerTicketController.testType == TestType.subStation,
        category: element,
        isBackground: false,
      );

      if (res.isLoadSuccess) {
        listEquipment
            .addAll(res.data.list.map((e) => OptionModelString(e.name, e.id)));
      } else {
        await hShowDialogOneButton(res.message);
      }
      listEquipment.refresh();
      update();
    });
  }

  bool hasFilter() {
    return toDateTime != null ||
        fromDateTime != null ||
        worksStatus.isNotEmpty ||
        equipments.isNotEmpty ||
        categories.isNotEmpty||
        listNode.isNotEmpty;
  }

}

