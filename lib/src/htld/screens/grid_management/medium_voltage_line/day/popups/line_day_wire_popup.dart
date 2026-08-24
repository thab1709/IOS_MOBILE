// @dart=2.9
import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/src/htld/models/equipment_model.dart';
import 'package:evnmobile/src/htld/models/line/line_branch_info.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/models/problem_positions_model.dart';
import 'package:evnmobile/src/htld/common/constance/line_content_option.dart';
import 'package:evnmobile/src/htld/common/constance/content_option.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_line_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_line_drop_down_ht.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_wire_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../../app_common/shared/app_shared.dart';
import '../../../containers/e_drop_down.dart';
import '../../../containers/e_text_area.dart';
import '../../../containers/e_text_field.dart';

class LineDayWirePopup extends BasePopupWidget {
  LineDayWirePopup(
      {@required PopupsDataModel popupsDataModel,
      @required LineBranchInfo lineBranchInfo,
      @required this.equipmentModels}) {
    _controller.popupsDataModel = popupsDataModel;
    _controller.lineBranchInfo = lineBranchInfo;
    Future.delayed(const Duration(milliseconds: 200), () async {
      await _controller.getData();
      // Set default values for hidden fields when HTLDHT
      if (AppShared.instance.getAppType() == AppType.HTLDHT) {
        _setDefaultValuesForHiddenFields();
      }
    });
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
              if (AppShared.instance.getAppType() == AppType.HTLDHT)
                const Text("Tồn tại",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (AppShared.instance.getAppType() != AppType.HTLDHT)
                ELineDropDownHT(
                  LineOption.DBVH_DS_T_TT_Option,
                  title: 'Tình trạng',
                  index: 1,
                  enable: _controller.isEnable(),
                  isSelectArea:
                      AppShared.instance.getAppType() != AppType.HTLDHT,
                  equipmentModel: equipmentModels,
                  defaultValue: _controller.model.value
                      .getProblemValue(1, LineContentOption.ensureOperation),
                  problemPositions: _controller.model.value?.problemPositions
                      ?.where((element) => element.fieldValue == 1)
                      ?.toList(),
                  onSelectedAbnormalOption:
                      (categoryName, abnormal, index, optionCategory) {
                    _controller.setAbnormalLine(
                        categoryName,
                        _controller.model.value,
                        abnormal,
                        index,
                        optionCategory);
                  },
                  images: _controller.model.value.images,
                  onDataChange:
                      (optionData, index, mess, listData, isAbnormal) {
                    // Special handling for HTLDHT: create 2 problemPositions like old logic
                    if (AppShared.instance.getAppType() == AppType.HTLDHT) {
                      // Remove old problemPositions for this index
                      _controller.model.value.problemPositions?.removeWhere(
                          (element) => element.fieldValue == index);

                      // If abnormal option selected, create 2 problemPositions
                      if (isAbnormal &&
                          equipmentModels != null &&
                          equipmentModels.isNotEmpty) {
                        _controller.model.value.problemPositions ??= [];

                        // 1. Create problemPosition with positionId = null (like old ELineDropDown)
                        _controller.model.value.problemPositions.add(
                          ProblemPositions(
                            fieldValue: index,
                            problemValue: optionData.optionModel.value,
                            title: 'Tình trạng',
                            positionId: null,
                            isAbnormal: true,
                            note: '',
                          ),
                        );

                        // 2. Create problemPosition with first equipment and note
                        _controller.model.value.problemPositions.add(
                          ProblemPositions(
                            fieldValue: index,
                            problemValue: optionData.optionModel.value,
                            title: 'Tình trạng',
                            positionId: equipmentModels.first.id,
                            isAbnormal: true,
                            note: '', // Will be updated by onNoteChanged
                          ),
                        );
                      }
                    } else {
                      // Normal handling for non-HTLDHT
                      _controller.model.value.setProblemPositions(
                          mess, optionData, index,
                          isAbnormal: isAbnormal);
                    }
                    _controller.model.value
                        .setLineAreaUnusually(mess, listData);
                  },
                  onNoteChanged: (note) {
                    // Update note in problemPosition that has positionId (not null)
                    final problemPosition =
                        _controller.model.value.problemPositions?.firstWhere(
                            (element) =>
                                element.fieldValue == 1 &&
                                element.positionId != null,
                            orElse: () => null);
                    if (problemPosition != null) {
                      problemPosition.note = note;
                    }
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  },
                )
              else
                ELineDropDown(
                  LineOption.DBVH_DS_T_TT_Option,
                  title: 'Tình trạng',
                  index: 1,
                  enable: _controller.isEnable(),
                  isSelectArea:
                      AppShared.instance.getAppType() != AppType.HTLDHT,
                  equipmentModel: equipmentModels,
                  defaultValue: _controller.model.value
                      .getProblemValue(1, LineContentOption.ensureOperation),
                  problemPositions: _controller.model.value?.problemPositions
                      ?.where((element) => element.fieldValue == 1)
                      ?.toList(),
                  onSelectedAbnormalOption:
                      (categoryName, abnormal, index, optionCategory) {
                    _controller.setAbnormalLine(
                        categoryName,
                        _controller.model.value,
                        abnormal,
                        index,
                        optionCategory);
                  },
                  images: _controller.model.value.images,
                  onDataChange:
                      (optionData, index, mess, listData, isAbnormal) {
                    _controller.model.value.setProblemPositions(
                        mess, optionData, index,
                        isAbnormal: isAbnormal);
                    _controller.model.value
                        .setLineAreaUnusually(mess, listData);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  },
                ),
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
                isSelectArea: true,
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
                  _controller.model.value.setLineAreaUnusually(mess, listData);
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
                isSelectArea: true,
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
                  _controller.model.value.setLineAreaUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              if (AppShared().getAppType() != AppType.HTLDHT)
                ELineDropDown(
                  LineOption.DBVH_T_M_NA_Option,
                  title: 'Tạ chống rung',
                  index: 5,
                  enable: _controller.isEnable(),
                  isSelectArea: true,
                  equipmentModel: equipmentModels,
                  defaultValue: _controller.model.value
                      .getProblemValue(5, LineContentOption.ensureOperation),
                  problemPositions: _controller.model.value?.problemPositions
                      ?.where((element) => element.fieldValue == 5)
                      ?.toList(),
                  onSelectedAbnormalOption:
                      (categoryName, abnormal, index, optionCategory) {
                    _controller.setAbnormalLine(
                        categoryName,
                        _controller.model.value,
                        abnormal,
                        index,
                        optionCategory);
                  },
                  images: _controller.model.value.images,
                  onDataChange:
                      (optionData, index, mess, listData, isAbnormal) {
                    _controller.model.value.setProblemPositions(
                        mess, optionData, index,
                        isAbnormal: isAbnormal);
                    _controller.model.value
                        .setLineAreaUnusually(mess, listData);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  },
                ),
              if (AppShared().getAppType() != AppType.HTLDHT)
                ELineDropDown(
                  LineOption.DBVH_BT_NA_Option,
                  title: 'Độ võng',
                  index: 6,
                  enable: _controller.isEnable(),
                  isSelectArea: true,
                  equipmentModel: equipmentModels,
                  defaultValue: _controller.model.value
                      .getProblemValue(6, LineContentOption.ensureOperation),
                  problemPositions: _controller.model.value?.problemPositions
                      ?.where((element) => element.fieldValue == 6)
                      ?.toList(),
                  onSelectedAbnormalOption:
                      (categoryName, abnormal, index, optionCategory) {
                    _controller.setAbnormalLine(
                        categoryName,
                        _controller.model.value,
                        abnormal,
                        index,
                        optionCategory);
                  },
                  images: _controller.model.value.images,
                  onDataChange:
                      (optionData, index, mess, listData, isAbnormal) {
                    _controller.model.value.setProblemPositions(
                        mess, optionData, index,
                        isAbnormal: isAbnormal);
                    _controller.model.value
                        .setLineAreaUnusually(mess, listData);
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
                LineOption.DBVH_KDB_NA_Option,
                title:
                    'Khoảng cách an toàn với các dây vượt qua, các công trình khác',
                index: 7,
                enable: _controller.isEnable(),
                isSelectArea: true,
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
                  _controller.model.value.setLineAreaUnusually(mess, listData);
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
                index: 8,
                enable: _controller.isEnable(),
                isSelectArea: true,
                equipmentModel: equipmentModels,
                defaultValue: _controller.model.value
                    .getProblemValue(8, ContentOptions.no.value),
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 8)
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
                  _controller.model.value.setLineAreaUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ELineDropDown(
                LineOption.K_C_Option,
                title: 'Xử lý ngay trong kiểm tra',
                index: 9,
                enable: _controller.isEnable(),
                isSelectArea: true,
                equipmentModel: equipmentModels,
                defaultValue: _controller.model.value
                    .getProblemValue(9, LineContentOption.no),
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 9)
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

  /// Sets default values for hidden fields when HTLDHT
  /// Index 5: Tạ chống rung
  /// Index 6: Độ võng
  void _setDefaultValuesForHiddenFields() {
    _controller.model.value.problemPositions ??= [];

    // Check if default values for index 5 and 6 already exist
    final hasIndex5 = _controller.model.value.problemPositions
            ?.any((element) => element.fieldValue == 5) ??
        false;
    final hasIndex6 = _controller.model.value.problemPositions
            ?.any((element) => element.fieldValue == 6) ??
        false;

    // If not exists, add default ProblemPositions (EnsureOperation)
    if (!hasIndex5) {
      _controller.model.value.problemPositions.add(
        ProblemPositions(
          fieldValue: 5,
          problemValue: LineContentOption.ensureOperation,
          title: 'Tạ chống rung',
          positionId: null,
          isAbnormal: false,
        ),
      );
    }

    if (!hasIndex6) {
      _controller.model.value.problemPositions.add(
        ProblemPositions(
          fieldValue: 6,
          problemValue: LineContentOption.ensureOperation,
          title: 'Độ võng',
          positionId: null,
          isAbnormal: false,
        ),
      );
    }

    _controller.model.refresh();
  }
}

