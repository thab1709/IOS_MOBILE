// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/substation.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../containers/e_drop_down.dart';
import '../../../containers/e_text_area.dart';

class SubstationController extends BasePopupController {
  Rx<Substation> model = Substation().obs;

  void createDefaultIfNeeded() {
    // model.value.voice ??= BTOptions.first.value;
    // model.value.caseSubstation ??= BTCDHHOptions.first.value;
    // model.value.subOilTankLevel ??= DTOptions.first.value;
    // model.value.color ??= TKTOptions.first.value;
    // model.value.insulation ??= BTNVCPBOptions.first.value;
    // model.value.contactHeatGeneration ??= KCOptions.first.value;
    // model.value.groundingSystem ??= BTOptions.first.value;
    // model.value.desiccantColor ??= BTOptions.first.value;
    // model.value.radiatorFins ??= BTOptions.first.value;
    // model.value.possibleProblematic ??= KCOptions.first.value;
    // model.value.handingInCheck ??= CKOptions.first.value;
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

  String endPoint = 'substation';

  @override
  Future getData() async {
    await super.getData();
    final isConnectInternet = await Connection.shared.checkConnection();

    if (!isConnectInternet) {
      await getOffine(ticketController.ticketID);
    } else {
      final response = await repository.getSubstation(
          ticketController.ticketID, popupsDataModel.equipmentId);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? Substation();
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
        'substation': model.value.toJSON()
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
        'substation': model.value.toJSON()
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
    model.value = Substation.fromJson(data['substation']);

    model.value.title = popupsDataModel.getPopupName();
  }
}

class SubstationPopup extends BasePopupWidget {
  SubstationPopup({@required PopupsDataModel popupsDataModel}) {
    _controller.popupsDataModel = popupsDataModel;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  final SubstationController _controller = SubstationController();
  static String endPoint = 'substation';

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
                BTOptions,
                index: 1,
                enable: _controller.popupsDataModel.isAllowEdit,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.voice,
                title: 'Tiếng kêu:',
                onChange: (option, mess) {
                  _controller.model.value.voice = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTCDHHOptions,
                index: 2,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.caseSubstation,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                title: 'Vỏ máy',
                onChange: (option, mess) {
                  _controller.model.value.caseSubstation = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                OilNAOptions,
                index: 3,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.subOilTankLevel,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                title: 'Mức dầu trong bình dầu phụ:',
                onChange: (option, mess) {
                  _controller.model.value.subOilTankLevel = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                TKTNAOptions,
                index: 4,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.color,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                title: 'Màu sắc:',
                onChange: (option, mess) {
                  _controller.model.value.color = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNVCPBOptions,
                index: 5,
                enable: _controller.popupsDataModel.isAllowEdit,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.insulation,
                title: 'Cách điện (Sứ đầu vào):',
                onChange: (option, mess) {
                  _controller.model.value.insulation = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                KCOptions,
                index: 6,
                enable: _controller.popupsDataModel.isAllowEdit,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.contactHeatGeneration,
                title: 'Phát nhiệt tiếp xúc:',
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
                index: 7,
                enable: _controller.popupsDataModel.isAllowEdit,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.groundingSystem,
                title: 'Hệ thống nối đất',
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
                index: 8,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.desiccantColor,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                title: 'Mầu sắc của hạt hút ẩm trong bình thở: ',
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
                index: 9,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.radiatorFins,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                title: 'Cánh tản nhiệt: ',
                onChange: (option, mess) {
                  _controller.model.value.radiatorFins = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                  title: 'Các hiện tượng cụ thể: ',
                  isRequire: true,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  value: _controller.model.value.getSpecificPhenomena(),
                  onChange: (value) {
                    _controller.model.value.specificPhenomena = value;
                  }),
              EDropDown(
                KCOptions,
                index: 10,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.possibleProblematic,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                title: 'Có khả năng gây sự cố: ',
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
                index: 11,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.handingInCheck,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  // _controller.setAbnormal(
                  //     categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                title: 'Xử lý ngay trong kiểm tra:  ',
                onChange: (option, mess) {
                  _controller.model.value.handingInCheck = option.value;
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

