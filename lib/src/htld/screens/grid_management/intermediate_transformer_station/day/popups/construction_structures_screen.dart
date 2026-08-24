// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_construction_structure.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../containers/e_drop_down.dart';
import '../../../containers/e_text_area.dart';

class ConstructionStructuresScreen extends BasePopupWidget {
  ConstructionStructuresScreen({@required PopupsDataModel popupsDataModel}) {
    _controller.popupsDataModel = popupsDataModel;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  static String endPoint = 'construction-structure';
  final _controller = _ConstructionStructuresController();

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
                CKOptions,
                disableImage: true,
                enable: _controller.popupsDataModel.isAllowEdit,
                title: 'Hiện hữu',
                defaultValue: _controller.model.value.isExist,
                onChange: (option, mess) {
                  if (_controller.model.value.isExist != option.value) {
                    _controller.model.value.clearAllProblem();
                    _controller.model.value.condition = null;
                    _controller.model.value.beamSystem = null;
                    _controller.model.value.bolt = null;
                    _controller.model.value.columns = null;
                    _controller.model.value.bracket = null;
                    _controller.model.value.foundation = null;
                    _controller.model.value.ropes = null;
                    _controller.model.value.weld = null;
                    _controller.model.value.ground = null;
                    _controller.model.value.covers = null;
                    _controller.model.value.possibleProblematic = null;
                    _controller.model.value.handlingImmediatelyInspection = null;
                    _controller.model.value.isExist = option.value;
                    Future.delayed(const Duration(milliseconds: 50),
                        _controller.model.refresh);
                  }
                },
              ),
              if (_controller.model.value.isExist == CKOptions.first.value)
                Column(
                  children: [
                    EDropDown(
                      TKTOptions,
                      title: 'Tình trạng',
                      index: 1,
                      enable: _controller.popupsDataModel.isAllowEdit,
                      defaultValue: _controller.model.value.condition,
                      onSelectedAbnormalOption:
                          (categoryName, abnormal, index) {
                        _controller.setAbnormal(categoryName,
                            _controller.model.value, abnormal, index);
                      },
                      images: _controller.model.value.images,
                      onChange: (option, mess) {
                        _controller.model.value.condition = option.value;
                        _controller.model.value.setUnusually(mess);
                      },
                      onAttachImages: (images, index) {
                        _controller.model.value.setImages(images, index);
                      },
                    ),
                    EDropDown(
                      BTGGNAOptions,
                      title: 'Hệ thống xà',
                      index: 2,
                      enable: _controller.popupsDataModel.isAllowEdit,
                      defaultValue: _controller.model.value.beamSystem,
                      onSelectedAbnormalOption:
                          (categoryName, abnormal, index) {
                        _controller.setAbnormal(categoryName,
                            _controller.model.value, abnormal, index);
                      },
                      images: _controller.model.value.images,
                      onChange: (option, mess) {
                        _controller.model.value.beamSystem = option.value;
                        _controller.model.value.setUnusually(mess);
                      },
                      onAttachImages: (images, index) {
                        _controller.model.value.setImages(images, index);
                      },
                    ),
                    EDropDown(
                      NVKNVNAOption,
                      title: 'Bu lông bắt xà',
                      index: 3,
                      enable: _controller.popupsDataModel.isAllowEdit,
                      defaultValue: _controller.model.value.bolt,
                      onSelectedAbnormalOption:
                          (categoryName, abnormal, index) {
                        _controller.setAbnormal(categoryName,
                            _controller.model.value, abnormal, index);
                      },
                      images: _controller.model.value.images,
                      onChange: (option, mess) {
                        _controller.model.value.bolt = option.value;
                        _controller.model.value.setUnusually(mess);
                      },
                      onAttachImages: (images, index) {
                        _controller.model.value.setImages(images, index);
                      },
                    ),
                    EDropDown(
                      BTNMNAOption,
                      title: 'Cột',
                      index: 4,
                      enable: _controller.popupsDataModel.isAllowEdit,
                      defaultValue: _controller.model.value.columns,
                      onSelectedAbnormalOption:
                          (categoryName, abnormal, index) {
                        _controller.setAbnormal(categoryName,
                            _controller.model.value, abnormal, index);
                      },
                      images: _controller.model.value.images,
                      onChange: (option, mess) {
                        _controller.model.value.columns = option.value;
                        _controller.model.value.setUnusually(mess);
                      },
                      onAttachImages: (images, index) {
                        _controller.model.value.setImages(images, index);
                      },
                    ),
                    EDropDown(
                      BTCBDGNAOption,
                      title: 'Giá đỡ',
                      index: 5,
                      enable: _controller.popupsDataModel.isAllowEdit,
                      defaultValue: _controller.model.value.bracket,
                      onSelectedAbnormalOption:
                          (categoryName, abnormal, index) {
                        _controller.setAbnormal(categoryName,
                            _controller.model.value, abnormal, index);
                      },
                      images: _controller.model.value.images,
                      onChange: (option, mess) {
                        _controller.model.value.bracket = option.value;
                        _controller.model.value.setUnusually(mess);
                      },
                      onAttachImages: (images, index) {
                        _controller.model.value.setImages(images, index);
                      },
                    ),
                    EDropDown(
                      BTLVNNAOption,
                      title: 'Móng',
                      index: 6,
                      enable: _controller.popupsDataModel.isAllowEdit,
                      defaultValue: _controller.model.value.foundation,
                      onSelectedAbnormalOption:
                          (categoryName, abnormal, index) {
                        _controller.setAbnormal(categoryName,
                            _controller.model.value, abnormal, index);
                      },
                      images: _controller.model.value.images,
                      onChange: (option, mess) {
                        _controller.model.value.foundation = option.value;
                        _controller.model.value.setUnusually(mess);
                      },
                      onAttachImages: (images, index) {
                        _controller.model.value.setImages(images, index);
                      },
                    ),
                    EDropDown(
                      BTCDGNAOption,
                      title: 'Dây néo',
                      index: 7,
                      enable: _controller.popupsDataModel.isAllowEdit,
                      defaultValue: _controller.model.value.ropes,
                      onSelectedAbnormalOption:
                          (categoryName, abnormal, index) {
                        _controller.setAbnormal(categoryName,
                            _controller.model.value, abnormal, index);
                      },
                      images: _controller.model.value.images,
                      onChange: (option, mess) {
                        _controller.model.value.ropes = option.value;
                        _controller.model.value.setUnusually(mess);
                      },
                      onAttachImages: (images, index) {
                        _controller.model.value.setImages(images, index);
                      },
                    ),
                    EDropDown(
                      KHNAOption,
                      title: 'Mối hàn',
                      index: 8,
                      enable: _controller.popupsDataModel.isAllowEdit,
                      defaultValue: _controller.model.value.weld,
                      onSelectedAbnormalOption:
                          (categoryName, abnormal, index) {
                        _controller.setAbnormal(categoryName,
                            _controller.model.value, abnormal, index);
                      },
                      images: _controller.model.value.images,
                      onChange: (option, mess) {
                        _controller.model.value.weld = option.value;
                        _controller.model.value.setUnusually(mess);
                      },
                      onAttachImages: (images, index) {
                        _controller.model.value.setImages(images, index);
                      },
                    ),
                    EDropDown(
                      BTOptions,
                      title: 'Nối đất',
                      index: 9,
                      enable: _controller.popupsDataModel.isAllowEdit,
                      defaultValue: _controller.model.value.ground,
                      onSelectedAbnormalOption:
                          (categoryName, abnormal, index) {
                        _controller.setAbnormal(categoryName,
                            _controller.model.value, abnormal, index);
                      },
                      images: _controller.model.value.images,
                      onChange: (option, mess) {
                        _controller.model.value.ground = option.value;
                        _controller.model.value.setUnusually(mess);
                      },
                      onAttachImages: (images, index) {
                        _controller.model.value.setImages(images, index);
                      },
                    ),
                    EDropDown(
                      BTNAOptions,
                      title:
                          'Lưới chống chim, chuột, mương cáp và các tấm che mương cáp, hệ thống thoát nước, dầu',
                      index: 10,
                      enable: _controller.popupsDataModel.isAllowEdit,
                      defaultValue: _controller.model.value.covers,
                      onSelectedAbnormalOption:
                          (categoryName, abnormal, index) {
                        _controller.setAbnormal(categoryName,
                            _controller.model.value, abnormal, index);
                      },
                      images: _controller.model.value.images,
                      onChange: (option, mess) {
                        _controller.model.value.covers = option.value;
                        _controller.model.value.setUnusually(mess);
                      },
                      onAttachImages: (images, index) {
                        _controller.model.value.setImages(images, index);
                      },
                    ),
                    // EDropDown(BTNAOptions, title: 'Cửa sổ, cửa ra vào, lỗ thông hơi, hệ thống chiếu sáng, lưới chắn, hệ thống mái che, chống thấm, dột... cửa nhà điều khiển',
                    //   index: 11,
                    //   enable: _controller.popupsDataModel.isAllowEdit,
                    //   defaultValue: _controller.model.value.operator,
                    //   images: _controller.model.value.images,
                    //   onChange: (option, mess) {
                    //     _controller.model.value.operator = option.value;
                    //     _controller.model.value.setUnusually(mess);
                    //   },
                    //   onAttachImages: (images, index) {
                    //     _controller.model.value.setImages(images, index);
                    //   },
                    // ),
                    ETextArea(
                      title: 'Các hiện tượng cụ thể',
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
                      index: 12,
                      enable: _controller.popupsDataModel.isAllowEdit,
                      defaultValue: _controller.model.value.possibleProblematic,
                      onSelectedAbnormalOption:
                          (categoryName, abnormal, index) {
                        _controller.setAbnormal(categoryName,
                            _controller.model.value, abnormal, index);
                      },
                      images: _controller.model.value.images,
                      onChange: (option, mess) {
                        _controller.model.value.possibleProblematic =
                            option.value;
                        _controller.model.value.setUnusually(mess);
                      },
                      onAttachImages: (images, index) {
                        _controller.model.value.setImages(images, index);
                      },
                    ),
                    EDropDown(
                      KCOptions,
                      title: 'Xử lý ngay trong kiểm tra',
                      index: 13,
                      enable: _controller.popupsDataModel.isAllowEdit,
                      defaultValue:
                          _controller.model.value.handlingImmediatelyInspection,
                      onSelectedAbnormalOption:
                          (categoryName, abnormal, index) {
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
                      title: 'Đề xuất xử lý bất thường/hư hỏng',
                      isRequire: true,
                      enable: _controller.popupsDataModel.isAllowEdit,
                      value: _controller.model.value
                          .getSuggestedHandlingOfAbnormal(),
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

class _ConstructionStructuresController extends BasePopupController {
  Rx<InterConstructionStructure> model = InterConstructionStructure().obs;

  void createDefaultIfNeeded() {
    model.value.isExist ??= CKOptions.first.value;
    // model.value.condition ??= TKTOptions.first.value;
    // model.value.beamSystem ??= BTGGOptions.first.value;
    // model.value.bolt ??= NVKNVOption.first.value;
    // model.value.columns ??= BTNMOption.first.value;
    // model.value.bracket ??= BTCBDGOption.first.value;
    // model.value.foundation ??= BTOptions.first.value;
    // model.value.ropes ??= BTLVNOption.first.value;
    // model.value.weld ??= KHOption.first.value;
    // model.value.ground ??= BTOptions.first.value;
    // model.value.covers ??= BTOptions.first.value;
    // model.value.operator ??= BTOptions.first.value;
    // model.value.possibleProblematic ??= KCOptions.first.value;
    // model.value.handlingImmediatelyInspection ??= CKOptions.first.value;
  }

  String endPoint = 'construction-structure';

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
      final response = await repository.getInterConstructionStructure(
          ticketController.ticketID, endPoint);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? InterConstructionStructure();
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
      final params = {'constructionStructure': model.value.toJson()};

      await updateOffline(params, ticketController.ticketID);
      Get.back(result: true);
    } else {
      if (!validateAllData(model.value)) {
        await showDialogValidateData();
        model.refresh();
        return;
      }
      final params = {'constructionStructure': model.value.toJson()};
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
        InterConstructionStructure.fromJson(data['constructionStructure']);
    model.value.title = popupsDataModel.getPopupName();
  }
}

