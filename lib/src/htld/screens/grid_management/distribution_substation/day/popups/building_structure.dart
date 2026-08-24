// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/content_option.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/distribution_building_structure.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DistributionBuildingStructurePopup extends BasePopupWidget {
  DistributionBuildingStructurePopup(
      {@required PopupsDataModel popupsDataModel}) {
    _controller.popupsDataModel = popupsDataModel;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  static String endPoint = 'building-structure';
  final _controller = _DistributionBuildingStructureController();

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
                images: _controller.model.value.images,
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                CKOptions,
                enable: _controller.popupsDataModel.isAllowEdit,
                disableImage: true,
                title: 'Hiện hữu',
                defaultValue: _controller.model.value.isExist,
                onChange: (option, mess) {
                  if (_controller.model.value.isExist != option.value) {
                    _controller.model.value.beams = null;
                    _controller.model.value.bolts = null;
                    _controller.model.value.columnFoot = null;
                    _controller.model.value.columns = null;
                    _controller.model.value.columnsNumber = null;
                    _controller.model.value.firePrevention = null;
                    _controller.model.value.illumination = null;
                    _controller.model.value.industrialHygiene = null;
                    _controller.model.value.penetration = null;
                    _controller.model.value.safetyCorridor = null;
                    _controller.model.value.safetySigns = null;
                    _controller.model.value.wireToConnect = null;
                    _controller.model.value.ropes = null;
                    _controller.model.value.clearAllProblem();
                    _controller.model.value.isExist = option.value;
                    Future.delayed(const Duration(milliseconds: 50),
                        _controller.model.refresh);
                  }
                },
              ),
              if (_controller.model.value.isExist == CKOptions.first.value)
                renderContent()
            ],
          )),
    );
  }

  @override
  void saveData() {
    _controller.updateData();
  }

  Widget renderContent() {
    return Column(
      children: [
        EDropDown(
          BTNAOptions,
          title: 'Hành lang an toàn',
          images: _controller.model.value.images,
          index: 1,
          enable: _controller.popupsDataModel.isAllowEdit,
          onSelectedAbnormalOption: (categoryName, abnormal, index) {
            _controller.setAbnormal(
                categoryName, _controller.model.value, abnormal, index);
          },
          defaultValue: _controller.model.value.safetyCorridor,
          onChange: (option, mess) {
            _controller.model.value.safetyCorridor = option.value;
            _controller.model.value.setUnusually(mess);
          },
          onAttachImages: (images, index) {
            _controller.model.value.setImages(images, index);
          },
        ),
        EDropDown(
          TKTNAOptions,
          title: 'Chiếu sáng, thông gió, tính trạng ẩm ướt:',
          index: 2,
          enable: _controller.popupsDataModel.isAllowEdit,
          onSelectedAbnormalOption: (categoryName, abnormal, index) {
            _controller.setAbnormal(
                categoryName, _controller.model.value, abnormal, index);
          },
          images: _controller.model.value.images,
          defaultValue: _controller.model.value.illumination,
          onChange: (option, mess) {
            _controller.model.value.illumination = option.value;
            _controller.model.value.setUnusually(mess);
          },
          onAttachImages: (images, index) {
            _controller.model.value.setImages(images, index);
          },
        ),
        EDropDown(
          TKTNAOptions,
          title: 'Vệ sinh công nghiệp',
          index: 3,
          enable: _controller.popupsDataModel.isAllowEdit,
          onSelectedAbnormalOption: (categoryName, abnormal, index) {
            _controller.setAbnormal(
                categoryName, _controller.model.value, abnormal, index);
          },
          images: _controller.model.value.images,
          defaultValue: _controller.model.value.industrialHygiene,
          onChange: (option, mess) {
            _controller.model.value.industrialHygiene = option.value;
            _controller.model.value.setUnusually(mess);
          },
          onAttachImages: (images, index) {
            _controller.model.value.setImages(images, index);
          },
        ),
        EDropDown(
          BTGGCBDNAOption,
          title: 'Xà, giá đỡ',
          index: 4,
          enable: _controller.popupsDataModel.isAllowEdit,
          onSelectedAbnormalOption: (categoryName, abnormal, index) {
            _controller.setAbnormal(
                categoryName, _controller.model.value, abnormal, index);
          },
          images: _controller.model.value.images,
          defaultValue: _controller.model.value.beams,
          onChange: (option, mess) {
            _controller.model.value.beams = option.value;
            _controller.model.value.setUnusually(mess);
          },
          onAttachImages: (images, index) {
            _controller.model.value.setImages(images, index);
          },
        ),
        EDropDown(
          BTLVNNAOption,
          title: 'Chân cột và móng cột:',
          index: 5,
          enable: _controller.popupsDataModel.isAllowEdit,
          onSelectedAbnormalOption: (categoryName, abnormal, index) {
            _controller.setAbnormal(
                categoryName, _controller.model.value, abnormal, index);
          },
          images: _controller.model.value.images,
          defaultValue: _controller.model.value.columnFoot,
          onChange: (option, mess) {
            _controller.model.value.columnFoot = option.value;
            _controller.model.value.setUnusually(mess);
          },
          onAttachImages: (images, index) {
            _controller.model.value.setImages(images, index);
          },
        ),
        EDropDown(
          BTNGNAOption,
          title: 'Cột:',
          index: 6,
          enable: _controller.popupsDataModel.isAllowEdit,
          onSelectedAbnormalOption: (categoryName, abnormal, index) {
            _controller.setAbnormal(
                categoryName, _controller.model.value, abnormal, index);
          },
          images: _controller.model.value.images,
          defaultValue: _controller.model.value.columns,
          onChange: (option, mess) {
            _controller.model.value.columns = option.value;
            _controller.model.value.setUnusually(mess);
          },
          onAttachImages: (images, index) {
            _controller.model.value.setImages(images, index);
          },
        ),
        EDropDown(
          BTCDGNAOption,
          title: 'Dây néo:',
          index: 7,
          enable: _controller.popupsDataModel.isAllowEdit,
          onSelectedAbnormalOption: (categoryName, abnormal, index) {
            _controller.setAbnormal(
                categoryName, _controller.model.value, abnormal, index);
          },
          images: _controller.model.value.images,
          defaultValue: _controller.model.value.ropes,
          onChange: (option, mess) {
            _controller.model.value.ropes = option.value;
            _controller.model.value.setUnusually(mess);
          },
          onAttachImages: (images, index) {
            _controller.model.value.setImages(images, index);
          },
        ),
        EDropDown(
          BTNAOptions,
          title: 'Bu lông, mối hàn, đinh tán (trụ Pylone):',
          index: 8,
          enable: _controller.popupsDataModel.isAllowEdit,
          onSelectedAbnormalOption: (categoryName, abnormal, index) {
            _controller.setAbnormal(
                categoryName, _controller.model.value, abnormal, index);
          },
          images: _controller.model.value.images,
          defaultValue: _controller.model.value.bolts,
          onChange: (option, mess) {
            _controller.model.value.bolts = option.value;
            _controller.model.value.setUnusually(mess);
          },
          onAttachImages: (images, index) {
            _controller.model.value.setImages(images, index);
          },
        ),
        EDropDown(
          TXSVTNAOptions,
          title: 'Biển báo an toàn:',
          index: 9,
          enable: _controller.popupsDataModel.isAllowEdit,
          onSelectedAbnormalOption: (categoryName, abnormal, index) {
            _controller.setAbnormal(
                categoryName, _controller.model.value, abnormal, index);
          },
          images: _controller.model.value.images,
          defaultValue: _controller.model.value.safetySigns,
          onChange: (option, mess) {
            _controller.model.value.safetySigns = option.value;
            _controller.model.value.setUnusually(mess);
          },
          onAttachImages: (images, index) {
            _controller.model.value.setImages(images, index);
          },
        ),
        EDropDown(
          DTNAOptions,
          title: 'Số cột:',
          index: 10,
          enable: _controller.popupsDataModel.isAllowEdit,
          onSelectedAbnormalOption: (categoryName, abnormal, index) {
            _controller.setAbnormal(
                categoryName, _controller.model.value, abnormal, index);
          },
          images: _controller.model.value.images,
          defaultValue: _controller.model.value.columnsNumber,
          onChange: (option, mess) {
            _controller.model.value.columnsNumber = option.value;
            _controller.model.value.setUnusually(mess);
          },
          onAttachImages: (images, index) {
            _controller.model.value.setImages(images, index);
          },
        ),
        // EDropDown(
        //   BTNAOptions,
        //   title:
        //       'Cửa sổ, cửa ra vào, lỗ thông hơi, hệ thống chiếu sáng, lưới chắn, hệ thống mái che, kết cấu của nhà, tủ đặt MBA:',
        //   index: 11,
        //   images: _controller.model.value.images,
        //   defaultValue: _controller.model.value.structures,
        //   onChange: (option, mess) {
        //     _controller.model.value.structures = option.value;
        //     _controller.model.value.setUnusually(mess);
        //   },
        //   onAttachImages: (images, index) {
        //     _controller.model.value.setImages(images, index);
        //   },
        // ),
        EDropDown(
          DT_KHH_NAOptions,
          title: 'Trang bị phòng, chữa cháy:',
          index: 12,
          enable: _controller.popupsDataModel.isAllowEdit,
          onSelectedAbnormalOption: (categoryName, abnormal, index) {
            _controller.setAbnormal(
                categoryName, _controller.model.value, abnormal, index);
          },
          images: _controller.model.value.images,
          defaultValue: _controller.model.value.firePrevention,
          onChange: (option, mess) {
            _controller.model.value.firePrevention = option.value;
            if (option.value == ContentOptions.notExist.value) {
              mess.message = '';
            }
            _controller.model.value.setUnusually(mess);
          },
          onAttachImages: (images, index) {
            _controller.model.value.setImages(images, index);
          },
        ),
        EDropDown(
          BTTDNAOptions,
          title: 'Dây dẫn đầu nối từ ngoài đường dây vào trạm:',
          index: 13,
          enable: _controller.popupsDataModel.isAllowEdit,
          onSelectedAbnormalOption: (categoryName, abnormal, index) {
            _controller.setAbnormal(
                categoryName, _controller.model.value, abnormal, index);
          },
          images: _controller.model.value.images,
          defaultValue: _controller.model.value.wireToConnect,
          onChange: (option, mess) {
            _controller.model.value.wireToConnect = option.value;
            _controller.model.value.setUnusually(mess);
          },
          onAttachImages: (images, index) {
            _controller.model.value.setImages(images, index);
          },
        ),
        EDropDown(
          BTNVPNAOptions,
          title: 'Sứ xuyên:',
          index: 14,
          enable: _controller.popupsDataModel.isAllowEdit,
          onSelectedAbnormalOption: (categoryName, abnormal, index) {
            _controller.setAbnormal(
                categoryName, _controller.model.value, abnormal, index);
          },
          images: _controller.model.value.images,
          defaultValue: _controller.model.value.penetration,
          onChange: (option, mess) {
            _controller.model.value.penetration = option.value;
            _controller.model.value.setUnusually(mess);
          },
          onAttachImages: (images, index) {
            _controller.model.value.setImages(images, index);
          },
        ),
      ],
    );
  }
}

