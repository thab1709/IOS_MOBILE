// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/equipment_model.dart';
import 'package:evnmobile/src/htld/models/line/line_branch_info.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_wire_model.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/common/constance/line_content_option.dart';
import 'package:evnmobile/src/htld/common/constance/content_option.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_line_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../../../app_env.dart';
import '../../../../../../app_common/shared/app_shared.dart';
import '../../../containers/e_text_area.dart';
import '../../../containers/e_text_field.dart';

class LineIncidentWirePopup extends BasePopupWidget {
  LineIncidentWirePopup(
      {@required PopupsDataModel popupsDataModel,
      @required LineBranchInfo lineBranchInfo,
      @required this.equipmentModels}) {
    _controller.popupsDataModel = popupsDataModel;
    _controller.lineBranchInfo = lineBranchInfo;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  final List<EquipmentModel> equipmentModels;
  final _controller = LineWireController();

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
                LineOption.DBVH_DS_T_TT_Option,
                title: 'Tình trạng',
                index: 1,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                defaultValue: _controller.model.value
                    .getProblemValue(1, LineContentOption.ensureOperation),
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 1)
                    ?.toList(),
                isSelectArea: AppShared.instance.getAppType() != AppType.HTLDHT,
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
                  _controller.model.value.setLineAreaUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              // ELineDropDown(LineOption.D_M_H_Option,
              //   title: 'Mốc (Cọc) báo hiệu cáp ngầm',
              //   index: 2,
              //   equipmentModel: equipmentModels,
              //   problemPositions: _controller.model.value?.problemPositions?.where((element) => element.fieldValue == 2)?.toList(),
              //   images: _controller.model.value.images,
              //    onDataChange: (optionData, index, mess, listData) {
              //     _controller.model.value.setProblemPositions(optionData, index);
              //     _controller.model.value.setLineUnusually(mess, listData);
              //   },
              //   onAttachImages: (images, index) {
              //     _controller.model.value.setImages(images, index);
              //   },),
              ETextArea(
                title: 'Vật liệu lạ bám vào dây',
                isRequire: true,
                enable: _controller.isEnable(),
                value: _controller.model.value.materialClingingToWire ??=
                    "Không",
                onChange: (value) {
                  _controller.model.value.materialClingingToWire = value;
                },
              ),
              ELineDropDown(
                LineOption.K_C_Option,
                title: 'Phóng điện',
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
                LineOption.DBVH_T_L_NA_Option,
                title: 'Khóa đỡ dây dẫn',
                index: 4,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                defaultValue: _controller.model.value
                    .getProblemValue(4, LineContentOption.ensureOperation),
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
                LineOption.DBVH_T_M_NA_Option,
                title: 'Tạ chống rung',
                index: 5,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                defaultValue: _controller.model.value
                    .getProblemValue(5, LineContentOption.ensureOperation),
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
                LineOption.DBVH_BT_Option,
                title: 'Độ võng',
                index: 6,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                defaultValue: _controller.model.value
                    .getProblemValue(6, LineContentOption.ensureOperation),
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
              ETextField(
                title: 'Trị số võng',
                isRequire: true,
                enable: _controller.isEnable(),
                weight: FontWeight.normal,
                horizontalPadding: 0,
                value: _controller.model.value.saggingValue ??= "Không",
                onChange: (value) {
                  _controller.model.value.saggingValue = value;
                },
              ),
              ELineDropDown(
                LineOption.DBVH_BT_Option,
                title:
                    'Khoảng cách an toàn với các dây vượt qua, các công trình khác',
                index: 7,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                defaultValue: _controller.model.value
                    .getProblemValue(7, LineContentOption.ensureOperation),
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
                LineOption.K_C_Option,
                title: 'Xử lý ngay trong kiểm tra',
                index: 8,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                defaultValue: _controller.model.value
                    .getProblemValue(8, LineContentOption.no),
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 8)
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

class LineWireController extends BasePopupController {
  Rx<LineWireModel> model = LineWireModel().obs;

  String endPoint = 'wire';

  @override
  void refresh() {
    model.refresh();
    super.refresh();
  }

  @override
  Future getData() async {
    await super.getData();
    Future online() async {
      final response = await repository.getLineWire(
          lineTicketController.ticketId,
          popupsDataModel.equipmentId,
          endPoint,
          lineBranchInfo.id);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? LineWireModel();
        model.value.title = popupsDataModel.equipmentName;
        update();
      } else {
        await showDialogError(response.message);
      }
    }

    void offline() {
      final response = LocalDataManager.shared.getLinePopup<LineWireModel>(
          lineTicketController.ticketId,
          lineBranchInfo.id,
          popupsDataModel.equipmentId,
          popupsDataModel.inspectionCategory);
      model.value = response ?? LineWireModel();
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
      final result = await LocalDataManager.shared.saveLinePopup<LineWireModel>(
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
        'lineWire': model.toJson()
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

