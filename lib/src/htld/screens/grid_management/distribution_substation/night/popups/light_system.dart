// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../../models/day_night/popups/lighting_system_night_time.dart';
import '../../../containers/e_drop_down.dart';
import '../../../containers/e_text_area.dart';

class LightSystemController extends BasePopupController {
  Rx<LightingSystemNightTime> model = LightingSystemNightTime().obs;

  void createDefaultIfNeeded() {
    model.value.isExist ??= true;
    // model.value.operatingStatus ??= BTOptions.first.value;
    // model.value.possibleProblematic ??= KCOptions.first.value;
    // model.value.handlingInCheck ??= KCOptions.first.value;
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

  String endPoint = 'lighting-system';

  @override
  Future getData() async {
    await super.getData();
    final isConnectInternet = await Connection.shared.checkConnection();

    if (!isConnectInternet) {
      await getOffine(ticketController.ticketID);
      createDefaultIfNeeded();
    } else {
      // To do : check update time between LocalData and ServerData
      final response = await repository.getLightingSystemNightTime(
          ticketController.ticketID, endPoint);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? LightingSystemNightTime();
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
    final result = await InternetConnectionChecker().hasConnection;

    if (!result) {
      if (!validateAllData(model.value)) {
        await showDialogValidateData();
        model.refresh();
        return;
      }
      final params = {'lightingSystemNightTime': model.value.toJson()};
      await updateOffine(params, ticketController.ticketID);
      Get.back(result: true);
    } else {
      if (!validateAllData(model.value)) {
        await showDialogValidateData();
        model.refresh();
        return;
      }
      final params = {'lightingSystemNightTime': model.value.toJson()};
      await updateOffine(params, ticketController.ticketID);
      final response = await repository.updateDistributionNightPopup(
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
    model.value =
        LightingSystemNightTime.fromJson(data['lightingSystemNightTime']);
    model.value.title = popupsDataModel.getPopupName();
  }
}

class LightSystemPopup extends BasePopupWidget {
  LightSystemPopup({@required PopupsDataModel popupsDataModel}) {
    _controller.popupsDataModel = popupsDataModel;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  static String endPoint = 'lighting-system';
  final LightSystemController _controller = LightSystemController();

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
                CKOptions,
                disableImage: true,
                enable: _controller.popupsDataModel.isAllowEdit,
                index: 100,
                defaultValue: _controller.model.value.isExist ?? true
                    ? CKOptions.first.value
                    : CKOptions.last.value,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  // _controller.setAbnormal(
                  //     categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                title: 'Hiện hữu:',
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
                onChange: (option, mess) {
                  if (_controller.model.value.isExist != (option.value == CKOptions.first.value)) {
                    _controller.model.value.handlingInCheck = null;
                    _controller.model.value.operatingStatus = null;
                    _controller.model.value.possibleProblematic = null;
                    _controller.model.value.clearAllProblem();
                    _controller.model.value.isExist = option.value == CKOptions.first.value;
                    Future.delayed(const Duration(milliseconds: 50), _controller.model.refresh);
                  }

                },
              ),
              if (_controller.model.value.isExist ?? true)
                Column(
                  children: [
                    EDropDown(
                      BTOptions,
                      onSelectedAbnormalOption:
                          (categoryName, abnormal, index) {
                        _controller.setAbnormal(categoryName,
                            _controller.model.value, abnormal, index);
                      },
                      images: _controller.model.value.images,
                      enable: _controller.popupsDataModel.isAllowEdit,
                      index: 1,
                      title: 'Tình trạng vận hành:',
                      onAttachImages: (images, index) {
                        _controller.model.value.setImages(images, index);
                      },
                      defaultValue: _controller.model.value.operatingStatus,
                      onChange: (option, message) {
                        _controller.model.value.operatingStatus = option.value;
                        _controller.model.value.setUnusually(message);
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
                      enable: _controller.popupsDataModel.isAllowEdit,
                      index: 2,
                      onSelectedAbnormalOption:
                          (categoryName, abnormal, index) {
                        _controller.setAbnormal(categoryName,
                            _controller.model.value, abnormal, index);
                      },
                      images: _controller.model.value.images,
                      onAttachImages: (images, index) {
                        _controller.model.value.setImages(images, index);
                      },
                      defaultValue: _controller.model.value.possibleProblematic,
                      onChange: (option, message) {
                        _controller.model.value.possibleProblematic =
                            option.value;
                        _controller.model.value.setUnusually(message);
                      },
                    ),
                    EDropDown(
                      KCOptions,
                      index: 3,
                      onSelectedAbnormalOption:
                          (categoryName, abnormal, index) {
                        // _controller.setAbnormal(
                        //     categoryName, _controller.model.value, abnormal, index);
                      },
                      images: _controller.model.value.images,
                      enable: _controller.popupsDataModel.isAllowEdit,
                      title: 'Xử lý ngay trong kiểm tra:  ',
                      onAttachImages: (images, index) {
                        _controller.model.value.setImages(images, index);
                      },
                      defaultValue: _controller.model.value.handlingInCheck,
                      onChange: (option, message) {
                        _controller.model.value.handlingInCheck = option.value;
                        //_controller.model.value.setUnusually(message);
                      },
                    ),
                    ETextArea(
                      title: 'Đề xuất xử lý bất thường/ hư hỏng:',
                      value: _controller.model.value
                          .getSuggestedHandlingOfAbnormal(),
                      enable: _controller.popupsDataModel.isAllowEdit,
                      isRequire: true,
                      onChange: (value) {
                        _controller.model.value.suggestedHandlingOfAbnormal =
                            value;
                      },
                    ),
                  ],
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

