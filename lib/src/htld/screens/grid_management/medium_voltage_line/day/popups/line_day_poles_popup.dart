// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/constance/content_option.dart';
import 'package:evnmobile/src/htld/models/equipment_model.dart';
import 'package:evnmobile/src/htld/models/line/line_branch_info.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/common/constance/line_content_option.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_line_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../app_env.dart';
import '../../../containers/e_drop_down.dart';
import '../../../containers/e_text_area.dart';
import '../../../containers/e_text_field.dart';

class LineDayPolesPopup extends BasePopupWidget {
  LineDayPolesPopup(
      {@required PopupsDataModel popupsDataModel,
      @required LineBranchInfo lineBranchInfo,
      @required this.equipmentModels}) {
    _controller.popupsDataModel = popupsDataModel;
    _controller.lineBranchInfo = lineBranchInfo;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  final List<EquipmentModel> equipmentModels;

  final _controller = LinePoleIncidentController();

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
              if (AppShared.instance.getAppType() == AppType.HTLDHT)
                const Text("Tồn tại",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ELineDropDown(
                LineOption.DBVH_G_N_BD_HH_N_LBT_G_Option,
                title: 'Tình trạng',
                weight: FontWeight.normal,
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
              ETextField(
                horizontalPadding: 0,
                title: 'Vật liệu lạ bám vào cột',
                isRequire: true,
                enable: _controller.isEnable(),
                value: _controller.model.value.materialClingToPole ??= 'Không',
                onChange: (value) {
                  _controller.model.value.materialClingToPole = value;
                },
              ),
              ELineDropDown(
                LineOption.DQC_M_H_M_SQC_Option,
                title: 'Biển báo',
                index: 2,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                defaultValue: _controller.model.value
                    .getProblemValue(2, LineContentOption.correct),
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
                LineOption.DQC_SQC_M_CDS_Option,
                title: 'Đánh số cột',
                index: 3,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                defaultValue: _controller.model.value
                    .getProblemValue(3, LineContentOption.correct),
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
                LineOption.DBVH_BT_NA_Option,
                title: 'Hệ thống neo chằng cột',
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
              ETextArea(
                title: 'Các hiện tượng cụ thể',
                isRequire: true,
                enable: _controller.isEnable(),
                value: _controller.model.value.getSpecificPhenomena(),
                onChange: (value) {
                  _controller.model.value.specificPhenomena = value;
                },
              ),
              if (AppShared.instance.getAppType() == AppType.HTLDHT)
                const Text("Cảnh báo",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ELineDropDown(
                KCOptions,
                title: 'Có khả năng gây sự cố',
                index: 5,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                defaultValue: _controller.model.value
                    .getProblemValue(5, ContentOptions.no.value),
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
                LineOption.K_C_Option,
                title: 'Xử lý ngay trong kiểm tra',
                index: 6,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                defaultValue: _controller.model.value
                    .getProblemValue(6, LineContentOption.no),
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 6)
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

