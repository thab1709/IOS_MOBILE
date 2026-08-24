// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/low_voltage_capacito.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_text_area.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LowVoltageCapacitoPopup extends BasePopupWidget {
  LowVoltageCapacitoPopup({@required PopupsDataModel popupsDataModel}) {
    _controller.popupsDataModel = popupsDataModel;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  final _LowVoltageCapacitoController _controller =
      _LowVoltageCapacitoController();
  static String endPoint = 'low-voltage-capacito';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EDropDown(CKOptions,
                  index: 0,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  }),
              EDropDown(
                BTPROptions,
                title: 'Tình trạng:',
                enable: _controller.popupsDataModel.isAllowEdit,
                index: 1,
                isHasDefault: true,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.condition,
                onChange: (option, mess) {
                  _controller.model.value.condition = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Đầu nối, các vị trí tiếp xúc:',
                index: 2,
                isHasDefault: true,
                enable: _controller.popupsDataModel.isAllowEdit,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.connector,
                onChange: (option, mess) {
                  _controller.model.value.connector = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTBTDPDOptions,
                title: 'Tiếng kêu:',
                enable: _controller.popupsDataModel.isAllowEdit,
                index: 3,
                isHasDefault: true,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.sound,
                onChange: (option, mess) {
                  _controller.model.value.sound = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Tiếp địa tụ:',
                enable: _controller.popupsDataModel.isAllowEdit,
                index: 4,
                isHasDefault: true,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.grounding,
                onChange: (option, mess) {
                  _controller.model.value.grounding = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTRNNAOptions,
                title: 'Hệ thống bảo vệ và tự động đóng tụ bù:',
                enable: _controller.popupsDataModel.isAllowEdit,
                index: 5,
                isHasDefault: true,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.systemProtection,
                onChange: (option, mess) {
                  _controller.model.value.systemProtection = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                enable: _controller.popupsDataModel.isAllowEdit,
                title: 'Bộ hiển thị và cài đặt tụ bù:',
                index: 6,
                isHasDefault: true,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.capacitorDisplay,
                onChange: (option, mess) {
                  _controller.model.value.capacitorDisplay = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTRNNAOptions,
                enable: _controller.popupsDataModel.isAllowEdit,
                title: 'Cáp lực hạ áp, cáp lực tụ bù:',
                index: 7,
                isHasDefault: true,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.compensationCable,
                onChange: (option, mess) {
                  _controller.model.value.compensationCable = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                KCOptions,
                enable: _controller.popupsDataModel.isAllowEdit,
                title: 'Có khả năng gây sự cố: ',
                index: 8,
                isHasDefault: true,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.possibleProblematic,
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
                title: 'Xử lý ngay trong kiểm tra:  ',
                enable: _controller.popupsDataModel.isAllowEdit,
                index: 9,
                isHasDefault: true,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  // _controller.setAbnormal(
                  //     categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.handlingInCheck,
                onChange: (option, mess) {
                  _controller.model.value.handlingInCheck = option.value;
                  //_controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                title: 'Đề xuất xử lý bất thường/ hư hỏng:',
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

class _LowVoltageCapacitoController extends BasePopupController {
  final model = LowVoltageCapacitoModel().obs;

  String endPoint = 'low-voltage-capacito';

  @override
  void onInit() {
    super.onInit();
    createDefaultValue();
  }

  @override
  void refresh() {
    model.refresh();
    super.refresh();
  }

  void createDefaultValue() {
    // model.value.condition ??=BTPROptions.first.value;
    // model.value.connector ??=BTOptions.first.value;
    // model.value.sound ??=BTBTDPDOptions.first.value;
    // model.value.grounding ??=BTOptions.first.value;
    // model.value.systemProtection ??=BTRNOptions.first.value;
    // model.value.capacitorDisplay ??=BTOptions.first.value;
    // model.value.compensationCable ??=BTRNOptions.first.value;
    // model.value.possibleProblematic ??=KCOptions.first.value;
    // model.value.handlingInCheck ??=KCOptions.first.value;
  }

  @override
  Future getData() async {
    await super.getData();
    final isConnectInternet = await Connection.shared.checkConnection();

    if (!isConnectInternet) {
      await getOffline(ticketController.ticketID);
    } else {
      // To do : check update time between LocalData and ServerData
      final response = await repository.getLowVoltageCapacito(
          ticketController.ticketID, popupsDataModel.equipmentId, endPoint);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? LowVoltageCapacitoModel();
        model.value.title = popupsDataModel.getPopupName();
        createDefaultValue();
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
        'lowVoltageCapacito': model.value.toJson()
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
        'lowVoltageCapacito': model.value.toJson()
      };
      await updateOffline(params, ticketController.ticketID);
      final response = await repository.updatePopup(
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
    debugPrint(data.toString());
    model.value = LowVoltageCapacitoModel.fromJson(data['lowVoltageCapacito']);
    model.value.title = popupsDataModel.getPopupName();
  }
}

