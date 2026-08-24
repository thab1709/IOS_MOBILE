// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/distribution_grounding_system.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_text_area.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_controller.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DistributionGroundingSystemPopup extends BasePopupWidget {
  DistributionGroundingSystemPopup(
      {@required PopupsDataModel popupsDataModel}) {
    _controller.popupsDataModel = popupsDataModel;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  static String endPoint = 'grounding-system';
  final _DistributionGroundingSystemController _controller =
      _DistributionGroundingSystemController();

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
                NVKNVOption,
                enable: _controller.popupsDataModel.isAllowEdit,
                title: 'Dây tiếp địa:',
                index: 1,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.groundWire,
                onChange: (option, mess) {
                  _controller.model.value.groundWire = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                TKTOptions,
                enable: _controller.popupsDataModel.isAllowEdit,
                title: 'Tiếp xúc của tiếp địa:',
                index: 2,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.theContact,
                onChange: (option, mess) {
                  _controller.model.value.theContact = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTOptions,
                enable: _controller.popupsDataModel.isAllowEdit,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                title: 'Tiếp đất trung tính, đầu cáp:',
                index: 3,
                defaultValue: _controller.model.value.neutralGround,
                onChange: (option, mess) {
                  _controller.model.value.neutralGround = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTOptions,
                title: 'Tiếp đất an toàn:',
                enable: _controller.popupsDataModel.isAllowEdit,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                index: 4,
                defaultValue: _controller.model.value.safeGrounding,
                onChange: (option, mess) {
                  _controller.model.value.safeGrounding = option.value;
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
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                index: 5,
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
                enable: _controller.popupsDataModel.isAllowEdit,
                title: 'Xử lý ngay trong kiểm tra:  ',
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  // _controller.setAbnormal(
                  //     categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                index: 6,
                defaultValue: _controller.model.value.handlingInCheck,
                onChange: (option, mess) {
                  _controller.model.value.handlingInCheck = option.value;
                  // _controller.model.value.setUnusually(mess);
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

class _DistributionGroundingSystemController extends BasePopupController {
  Rx<DistributionGroundingSystem> model = DistributionGroundingSystem().obs;
  final TicketController _ticketController = Get.find();

  String endPoint = 'grounding-system';

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
      await getOffine(_ticketController.ticketID);
    } else {
      // To do : check update time between LocalData and ServerData
      final response = await repository.getGroundingSystem(
          _ticketController.ticketID, endPoint);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? DistributionGroundingSystem();
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
      final params = {'groundingSystem': model.value.toJson()};
      await updateOffine(params, _ticketController.ticketID);
      Get.back(result: true);
    } else {
      if (!validateAllData(model.value)) {
        await showDialogValidateData();
        model.refresh();
        return;
      }
      final params = {'groundingSystem': model.value.toJson()};
      await updateOffine(params, _ticketController.ticketID);
      final response = await repository.updatePopup(
          _ticketController.ticketID, endPoint, params);

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
    model.value = DistributionGroundingSystem.fromJson(data['groundingSystem']);
    model.value.title = popupsDataModel.getPopupName();
  }

  void createDefaultIfNeeded() {
    // model?.value?.groundWire ??= NVKNVOption.first.value;
    // model?.value?.theContact ??= TKTOptions.first.value;
    // model?.value?.neutralGround ??= BTOptions.first.value;
    // model?.value?.possibleProblematic ??= KCOptions.first.value;
    // model?.value?.safeGrounding ??= BTOptions.first.value;
    // model?.value?.handlingInCheck ??= KCOptions.first.value;
  }
}

