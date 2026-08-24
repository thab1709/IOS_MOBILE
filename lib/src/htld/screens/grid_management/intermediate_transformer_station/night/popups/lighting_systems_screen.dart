// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/light_system_night.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../containers/e_drop_down.dart';
import '../../../containers/e_text_area.dart';

class InterLightSystemNightController extends BasePopupController {
  Rx<LightSystemNight> model = LightSystemNight().obs;

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

  static String endPoint = 'lighting-system';

  @override
  Future getData() async {
    await super.getData();
    final isConnectInternet = await Connection.shared.checkConnection();
    if (!isConnectInternet) {
      await getOffline(ticketController.ticketID);
    } else {
      final response = await repository.getInterLightSystemNight(
          ticketController.ticketID, endPoint);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? LightSystemNight();
        createDefaultIfNeeded();
        model.value.title = popupsDataModel.getPopupName();
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
      final params = {'lightingSystemNightTime': model.value.toJson()};

      await updateOffline(params, ticketController.ticketID);
      Get.back(result: true);
    } else {
      if (!validateAllData(model.value)) {
        await showDialogValidateData();
        model.refresh();
        return;
      }
      final params = {'lightingSystemNightTime': model.value.toJson()};

      await updateOffline(params, ticketController.ticketID);

      final response = await repository.updateInterNightPopup(
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
    model.value = LightSystemNight.fromJson(data['lightingSystemNightTime']);
    model.value.title = popupsDataModel.getPopupName();
  }

  void createDefaultIfNeeded() {
    // model.value.operatingStatus ??= TKTOptions.first.value;
    // model.value.possibleProblematic ??= KCOptions.first.value;
    // model.value.handlingInCheck ??= KCOptions.first.value;
  }
}

class LightingSystemsScreen extends BasePopupWidget {
  final InterLightSystemNightController _controller =
      InterLightSystemNightController();

  LightingSystemsScreen({@required PopupsDataModel popupsDataModel}) {
    _controller.popupsDataModel = popupsDataModel;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  static String endPoint = 'lighting-system';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Obx(
      () => Column(
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
            disableImage: true,
            index: 100,
            enable: _controller.popupsDataModel.isAllowEdit,
            defaultValue: _controller.model.value.isExist ?? true
                ? CKOptions.first.value
                : CKOptions.last.value,
            images: _controller.model.value.images,
            title: 'Hiện hữu:',
            onChange: (option, mess) {
            if (_controller.model.value.isExist != (option.value == CKOptions.first.value)) {
              _controller.model.value.clearAllProblem();
              _controller.model.value.operatingStatus = null;
              _controller.model.value.possibleProblematic = null;
              _controller.model.value.handlingInCheck = null;
              _controller.model.value.isExist = option.value == CKOptions.first.value;
              _controller.model.refresh();
              }

            },
            onAttachImages: (images, index) {
              _controller.model.value.setImages(images, index);
            },
          ),
          if (_controller.model.value.isExist ?? true)
            Column(
              children: [
                EDropDown(TKTOptions,
                    enable: _controller.popupsDataModel.isAllowEdit,
                    index: 1,
                    title: 'Tình trạng vận hành',
                    defaultValue: _controller.model.value.operatingStatus,
                    onChange: (option, mess) {
                      _controller.model.value.operatingStatus = option.value;
                      _controller.model.value.setUnusually(mess);
                    },
                    onSelectedAbnormalOption: (categoryName, abnormal, index) {
                      _controller.setAbnormal(categoryName,
                          _controller.model.value, abnormal, index);
                    },
                    images: _controller.model.value.images,
                    onAttachImages: (images, index) {
                      _controller.model.value.setImages(images, index);
                    }),
                ETextArea(
                  title: 'Các hiện tượng cụ thể',
                  enable: _controller.popupsDataModel.isAllowEdit,
                  value: _controller.model.value.getSpecificPhenomena(),
                  isRequire: true,
                  onChange: (value) {
                    _controller.model.value.specificPhenomena = value;
                  },
                ),
                EDropDown(
                  KCOptions,
                  title: 'Có khả năng gây sự cố',
                  index: 2,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.possibleProblematic,
                  onChange: (option, mess) {
                    _controller.model.value.possibleProblematic = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
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
                  KCOptions,
                  title: 'Xử lý ngay trong kiểm tra',
                  enable: _controller.popupsDataModel.isAllowEdit,
                  index: 3,
                  defaultValue: _controller.model.value.handlingInCheck,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    // _controller.setAbnormal(
                    //     categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onChange: (option, mess) {
                    _controller.model.value.handlingInCheck = option.value;
                    //_controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  },
                ),
                ETextArea(
                  title: 'Đề xuất xử lý bất thường/hư hỏng',
                  enable: _controller.popupsDataModel.isAllowEdit,
                  value:
                      _controller.model.value.getSuggestedHandlingOfAbnormal(),
                  isRequire: true,
                  onChange: (value) {
                    _controller.model.value.suggestedHandlingOfAbnormal = value;
                  },
                )
              ],
            )
        ],
      ),
    ));
  }

  @override
  void saveData() {
    _controller.updateData();
  }
}

