// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/cutting_machine.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../containers/e_drop_down.dart';
import '../../../containers/e_text_area.dart';

class CuttingMachineController extends BasePopupController {
  Rx<CuttingMachine> model = CuttingMachine().obs;

  void createDefaultIfNeeded() {
    // model?.value?.externalCondition ??= BTOptions.first.value;
    // model?.value?.sound ??= BTBTDPDOptions.first.value;
    // model?.value?.driveStructureClosed ??= BTOptions.first.value;
    // model?.value?.sf6Gas ??= DTGasOptions.first.value;
    // model?.value?.cableFaultRelay ??= BTOptions.first.value;
    // model?.value?.dryingResistance ??= BTOptions.first.value;
    // model?.value?.insulation ??= BTNVCPBOptions.first.value;
    model?.value?.contactAtBlade ??= BTOptions.first.value;
    // model?.value?.springPressesContact ??= BTOptions.first.value;
    // model?.value?.bolts ??= BTOptions.first.value;
    // model?.value?.groundingEquipment ??= BTOptions.first.value;
    // model?.value?.possibleProblematic ??= KCOptions.first.value;
    // model?.value?.handlingImmediatelyInspection ??= CKOptions.first.value;
  }

  String endPoint = 'cutting-machine';

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
      await getOffine(ticketController.ticketID);
    } else {
      // To do : check update time between LocalData and ServerData
      final response = await repository.getCuttingMachine(
          ticketController.ticketID, popupsDataModel.equipmentId, endPoint);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? CuttingMachine();
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
      await updateOffine(params, ticketController.ticketID);
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
      await updateOffine(params, ticketController.ticketID);
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

  Future<void> updateOffine(Map<String, dynamic> data, String ticketId) async {
    await LocalDataManager.shared
        .savePopup(endPoint, data, ticketId, popupsDataModel: popupsDataModel);
  }

  Future<void> getOffine(String ticketId) async {
    final data = await LocalDataManager.shared
        .getPopup(ticketId, equipmentId: popupsDataModel.equipmentId);
    model.value = CuttingMachine.fromJson(data['cuttingMachine']);
    model.value.title = popupsDataModel.getPopupName();
  }
}

class CutMachinePopup extends BasePopupWidget {
  CutMachinePopup({@required PopupsDataModel popupsDataModel}) {
    _controller.popupsDataModel = popupsDataModel;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  static String endPoint = 'cutting-machine';
  final CuttingMachineController _controller = CuttingMachineController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EDropDown(CKOptions,
                  index: 0,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  }),
              EDropDown(
                BTOptions,
                index: 1,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.externalCondition,
                images: _controller.model.value.images,
                title:
                    'Tình trạng bên ngoài của các tủ, bảng, hộp đấu dây và các thiết bị:',
                onChange: (option, mess) {
                  _controller.model.value.externalCondition = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTBTDPDOptions,
                title: 'Tiếng kêu:',
                index: 2,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.sound,
                images: _controller.model.value.images,
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
                title: 'Cần chỉ trạng thái, cấu trúc truyền động đóng, cắt:',
                index: 3,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.driveStructureClosed,
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.driveStructureClosed = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                DTGasNAOptions,
                title: 'Khí SF6:',
                index: 4,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                defaultValue: _controller.model.value.sf6Gas,
                enable: _controller.popupsDataModel.isAllowEdit,
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.sf6Gas = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Rơle báo sự cố cáp:',
                index: 5,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                defaultValue: _controller.model.value.cableFaultRelay,
                enable: _controller.popupsDataModel.isAllowEdit,
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.cableFaultRelay = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Điện trở sấy:',
                index: 6,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                defaultValue: _controller.model.value.dryingResistance,
                images: _controller.model.value.images,
                enable: _controller.popupsDataModel.isAllowEdit,
                onChange: (option, mess) {
                  _controller.model.value.dryingResistance = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNVCPBOptions,
                title: 'Cách điện: ',
                index: 7,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                defaultValue: _controller.model.value.insulation,
                images: _controller.model.value.images,
                enable: _controller.popupsDataModel.isAllowEdit,
                onChange: (option, mess) {
                  _controller.model.value.insulation = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                title: 'Đo phóng điện cục bộ (PD):',
                value: _controller.model.value.measurePartialDischarge ?? '',
                isRequire: true,
                enable: _controller.popupsDataModel.isAllowEdit,
                onChange: (value) {
                  _controller.model.value.measurePartialDischarge = value;
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Lò xo ép tiếp điểm: ',
                index: 9,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                defaultValue: _controller.model.value.springPressesContact,
                images: _controller.model.value.images,
                enable: _controller.popupsDataModel.isAllowEdit,
                onChange: (option, mess) {
                  _controller.model.value.springPressesContact = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Bu lông: ',
                index: 10,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                defaultValue: _controller.model.value.bolts,
                images: _controller.model.value.images,
                enable: _controller.popupsDataModel.isAllowEdit,
                onChange: (option, mess) {
                  _controller.model.value.bolts = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTOptions,
                title: 'Nối đất của thiết bị: ',
                index: 11,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                defaultValue: _controller.model.value.groundingEquipment,
                images: _controller.model.value.images,
                enable: _controller.popupsDataModel.isAllowEdit,
                onChange: (option, mess) {
                  _controller.model.value.groundingEquipment = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                title: 'Các hiện tượng cụ thể:',
                value: _controller.model.value.getSpecificPhenomena(),
                enable: _controller.popupsDataModel.isAllowEdit,
                onChange: (value) {
                  _controller.model.value.specificPhenomena = value;
                },
              ),
              EDropDown(
                KCOptions,
                title: 'Có khả năng gây sự cố:  ',
                index: 12,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                defaultValue: _controller.model.value.possibleProblematic,
                images: _controller.model.value.images,
                enable: _controller.popupsDataModel.isAllowEdit,
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
                index: 13,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  // _controller.setAbnormal(
                  //     categoryName, _controller.model.value, abnormal, index);
                },
                defaultValue:
                    _controller.model.value.handlingImmediatelyInspection,
                images: _controller.model.value.images,
                enable: _controller.popupsDataModel.isAllowEdit,
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
                title: 'Đề xuất xử lý bất thường/ hư hỏng:',
                value: _controller.model.value.getSuggestedHandlingOfAbnormal(),
                enable: _controller.popupsDataModel.isAllowEdit,
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

