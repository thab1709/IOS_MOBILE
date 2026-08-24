// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_substation_room_model.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../containers/e_drop_down.dart';

class InterSubstationRoomPopup extends BasePopupWidget {
  InterSubstationRoomPopup({@required PopupsDataModel popupsDataModel}) {
    _controller.popupsDataModel = popupsDataModel;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  final _controller = _SubstationRoomController();
  static String endPoint = 'substation-room';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() => Column(
            children: [
              EDropDown(CKOptions,
                  index: 0,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  images: _controller.model.value.images,
                  onAttachImages: (images, index) {
                _controller.model.value.setImages(images, index);
              }),
              EDropDown(
                CKOptions,
                index: 1,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.isExist,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                title: 'Hiện hữu:',
                onChange: (option, mess) {
                  if (option.value != _controller.model.value.isExist) {
                    _controller.model.value.entrance = null;
                    _controller.model.value.vent = null;
                    _controller.model.value.lighting = null;
                    _controller.model.value.barrierNet = null;
                    _controller.model.value.clearAllProblem();
                    _controller.setFieldIsExist(option.value);
                  }
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              if (_controller.model.value.isExist == CKOptions.first.value)
                EDropDown(
                  BTNAOptions,
                  title: 'Cửa ra vào:',
                  index: 2,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.entrance,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onChange: (option, mess) {
                    _controller.model.value.entrance = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  },
                ),
              if (_controller.model.value.isExist == CKOptions.first.value)
                EDropDown(
                  BTNAOptions,
                  title: 'Lỗ thông hơi:',
                  index: 3,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.vent,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onChange: (option, mess) {
                    _controller.model.value.vent = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  },
                ),
              if (_controller.model.value.isExist == CKOptions.first.value)
                EDropDown(
                  BTNAOptions,
                  title: 'Đèn chiếu sáng:',
                  index: 4,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.lighting,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onChange: (option, mess) {
                    _controller.model.value.lighting = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  },
                ),
              if (_controller.model.value.isExist == CKOptions.first.value)
                EDropDown(
                  BTNAOptions,
                  title: 'Lưới chắn:',
                  index: 5,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.barrierNet,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onChange: (option, mess) {
                    _controller.model.value.barrierNet = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  },
                ),
            ],
          )),
    );
  }

  @override
  void saveData() {
    _controller.updateData();
  }
}

class _SubstationRoomController extends BasePopupController {
  Rx<InterSubstationRoomModel> model = InterSubstationRoomModel().obs;

  void createDefaultIfNeeded() {
    // model.value.entrance ??= BTOptions.first.value;
    // model.value.vent ??= BTOptions.first.value;
    // model.value.lighting ??= BTOptions.first.value;
    // model.value.barrierNet ??= BTOptions.first.value;
    model.value.isExist ??= CKOptions.first.value;
  }

  void setFieldIsExist(int value) {
    model?.value?.isExist = value;
    model?.value = model.value.copy();
    model.value.clearAllProblem();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    createDefaultIfNeeded();
  }

  @override
  void refresh() {
    model.refresh();
    super.refresh();
  }

  static String endPoint = 'substation-room';

  @override
  Future getData() async {
    await super.getData();
    final isConnectInternet = await Connection.shared.checkConnection();
    if (!isConnectInternet) {
      await getOffline(ticketController.ticketID);
    } else {
      final response =
          await repository.getInterSubstationRoom(ticketController.ticketID);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? InterSubstationRoomModel();
        model.value.title = popupsDataModel.getPopupName();
        createDefaultIfNeeded();
        update();
      } else {
        await showDialogError(response.message);
      }
    }
  }

  @override
  Future updateData() async {
    final isConnectInternet = await Connection.shared.checkConnection();
    if (!isConnectInternet) {
      if (!validateAllData(model.value)) {
        await showDialogValidateData();
        model.refresh();
        return;
      }
      final params = {
        'equipmentId': popupsDataModel.equipmentId,
        'substationRoom': model.value.toJson()
      };

      await updateOffline(params, ticketController.ticketID);
      Get.back(result: true);
    } else {
      if (!validateAllData(model.value)) {
        await showDialogValidateData();
        model.refresh();
        return;
      }
      final params = {
        'equipmentId': popupsDataModel.equipmentId,
        'substationRoom': model.value.toJson()
      };

      await updateOffline(params, ticketController.ticketID);

      final response = await repository.updateInterPopup(
          ticketController.ticketID, endPoint, params);

      if (response.isLoadSuccess) {
        Get.back(result: true);
        SnackBarHUD.show(response.message);
      } else {
        await showDialogError(response.message);
      }
    }
  }

  Future<void> updateOffline(Map<String, dynamic> data, String ticketId) async {
    await LocalDataManager.shared
        .savePopup(endPoint, data, ticketId, popupsDataModel: popupsDataModel);
  }

  Future<void> getOffline(String ticketId) async {
    final data = await LocalDataManager.shared
        .getPopup(ticketId, equipmentId: popupsDataModel.equipmentId);
    model.value = InterSubstationRoomModel.fromJson(data['substationRoom']);
    model.value.title = popupsDataModel.getPopupName();
  }
}

