// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_recloser_model.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../containers/e_drop_down.dart';
import '../../../containers/e_text_area.dart';

class RecloserPopup extends BasePopupWidget {
  RecloserPopup({@required PopupsDataModel popupsDataModel}) {
    _controller.popupsDataModel = popupsDataModel;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  final _controller = _RecloserController();
  static String endPoint = 'recloser';

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
                title: 'Chỉ thị đóng cắt',
                index: 1,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.switchingIndicator,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.switchingIndicator = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTPDNVBOptions,
                title: 'Cách điện',
                index: 2,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.insulation,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.insulation = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNDDMPDNAOptions,
                title: 'Mối nối trung áp',
                index: 3,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.mediumVoltageJunction,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.mediumVoltageJunction = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Hệ thống nối đất chống sét',
                index: 4,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.lightingProtection,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.lightingProtection = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Cáp tín hiệu và bộ nối cáp',
                index: 5,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.signalCable,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.signalCable = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Nguồn cung cấp cho tủ điều khiển',
                index: 6,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.powerSupply,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.powerSupply = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Hệ thống acquy, pin trong tủ điều khiển',
                index: 7,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.battery,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.battery = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Tủ điều khiển',
                index: 8,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.controlCabinet,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.controlCabinet = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Áp suất khí SF6',
                index: 9,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.gasPressure,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.gasPressure = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Tiếp điểm',
                index: 10,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.contact,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.contact = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                TKTNAOptions,
                title: 'Tiếp xúc lưỡi dao',
                index: 11,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.bladeContact,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.bladeContact = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                title: 'Các hiện tượng cụ thể',
                isRequire: true,
                enable: _controller.popupsDataModel.isAllowEdit,
                value: _controller.model.value.getSpecificPhenomena(),
                onChange: (value) {
                  _controller.model.value.specificPhenomena = value;
                },
              ),
              EDropDown(
                KCOptions,
                title: 'Có khả năng gây sự cố',
                index: 12,
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
                index: 13,
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
                  // _controller.model.value.setUnusually(mess);
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
              )
            ],
          )),
    );
  }

  @override
  void saveData() {
    _controller.updateData();
  }
}

class _RecloserController extends BasePopupController {
  Rx<InterRecloserModel> model = InterRecloserModel().obs;

  void createDefaultIfNeeded() {
    // model.value.switchingIndicator ??= DCOptions.first.value;
    // model.value.insulation ??= BTPDNVBOptions.first.value;
    // model.value.mediumVoltageJunction ??= BTNDDMPDOptions.first.value;
    // model.value.lightingProtection ??= BTOptions.first.value;
    // model.value.signalCable ??= BTOptions.first.value;
    // model.value.powerSupply ??= BTOptions.first.value;
    // model.value.battery ??= BTOptions.first.value;
    // model.value.controlCabinet ??= BTOptions.first.value;
    // model.value.gasPressure ??= BTOptions.first.value;
    // model.value.contact ??= BTOptions.first.value;
    // model.value.bladeContact ??= TKTOptions.first.value;
    // model.value.possibleProblematic ??= KCOptions.first.value;
    // model.value.handlingImmediatelyInspection ??= CKOptions.first.value;
  }

  static String endPoint = 'recloser';

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

  @override
  Future getData() async {
    await super.getData();
    final isConnectInternet = await Connection.shared.checkConnection();
    if (!isConnectInternet) {
      await getOffline(ticketController.ticketID);
    } else {
      final response = await repository.getInterRecloser(
          ticketController.ticketID, popupsDataModel.equipmentId, endPoint);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? InterRecloserModel();
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
        'recloser': model.value.toJson()
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
        'recloser': model.value.toJson()
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
    model.value = InterRecloserModel.fromJson(data['recloser']);
    model.value.title = popupsDataModel.getPopupName();
  }
}

