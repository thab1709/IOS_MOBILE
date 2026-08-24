// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/inspection_model.dart';
import 'package:evnmobile/src/htld/models/option_model.dart';
import 'package:evnmobile/src/htld/services/responsitory/inspection_repository.dart';
import 'package:evnmobile/src/htld/services/responsitory/substation_repository.dart';
import 'package:evnmobile/src/htld/shared_preferences/app_shared.dart';
import 'package:get/get.dart';

abstract class HistoryCheckDelegate {
  void onRefreshSuccess();

  void onLoadMoreSuccess();

}

class HistoryCheckController extends GetxController
    with StateMixin<List<InspectionModel>> {
  RxString fromDate = ''.obs;
  RxString toDate = ''.obs;

  DateTime fromDateTime = DateTime.now();
  DateTime toDateTime = DateTime.now();

  final more = false.obs;
  final page = 1.obs;
  final isHasLoadMore = false.obs;
  final ticketStatus = '1'.obs;
  final ticketTypeCode = ''.obs;
  final searchTerm = ''.obs;

  final isFilter = false.obs;

  List<UserOptionModel> units = MAppShared.shared.units
      .map((e) => UserOptionModel(e.name, e.id)).toList();
  String unitId = '0';
  SubStationType stationType;
  TicketType ticketType;

  final service = InspectionRepository();
  HistoryCheckDelegate delegate;
  RxList<InspectionModel> listItemTicket = <InspectionModel>[].obs;
  SubstationRepository service1 = SubstationRepository();
  final userProfile = AppShared.instance.getUserProfile();

  @override
  void onInit() {
    super.onInit();
    if(userProfile?.unitId != null){
      unitId = userProfile.unitId;
    }
  }


  @override
  void dispose() {
    super.dispose();
    fromDate.value = '';
    toDate.value = '';
    listItemTicket.clear();
  }

  void clearFilter(){
    ticketTypeCode.value = ticketType.code.toString();
    ticketStatus.value = '0';
    fromDate.value = '';
    toDate.value = '';
    unitId = '0';
    fromDateTime = DateTime.now();
    toDateTime = DateTime.now();
    isFilter.value = false;
    Get.back();
    getData();
  }

  Future<void> getData() async {
    if (ticketTypeCode.value != ticketType.code.toString() || ticketStatus.value != '0' || fromDate.value != '' || unitId != '0') {
      isFilter.value = true;
    }

    if (ticketTypeCode.value == ticketType.code.toString() && ticketStatus.value == '0' && fromDate.value == '' && unitId == '0') {
      isFilter.value = false;
    }

    final hasInternet = await Connection.shared.checkConnection();

    if (!hasInternet) {

    }

    final response = await service.getListTicket(stationType,ticketTypeCode.value,
        ticketStatus.value == '0' ? '' : ticketStatus.value, fromDate.value, toDate.value , unitId, searchTerm.value);

    if (response.isLoadSuccess) {
      listItemTicket.assignAll(response?.data?.list?.obs ?? RxList.empty());
      listItemTicket.refresh();
    } else {
      await showDialogError(response.message);
    }

    isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
  }

  Future<void> refreshList() async {
    page.value = 1;
    final response = await service.getListTicket(stationType, ticketTypeCode.value,
        ticketStatus.value, fromDate.value, toDate.value, unitId, searchTerm.value, );
    delegate.onRefreshSuccess();
    if (response.isLoadSuccess) {
      listItemTicket.assignAll(response?.data?.list?.obs ?? RxList.empty());
      listItemTicket.refresh();
    } else {
      await showDialogError(response.message);
    }

    isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
  }

  // Future<void> deleteInspection(String inspectionId) async {
  //
  //   final response = await service.deleteInspection(inspectionId, stationType.endPoint);
  //
  //   delegate.onRefreshSuccess();
  //   if (response?.ticketId != null) {
  //     listItemTicket.removeWhere((element) => element.id == inspectionId);
  //     listItemTicket.refresh();
  //     update();
  //     SnackBarHUD.show('Xoá công việc kiểm tra kiểm tra thành công');
  //   } else {
  //     await showDialogError(response.message);
  //   }
  // }

  Future<void> loadMore(
  ) async {
      page.value = page.value + 1;
      final response = await service.getListTicket(
      stationType,
      ticketTypeCode.value,
      ticketStatus.value,
      fromDate.value,
      toDate.value,
      unitId,
      searchTerm.value,
      pageIndex: page.value,
    );
    delegate.onLoadMoreSuccess();
    if (response.isLoadSuccess) {
      if (response.data.list.isNotEmpty) {
        listItemTicket.addAll(response?.data?.list?.obs ?? RxList.empty());
        listItemTicket.refresh();
      }
    } else {
      await showDialogError(response.message);
    }

    isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
 }
}

