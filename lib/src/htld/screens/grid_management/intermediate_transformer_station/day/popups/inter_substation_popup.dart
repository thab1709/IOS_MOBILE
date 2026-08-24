// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/content_option.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_substation_model.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../containers/e_drop_down.dart';
import '../../../containers/e_text_area.dart';

class InterSubstationPopup extends BasePopupWidget {
  InterSubstationPopup({@required PopupsDataModel popupsDataModel}) {
    _controller.popupsDataModel = popupsDataModel;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  final _SubstationController _controller = _SubstationController();
  static String endPoint = 'substation';

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
                BTOptions,
                title: 'Tiếng kêu:',
                index: 1,
                enable: _controller.popupsDataModel.isAllowEdit,
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
                TCDOptions,
                title: 'Vỏ máy:',
                index: 2,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.caseOption,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.caseOption = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                OilNAOptions,
                title: 'Mức dầu:',
                index: 3,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.oilLevel,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.oilLevel = option.value;
                  if (option.value == ContentOptions.noOil.value) {
                    mess.message = '';
                    _controller.model.value.setUnusually(mess);
                  }
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                title: 'Nhiệt độ dầu:',
                isRequire: true,
                enable: _controller.popupsDataModel.isAllowEdit,
                value: _controller.model.value?.oilTemperature,
                onChange: (value) {
                  _controller.model.value?.oilTemperature = value;
                },
              ),
              EDropDown(
                TKTOptions,
                title: 'Cách điện',
                index: 4,
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
                BTRNBPDCDOptions,
                title: 'Bề mặt cách điện',
                index: 5,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.insulationSurface,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.insulationSurface = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Quạt mát',
                index: 6,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.coolingFan,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.coolingFan = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Rơ le hơi',
                index: 7,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.steamRelay,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.steamRelay = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Van an toàn',
                index: 8,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.safetVvalve,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.safetVvalve = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Mặt kính ống phòng nổ',
                index: 9,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.explosionProof,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.explosionProof = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Thiết bị báo tín hiệu',
                index: 10,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.signalingDevice,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.signalingDevice = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                KCOptions,
                title: 'Phát nhiệt tiếp xúc',
                index: 11,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.contactHeatGeneration,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.contactHeatGeneration = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTOptions,
                title: 'Hệ thống nối đất',
                index: 12,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.groundingSystem,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.groundingSystem = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Màu sắc hạt hút ẩm trong bình thở',
                index: 13,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.desiccantColor,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.desiccantColor = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Van dầu cách tản nhiệt',
                index: 14,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.radiatorVane,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.radiatorVane = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                title: 'Các hiện tượng cụ thể:',
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
                index: 15,
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
                index: 16,
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
                  //  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                title: 'Đề xuất xử lý bất thường/hư hỏng:',
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

class _SubstationController extends BasePopupController {
  Rx<InterSubstationModel> model = InterSubstationModel().obs;

  void createDefaultIfNeeded() {
    // model.value.sound ??= BTOptions.first.value;
    // model.value.caseOption ??= TCDOptions.first.value;
    // model.value.oilLevel ??= DTOptions.first.value;
    // model.value.insulation ??= TKTOptions.first.value;
    // model.value.insulationSurface ??= BTRNBPDCDOptions.first.value;
    // model.value.coolingFan ??= BTOptions.first.value;
    // model.value.steamRelay ??= BTOptions.first.value;
    // model.value.safetVvalve ??= BTOptions.first.value;
    // model.value.explosionProof ??= BTOptions.first.value;
    // model.value.signalingDevice ??= BTOptions.first.value;
    // model.value.contactHeatGeneration ??= KCOptions.first.value;
    // model.value.groundingSystem ??= BTOptions.first.value;
    // model.value.desiccantColor ??= BTOptions.first.value;
    // model.value.radiatorVane ??= BTOptions.first.value;
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

  static String endPoint = 'substation';

  @override
  Future getData() async {
    await super.getData();
    final isConnectInternet = await Connection.shared.checkConnection();
    if (!isConnectInternet) {
      await getOffline(ticketController.ticketID);
    } else {
      final response = await repository.getInterSubstation(
          ticketController.ticketID, popupsDataModel.equipmentId);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? InterSubstationModel();
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
        'substation': model.value.toJson()
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
        'substation': model.value.toJson()
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
    model.value = InterSubstationModel.fromJson(data['substation']);
    model.value.title = popupsDataModel.getPopupName();
  }
}

