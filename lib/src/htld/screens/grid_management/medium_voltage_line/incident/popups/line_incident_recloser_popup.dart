// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/equipment_model.dart';
import 'package:evnmobile/src/htld/models/line/line_branch_info.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_recloser_model.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/common/constance/line_content_option.dart';
import 'package:evnmobile/src/htld/common/constance/content_option.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_line_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../containers/e_drop_down.dart';
import '../../../containers/e_text_area.dart';

class LineIncidentRecloserPopup extends BasePopupWidget {
  LineIncidentRecloserPopup(
      {@required PopupsDataModel popupsDataModel,
      @required LineBranchInfo lineBranchInfo,
      @required this.equipmentModels}) {
    _controller.popupsDataModel = popupsDataModel;
    _controller.lineBranchInfo = lineBranchInfo;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  final List<EquipmentModel> equipmentModels;

  final _controller = LineRecloserController();

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
                LineOption.DBVH_BT_Option,
                title: 'TU cấp nguồn và các thiết bị khác',
                index: 1,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                defaultValue: _controller.model.value
                    .getProblemValue(1, LineContentOption.ensureOperation),
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
                LineOption.DBVH_BT_Option,
                title: 'Cảnh báo sự cố',
                index: 2,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                defaultValue: _controller.model.value
                    .getProblemValue(2, LineContentOption.ensureOperation),
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
              ETextArea(
                title: 'Các hiện tượng cụ thể',
                isRequire: true,
                enable: _controller.isEnable(),
                value:
                    _controller.model.value.getSpecificPhenomena() ?? "Không",
                onChange: (value) {
                  _controller.model.value.specificPhenomena = value;
                },
              ),
              ELineDropDown(
                LineOption.K_C_Option,
                title: 'Xử lý ngay trong kiểm tra',
                index: 3,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                defaultValue: _controller.model.value
                    .getProblemValue(3, LineContentOption.no),
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 3)
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
                value:
                    _controller.model.value.getSuggestedHandlingOfAbnormal() ??
                        "Không",
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

class LineRecloserController extends BasePopupController {
  Rx<LineRecloserModel> model = LineRecloserModel().obs;

  String endPoint = 'recloser';

  @override
  void refresh() {
    model.refresh();
    super.refresh();
  }

  @override
  Future getData() async {
    await super.getData();
    Future online() async {
      final response = await repository.getLineRecloser(
          lineTicketController.ticketId,
          popupsDataModel.equipmentId,
          endPoint,
          lineBranchInfo.id);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? LineRecloserModel();
        model.value.title = popupsDataModel.equipmentName;
        update();
      } else {
        await showDialogError(response.message);
      }
    }

    void offline() {
      final response = LocalDataManager.shared.getLinePopup<LineRecloserModel>(
          lineTicketController.ticketId,
          lineBranchInfo.id,
          popupsDataModel.equipmentId,
          popupsDataModel.inspectionCategory);
      model.value = response ?? LineRecloserModel();
      model.value.title = popupsDataModel.equipmentName;
      update();
    }

    final isHandleDataOnline = await lineTicketController.isHandleDataOnline();

    if (isHandleDataOnline) {
      await online();
    } else {
      offline();
    }
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
      final result = await LocalDataManager.shared
          .saveLinePopup<LineRecloserModel>(
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
        'lineRecloser': model.toJson()
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
}

