// @dart=2.9
import 'package:evnmobile/src/htld/models/equipment_model.dart';
import 'package:evnmobile/src/htld/models/line/line_branch_info.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/common/constance/line_content_option.dart';
import 'package:evnmobile/src/htld/common/constance/content_option.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_line_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_insulation_popup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../../../app_env.dart';
import '../../../../../../app_common/shared/app_shared.dart';
import '../../../containers/e_text_area.dart';

class LineDayInsulationPopup extends BasePopupWidget {
  LineDayInsulationPopup(
      {@required PopupsDataModel popupsDataModel,
      @required LineBranchInfo lineBranchInfo,
      @required this.equipmentModels}) {
    _controller.popupsDataModel = popupsDataModel;
    _controller.lineBranchInfo = lineBranchInfo;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  final List<EquipmentModel> equipmentModels;
  final _controller = LineInsulationController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Obx(
      () => Column(
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ELineDropDown(
            LineOption.DBVH_V_N_R_Option,
            title: 'Tình trạng',
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
              _controller.setAbnormalLine(categoryName, _controller.model.value,
                  abnormal, index, optionCategory);
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
            LineOption.DBVH_B_PDBM_CN_Option,
            title: 'Bề mặt sứ',
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
              _controller.setAbnormalLine(categoryName, _controller.model.value,
                  abnormal, index, optionCategory);
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
            title: 'Hư hỏng trên chuỗi cách điện',
            isRequire: true,
            enable: _controller.isEnable(),
            value: _controller.model.value.damaged ??= "Không",
            onChange: (value) {
              _controller.model.value.damaged = value;
            },
          ),
          ETextArea(
            title: 'Vật liệu lạ bám vào cách điện',
            value: _controller.model.value.materialClingToInsulation ??=
                "Không",
            isRequire: true,
            enable: _controller.isEnable(),
            onChange: (value) {
              _controller.model.value.materialClingToInsulation = value;
            },
          ),
          ELineDropDown(
            LineOption.K_L_Option,
            title: 'Độ ồn',
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
              _controller.setAbnormalLine(categoryName, _controller.model.value,
                  abnormal, index, optionCategory);
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
            title: 'Phóng điện (xuyên thủng bề mặt)',
            index: 4,
            enable: _controller.isEnable(),
            equipmentModel: equipmentModels,
            defaultValue: _controller.model.value
                .getProblemValue(4, LineContentOption.no),
            problemPositions: _controller.model.value?.problemPositions
                ?.where((element) => element.fieldValue == 4)
                ?.toList(),
            onSelectedAbnormalOption:
                (categoryName, abnormal, index, optionCategory) {
              _controller.setAbnormalLine(categoryName, _controller.model.value,
                  abnormal, index, optionCategory);
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
            LineOption.BT_UK_L_PKR_T_Option,
            title: 'Tình trạng lắp đặt',
            index: 5,
            enable: _controller.isEnable(),
            equipmentModel: equipmentModels,
            defaultValue: _controller.model.value
                .getProblemValue(5, LineContentOption.normal),
            problemPositions: _controller.model.value?.problemPositions
                ?.where((element) => element.fieldValue == 5)
                ?.toList(),
            onSelectedAbnormalOption:
                (categoryName, abnormal, index, optionCategory) {
              _controller.setAbnormalLine(categoryName, _controller.model.value,
                  abnormal, index, optionCategory);
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ELineDropDown(
            LineOption.K_C_Option,
            title: 'Có khả năng gây sự cố',
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
              _controller.setAbnormalLine(categoryName, _controller.model.value,
                  abnormal, index, optionCategory);
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
            index: 7,
            enable: _controller.isEnable(),
            equipmentModel: equipmentModels,
            defaultValue: _controller.model.value
                .getProblemValue(7, LineContentOption.no),
            problemPositions: _controller.model.value?.problemPositions
                ?.where((element) => element.fieldValue == 7)
                ?.toList(),
            onSelectedAbnormalOption:
                (categoryName, abnormal, index, optionCategory) {
              // _controller.setAbnormalLine(categoryName, _controller.model.value,
              //     abnormal, index, optionCategory);
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
      ),
    ));
  }

  @override
  void saveData() {
    _controller.updateData();
  }
}

