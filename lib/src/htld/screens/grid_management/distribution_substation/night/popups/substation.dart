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

import '../../../../../models/day_night/popups/substation_night_time.dart';
import '../../../containers/e_drop_down.dart';
import '../../../containers/e_text_area.dart';

class SubStationController extends BasePopupController {
  Rx<SubstationNightTime> model = SubstationNightTime().obs;

  void createDefaultIfNeeded() {
    // model.value.unusualSound ??= KCOptions.first.value;
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

  String endPoint = 'substation';

  @override
  Future getData() async {
    await super.getData();
    final isConnectInternet = await Connection.shared.checkConnection();

    if (!isConnectInternet) {
      await getOffine(ticketController.ticketID);
    } else {
      // To do : check update time between LocalData and ServerData
      final response = await repository.getTransformerNightTime(
          ticketController.ticketID, endPoint);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? SubstationNightTime();
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
      final params = {'substationNightTime': model.value.toJson()};
      await updateOffine(params, ticketController.ticketID);
      Get.back(result: true);
    } else {
      if (!validateAllData(model.value)) {
        await showDialogValidateData();
        model.refresh();
        return;
      }
      final params = {'substationNightTime': model.value.toJson()};
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
    model.value = SubstationNightTime.fromJson(data['substationNightTime']);
    model.value.title = popupsDataModel.getPopupName();
  }
}

class SubStationNightTimePopup extends BasePopupWidget {
  SubStationNightTimePopup({@required PopupsDataModel popupsDataModel}) {
    _controller.popupsDataModel = popupsDataModel;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  static String endPoint = 'substation';
  final SubStationController _controller = SubStationController();

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
                KCOptions,
                index: 1,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value?.unusualSound,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                title: 'Tiếng phóng điện, âm thanh bất thường:',
                onChange: (option, mess) {
                  _controller.model.value?.unusualSound = option.value;
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
                index: 2,
                title: 'Có khả năng gây sự cố: ',
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                enable: _controller.popupsDataModel.isAllowEdit,
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
                index: 3,
                title: 'Xử lý ngay trong kiểm tra:  ',
                enable: _controller.popupsDataModel.isAllowEdit,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  // _controller.setAbnormal(
                  //     categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value?.handlingInCheck,
                onChange: (option, mess) {
                  _controller.model.value?.handlingInCheck = option.value;
                  //_controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                title: 'Đề xuất xử lý bất thường/ hư hỏng:',
                value: _controller.model.value.getSuggestedHandlingOfAbnormal(),
                enable: _controller.popupsDataModel.isAllowEdit,
                isRequire: true,
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

