// @dart=2.9
import 'package:evnmobile/src/htld/common/components/app_button.dart';
import 'package:evnmobile/src/htld/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/models/line/line_branch_info.dart';
import 'package:evnmobile/src/htld/models/problem_positions_model.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_line_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_section_title.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_single_text_area.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/popup_mobile_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/title_with_auto_button_view.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/line_ticket_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/popups/line_breaker.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/popups/line_rmu.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/popups/line_ti.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/popups/line_tu.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/day/popups/line_sub_cable.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/medium_content_branch_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../containers/content_checklist_button.dart';
import '../../containers/e_drop_down.dart';
import '../../containers/e_label.dart';
import '../../containers/e_text_area.dart';
import '../common/sticky_expansion_tile.dart';
import '../medium_content_controller.dart';
import 'popups/line_incident_beam_popup.dart';
import 'popups/line_incident_capacitors_popup.dart';
import 'popups/line_incident_cutting_machines_popup.dart';
import 'popups/line_incident_disconnectors_switch_popup.dart';
import 'popups/line_incident_earthing_popup.dart';
import 'popups/line_incident_fudament_popup.dart';
import 'popups/line_incident_fuse_cut_out_popup.dart';
import 'popups/line_incident_insulation_popup.dart';
import 'popups/line_incident_lightning_arrester_popup.dart';
import 'popups/line_incident_measure_boundaries_popup.dart';
import 'popups/line_incident_poles_popup.dart';
import 'popups/line_incident_recloser_popup.dart';
import 'popups/line_incident_rod_rap_popup.dart';
import 'popups/line_incident_wire_popup.dart';

class MediumContentIncidentHTScreen extends StatefulWidget {
  final Function next;

  const MediumContentIncidentHTScreen({this.next});

  @override
  _MediumContentIncidentHTScreenState createState() =>
      _MediumContentIncidentHTScreenState();
}

