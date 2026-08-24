// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_cutter_lbs.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../containers/e_drop_down.dart';
import '../../../containers/e_text_area.dart';

class InterCutterLBSScreen extends BasePopupWidget {
  InterCutterLBSScreen({@required PopupsDataModel popupsDataModel}) {
    _controller.popupsDataModel = popupsDataModel;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  static String endPoint = 'cutter-lbs';
  final _InterCutterLBSController _controller = _InterCutterLBSController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EDropDown(CKOptions,
                  index: 0,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  images: _controller.model.value.images,
                  onAttachImages: (images, index) {
                _controller.model.value.setImages(images, index);
              }),
              EDropDown(
                BTNAOptions,
                title: 'Cần chỉ trạng thái đóng cắt',
                index: 1,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.switchingState,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.switchingState = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(TKTNAOptions,
                  title: 'Cơ cấu truyền động đóng, cắt',
                  index: 2,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.movementStructure,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onChange: (option, mess) {
                    _controller.model.value.movementStructure = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  }),
              EDropDown(BTNVOptions,
                  title: 'Cách điện',
                  index: 3,
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
                  }),
              EDropDown(BTNAOptions,
                  title: 'Tiếp xúc tại các đầu cách điện',
                  index: 4,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.contactAtInsulation,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onChange: (option, mess) {
                    _controller.model.value.contactAtInsulation = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  }),
              EDropDown(BTBTDPDBMOptions,
                  title: 'Tiếng kêu',
                  index: 5,
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
                  }),
              EDropDown(BTNAOptions,
                  title: 'Mối nối',
                  index: 6,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.joint,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onChange: (option, mess) {
                    _controller.model.value.joint = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  }),
              EDropDown(BTOptions,
                  title: 'Nối đất, chống sét',
                  index: 7,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.lightningProtection,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onChange: (option, mess) {
                    _controller.model.value.lightningProtection = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  }),
              EDropDown(BTNAOptions,
                  title: 'Đồng hồ chỉ thị áp suất khi SF6',
                  index: 8,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.gasPressure,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onChange: (option, mess) {
                    _controller.model.value.gasPressure = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  }),
              ETextArea(
                title: 'Các hiện tượng cụ thể',
                enable: _controller.popupsDataModel.isAllowEdit,
                isRequire: true,
                value: _controller.model.value.getSpecificPhenomena(),
                onChange: (value) {
                  _controller.model.value.specificPhenomena = value;
                },
              ),
              EDropDown(KCOptions,
                  title: 'Có khả năng gây sự cố',
                  index: 9,
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
                  }),
              EDropDown(KCOptions,
                  title: 'Xử lý ngay trong kiểm tra',
                  index: 10,
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
                    // _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  }),
              ETextArea(
                  title: 'Đề xuất xử lý bất thường/ hư hỏng',
                  enable: _controller.popupsDataModel.isAllowEdit,
                  isRequire: true,
                  value:
                      _controller.model.value.getSuggestedHandlingOfAbnormal(),
                  onChange: (value) {
                    _controller.model.value.specificPhenomena = value;
                  }),
            ],
          )),
    );
  }

  @override
  void saveData() {
    _controller.updateData();
  }
}

class _InterCutterLBSController extends BasePopupController {
  Rx<InterCutterLBS> model = InterCutterLBS().obs;

  void createDefaultIfNeeded() {
    // model.value.switchingState ??= BTOptions.first.value;
    // model.value.movementStructure ??= TKTOptions.first.value;
    // model.value.insulation ??= BTNVOptions.first.value;
    // model.value.contactAtInsulation ??= BTOptions.first.value;
    // model.value.sound ??= BTBTDPDBMOptions.first.value;
    // model.value.joint ??= BTOptions.first.value;
    // model.value.lightningProtection ??= BTOptions.first.value;
    // model.value.gasPressure ??= BTOptions.first.value;
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

  String endPoint = 'cutter-lbs';

  @override
  Future getData() async {
    await super.getData();
    final isConnectInternet = await Connection.shared.checkConnection();
    if (!isConnectInternet) {
      await getOffline(ticketController.ticketID);
    } else {
      final response = await repository.getInterCutterLBS(
          ticketController.ticketID, popupsDataModel.equipmentId, endPoint);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? InterCutterLBS();
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
        'cutterLbs': model.toJson()
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
        'cutterLbs': model.toJson()
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
    model.value = InterCutterLBS.fromJson(data['cutterLbs']);
    model.value.title = popupsDataModel.getPopupName();
  }
}