class _DistributionBuildingStructureController extends BasePopupController {
  Rx<DistributionBuildingStructureModel> model =
      DistributionBuildingStructureModel().obs;

  String endPoint = 'building-structure';

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
      createDefaultIfNeeded();
    } else {
      // To do : check update time between LocalData and ServerData
      final response = await repository.getBuildingStructure(
          ticketController.ticketID, endPoint);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? DistributionBuildingStructureModel();
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
      final params = {'buildingStructure': model.value.toJson()};
      await updateOffine(params, ticketController.ticketID);
      Get.back(result: true);
    } else {
      if (!validateAllData(model.value)) {
        await showDialogValidateData();
        model.refresh();
        return;
      }

      final params = {'buildingStructure': model.value.toJson()};
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
    model.value =
        DistributionBuildingStructureModel.fromJson(data['buildingStructure']);
    model.value.title = popupsDataModel.getPopupName();
  }

  void createDefaultIfNeeded() {
    model?.value?.isExist ??= CKOptions.first.value;
    // model?.value?.safetyCorridor ??= BTOptions.first.value;
    // model?.value?.illumination ??= TKTOptions.first.value;
    // model?.value?.industrialHygiene ??= TKTOptions.first.value;
    // model?.value?.beams ??= BTGGCBDOption.first.value;
    // model?.value?.columnFoot ??= BTLVNOption.first.value;
    // model?.value?.columns ??= BTNGOption.first.value;
    // model?.value?.ropes ??= BTCDGOption.first.value;
    // model?.value?.bolts ??= BTOptions.first.value;
    // model?.value?.safetySigns ??= TXSVTOptions.first.value;
    // model?.value?.columnsNumber ??= DTOptions.first.value;
    // model?.value?.structures ??= BTOptions.first.value;
    // model?.value?.firePrevention ??= DTOptions.first.value;
    // model?.value?.wireToConnect ??= BTTDOptions.first.value;
    // model?.value?.penetration ??= BTNVPOptions.first.value;
  }
}

