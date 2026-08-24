// @dart=2.9

import 'package:evnmobile/src/htld/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/models/transformer_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/distribution_day_content_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_controller.dart';
import 'package:evnmobile/src/htld/services/location_background_service.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/htld/services/responseModel/distribution_content_night_response.dart';
import 'package:evnmobile/src/htld/services/responsitory/ticket_repository.dart';
import 'package:get/get.dart';

mixin InterDayContentDelegate{
  void createContentSuccess();
}

class DistributionNightContentController extends GetxController {
  final transformers = <TransformerModel>[].obs;
  final distributionContentNightResponse = DistributionContentNightResponse().obs;
  final listPopups = <PopupsDataModel>[].obs;
  final service = TicketRepository();

  final TicketController _ticketController = Get.find();

  DistributionDayContentDelegate delegate;

  RxString abnormalPhenomenon = ''.obs;
  RxString processed = ''.obs;

  void updatePopupSuccess(PopupsDataModel popupsDataModel){
    listPopups.firstWhere((element) => element.equipmentId == popupsDataModel.equipmentId)?.isSaved = true;
    listPopups.refresh();
    update();
  }

 void updateValueTransformer(String key, String equipmentId, String value) {
    final model = transformers.firstWhere((element) => element.equipmentId == equipmentId);
    model.addValueForKey(key, value);
  }

  String getValueMBAField(String equipmentId, String key) {
    if (distributionContentNightResponse != null) {
      final mba = distributionContentNightResponse.value.equipments?.firstWhere((element) => element.equipmentId == equipmentId);
      final value = mba == null ? '' : mba.toJson()[key];
      updateValueTransformer(key, equipmentId, value);
      return value;
    }

    return '';
  }

  Future getPopupOffline() async {
    final contentJson = await LocalDataManager.shared.getContent(_ticketController.ticketID);
    distributionContentNightResponse.value = DistributionContentNightResponse.fromJSON(contentJson);
    transformers.value = distributionContentNightResponse.value.equipments;
    transformers.refresh();
    final popups = await LocalDataManager.shared.getPopupsForTicket(_ticketController.ticketID);
    listPopups.value = popups;
    listPopups.refresh();
  }

  Future saveContentOffline() async {
    final params = distributionContentNightResponse.toJson();
    params['equipments'] = transformers.map((e) => e.toJson()).toList();
    await LocalDataManager.shared.saveTransformers(_ticketController.ticketID, transformers);
    await LocalDataManager.shared.saveContent(params, _ticketController.ticketID);
  }

  Future<void> getContentNight(String ticketId) async {
    if (ticketId == null) {
      return;
    }
    final connection = await Connection.shared.checkConnection();
    if(connection){
      final response = await service.getContentNight(ticketId);
      if (response.isLoadSuccess) {
        distributionContentNightResponse.value = response.data;
        abnormalPhenomenon.value = response.data.abnormalPhenomenon;
        processed.value = response.data.processed;

        transformers.value = response.data.equipments;
        transformers.refresh();

        listPopups.clear();
        listPopups.addAll(response.data.popupsModel);
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

  Future<void> getAbnormalPhenomenon() async {
    if (_ticketController.ticketID == null) {
      return;
    }

    Future getAbnormalOnline() async {
      final subStationType = _ticketController.ticketScreenArgument.subStationType;
      final response = await service.getAbnormalPhenomenon(_ticketController.ticketID, subStationType.endPoint);

      if (response.isLoadSuccess) {
        if (response?.data != null) {
          abnormalPhenomenon.value = '';
          abnormalPhenomenon.value = response.data.map((e) => e).join('\n');
          distributionContentNightResponse.value.abnormalPhenomenon = abnormalPhenomenon.value;
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
        InspectionCategory.getKeyDistributionNightModel(
            element.inspectionCategory)]['description'].string;
        if (description?.isNotEmpty == true) {
          allAbnormalString.add(description);
        }

        abnormalPhenomenon.value = allAbnormalString.map((e) => e).join('\n');
        distributionContentNightResponse.value.abnormalPhenomenon = abnormalPhenomenon.value;
        update();
      });
    }

    if (await Connection.shared.checkConnection()) {
      await getAbnormalOnline();
    }  else {
      await getAbNormalOffline();
    }

  }

  Future createContent() async {

    if (_ticketController.ticketID == null || _ticketController.ticketID.isEmpty) {
      await showDialogError('Không thể cập nhật khi chưa tạo công việc kiểm tra.');
      return;
    }

    final params = distributionContentNightResponse.toJson();
    params['equipments'] = transformers.map((e) => e.toJson()).toList();
    final isLocationGranted = await checkLocationPermission();
    if (isLocationGranted) {
      Future.delayed(const Duration(milliseconds: 200), () async {
        final hasInternet = await Connection.shared.checkConnection();
        if(hasInternet ){
          await LocalDataManager.shared.saveContent(params, _ticketController.ticketID);
          final response = await service.createContentNightTime(params, _ticketController.ticketID);
          LocationServiceBackground.shared.updateLocationToServer(_ticketController.getSubstationId());
          if (response.isLoadSuccess) {
            SnackBarHUD.show('Cập nhật công việc kiểm tra thành công.');
          } else {
            await showDialogError(response.message);
          }
          delegate.createContentSuccess(isSuccess: response.isLoadSuccess);
        }
        else{
          await LocalDataManager.shared.saveContent(params, _ticketController.ticketID);
          SnackBarHUD.show('Thực hiện lưu offline thành công!');
          delegate.createContentSuccess(isSuccess: true);
        }


      });
    }
  }

}
