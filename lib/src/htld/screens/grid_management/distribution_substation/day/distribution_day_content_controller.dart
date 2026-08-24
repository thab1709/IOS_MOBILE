// @dart=2.9

import 'package:evnmobile/src/htld/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_controller.dart';
import 'package:evnmobile/src/htld/services/location_background_service.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/htld/services/responseModel/distribution_content_day_response.dart';
import 'package:evnmobile/src/htld/services/responsitory/ticket_repository.dart';
import 'package:get/get.dart';


mixin DistributionDayContentDelegate{
  void createContentSuccess({bool isSuccess});
}

class DistributionDayContentController extends GetxController {
  List<PopupBaseModel> checklists = <PopupBaseModel>[];
  final listPopups = <PopupsDataModel>[].obs;
  final contentResponse = DistributionContentDayResponse().obs;

  final service = TicketRepository();
  final TicketController _ticketController = Get.find();

  RxString abnormalPhenomenon = ''.obs;

  DistributionDayContentDelegate delegate;

  Future<void> getContentDay(String ticketId) async {
    if (_ticketController.ticketID == null) {
      return;
    }
    final connection = await Connection.shared.checkConnection();
    if(connection){
      final response = await service.getContentDistributionDayTime(ticketId);
      if (response.isLoadSuccess) {
        contentResponse.value = response.data;
        abnormalPhenomenon.value = response.data.abnormalPhenomenon;
        listPopups.value = response.data.popupsModel;
        listPopups.refresh();
        update();
      } else {
        await showDialogError(response.message);
      }
    }
    else{
     await getPopupOffline();
    }
  }

  Future getPopupOffline() async {
    final contentData = await LocalDataManager.shared.getContent(_ticketController.ticketID);
    contentResponse.value = DistributionContentDayResponse.fromJson(contentData);
    abnormalPhenomenon.value = contentResponse.value.abnormalPhenomenon;
    final popups = await LocalDataManager.shared.getPopupsForTicket(_ticketController.ticketID);
    listPopups.value = popups;
    listPopups.refresh();
    update();
  }

  void updatePopupSuccess(PopupsDataModel popupsDataModel){
    listPopups.firstWhere((element) => element.equipmentId == popupsDataModel.equipmentId)?.isSaved = true;
    listPopups.refresh();
    update();
  }

  Future createContent() async {
    if (_ticketController.ticketID == null || _ticketController.ticketID.isEmpty) {
      await showDialogError('Không thể cập nhật khi chưa tạo công việc kiểm tra.');
      return;
    }

    final params = contentResponse.value.toJson();
    final isLocationGranted = await checkLocationPermission();
    if (isLocationGranted) {
      final isConnectInternet = await Connection.shared.checkConnection();
      if (isConnectInternet) {
        Future.delayed(const Duration(milliseconds: 200), () async {
          final response = await service.updateContentDayDistribution(
              params, _ticketController.ticketID);
          LocationServiceBackground.shared
              .updateLocationToServer(_ticketController.getSubstationId());
          if (response.isLoadSuccess) {
            SnackBarHUD.show(response.message);
          } else {
            await showDialogError(response.message);
          }
          delegate.createContentSuccess(isSuccess: response.isLoadSuccess);
        });
      } else {
        await LocalDataManager.shared.saveContent(params, _ticketController.ticketID);
        delegate.createContentSuccess(isSuccess: true);
      }
    } else {}
  }

  Future<void> getAbnormalPhenomenon() async {
    final isConnectInternet = await Connection.shared.checkConnection();

    if (_ticketController.ticketID == null) {
      return;
    }

    Future<void> getAbnormalOnline() async{

      final subStationType = _ticketController.ticketScreenArgument.subStationType;
      final response = await service.getAbnormalPhenomenon(_ticketController.ticketID, subStationType.endPoint);

      if (response.isLoadSuccess) {
        if (response?.data != null) {
          abnormalPhenomenon.value = '';
          abnormalPhenomenon.value = response.data.map((e) => e).join('\n');
          contentResponse.value.abnormalPhenomenon = abnormalPhenomenon.value;
          update();
        }
      } else {
        await showDialogError(response.message);
      }
    }

    Future getAbNormalOffline() async {
      final allAbnormalString = <String>[];

      listPopups.forEach((element) async {
        final data = await LocalDataManager.shared.getPopup(
            _ticketController.ticketID,
            equipmentId: element.equipmentId);
        final description = data[
        InspectionCategory.getKeyDistributionDayModel(
            element.inspectionCategory)]['description'].string;
        if (description?.isNotEmpty == true) {
          allAbnormalString.add(description);
        }

        abnormalPhenomenon.value = allAbnormalString.map((e) => e).join('\n');
        contentResponse.value.abnormalPhenomenon = abnormalPhenomenon.value;
        update();
      });
    }

    if (isConnectInternet) {
      await getAbnormalOnline();
    } else {
      await getAbNormalOffline();
    }
  }

}
