// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_cutting_machine_model.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../containers/e_drop_down.dart';
import '../../../containers/e_text_area.dart';

class CuttingMachinesScreen extends BasePopupWidget {
  CuttingMachinesScreen({@required PopupsDataModel popupsDataModel}) {
    _controller.popupsDataModel = popupsDataModel;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  static String endPoint = 'cutting-machine';
  final _controller = _CuttingMachineController();

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
                DCNAOptions,
                title: 'Chỉ thị đóng máy cắt của máy cắt',
                index: 1,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.cuttingIndicator,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.cuttingIndicator = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                TKTNAOptions,
                title: 'Mức dầu (Khí)',
                index: 2,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.oilLevel,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.oilLevel = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTPDNVBOptions,
                title: 'Cách điện',
                index: 3,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.insulation1,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.insulation1 = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                TKTNAOptions,
                title: 'Bộ truyền động',
                index: 4,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.transmission,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.transmission = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                title: 'Dòng điện',
                enable: _controller.popupsDataModel.isAllowEdit,
                isRequire: true,
                value: _controller.model.value?.electric,
                onChange: (value) {
                  _controller.model.value?.electric = value;
                },
              ),
              ETextArea(
                title: 'Điện áp:',
                enable: _controller.popupsDataModel.isAllowEdit,
                isRequire: true,
                value: _controller.model.value?.voltage,
                onChange: (value) {
                  _controller.model.value?.voltage = value;
                },
              ),
              EDropDown(
                BTPDNVBOptions,
                title: 'Cách điện',
                index: 5,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.insulation2,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.insulation2 = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNDDMNAOptions,
                title: 'Đầu nối',
                index: 6,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.connector,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.connector = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                CKNAOptions,
                title: 'Mạch sấy có làm việc',
                index: 7,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.fusingCircuit,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.fusingCircuit = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTOptions,
                title: 'Nối đất',
                index: 8,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.ground,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.ground = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Nguồn điều khiển',
                index: 9,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.controlSource,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.controlSource = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Tình trạng tích năng của lò xo, thiết bị truyền động',
                index: 10,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.actuatorStatus,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.actuatorStatus = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                title: 'Số lần đóng cắt',
                isRequire: true,
                enable: _controller.popupsDataModel.isAllowEdit,
                value: _controller.model.value?.switchingTimesNumber,
                onChange: (value) {
                  _controller.model.value?.switchingTimesNumber = value;
                },
              ),
              ETextArea(
                title: 'Các hiện tượng cụ thể',
                enable: _controller.popupsDataModel.isAllowEdit,
                value: _controller.model.value.getSpecificPhenomena(),
                onChange: (value) {
                  _controller.model.value.specificPhenomena = value;
                },
              ),
              EDropDown(
                KCOptions,
                title: 'Có khả năng gây sự cố',
                index: 11,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.possibleProblematic,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.possibleProblematic = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                KCOptions,
                title: 'Xử lý ngay trong kiểm tra',
                index: 12,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue:
                    _controller.model.value.handlingImmediatelyInspection,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  // _controller.setAbnormal(
                  //     categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.handlingImmediatelyInspection =
                      option.value;
                  //_controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                title: 'Đề xuất xử lý bất thường/hư hỏng',
                isRequire: true,
                enable: _controller.popupsDataModel.isAllowEdit,
                value: _controller.model.value.getSuggestedHandlingOfAbnormal(),
                onChange: (value) {
                  _controller.model.value.suggestedHandlingOfAbnormal = value;
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

class _CuttingMachineController extends BasePopupController {
  Rx<InterCuttingMachineModel> model = InterCuttingMachineModel().obs;

  void createDefaultIfNeeded() {
    // model.value.cuttingIndicator ??= DCOptions.first.value;
    // model.value.oilLevel ??= TKTOptions.first.value;
    // model.value.insulation1 ??= BTPDNVBOptions.first.value;
    // model.value.transmission ??= TKTOptions.first.value;
    // model.value.insulation2 ??= BTPDNVBOptions.first.value;
    // model.value.connector ??= BTNDDMOptions.first.value;
    // model.value.fusingCircuit ??= CKOptions.first.value;
    // model.value.ground ??= BTOptions.first.value;
    // model.value.controlSource ??= BTOptions.first.value;
    // model.value.actuatorStatus ??= BTOptions.first.value;
    // model.value.possibleProblematic ??= KCOptions.first.value;
    // model.value.handlingImmediatelyInspection ??= CKOptions.first.value;
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

  String endPoint = 'cutting-machine';

  @override
  Future getData() async {
    await super.getData();
    final isConnectInternet = await Connection.shared.checkConnection();
    if (!isConnectInternet) {
      await getOffline(ticketController.ticketID);
    } else {
      final response = await repository.getInterCuttingMachine(
          ticketController.ticketID, popupsDataModel.equipmentId, endPoint);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? InterCuttingMachineModel();
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
        'cuttingMachine': model.value.toJson()
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
        'cuttingMachine': model.value.toJson()
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
    model.value = InterCuttingMachineModel.fromJson(data['cuttingMachine']);
    model.value.title = popupsDataModel.getPopupName();
  }
}

