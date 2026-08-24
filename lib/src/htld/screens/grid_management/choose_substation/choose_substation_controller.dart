// @dart=2.9

import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/models/equipment_model.dart';
import 'package:evnmobile/src/htld/models/substation_model.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/htld/services/responsitory/substation_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ChooseSubStationController extends GetxController {
  SubstationRepository service = SubstationRepository();
  RxList<SubstationModel> searchValues = RxList<SubstationModel>();
  RxList<EquipmentModel> equipments = RxList<EquipmentModel>();
  final isCheckAll = false.obs;
  final searchText = ''.obs;

  RxBool isSearching = false.obs;
  RxBool isSelectedSubstation = false.obs;
  SubstationModel substationSelected;
  bool isHanding = false;

  void checkAllDevices({@required bool value}) {
    isCheckAll.value = value;
    equipments.forEach((element) {
      if (!element.isUsed) {
        element.isChecked = value;
      }
    });
    equipments.refresh();
  }

  void toggleCheckAll(){
    isCheckAll.value = !isCheckAll.value;
  }

  void selectedItem(int index, {@required bool value}) {
    if (isCheckAll.value && value == false) {
      toggleCheckAll();
    }

    equipments[index].isChecked = value;
    equipments.refresh();
  }

  Future<void> search(String value, String inspectType) async {
    if (value.isEmpty) {
      isSearching.value = false;
      isSelectedSubstation.value = false;
      searchValues = RxList<SubstationModel>();
      searchValues.refresh();
      return;
    }


    final substationResponse =
        await service.getListSubstation(searchTerm: value, inspectType: inspectType);

    if (substationResponse.isLoadSuccess) {
      if (substationResponse.data.list.isNotEmpty) {
        searchValues.assignAll(substationResponse.data.list);
      } else {
        searchValues.assignAll([SubstationModel(id: null, name: 'Không tìm thấy trạm biến áp nào')]);
      }
      isSearching.value = true;
      searchValues.refresh();
    } else {
      await showDialogError(substationResponse.message);
    }
  }

  Future<void> getEquipments(String substationId, {@required String inspectType, @required String ticketType, String ticketId,}) async {
    isSelectedSubstation.value = true;

    // If there is no Internet, get data from local
    final connection = await Connection.shared.checkConnection();
    if(!connection) {
      final localEquipments = await LocalDataManager.shared.getEquipmentForWork(inspectType, substationId, ticketType);
      equipments.assignAll(localEquipments);
    }
    // Else, get data from API
    else {
      final response = await service.getListEquipment(substationId: substationId, searchTerm: searchText.value, ticketId: ticketId, inspectType: inspectType);
      if (response.isLoadSuccess) {
        equipments.clear();
        equipments.addAll(response?.data?.list ?? List.empty());
        equipments.refresh();
      } else {
        await showDialogError(response.message);
      }
    }
  }

  List<EquipmentModel> getDevicesSelected() {
    return equipments.where((e) => e.isChecked).toList();
  }
}