class _MediumContentIncidentHTScreenState
    extends State<MediumContentIncidentHTScreen>
    implements LineMediumContentDelegate {
  final LineTicketController ticketController = Get.find();
  final MediumContentController mediumContentController =
      MediumContentController();

  @override
  void initState() {
    super.initState();
    mediumContentController.delegate = this;
    Future.delayed(
        const Duration(milliseconds: 200), mediumContentController.getContent);
  }

  // Helper method to set default problem value
  void _setDefaultProblem(
      List<ProblemPositions> list, int fieldValue, int defaultValue) {
    if (list == null) return;

    final item = list.firstWhere(
      (e) => e.fieldValue == fieldValue,
      orElse: () => null,
    );

    if (item != null) {
      item.problemValue ??= defaultValue;
    } else {
      list.add(ProblemPositions(
        fieldValue: fieldValue,
        problemValue: defaultValue,
      ));
    }
  }

  final ValueNotifier<Map<Key, Widget>> _stickyHeadersNotifier =
      ValueNotifier({});

  void _updateStickyHeader(Key key, Widget header, double top) {
    final currentMap = Map<Key, Widget>.from(_stickyHeadersNotifier.value);
    bool hasChanged = false;

    if (header != null) {
      // Only add if not already present or position changed
      final newWidget = Positioned(
        top: top,
        left: 0,
        right: 0,
        child: Material(
          elevation: 4.0,
          child: header,
        ),
      );
      if (!currentMap.containsKey(key)) {
        currentMap[key] = newWidget;
        hasChanged = true;
      } else {
        // Update position if changed
        currentMap[key] = newWidget;
        hasChanged = true;
      }
    } else {
      // Remove if present
      if (currentMap.containsKey(key)) {
        currentMap.remove(key);
        hasChanged = true;
      }
    }

    // Only notify if map actually changed
    if (hasChanged) {
      _stickyHeadersNotifier.value = currentMap;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: ESectionTitle('Nội dung kiểm tra'),
                          ),
                          Obx(() {
                            final total = mediumContentController
                                    ?.listLineBranchInfo?.length ??
                                0;
                            final saved = mediumContentController
                                    ?.listLineBranchInfo
                                    ?.where((item) => item.isSaved == true)
                                    ?.length ??
                                0;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                "Đã kiểm tra $saved / $total",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: saved == total
                                      ? Colors.green
                                      : Colors.grey.shade700,
                                ),
                              ),
                            );
                          }),
                          Obx(() => Column(
                                children: mediumContentController
                                        ?.listLineBranchInfo
                                        ?.mapIndexed(_renderMenu)
                                        ?.toList() ??
                                    List.empty(),
                              ))
                        ],
                      ),
                    ),
                    ValueListenableBuilder<Map<Key, Widget>>(
                      valueListenable: _stickyHeadersNotifier,
                      builder: (context, headers, child) {
                        return Stack(
                          children: headers.values.toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  // - First Section
  Widget _renderFirstSection(
      MediumContentBranchController controller, String title) {
    controller.lineContent.value.lineRightsOfWay.title = title;
    const _paddingHorizontal = 16.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ELabel(
          title: title,
          padding: const EdgeInsets.symmetric(horizontal: _paddingHorizontal),
        ),
        () {
          controller.lineContent.value.lineRightsOfWay.anotherLineCrossing ??=
              KCOptions.first.value;
          return EDropDown(KCOptions,
              title: 'Có giao chéo đường dây khác',
              defaultValue: controller
                  .lineContent.value.lineRightsOfWay.anotherLineCrossing,
              enable: ticketController.argument.isEdit(),
              isShowAbnormal: false,
              onChange: (option, mess) {
                controller.lineContent.value.lineRightsOfWay
                    .anotherLineCrossing = option.value;
                controller.lineContent.value.lineRightsOfWay.setUnusually(mess);
              },
              onSelectedAbnormalOption: (categoryName, abnormal, index) {
                controller.setAbnormal(
                    categoryName,
                    controller.lineContent.value.lineRightsOfWay,
                    abnormal,
                    index,
                    InspectionCategory.lineRightsOfWay);
              },
              index: 1,
              images: controller.lineContent.value.lineRightsOfWay.images,
              onAttachImages: (images, index) {
                controller.lineContent.value.lineRightsOfWay
                    .setImages(images, 1);
              },
              weight: FontWeight.bold,
              paddingHorizontal: _paddingHorizontal);
        }(),
        Container(
            margin: const EdgeInsets.only(left: _paddingHorizontal),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Text(
              'Cây trong hành lang bảo vệ đường dây',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
        Container(
          margin: const EdgeInsets.only(left: 8),
          child: Column(
            children: [
              () {
                _setDefaultProblem(
                    controller
                        .lineContent.value.lineRightsOfWay.problemPositions,
                    2,
                    KCOptions.first.value);
                return ELineDropDown(KCOptions,
                    title:
                        'Cây ở gần, cây gẫy, đổ, cây mọc nhanh có khả năng gây sự cố',
                    isSelectArea: true,
                    isShowAbnormal: false,
                    onSelectedAbnormalOption:
                        (categoryName, abnormal, index, optionCategory) {
                      controller.setAbnormalLine(
                          categoryName,
                          controller.lineContent.value.lineRightsOfWay,
                          abnormal,
                          index,
                          optionCategory,
                          InspectionCategory.lineRightsOfWay);
                    },
                    enable: ticketController.argument.isEdit(),
                    equipmentModel: controller.listSubstations,
                    problemPositions: controller
                        .lineContent.value.lineRightsOfWay.problemPositions
                        ?.where((element) => element.fieldValue == 2)
                        ?.toList(),
                    defaultValue: controller
                        .lineContent.value.lineRightsOfWay.problemPositions
                        ?.firstWhere((element) => element.fieldValue == 2,
                            orElse: () => null)
                        ?.problemValue,
                    onDataChange:
                        (optionData, index, mess, listData, isAbnormal) {
                      controller.lineContent.value.lineRightsOfWay
                          .setProblemPositions(mess, optionData, index,
                              isAbnormal: isAbnormal);
                      controller.lineContent.value.lineRightsOfWay
                          .setLineAreaUnusually(mess, listData);
                    },
                    index: 2,
                    images: controller.lineContent.value.lineRightsOfWay.images,
                    paddingHorizontal: _paddingHorizontal,
                    onAttachImages: (images, index) {
                      controller.lineContent.value.lineRightsOfWay
                          .setImages(images, 2);
                    },
                    weight: FontWeight.normal);
              }(),
              () {
                controller.lineContent.value.lineRightsOfWay.violation ??=
                    KCOptions.first.value;
                return EDropDown(KCOptions,
                    title:
                        'Vi phạm tình trạng hành lang tuyến (dây nổi/ cáp ngầm)',
                    defaultValue:
                        controller.lineContent.value.lineRightsOfWay.violation,
                    enable: ticketController.argument.isEdit(),
                    onSelectedAbnormalOption: (categoryName, abnormal, index) {
                      controller.setAbnormal(
                          categoryName,
                          controller.lineContent.value.lineRightsOfWay,
                          abnormal,
                          index,
                          InspectionCategory.lineRightsOfWay);
                    },
                    isShowAbnormal: false,
                    onChange: (option, mess) {
                      controller.lineContent.value.lineRightsOfWay.violation =
                          option.value;
                      controller.lineContent.value.lineRightsOfWay
                          .setUnusually(mess);
                    },
                    index: 3,
                    images: controller.lineContent.value.lineRightsOfWay.images,
                    onAttachImages: (images, index) {
                      controller.lineContent.value.lineRightsOfWay
                          .setImages(images, 3);
                    },
                    weight: FontWeight.normal,
                    paddingHorizontal: _paddingHorizontal);
              }(),
              () {
                if (controller.lineContent.value.lineRightsOfWay
                            .subjectOfViolation ==
                        null ||
                    controller.lineContent.value.lineRightsOfWay
                        .subjectOfViolation.isEmpty) {
                  controller.lineContent.value.lineRightsOfWay
                      .subjectOfViolation = "Không";
                }
                return Padding(
                  padding: const EdgeInsets.all(_paddingHorizontal),
                  child: ETextArea(
                    title: 'Đối tượng vi phạm (nếu có)',
                    value: controller
                        .lineContent.value.lineRightsOfWay.subjectOfViolation,
                    isRequire: true,
                    enable: ticketController.argument.isEdit(),
                    onChange: (value) {
                      controller.lineContent.value.lineRightsOfWay
                          .subjectOfViolation = value;
                    },
                  ),
                );
              }(),
              () {
                controller.lineContent.value.lineRightsOfWay
                    .treeFellingCondition ??= KCOptions.first.value;
                return EDropDown(KCOptions,
                    title: 'Điều kiện chặt cây',
                    defaultValue: controller
                        .lineContent.value.lineRightsOfWay.treeFellingCondition,
                    enable: ticketController.argument.isEdit(),
                    isShowAbnormal: false,
                    onSelectedAbnormalOption: (categoryName, abnormal, index) {
                      controller.setAbnormal(
                          categoryName,
                          controller.lineContent.value.lineRightsOfWay,
                          abnormal,
                          index,
                          InspectionCategory.lineRightsOfWay);
                    },
                    onChange: (option, mess) {
                      controller.lineContent.value.lineRightsOfWay
                          .treeFellingCondition = option.value;
                      controller.lineContent.value.lineRightsOfWay
                          .setUnusually(mess);
                    },
                    index: 4,
                    images: controller.lineContent.value.lineRightsOfWay.images,
                    onAttachImages: (images, index) {
                      controller.lineContent.value.lineRightsOfWay
                          .setImages(images, 4);
                    },
                    weight: FontWeight.normal,
                    paddingHorizontal: _paddingHorizontal);
              }(),
              () {
                controller.lineContent.value.lineRightsOfWay
                        .informationOnTreeFellingAndPlanting ??=
                    CutTreeOptions.first.value;

                return EDropDown(CutTreeOptions,
                    changeTextColorIfNotDefault: false,
                    disableImage: true,
                    isShowAbnormal: false,
                    index: 5,
                    enable: ticketController.argument.isEdit(),
                    title: 'Những thông tin về chặt cây, kế hoạch trồng cây',
                    defaultValue: controller.lineContent.value.lineRightsOfWay
                        .informationOnTreeFellingAndPlanting,
                    weight: FontWeight.normal, onChange: (option, mess) {
                  controller.lineContent.value.lineRightsOfWay
                      .informationOnTreeFellingAndPlanting = option.value;
                  // controller.lineContent.value.lineRightsOfWay.setUnusually(mess);
                },
                    images: controller.lineContent.value.lineRightsOfWay.images,
                    paddingHorizontal: _paddingHorizontal);
              }(),
            ],
          ),
        ),
        const SizedBox(height: _paddingHorizontal),
        Container(
            margin: const EdgeInsets.only(left: _paddingHorizontal),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Text(
              'Các thay đổi xung quanh  đường dây',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
        Container(
          margin: const EdgeInsets.only(left: 8),
          child: Column(
            children: [
              () {
                _setDefaultProblem(
                    controller
                        .lineContent.value.lineRightsOfWay.problemPositions,
                    6,
                    KCOptions.first.value);
                return ELineDropDown(
                  KCOptions,
                  title: 'Đất, đá lở',
                  index: 6,
                  isShowAbnormal: false,
                  enable: ticketController.argument.isEdit(),
                  isSelectArea: true,
                  onSelectedAbnormalOption:
                      (categoryName, abnormal, index, optionCategory) {
                    controller.setAbnormalLine(
                        categoryName,
                        controller.lineContent.value.lineRightsOfWay,
                        abnormal,
                        index,
                        optionCategory,
                        InspectionCategory.lineRightsOfWay);
                  },
                  equipmentModel: controller.listSubstations,
                  problemPositions: controller
                      .lineContent.value.lineRightsOfWay.problemPositions
                      ?.where((element) => element.fieldValue == 6)
                      ?.toList(),
                  defaultValue: controller
                      .lineContent.value.lineRightsOfWay.problemPositions
                      ?.firstWhere((element) => element.fieldValue == 6,
                          orElse: () => null)
                      ?.problemValue,
                  onDataChange:
                      (optionData, index, mess, listData, isAbnormal) {
                    controller.lineContent.value.lineRightsOfWay
                        .setProblemPositions(mess, optionData, index,
                            isAbnormal: isAbnormal);
                    controller.lineContent.value.lineRightsOfWay
                        .setLineAreaUnusually(mess, listData);
                  },
                  images: controller.lineContent.value.lineRightsOfWay.images,
                  onAttachImages: (images, index) {
                    controller.lineContent.value.lineRightsOfWay
                        .setImages(images, 6);
                  },
                  paddingHorizontal: _paddingHorizontal,
                  weight: FontWeight.normal,
                );
              }(),
              () {
                if (controller.lineContent.value.lineRightsOfWay
                            .theWorksAreUnderConstruction ==
                        null ||
                    controller.lineContent.value.lineRightsOfWay
                        .theWorksAreUnderConstruction.isEmpty) {
                  controller.lineContent.value.lineRightsOfWay
                      .theWorksAreUnderConstruction = "Không";
                }
                return Padding(
                  padding: const EdgeInsets.all(_paddingHorizontal),
                  child: ETextArea(
                    title: 'Các công trình đang xây dựng',
                    isRequire: true,
                    enable: ticketController.argument.isEdit(),
                    value: controller.lineContent.value.lineRightsOfWay
                        .theWorksAreUnderConstruction,
                    onChange: (value) {
                      controller.lineContent.value.lineRightsOfWay
                          .theWorksAreUnderConstruction = value;
                    },
                  ),
                );
              }(),
              () {
                controller.lineContent.value.lineRightsOfWay
                    .handlingImmediatelyInspection ??= KCOptions.first.value;

                return EDropDown(KCOptions,
                    title: 'Xủ lý ngay trong kiểm tra',
                    enable: ticketController.argument.isEdit(),
                    isShowAbnormal: false,
                    defaultValue: controller.lineContent.value.lineRightsOfWay
                        .handlingImmediatelyInspection,
                    onChange: (option, mess) {
                      controller.lineContent.value.lineRightsOfWay
                          .handlingImmediatelyInspection = option.value;
                      // controller.lineContent.value.lineRightsOfWay
                      //     .setUnusually(mess);
                    },
                    onSelectedAbnormalOption: (categoryName, abnormal, index) {
                      controller.setAbnormal(
                          categoryName,
                          controller.lineContent.value.lineRightsOfWay,
                          abnormal,
                          index,
                          InspectionCategory.lineRightsOfWay);
                    },
                    index: 7,
                    images: controller.lineContent.value.lineRightsOfWay.images,
                    onAttachImages: (images, index) {
                      controller.lineContent.value.lineRightsOfWay
                          .setImages(images, 7);
                    },
                    weight: FontWeight.normal,
                    paddingHorizontal: _paddingHorizontal);
              }(),
              () {
                if (controller.lineContent.value.lineRightsOfWay
                            .suggestedHandlingOfAbnormal ==
                        null ||
                    controller.lineContent.value.lineRightsOfWay
                        .suggestedHandlingOfAbnormal.isEmpty) {
                  controller.lineContent.value.lineRightsOfWay
                      .suggestedHandlingOfAbnormal = "Không";
                }
                return Padding(
                  padding: const EdgeInsets.all(_paddingHorizontal),
                  child: ETextArea(
                    title: 'Đề xuất xử lý bất thường/ hư hỏng',
                    isRequire: true,
                    enable: ticketController.argument.isEdit(),
                    value: controller.lineContent.value.lineRightsOfWay
                        .suggestedHandlingOfAbnormal,
                    onChange: (value) {
                      controller.lineContent.value.lineRightsOfWay
                          .suggestedHandlingOfAbnormal = value;
                    },
                  ),
                );
              }()
            ],
          ),
        ),
      ],
    );
  }

  Widget _renderCheckList(MediumContentBranchController controller) {
    return Obx(() => GridView.count(
          crossAxisCount: GetPlatform.isMobile ? 1 : 2,
          shrinkWrap: true,
          childAspectRatio: 6 / 1.1,
          crossAxisSpacing: 10,
          physics: const NeverScrollableScrollPhysics(),
          children: controller?.listPopups
                  ?.map((e) => ContentCheckListDayButton(e, onTap: () {
                        _handleCheckListTap(controller, e);
                      }))
                  ?.toList() ??
              <ContentCheckListDayButton>[],
        ));
  }

  Future _handleCheckListTap(MediumContentBranchController controller,
      PopupsDataModel popupsDataModel) async {
    // final name = popupsDataModel.equipmentName;
    final actionType = controller.ticketController.argument.actionType;

    switch (popupsDataModel.inspectionCategory) {
      case InspectionCategory.linePole:
        await openPopup(
            popupsDataModel,
            AppStrings.linePole,
            LineIncidentPolesPopup(
              popupsDataModel: popupsDataModel,
              equipmentModels: controller.listSubstations,
              lineBranchInfo: controller.lineBranchInfo.value,
            ),
            actionType,
            controller);

        break;
      case InspectionCategory.lineBeam:
        await openPopup(
            popupsDataModel,
            AppStrings.lineBeam,
            LineIncidentBeamPopup(
              popupsDataModel: popupsDataModel,
              equipmentModels: controller.listSubstations,
              lineBranchInfo: controller.lineBranchInfo.value,
            ),
            actionType,
            controller);

        break;
      case InspectionCategory.lineFundament:
        await openPopup(
            popupsDataModel,
            AppStrings.lineFundament,
            LineIncidentFudamentPopup(
              popupsDataModel: popupsDataModel,
              equipmentModels: controller.listSubstations,
              lineBranchInfo: controller.lineBranchInfo.value,
            ),
            actionType,
            controller);

        break;
      case InspectionCategory.lineWire:
        await openPopup(
            popupsDataModel,
            AppStrings.lineWire,
            LineIncidentWirePopup(
              popupsDataModel: popupsDataModel,
              equipmentModels: controller.listSubstations,
              lineBranchInfo: controller.lineBranchInfo.value,
            ),
            actionType,
            controller);

        break;
      case InspectionCategory.lineInsulation:
        await openPopup(
            popupsDataModel,
            AppStrings.lineInsulation,
            LineIncidentInsulationPopup(
              popupsDataModel: popupsDataModel,
              equipmentModels: controller.listSubstations,
              lineBranchInfo: controller.lineBranchInfo.value,
            ),
            actionType,
            controller);

        break;
      case InspectionCategory.lineRodGap:
        await openPopup(
            popupsDataModel,
            AppStrings.lineRodRap,
            LineIncidentRodRapPopup(
              popupsDataModel: popupsDataModel,
              equipmentModels: controller.listSubstations,
              lineBranchInfo: controller.lineBranchInfo.value,
            ),
            actionType,
            controller);

        break;
      case InspectionCategory.lineLightningArrester:
        await openPopup(
            popupsDataModel,
            AppStrings.lineLightningArrester,
            LineIncidentLightningArresterPopup(
              popupsDataModel: popupsDataModel,
              equipmentModels: controller.listSubstations,
              lineBranchInfo: controller.lineBranchInfo.value,
            ),
            actionType,
            controller);

        break;
      case InspectionCategory.lineEarthing:
        await openPopup(
            popupsDataModel,
            AppStrings.lineEarthing,
            LineIncidentEarthingPopup(
              popupsDataModel: popupsDataModel,
              equipmentModels: controller.listSubstations,
              lineBranchInfo: controller.lineBranchInfo.value,
            ),
            actionType,
            controller);

        break;
      case InspectionCategory.lineDisconnectorsSwitch:
        await openPopup(
            popupsDataModel,
            AppStrings.lineDisconnectorSwitch,
            LineIncidentDisconnectorsSwitchPopup(
              popupsDataModel: popupsDataModel,
              equipmentModels: controller.listSubstations,
              lineBranchInfo: controller.lineBranchInfo.value,
            ),
            actionType,
            controller);

        break;
      case InspectionCategory.lineRecloser:
        await openPopup(
            popupsDataModel,
            AppStrings.lineRecloser,
            LineIncidentRecloserPopup(
              popupsDataModel: popupsDataModel,
              equipmentModels: controller.listSubstations,
              lineBranchInfo: controller.lineBranchInfo.value,
            ),
            actionType,
            controller);

        break;
      case InspectionCategory.lineCuttingMachine:
        await openPopup(
            popupsDataModel,
            AppStrings.lineCuttingMachine,
            LineIncidentCuttingMachinesPopup(
              popupsDataModel: popupsDataModel,
              equipmentModels: controller.listSubstations,
              lineBranchInfo: controller.lineBranchInfo.value,
            ),
            actionType,
            controller);

        break;
      case InspectionCategory.lineFuseCutOut:
        await openPopup(
            popupsDataModel,
            AppStrings.lineFuseCutOut,
            LineIncidentFuseCutOutPopup(
              popupsDataModel: popupsDataModel,
              equipmentModels: controller.listSubstations,
              lineBranchInfo: controller.lineBranchInfo.value,
            ),
            actionType,
            controller);

        break;
      case InspectionCategory.lineCapacitor:
        await openPopup(
            popupsDataModel,
            AppStrings.lineCapacitor,
            LineIncidentCapacitorsPopup(
              popupsDataModel: popupsDataModel,
              equipmentModels: controller.capacitors,
              lineBranchInfo: controller.lineBranchInfo.value,
            ),
            actionType,
            controller);

        break;
      case InspectionCategory.lineMeasureTheBoundary:
        await openPopup(
            popupsDataModel,
            AppStrings.lineMeasureBoundaries,
            LineIncidentMeasureBoundariesPopup(
              popupsDataModel: popupsDataModel,
              equipmentModels: controller.listSubstations,
              lineBranchInfo: controller.lineBranchInfo.value,
            ),
            actionType,
            controller);

        break;

      case InspectionCategory.ineUndergroundCables:
        await openPopup(
            popupsDataModel,
            AppStrings.lineUndergroundCable,
            LineSubCablePopup(
              popupsDataModel: popupsDataModel,
              equipmentModels: controller.undergroundCables,
              // Chỉ lấy các vật tư/ nút là cáp ngầm
              lineBranchInfo: controller.lineBranchInfo.value,
            ),
            actionType,
            controller);

        break;

      case InspectionCategory.lineTI:
        await openPopup(
          popupsDataModel,
          AppStrings.lineTI,
          LineTIPopup(
            popupsDataModel: popupsDataModel,
            equipmentModels: controller.tis,
            lineBranchInfo: controller.lineBranchInfo.value,
          ),
          actionType,
          controller,
        );

        break;

      case InspectionCategory.lineTU:
        await openPopup(
          popupsDataModel,
          AppStrings.lineTU,
          LineTUPopup(
            popupsDataModel: popupsDataModel,
            equipmentModels: controller.tus,
            lineBranchInfo: controller.lineBranchInfo.value,
          ),
          actionType,
          controller,
        );

        break;

      case InspectionCategory.lineRMU:
        await openPopup(
          popupsDataModel,
          AppStrings.lineRMU,
          LineRMUPopup(
            popupsDataModel: popupsDataModel,
            equipmentModels: controller.rmus,
            lineBranchInfo: controller.lineBranchInfo.value,
          ),
          actionType,
          controller,
        );

        break;

      case InspectionCategory.lineBreaker:
        await openPopup(
          popupsDataModel,
          AppStrings.lineBreaker,
          LineBreakerPopup(
            popupsDataModel: popupsDataModel,
            equipmentModels: controller.breakers,
            lineBranchInfo: controller.lineBranchInfo.value,
          ),
          actionType,
          controller,
        );

        break;
      default:
        break;
    }
  }

  Future openPopup(PopupsDataModel model, String name, Widget child,
      ActionType actionType, MediumContentBranchController controller) async {
    if (GetPlatform.isMobile) {
      final value = await Get.to(() => PopupMobileScreen(
            name: name,
            actionType: actionType,
            child: child,
          ));
      if (value == true) {
        await controller.updatePopupSuccess(model);
        // Refresh branch data after saving popup
        await controller.getBranchData();
        // if (context.mounted) {
        //   Navigator.pop(context);
        // }
      }
      return;
    }
    final value = await showPopupCheckList(context, name, child, actionType);
    if (value == true) {
      await controller.updatePopupSuccess(model);
      // Refresh branch data after saving popup
      await controller.getBranchData();
      // if (context.mounted) {
      //   Navigator.pop(context);
      // }
    }
  }

  Widget _renderMenu(LineBranchInfo info, int index) {
    final subController = mediumContentController.listController[index];
    subController.lineBranchInfo.value = info;

    return Container(
      padding: const EdgeInsets.only(top: 8),
      child: StickyExpansionTile(
        key: ValueKey(index),
        onStickyUpdate: _updateStickyHeader,
        subController: subController,
        info: info,
        onExpansionChanged: (value) async {
          if (value && !subController.loadDataSuccess.value) {
            subController.getAbnormalOptions(
                inspectionCategory: InspectionCategory.lineRightsOfWay);
            await subController.getBranchData();
          }

          if (value && subController.listSubstations.isEmpty) {
            await subController.getBranchNodes();
          }

          // Reset showDetailContent when collapse
          if (!value) {
            subController.showDetailContent.value = false;
          }
        },
        headerBuilder: () =>
            _renderHeaderTitle(subController, info.lineBranchName),
        childBuilder: () => _renderMenuItem(subController, info),
      ),
    );
  }

  Widget _renderHeaderTitle(
      MediumContentBranchController subController, String title) {
    final _headerTitleStyle = TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
        color: subController?.lineBranchInfo?.value?.isSaved == true
            ? AppColor.highlightColor70
            : Colors.grey);
    final abnormalCount =
        subController?.lineBranchInfo?.value?.abnormalCount ??= 0;
    return ListTile(
      leading: (subController?.lineBranchInfo?.value?.isSaved == true)
          ? const Icon(
              Icons.assignment_turned_in,
              color: AppColor.highlightColor70,
            )
          : const Icon(
              Icons.assignment_turned_in,
              color: Colors.grey,
            ),
      title: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: _headerTitleStyle,
      ),
      trailing: abnormalCount > 0
          ? Container(
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(abnormalCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    )),
              ),
            )
          : const SizedBox(),
    );
  }

  Widget _renderMenuItem(
      MediumContentBranchController controller, LineBranchInfo info) {
    return Obx(() {
      if (controller.loadDataSuccess.value) {}
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ETextArea(
              title: 'Thông tin nhánh cha',
              enable: false,
              minLine: 1,
              value: info.getParentsName(),
              weight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          if (ticketController.argument.actionType != ActionType.view)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  EButton(
                      maxSize: false,
                      title: 'Lưu',
                      action: () async {
                        await controller.updateBranchData();
                        // Force refresh sticky header to update abnormalCount and isSaved status
                        controller.lineBranchInfo.refresh();
                        setState(() {});
                      }),
                  const Spacer(),
                  EButton(
                      maxSize: false,
                      title: 'Có tồn tại',
                      action: () async {
                        // Mark as existing and show content
                        controller.showDetailContent.value = true;
                        // Clear all sticky headers before content expansion
                        _stickyHeadersNotifier.value = {};
                        // Force rebuild to recalculate sticky header positions
                        setState(() {});
                        // Trigger scroll listener after frame rebuild to recalculate positions
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;
                          final scrollController = Scrollable.of(context);
                          if (scrollController != null) {
                            // Trigger sticky header recalculation
                            final position = scrollController.position;
                            position.notifyListeners();
                          }
                        });
                      }),
                ],
              ),
            ),
          const SizedBox(
            height: 16,
          ),
          // Only show detailed content if showDetailContent is true
          if (controller.showDetailContent.value) ...[
            _renderFirstSection(controller, 'Hành lang tuyến'),
            const SizedBox(height: 16),
            const ELabel(
              title: 'Thiết bị đường dây',
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
            const SizedBox(height: 10),
            _renderCheckList(controller),
            const SizedBox(height: 16),
            TitleWithAutoButtonView('Diễn giải các hiện tượng bất thường', () {
              controller.getAbnormalPhenomenon();
            },
                horizontalPadding: 16,
                actionType: controller.ticketController.argument.actionType),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                controller?.lineContent?.value?.specificPhenomena ??= "Không";
                if (controller.abnormalPhenomenon.value != null) {}
                return ESingleTextArea(
                  isRequire: true,
                  isEnable: ticketController.argument.isEdit(),
                  value: controller?.lineContent?.value?.specificPhenomena,
                  onChanged: (value) {
                    controller.lineContent.value.specificPhenomena = value;
                  },
                );
              }),
            ),
            const SizedBox(
              height: 20,
            ),
            const ELabel(
                title: 'Các tồn tại đã xử lý',
                padding: EdgeInsets.symmetric(horizontal: 16)),
            () {
              controller.lineContent.value.processed ??= 'Không';
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ESingleTextArea(
                  value: controller.lineContent.value.processed,
                  isEnable: ticketController.argument.isEdit(),
                  isRequire: true,
                  onChanged: (value) {
                    controller.lineContent.value.processed = value;
                  },
                ),
              );
            }(),
            const SizedBox(
              height: 20,
            ),
            if (ticketController.argument.actionType != ActionType.view)
              Padding(
                padding: const EdgeInsets.all(16),
                child: EButton(
                    maxSize: true,
                    title: 'Lưu và kiểm tra nhánh',
                    action: () async {
                      await controller.updateBranchData();
                      // Force refresh sticky header to update abnormalCount and isSaved status
                      controller.lineBranchInfo.refresh();
                      setState(() {});
                    }),
              )
          ],
        ],
      );
    });
  }

  @override
  void updateContentSuccess() {
    widget.next();
  }
}

