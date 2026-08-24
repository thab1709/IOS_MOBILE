// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_disconnectors_switches.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../containers/e_drop_down.dart';
import '../../../containers/e_text_area.dart';

class InterDisconnectorsSwitchesScreen extends BasePopupWidget {
  InterDisconnectorsSwitchesScreen(
      {@required PopupsDataModel popupsDataModel}) {
    _controller.popupsDataModel = popupsDataModel;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  static String endPoint = 'disconnector-switches';
  final _InterDisconnectorsSwitchesController _controller =
      _InterDisconnectorsSwitchesController();

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
                BTNVOptions,
                title: 'Cách điện',
                index: 1,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.insulation1,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                onChange: (option, mess) {
                  _controller.model.value.insulation1 = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(TKTNAOptions,
                  title: 'Bộ truyền động',
                  index: 2,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.transmission,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onChange: (option, mess) {
                    _controller.model.value.transmission = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  }),
              EDropDown(TKTNAOptions,
                  title: 'Tiếp xúc lưỡi dao',
                  index: 3,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.bladeContact,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onChange: (option, mess) {
                    _controller.model.value.bladeContact = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  }),
              EDropDown(BT_NVOptions,
                  title: 'Cách điện',
                  index: 4,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.insulation2,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onChange: (option, mess) {
                    _controller.model.value.insulation2 = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  }),
              EDropDown(TKTNAOptions,
                  title: 'Đồng bộ giữa các lưỡi dao',
                  index: 5,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.synchronizationBlade,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onChange: (option, mess) {
                    _controller.model.value.synchronizationBlade = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  }),
              EDropDown(TKTNAOptions,
                  title: 'Tiếp xúc tại các lưỡi dao và ngàm',
                  index: 6,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.bladesAndMountsCountact,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onChange: (option, mess) {
                    _controller.model.value.bladesAndMountsCountact =
                        option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  }),
              EDropDown(CVKTTNAOptions,
                  title: 'Lưỡi dao',
                  index: 7,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.blade,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onChange: (option, mess) {
                    _controller.model.value.blade = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  }),
              EDropDown(TKTNAOptions,
                  title: 'Lò xo ép tiếp điểm',
                  index: 8,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.contactSpring,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onChange: (option, mess) {
                    _controller.model.value.contactSpring = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  }),
              EDropDown(BTLNAOptions,
                  title: 'Bu lông',
                  index: 9,
                  enable: _controller.popupsDataModel.isAllowEdit,
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
                  }),
              EDropDown(BTRDOptions,
                  title: 'Tiếng kêu',
                  index: 10,
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
                  title: 'Mối nối trung áp',
                  index: 11,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.mediumVoltageJunction,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onChange: (option, mess) {
                    _controller.model.value.mediumVoltageJunction =
                        option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  }),
              EDropDown(BTTDOptions,
                  title: 'Nối đất của DLC',
                  index: 12,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.grounding,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onChange: (option, mess) {
                    _controller.model.value.grounding = option.value;
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
                  index: 13,
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
                  index: 14,
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
                    _controller.model.value.suggestedHandlingOfAbnormal = value;
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

class _InterDisconnectorsSwitchesController extends BasePopupController {
  Rx<InterDisconnectorsSwitches> model = InterDisconnectorsSwitches().obs;

  void createDefaultIfNeeded() {
    // model.value.insulation1 ??= BTNVOptions.first.value;
    // model.value.transmission ??= TKTOptions.first.value;
    // model.value.bladeContact ??= TKTOptions.first.value;
    // model.value.insulation2 ??= BT_NVOptions.first.value;
    // model.value.synchronizationBlade ??= TKTOptions.first.value;
    // model.value.bladesAndMountsCountact ??= TKTOptions.first.value;
    // model.value.blade ??= CVKTTOptions.first.value;
    // model.value.contactSpring ??= TKTOptions.first.value;
    // model.value.bolts ??= BTLOptions.first.value;
    // model.value.sound ??= BTRDOptions.first.value;
    // model.value.mediumVoltageJunction ??= BTOptions.first.value;
    // model.value.grounding ??= BTTDOptions.first.value;
    // model.value.possibleProblematic ??= KCOptions.first.value;
    // model.value.handlingImmediatelyInspection ??= CKOptions.first.value;
  }

  String endPoint = 'disconnector-switches';

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
      await getOffline(ticketController.ticketID);
    } else {
      final response = await repository.getInterDisconnectorsSwitches(
          ticketController.ticketID, popupsDataModel.equipmentId, endPoint);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? InterDisconnectorsSwitches();
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
        'disconnectorsSwitches': model.toJson()
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
        'disconnectorsSwitches': model.toJson()
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
    model.value =
        InterDisconnectorsSwitches.fromJson(data['disconnectorsSwitches']);
    model.value.title = popupsDataModel.getPopupName();
  }
}

