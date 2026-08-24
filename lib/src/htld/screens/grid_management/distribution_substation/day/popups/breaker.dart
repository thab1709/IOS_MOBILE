// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/breadker.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../containers/e_drop_down.dart';
import '../../../containers/e_text_area.dart';

class BreakerController extends BasePopupController {
  Rx<Breaker> model = Breaker().obs;

  void createDefaultIfNeeded() {
    // model?.value?.driveStructureClose ??= BTOptions.first.value;
    // model?.value?.insulation ??= BTNVCPBOptions.first.value;
    // model?.value?.contactAtBladeAndMount ??= BTOptions.first.value;
    // model?.value?.blade ??= BTCVHHOption.first.value;
    // model?.value?.contactPressureSpring ??= BTOptions.first.value;
    // model?.value?.bolts ??= BTOptions.first.value;
    // model?.value?.sound ??= BTBTDPDOptions.first.value;
    // model?.value?.isolationKnifeGrounding ??= BTTDOptions.first.value;
    // model?.value?.handleActionLock ??= BTOptions.first.value;
    // model?.value?.possibleProblematic ??= KCOptions.first.value;
    // model?.value?.handlingInCheck ??= KCOptions.first.value;
  }

  String endPoint = 'breaker';

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
      final response = await repository.getBreaker(
          ticketController.ticketID, popupsDataModel.equipmentId, endPoint);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? Breaker();
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
        'breaker': model.value.toJson()
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
        'breaker': model.value.toJson()
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
    model.value = Breaker.fromJson(data['breaker']);
    model.value.title = popupsDataModel.getPopupName();
  }
}

class BreakerPopup extends BasePopupWidget {
  BreakerPopup({@required PopupsDataModel popupsDataModel}) {
    _controller.popupsDataModel = popupsDataModel;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  static String endPoint = 'breaker';
  final BreakerController _controller = BreakerController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EDropDown(
                CKOptions,
                enable: _controller.popupsDataModel.isAllowEdit,
                index: 0,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Cấu trúc truyền động đóng, cắt:',
                index: 1,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.driveStructureClose,
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.driveStructureClose = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNVCPBOptions,
                title: 'Cách điện:',
                index: 2,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.insulation,
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
                BTNAOptions,
                title: 'Tiếp xúc tại lưỡi dao và ngàm: ',
                index: 3,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.contactAtBladeAndMount,
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.contactAtBladeAndMount = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTCVHHNAOption,
                title: 'Lưỡi dao',
                index: 4,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.blade,
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.blade = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Lò xo ép tiếp điểm:',
                index: 5,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.contactPressureSpring,
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.contactPressureSpring = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Bu lông:',
                index: 6,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.bolts,
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
                BTBTDPDNAOptions,
                title: 'Tiếng kêu:',
                index: 7,
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
                BTTDOptions,
                title: 'Nối đất dao cách ly:',
                index: 8,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.isolationKnifeGrounding,
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.isolationKnifeGrounding =
                      option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                title: 'Khóa thao tác của cần thao tác: ',
                index: 9,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.handleActionLock,
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.handleActionLock = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                title: 'Các hiện tượng cụ thể: ',
                value: _controller.model.value.getSpecificPhenomena(),
                enable: _controller.popupsDataModel.isAllowEdit,
                isRequire: true,
                onChange: (value) {
                  _controller.model.value.specificPhenomena = value;
                },
              ),
              EDropDown(
                KCOptions,
                title: 'Có khả năng gây sự cố: ',
                index: 10,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                defaultValue: _controller.model.value.possibleProblematic,
                enable: _controller.popupsDataModel.isAllowEdit,
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
                title: 'Xử lý ngay trong kiểm tra:  ',
                index: 11,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  // _controller.setAbnormal(
                  //     categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.handlingInCheck,
                enable: _controller.popupsDataModel.isAllowEdit,
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

