// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_content_night.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/temperature.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/intermediate_content.dart';
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_controller.dart';
import 'package:evnmobile/src/htld/services/location_background_service.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/htld/services/responsitory/ticket_repository.dart';
import 'package:get/get.dart';

mixin InterContentDelegate{
  void  onUpdateSuccess({bool isSuccess});
}

class InterContentNightController extends GetxController {
  List<PopupBaseModel> checklists = <PopupBaseModel>[];
  RxList<PopupsDataModel> listPopups = <PopupsDataModel>[].obs;
  final listInterEquipment = <InterEquipments>[].obs;
  final temperatures = <Temperature>[].obs;
  final listOutlines = <OutLines>[].obs;
  final contentResponse = IntermediateContentNightModel().obs;

  final service = TicketRepository();
  InterContentDelegate delegate;

  final TicketController _ticketController = Get.find();
  RxBool loadSuccess = false.obs;
  RxString abnormalPhenomenon = ''.obs;
  RxString processed = ''.obs;

  Future getPopupOffline() async {
    final contentJson = await LocalDataManager.shared.getContent(_ticketController.ticketID);
    contentResponse.value = IntermediateContentNightModel.fromJson(contentJson);

    listInterEquipment.value = contentResponse.value.equipments;
    temperatures.value = contentResponse.value.temperatures;
    listOutlines.value = contentResponse.value.outLines;

    listInterEquipment.refresh();
    temperatures.refresh();
    listOutlines.refresh();

    final popups = await LocalDataManager.shared.getPopupsForTicket(_ticketController.ticketID);
    listPopups.value = popups;
    listPopups.refresh();
    loadSuccess.value = true;
  }

  Future<void> getContent(String ticketId) async {
    final hasInternet = await Connection.shared.checkConnection();
    if (ticketId == null) {
      return;
    }
    if(!hasInternet){
      await getPopupOffline();
    }
    else {
      final response = await service.getContentInterNightTime(ticketId);

      if (response.isLoadSuccess) {
        contentResponse.value = response.data;
        listPopups.value = response.data.popupsModel;
        listPopups.refresh();
        temperatures.value = response.data.temperatures;
        abnormalPhenomenon.value = response.data.abnormalPhenomenon;
        processed.value = response.data.processed;

        if (response.data.equipments != null) {
          listInterEquipment.assignAll(response.data.equipments);
          listInterEquipment.refresh();
        }

        if (response.data.temperatures != null) {
          temperatures.value = response.data.temperatures;
        }
        listOutlines.clear();
        if (response.data.outLines != null && response.data.outLines.isNotEmpty) {
          listOutlines.addAll(response.data.outLines);
        } else {
          final lines = RxList.generate(3, (index) => OutLines());
          listOutlines.assignAll(lines);
        }
        loadSuccess.value = true;
        update();
      } else {
        await showDialogError(response.message);
      }
    }
  }

  void updatePopupSuccess(PopupsDataModel popupsDataModel){
    listPopups.firstWhere((element) => element.equipmentId == popupsDataModel.equipmentId)?.isSaved = true;
    listPopups.refresh();
    update();
    LocationServiceBackground.shared.updateLocationToServer(_ticketController.getSubstationId());

  }

  Future createContent() async {
    if (_ticketController.ticketID == null || _ticketController.ticketID.isEmpty) {
      await showDialogError('Không thể cập nhật khi chưa tạo công việc kiểm tra.');
      return;
    }

    if (!contentResponse.value.validateData()) {
      return showDialogValidateData();
    }

    contentResponse.value.outLines = listOutlines;
    contentResponse.value.equipments = listInterEquipment;
    contentResponse.value.temperatures = temperatures;

    final params = contentResponse.value.toJson();
    final isLocationGranted = await checkLocationPermission();
    if (isLocationGranted) {
      Future.delayed(const Duration(milliseconds: 200), () async {
        final hasInternet = await Connection.shared.checkConnection();
        if (hasInternet) {
          final response = await service.updateContentNightInter(params, _ticketController.ticketID);
          LocationServiceBackground.shared.updateLocationToServer(_ticketController.getSubstationId());
          if (response.isLoadSuccess) {
            SnackBarHUD.show('Cập nhật công việc kiểm tra thành công.');
          } else {
            await showDialogError(response.message);
          }
          delegate.onUpdateSuccess(isSuccess: response.isLoadSuccess);
        }
        else {
          await LocalDataManager.shared.saveContent(contentResponse.value.toJson(), _ticketController.ticketID);
          SnackBarHUD.show('Thực hiện lưu offline thành công!');
          delegate.onUpdateSuccess(isSuccess: true);
        }
      });
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
          contentResponse.value.abnormalPhenomenon = abnormalPhenomenon.value;
          update();
        }
      } else {
        await showDialogError(response.message);
      }
    }

    Future getAbnormalOffline() async {
      final allAbnormalString = <String>[];

      listPopups.forEach((element) async {
        final data = await LocalDataManager.shared.getPopup(
            _ticketController.ticketID,
            equipmentId: element.equipmentId);
        final description = data[
        InspectionCategory.getKeyIntermediateNightModel(
            element.inspectionCategory)]['description'].string;
        if (description?.isNotEmpty == true) {
          allAbnormalString.add(description);
        }

        abnormalPhenomenon.value = '';
        abnormalPhenomenon.value = allAbnormalString.map((e) => e).join('\n');
        contentResponse.value.abnormalPhenomenon = abnormalPhenomenon.value;

        update();
      });
    }

    if (await Connection.shared.checkConnection()) {
      await getAbnormalOnline();
    }  else {
      await getAbnormalOffline();
    }
  }


  void updateValueTransformer(InterEquipments item) {
    final index = listInterEquipment.indexOf(item);
    listInterEquipment[index] = item;
  }

  void updateValueOutlineMachine(OutLines item) {
    final index = listOutlines.indexOf(item);
    listOutlines[index] = item;
  }
  void updateValueTemperature(Temperature model) {
    final indexModel = temperatures.indexOf(model);
    temperatures[indexModel] = model;
  }
}

