// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/common.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/general_data_model.dart';
import 'package:evnmobile/src/htld/services/location_background_service.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../common/extension/extension.dart';
import '../../../models/distribution_inspect_model.dart';
import '../../../services/offline_service/local_data_manager.dart';
import '../../../services/responsitory/ticket_repository.dart';
import 'ticket_screen.dart';

abstract class TicketDelegate {
  void onCreateTicketSuccess({bool isSuccess});

  void onCreateContentSuccess();
}

class TicketController extends GetxController {
  final repository = TicketRepository();
  TicketScreenArgument ticketScreenArgument;
  DistributionInspectModel distributionInspectModel =
      DistributionInspectModel();
  TicketDelegate delegate;
  final generalDataModel = GeneralDataModel().obs;
  final time = 0.obs;
  bool isProcessing = false;

  Map<String, dynamic> contentParams = {};
  String ticketID;
  RxBool completed = false.obs;

  Future<void> updateOfflineTicket(
      DistributionInspectModel distributionInspectModel) async {
    await LocalDataManager.shared.syncLocation(ticketID);
    await LocalDataManager.shared
        .syncGenerals(distributionInspectModel, ticketID);
    await LocalDataManager.shared.updateCheckedEquipment(
        distributionInspectModel.subStationId,
        ticketScreenArgument.subStationType,
        ticketScreenArgument.ticketType,
        distributionInspectModel.equipments);
    await LocalDataManager.shared.updatePopupByEquipmentForTicket(
        ticketID, distributionInspectModel.equipments);
    delegate.onCreateTicketSuccess(isSuccess: true);
  }

  Future<void> createOfflineTicket(
      DistributionInspectModel distributionInspectModel) async {
    ticketID = 'offlineID_${const Uuid().v1()}';
    await LocalDataManager.shared.syncLocation(ticketID);
    await LocalDataManager.shared
        .syncGenerals(distributionInspectModel, ticketID);
    await LocalDataManager.shared.createPopupForTicket(
        ticketID,
        distributionInspectModel.equipments,
        ticketScreenArgument.subStationType,
        ticketScreenArgument.ticketType);

    //status 2 == dang thuc hien
    await LocalDataManager.shared.updateWorkStatus(
        ticketID,
        2,
        distributionInspectModel.subStationId,
        ticketScreenArgument.subStationType,
        getWorkType(ticketScreenArgument.subStationType,
                ticketScreenArgument.ticketType)
            .toString());
    await LocalDataManager.shared.updateCheckedEquipment(
        distributionInspectModel.subStationId,
        ticketScreenArgument.subStationType,
        ticketScreenArgument.ticketType,
        distributionInspectModel.equipments);

    delegate.onCreateTicketSuccess(isSuccess: true);
    isProcessing = false;
  }

  Future createTicket(String inspectRequest) async {
    isProcessing = true;
    final hasInternet = await Connection.shared.checkConnection();
    distributionInspectModel.workId = ticketScreenArgument.workId;
    distributionInspectModel.type = ticketScreenArgument.ticketType;
    distributionInspectModel.subStationId =
        ticketScreenArgument?.substationModel?.id ??
            ticketScreenArgument?.inspectionModel?.substationId;
    distributionInspectModel.inspectTime =
        DateTime.now().toStringFormat(AppStrings.utcFormatNotZ, isUtc: true);
    distributionInspectModel.equipments = ticketScreenArgument.equipments;
    distributionInspectModel.lastInspectTime =
        ticketScreenArgument.substationModel.latestInspectTime;
    distributionInspectModel.inspectRequest = inspectRequest;
    distributionInspectModel.frequency = ticketScreenArgument.fre;
    distributionInspectModel.equipments = ticketScreenArgument.equipments;
    distributionInspectModel.temperature_1 ??=
        generalDataModel.value.temperature1;
    distributionInspectModel.temperature_2 ??=
        generalDataModel.value.temperature2;
    distributionInspectModel.weather_1 ??= generalDataModel.value.weather1;
    distributionInspectModel.weather_2 ??= generalDataModel.value.weather2;

    if (!hasInternet) {
      await createOfflineTicket(distributionInspectModel);
    }
    final isLocationGranted = await checkLocationPermission();
    if (isLocationGranted) {
        final response = await repository.create(
            distributionInspectModel, ticketScreenArgument.subStationType);
        LocationServiceBackground.shared
            .updateLocationToServer(distributionInspectModel.subStationId);
        if (response.isLoadSuccess) {
          ticketID = response.data.ticketId;
          SnackBarHUD.show('Tạo công việc kiểm tra kiểm tra thành công');
        } else {
           await showDialogError(response.message);
        }
        delegate.onCreateTicketSuccess(isSuccess: response.isLoadSuccess);
    }
    isProcessing = false;
  }

  Future updateInfo() async {
    final hasInternet = await Connection.shared.checkConnection();
    distributionInspectModel.equipments = ticketScreenArgument.equipments;
    distributionInspectModel.temperature_1 ??=
        generalDataModel.value?.temperature1;
    distributionInspectModel.temperature_2 ??=
        generalDataModel.value?.temperature2;
    distributionInspectModel.weather_1 ??= generalDataModel.value?.weather1;
    distributionInspectModel.weather_2 ??= generalDataModel.value?.weather2;
    distributionInspectModel.subStationId =
        ticketScreenArgument?.substationModel?.id ??
            ticketScreenArgument?.inspectionModel?.substationId;

    if (!hasInternet) {
      await updateOfflineTicket(distributionInspectModel);
    } else {
      final location = await checkLocationPermission();
      if (location) {
        final response = await repository.update(distributionInspectModel,
            ticketScreenArgument.subStationType, ticketID);
        LocationServiceBackground.shared
            .updateLocationToServer(getSubstationId());
        if (response.isLoadSuccess) {
          SnackBarHUD.show(response?.message);
        } else {
          // await showDialogError(response.message);
        }
        delegate.onCreateTicketSuccess(isSuccess: response.isLoadSuccess);
      }
    }
    isProcessing = false;
  }

  Future getGeneral() async {
    if (ticketID == null) {
      return;
    }
    final connection = await Connection.shared.checkConnection();

    if (connection) {
      final response = await repository.getGeneralInfo(
          ticketID, ticketScreenArgument.subStationType);
      if (response.isLoadSuccess) {
        generalDataModel.value = response.data;
        time.value = generalDataModel?.value?.expireRemainingTime ?? 0;
        update();
      } else {
        await showDialogError(response.message);
      }
    } else {
      final res = await LocalDataManager.shared.getGenerals(ticketID);
      generalDataModel.value = res;
      update();
    }
  }

  String getSubstationId() {
    return ticketScreenArgument?.substationModel?.id;
  }

  String getLineId() {
    return ticketScreenArgument?.lineModel?.id;
  }
}

