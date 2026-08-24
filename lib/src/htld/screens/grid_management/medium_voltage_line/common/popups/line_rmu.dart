// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/equipment_model.dart';
import 'package:evnmobile/src/htld/models/line/line_branch_info.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_rmu.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_line_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_text_area.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RMUPopupController extends BasePopupController {
  Rx<LineRmu> model = LineRmu().obs;

  RxBool measurePartialDischargeOptions = false.obs;

  String endPoint = 'rmu';

  @override
  void refresh() {
    model.refresh();
    super.refresh();
  }

  @override
  Future getData() async {
    await super.getData();
    Future online() async {
      final response = await repository.getLineRmu(
          lineTicketController.ticketId,
          popupsDataModel.equipmentId,
          endPoint,
          lineBranchInfo.id);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? LineRmu();
        model.value.title = popupsDataModel.getPopupName();
        update();
      } else {
        await showDialogError(response.message);
      }
    }

    void offline() {
      final response = LocalDataManager.shared.getLinePopup<LineRmu>(
          lineTicketController.ticketId,
          lineBranchInfo.id,
          popupsDataModel.equipmentId,
          popupsDataModel.inspectionCategory);
      model.value = response ?? LineRmu();
      model.value.title = popupsDataModel.equipmentName;
      update();
    }

    final isHandleDataOnline = await lineTicketController.isHandleDataOnline();

    if (isHandleDataOnline) {
      await online();
    } else {
      offline();
    }

    model.value.measurePartialDischargeOptions ?? CKOptions.first;
  }

  @override
  Future updateData() async {
    if (!validateAllData(model.value)) {
      await showDialogValidateData();
      model.refresh();
      return;
    }

    Future offline({bool isOffline = true}) async {
      model.value.isUpdateOffline = isOffline;
      final result = await LocalDataManager.shared.saveLinePopup<LineRmu>(
          model.value,
          lineTicketController.ticketId,
          lineBranchInfo.id,
          popupsDataModel.equipmentId,
          workId: lineTicketController?.argument?.workModel?.workId,
          ticketType: lineTicketController?.argument?.ticketType,
          isOffline: isOffline,
          inspectionCategory: popupsDataModel.inspectionCategory);
      if (isOffline) {
        if (!result) {
          SnackBarHUD.show(AppStrings.updateOfflineFalse);
          return;
        }
        Get.back(result: true);
        SnackBarHUD.show('Cập nhật offline thành công');
      }
    }

    Future online() async {
      final params = {
        'equipmentId': popupsDataModel.equipmentId,
        'lineRmu': model.value.toJson()
      };

      final response = await repository.updateLinePopup(
          lineTicketController.ticketId, endPoint, params, lineBranchInfo.id);

      if (response.isLoadSuccess) {
        await offline(isOffline: false);
        Get.back(result: true);
        SnackBarHUD.show(response.message);
      } else {
        await showDialogError(response.message);
      }
    }

    final isHandleDataOnline = await lineTicketController.isHandleDataOnline();

    if (isHandleDataOnline) {
      await online();
    } else {
      await offline();
    }
  }

  void setMeasurePartialDischarge() {
    measurePartialDischargeOptions.value =
        model.value.measurePartialDischargeOptions == CKOptions.first.value;
    measurePartialDischargeOptions.refresh();
  }
}

