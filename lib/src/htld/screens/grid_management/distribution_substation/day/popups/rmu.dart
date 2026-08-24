// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/rmu.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../containers/e_drop_down.dart';
import '../../../containers/e_text_area.dart';

class RMUPopupController extends BasePopupController {
  Rx<Rmu> model = Rmu().obs;

  void createDefaultIfNeeded() {
    // model?.value?.measurePartialDischargeOptions ??= CKOptions.first.value;
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

  String endPoint = 'rmu';

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
      createDefaultIfNeeded();
    } else {
      final response = await repository.getRmu(
          ticketController.ticketID, popupsDataModel.equipmentId, endPoint);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? Rmu();
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
        'rmu': model.value.toJson()
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
        'rmu': model.value.toJson()
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
    model.value = Rmu.fromJson(data['rmu']);
    model.value.title = popupsDataModel.getPopupName();
  }
}

class RMUPopup extends BasePopupWidget {
  RMUPopup({@required PopupsDataModel popupsDataModel}) {
    _controller.popupsDataModel = popupsDataModel;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  final String endPoint = 'rmu';
  final RMUPopupController _controller = RMUPopupController();
  final RxBool measurePartialDischargeOptions = true.obs;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EDropDown(CKOptions,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  index: 0,
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
                enable: _controller.popupsDataModel.isAllowEdit,
                index: 1,
                defaultValue: _controller.model.value.externalCondition,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
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
                enable: _controller.popupsDataModel.isAllowEdit,
                title: 'Tiếng kêu:',
                index: 2,
                defaultValue: _controller.model.value.sound,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
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
                enable: _controller.popupsDataModel.isAllowEdit,
                title: 'Cần chỉ trạng thái, cấu trúc truyền động đóng, cắt:',
                index: 3,
                defaultValue: _controller.model.value.driveStructureClosed,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
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
                enable: _controller.popupsDataModel.isAllowEdit,
                title: 'Khí SF6:',
                index: 4,
                defaultValue: _controller.model.value.sf6Gas,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
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
                enable: _controller.popupsDataModel.isAllowEdit,
                title: 'Rơle báo sự cố cáp:',
                index: 5,
                defaultValue: _controller.model.value.cableFaultRelay,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
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
                enable: _controller.popupsDataModel.isAllowEdit,
                title: 'Điện trở sấy:',
                index: 6,
                defaultValue: _controller.model.value.dryingResistance,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
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
                enable: _controller.popupsDataModel.isAllowEdit,
                title: 'Cách điện: ',
                index: 7,
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
                CKOptions,
                enable: _controller.popupsDataModel.isAllowEdit,
                title: 'Có thiết bị đo phóng điện cục bộ (PD):',
                index: 9,
                disableImage: true,
                defaultValue:
                    _controller.model.value.measurePartialDischargeOptions,
                onChange: (option, mess) {
                  if( _controller.model.value.measurePartialDischargeOptions != option.value) {
                    _controller.model.value.measurePartialDischargeOptions =
                        option.value;
                    Future.delayed(const Duration(microseconds: 300),
                        _controller.model.refresh);
                  }
                },
              ),
              if (_controller.model.value.measurePartialDischargeOptions ==
                  CKOptions.first.value)
                ETextArea(
                  title: 'Đo phóng điện cục bộ (PD):',
                  enable: _controller.popupsDataModel.isAllowEdit,
                  isRequire: true,
                  value: _controller.model.value?.measurePartialDischarge ?? '',
                  onChange: (value) {
                    _controller.model.value.measurePartialDischarge = value;
                  },
                ),
              EDropDown(
                BTNAOptions,
                enable: _controller.popupsDataModel.isAllowEdit,
                title: 'Lò xo ép tiếp điểm: ',
                index: 9,
                defaultValue: _controller.model.value.springPressesContact,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
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
                enable: _controller.popupsDataModel.isAllowEdit,
                title: 'Bu lông: ',
                index: 10,
                defaultValue: _controller.model.value.bolts,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
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
                enable: _controller.popupsDataModel.isAllowEdit,
                title: 'Nối đất của thiết bị: ',
                index: 11,
                defaultValue: _controller.model.value.groundingEquipment,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
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
                enable: _controller.popupsDataModel.isAllowEdit,
                isRequire: true,
                value: _controller.model.value.getSpecificPhenomena(),
                onChange: (value) {
                  _controller.model.value.specificPhenomena = value;
                },
              ),
              EDropDown(
                KCOptions,
                enable: _controller.popupsDataModel.isAllowEdit,
                title: 'Có khả năng gây sự cố:  ',
                index: 12,
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
                enable: _controller.popupsDataModel.isAllowEdit,
                title: 'Xử lý ngay trong kiểm tra:  ',
                index: 13,
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
                title: 'Đề xuất xử lý bất thường/ hư hỏng:',
                enable: _controller.popupsDataModel.isAllowEdit,
                isRequire: true,
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