class LineRMUPopup extends BasePopupWidget {
  LineRMUPopup(
      {@required PopupsDataModel popupsDataModel,
      @required LineBranchInfo lineBranchInfo,
      @required this.equipmentModels}) {
    _controller.popupsDataModel = popupsDataModel;
    _controller.lineBranchInfo = lineBranchInfo;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  final RMUPopupController _controller = RMUPopupController();
  final List<EquipmentModel> equipmentModels;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EDropDown(CKOptions,
                  index: 0,
                  enable: _controller.isEnable(),
                  images: _controller.model.value.images,
                  onAttachImages: (images, index) {
                _controller.model.value.setImages(images, index);
              }),
              ELineDropDown(
                BTOptions,
                title:
                    'Tình trạng bên ngoài của các tủ, bảng, hộp đấu dây và các thiết bị',
                index: 1,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 1)
                    ?.toList(),
                
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  _controller.setAbnormalLine(categoryName,
                      _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                  _controller.model.value.setLineUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ELineDropDown(
                BTBTDPDOptions,
                title: 'Tiếng kêu:',
                index: 2,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 2)
                    ?.toList(),
                
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  _controller.setAbnormalLine(categoryName,
                      _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                  _controller.model.value.setLineUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ELineDropDown(
                BTOptions,
                title: 'Cần chỉ trạng thái, cấu trúc truyền động đóng, cắt',
                index: 3,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 3)
                    ?.toList(growable: true),
                
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  _controller.setAbnormalLine(categoryName,
                      _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                  _controller.model.value.setLineUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ELineDropDown(
                DTGasOptions,
                title: 'Khí SF6:',
                index: 4,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 4)
                    ?.toList(),
                
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  _controller.setAbnormalLine(categoryName,
                      _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                  _controller.model.value.setLineUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ELineDropDown(
                BTOptions,
                title: 'Rơle báo sự cố cáp',
                index: 5,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 5)
                    ?.toList(),
                
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  _controller.setAbnormalLine(categoryName,
                      _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                  _controller.model.value.setLineUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ELineDropDown(
                BTOptions,
                title: 'Điện trở sấy',
                index: 6,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 6)
                    ?.toList(),
                
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  _controller.setAbnormalLine(categoryName,
                      _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                  _controller.model.value.setLineUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ELineDropDown(
                BTNVCPBOptions,
                title: 'Cách điện',
                index: 7,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 7)
                    ?.toList(),
                
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  _controller.setAbnormalLine(categoryName,
                      _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                  _controller.model.value.setLineUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                CKOptions,
                title: 'Có thiết bị đo phóng điện cục bộ (PD)',
                index: 8,
                enable: _controller.isEnable(),
                disableImage: true,
                defaultValue:
                    _controller.model.value.measurePartialDischargeOptions,
                onChange: (option, mess) {
                  _controller.model.value.measurePartialDischargeOptions =
                      option.value;
                  _controller.setMeasurePartialDischarge();
                },
              ),
              Obx(() {
                if (_controller.measurePartialDischargeOptions.value) {
                  return ETextArea(
                    title: 'Đo phóng điện cục bộ (PD)',
                    isRequire: true,
                    enable: _controller.isEnable(),
                    value:
                        _controller.model.value?.measurePartialDischarge ?? '',
                    onChange: (value) {
                      _controller.model.value.measurePartialDischarge = value;
                    },
                  );
                } else {
                  return const SizedBox();
                }
              }),
              ELineDropDown(
                BTOptions,
                title: 'Lò xo ép tiếp điểm',
                index: 9,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 9)
                    ?.toList(),
                
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  _controller.setAbnormalLine(categoryName,
                      _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                  _controller.model.value.setLineUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ELineDropDown(
                BTOptions,
                title: 'Bu lông',
                index: 10,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 10)
                    ?.toList(),
                
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  _controller.setAbnormalLine(categoryName,
                      _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                  _controller.model.value.setLineUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ELineDropDown(
                BTOptions,
                title: 'Nối đất của thiết bị',
                index: 11,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 11)
                    ?.toList(),
                
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  _controller.setAbnormalLine(categoryName,
                      _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                  _controller.model.value.setLineUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                title: 'Các hiện tượng cụ thể',
                isRequire: true,
                enable: _controller.isEnable(),
                value: _controller.model.value.getSpecificPhenomena(),
                onChange: (value) {
                  _controller.model.value.specificPhenomena = value;
                },
              ),
              ELineDropDown(
                KCOptions,
                title: 'Có khả năng gây sự cố',
                index: 12,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 12)
                    ?.toList(),
                
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  _controller.setAbnormalLine(categoryName,
                      _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                  _controller.model.value.setLineUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ELineDropDown(
                KCOptions,
                title: 'Xử lý ngay trong kiểm tra',
                index: 13,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 13)
                    ?.toList(),
                
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  // _controller.setAbnormalLine(categoryName,
                  //     _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  //Task #55175
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                title: 'Đề xuất xử lý bất thường/ hư hỏng',
                isRequire: true,
                enable: _controller.isEnable(),
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

