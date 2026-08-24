// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htld/common/components/app_button.dart';
import 'package:evnmobile/src/htld/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/models/line/line_branch_info.dart';
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
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/day/popups/line_day_beam_popup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/day/popups/line_day_capacitors_popup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/day/popups/line_day_cutting_machines_pupup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/day/popups/line_day_disconnectors_switch_popup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/day/popups/line_day_earthing_popup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/day/popups/line_day_fudament_popup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/day/popups/line_day_fuse_cut_out_popup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/day/popups/line_day_insulation_popup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/day/popups/line_day_lightning_arrester_popup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/day/popups/line_day_measure_boundaries_popup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/day/popups/line_day_poles_popup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/day/popups/line_day_recloser_popup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/day/popups/line_day_rod_rap_popup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/day/popups/line_day_wire_popup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/medium_content_branch_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../app_env.dart';
import '../../../../../app_common/shared/app_shared.dart';
import '../../../../common/utils/alert_dialog_utils.dart';
import '../../containers/content_checklist_button.dart';
import '../../containers/e_drop_down.dart';
import '../../containers/e_label.dart';
import '../../containers/e_text_area.dart';
import '../common/sticky_expansion_tile.dart';
import '../medium_content_controller.dart';
import 'popups/line_sub_cable.dart';

class MediumContentDayHTScreen extends StatefulWidget {
  const MediumContentDayHTScreen({this.next});

  final Function next;

  @override
  _MediumContentDayHTScreenState createState() =>
      _MediumContentDayHTScreenState();
}

class _MediumContentDayHTScreenState extends State<MediumContentDayHTScreen>
    implements LineMediumContentDelegate {
  LineTicketController ticketController = Get.find();
  final MediumContentController mediumContentController =
      MediumContentController();

  @override
  void initState() {
    super.initState();

    mediumContentController.delegate = this;

    Future.delayed(
        const Duration(milliseconds: 200), mediumContentController.getContent);
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
          padding: const EdgeInsets.symmetric(vertical: 16),
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
                          // mediumContentController.listLineBranchInfo | tổng isSaved / length
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

    controller.lineContent.value.lineRightsOfWay.anotherLineCrossing ??=
        KCOptions.first.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ELabel(
          title: title,
        ),
        EDropDown(KCOptions,
            title: 'Có giao chéo đường dây khác',
            enable: ticketController.argument.isEdit(),
            // defaultValue: controller
            //     .lineContent.value.lineRightsOfWay.anotherLineCrossing,
            defaultValue: controller
                .lineContent.value.lineRightsOfWay.anotherLineCrossing,
            onSelectedAbnormalOption: (categoryName, abnormal, index) {
              controller.setAbnormal(
                  categoryName,
                  controller.lineContent.value.lineRightsOfWay,
                  abnormal,
                  index,
                  InspectionCategory.lineRightsOfWay);
            },
            onChange: (option, mess) {
              controller.lineContent.value.lineRightsOfWay.anotherLineCrossing =
                  option.value;
              controller.lineContent.value.lineRightsOfWay.setUnusually(mess);
            },
            isShowAbnormal: false,
            index: 1,
            images: controller.lineContent.value.lineRightsOfWay.images,
            onAttachImages: (images, index) {
              controller.lineContent.value.lineRightsOfWay.setImages(images, 1);
            },
            weight: FontWeight.bold),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Text(
              'Cây trong hành lang bảo vệ đường dây',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
        Container(
          margin: const EdgeInsets.only(left: 8),
          child: Column(
            children: [
              ELineDropDown(KCOptions,
                  title:
                      'Cây ở gần, cây gẫy, đổ, cây mọc nhanh có khả năng gây sự cố',
                  isSelectArea: true,
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
                          ?.problemValue ??
                      KCOptions.first.value,
                  onDataChange:
                      (optionData, index, mess, listData, isAbnormal) {
                    controller.lineContent.value.lineRightsOfWay
                        .setProblemPositions(mess, optionData, index,
                            isAbnormal: isAbnormal);
                    controller.lineContent.value.lineRightsOfWay
                        .setLineAreaUnusually(mess, listData);
                  },
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
                  index: 2,
                  images: controller.lineContent.value.lineRightsOfWay.images,
                  onAttachImages: (images, index) {
                    controller.lineContent.value.lineRightsOfWay
                        .setImages(images, 2);
                  },
                  weight: FontWeight.normal),
              () {
                controller.lineContent.value.lineRightsOfWay.violation ??=
                    KCOptions.first.value;
                return EDropDown(KCOptions,
                    title:
                        'Vi phạm tình trạng hành lang tuyến (dây nổi/ cáp ngầm)',
                    isShowAbnormal: false,
                    enable: ticketController.argument.isEdit(),
                    defaultValue:
                        controller.lineContent.value.lineRightsOfWay.violation,
                    onChange: (option, mess) {
                      controller.lineContent.value.lineRightsOfWay.violation =
                          option.value;
                      controller.lineContent.value.lineRightsOfWay
                          .setUnusually(mess);
                    },
                    onSelectedAbnormalOption: (categoryName, abnormal, index) {
                      controller.setAbnormal(
                          categoryName,
                          controller.lineContent.value.lineRightsOfWay,
                          abnormal,
                          index,
                          InspectionCategory.lineRightsOfWay);
                    },
                    index: 3,
                    images: controller.lineContent.value.lineRightsOfWay.images,
                    onAttachImages: (images, index) {
                      controller.lineContent.value.lineRightsOfWay
                          .setImages(images, 3);
                    },
                    weight: FontWeight.normal);
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
                return ETextArea(
                  title: 'Đối tượng vi phạm (nếu có)',
                  isRequire: true,
                  enable: ticketController.argument.isEdit(),
                  value: controller
                      .lineContent.value.lineRightsOfWay.subjectOfViolation,
                  onChange: (value) {
                    controller.lineContent.value.lineRightsOfWay
                        .subjectOfViolation = value;
                  },
                );
              }(),
              () {
                controller.lineContent.value.lineRightsOfWay
                    .treeFellingCondition ??= KCOptions.first.value;
                return EDropDown(
                  KCOptions,
                  title: 'Điều kiện chặt cây',
                  isShowAbnormal: false,
                  enable: ticketController.argument.isEdit(),
                  defaultValue: controller
                      .lineContent.value.lineRightsOfWay.treeFellingCondition,
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
                );
              }(),
              () {
                controller.lineContent.value.lineRightsOfWay
                        .informationOnTreeFellingAndPlanting ??=
                    CutTreeOptions.first.value;

                return EDropDown(
                  CutTreeOptions,
                  disableImage: true,
                  index: 5,
                  isShowAbnormal: false,
                  enable: ticketController.argument.isEdit(),
                  title: 'Những thông tin về chặt cây, kế hoạch trồng cây',
                  defaultValue: controller.lineContent.value.lineRightsOfWay
                      .informationOnTreeFellingAndPlanting,
                  weight: FontWeight.normal,
                  onChange: (option, mess) {
                    controller.lineContent.value.lineRightsOfWay
                        .informationOnTreeFellingAndPlanting = option.value;
                    // controller.lineContent.value.lineRightsOfWay.setUnusually(mess);
                  },
                  images: controller.lineContent.value.lineRightsOfWay.images,
                );
              }(),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Text(
              'Các thay đổi xung quanh  đường dây',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
        Container(
          margin: const EdgeInsets.only(left: 8),
          child: Column(
            children: [
              ELineDropDown(
                KCOptions,
                title: 'Đất, đá lở',
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
                isSelectArea: true,
                index: 6,
                isShowAbnormal: false,
                enable: ticketController.argument.isEdit(),
                equipmentModel: controller.listSubstations,
                problemPositions: controller
                    .lineContent.value.lineRightsOfWay.problemPositions
                    ?.where((element) => element.fieldValue == 6)
                    ?.toList(),
                defaultValue: controller
                        .lineContent.value.lineRightsOfWay.problemPositions
                        ?.firstWhere((element) => element.fieldValue == 6,
                            orElse: () => null)
                        ?.problemValue ??
                    KCOptions.first.value,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
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
                weight: FontWeight.normal,
              ),
              () {
                if (controller.lineContent.value.lineRightsOfWay
                            .theWorksAreUnderConstruction ==
                        null ||
                    controller.lineContent.value.lineRightsOfWay
                        .theWorksAreUnderConstruction.isEmpty) {
                  controller.lineContent.value.lineRightsOfWay
                      .theWorksAreUnderConstruction = "Không";
                }
                return ETextArea(
                  title: 'Các công trình đang xây dựng',
                  isRequire: true,
                  enable: ticketController.argument.isEdit(),
                  value: controller.lineContent.value.lineRightsOfWay
                      .theWorksAreUnderConstruction,
                  onChange: (value) {
                    controller.lineContent.value.lineRightsOfWay
                        .theWorksAreUnderConstruction = value;
                  },
                );
              }(),
              () {
                if (controller.lineContent.value.lineRightsOfWay
                            .informationConstructionPlan ==
                        null ||
                    controller.lineContent.value.lineRightsOfWay
                        .informationConstructionPlan.isEmpty) {
                  controller.lineContent.value.lineRightsOfWay
                      .informationConstructionPlan = "Không";
                }
                return ETextArea(
                  title: 'Thông tin về các kế hoạch xây dựng',
                  isRequire: true,
                  enable: ticketController.argument.isEdit(),
                  value: controller.lineContent.value.lineRightsOfWay
                      .informationConstructionPlan,
                  onChange: (value) {
                    controller.lineContent.value.lineRightsOfWay
                        .informationConstructionPlan = value;
                  },
                );
              }(),
              () {
                controller.lineContent.value.lineRightsOfWay
                    .changesConstruction ??= KCOptions.first.value;

                return EDropDown(
                  KCOptions,
                  title:
                      'Thay đổi nhà cửa, công trình công cộng, hệ thống giao thông',
                  isShowAbnormal: false,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    controller.setAbnormal(
                        categoryName,
                        controller.lineContent.value.lineRightsOfWay,
                        abnormal,
                        index,
                        InspectionCategory.lineRightsOfWay);
                  },
                  defaultValue: controller
                      .lineContent.value.lineRightsOfWay.changesConstruction,
                  enable: ticketController.argument.isEdit(),
                  onChange: (option, mess) {
                    controller.lineContent.value.lineRightsOfWay
                        .setUnusually(mess);
                    controller.lineContent.value.lineRightsOfWay
                        .changesConstruction = option.value;
                  },
                  index: 7,
                  images: controller.lineContent.value.lineRightsOfWay.images,
                  onAttachImages: (images, index) {
                    controller.lineContent.value.lineRightsOfWay
                        .setImages(images, 7);
                  },
                  weight: FontWeight.normal,
                );
              }(),
              () {
                controller.lineContent.value.lineRightsOfWay
                    .possibleProblematic ??= KCOptions.first.value;

                return EDropDown(
                  KCOptions,
                  title: 'Có khả năng gây sự cố',
                  isShowAbnormal: false,
                  enable: ticketController.argument.isEdit(),
                  defaultValue: controller
                      .lineContent.value.lineRightsOfWay.possibleProblematic,
                  onChange: (option, mess) {
                    controller.lineContent.value.lineRightsOfWay
                        .setUnusually(mess);
                    controller.lineContent.value.lineRightsOfWay
                        .possibleProblematic = option.value;
                  },
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    controller.setAbnormal(
                        categoryName,
                        controller.lineContent.value.lineRightsOfWay,
                        abnormal,
                        index,
                        InspectionCategory.lineRightsOfWay);
                  },
                  index: 8,
                  images: controller.lineContent.value.lineRightsOfWay.images,
                  onAttachImages: (images, index) {
                    controller.lineContent.value.lineRightsOfWay
                        .setImages(images, 8);
                  },
                  weight: FontWeight.normal,
                );
              }(),
              () {
                controller.lineContent.value.lineRightsOfWay
                    .handlingImmediatelyInspection ??= KCOptions.first.value;
                return EDropDown(
                  KCOptions,
                  changeTextColorIfNotDefault: false,
                  isShowAbnormal: false,
                  enable: ticketController.argument.isEdit(),
                  title: 'Xử  lý ngay trong kiểm tra',
                  defaultValue: controller.lineContent.value.lineRightsOfWay
                      .handlingImmediatelyInspection,
                  onChange: (option, mess) {
                    // controller.lineContent.value.lineRightsOfWay
                    //     .setUnusually(mess);
                    controller.lineContent.value.lineRightsOfWay
                        .handlingImmediatelyInspection = option.value;
                  },
                  index: 9,
                  images: controller.lineContent.value.lineRightsOfWay.images,
                  onAttachImages: (images, index) {
                    controller.lineContent.value.lineRightsOfWay
                        .setImages(images, 9);
                  },
                  weight: FontWeight.normal,
                );
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
                return ETextArea(
                  title: 'Đề xuất xử lý bất thường/ hư hỏng',
                  isRequire: true,
                  enable: ticketController.argument.isEdit(),
                  value: controller.lineContent.value.lineRightsOfWay
                      .suggestedHandlingOfAbnormal,
                  onChange: (value) {
                    controller.lineContent.value.lineRightsOfWay
                        .suggestedHandlingOfAbnormal = value;
                  },
                );
              }()
            ],
          ),
        ),
      ],
    );
  }

  Widget _renderCheckList(
    MediumContentBranchController controller,
  ) {
    return Obx(() => GridView.count(
          crossAxisCount: GetPlatform.isMobile ? 1 : 2,
          shrinkWrap: true,
          crossAxisSpacing: 10,
          childAspectRatio: 6 / 1.1,
          physics: const NeverScrollableScrollPhysics(),
          children: controller?.listPopups
                  ?.map((e) => ContentCheckListDayButton(e, marginHorizontal: 0,
                          onTap: () {
                        _handleCheckListTap(controller, e);
                      }))
                  ?.toList() ??
              <ContentCheckListDayButton>[],
        ));
  }

  Future _handleCheckListTap(MediumContentBranchController controller,
      PopupsDataModel popupsDataModel) async {
    //final name = popupsDataModel.equipmentName;
    final actionType = controller.ticketController.argument.actionType;
    switch (popupsDataModel.inspectionCategory) {
      case InspectionCategory.linePole:
        await openPopup(
            popupsDataModel,
            AppStrings.linePole,
            LineDayPolesPopup(
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
            LineDayBeamPopup(
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
            LineDayFudamentPopup(
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
            LineDayWirePopup(
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
            LineDayInsulationPopup(
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
            LineDayRodRapPopup(
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
            LineDayLightningArresterPopup(
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
            LineDayEarthingPopup(
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
            LineDayDisconnectorsSwitchPopup(
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
            LineDayRecloserPopup(
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
            LineDayCuttingMachinesPopup(
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
            LineDayFuseCutOutPopup(
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
            LineDayCapacitorsPopup(
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
            LineDayMeasureBoundariesPopup(
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
            controller);

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
            controller);

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
            controller);

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
            controller);

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

  Widget _renderHeaderTitle(
      MediumContentBranchController subController, String title) {
    final _headerTitleStyle = TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
        color: subController?.lineBranchInfo?.value?.isSaved == true
            ? Colors.white
            : Colors.grey);
    final abnormalCount =
        subController?.lineBranchInfo?.value?.abnormalCount ??= 0;
    return ListTile(
      leading: (subController?.lineBranchInfo?.value?.isSaved == true)
          ? Icon(
              Icons.assignment_turned_in,
              color: subController?.lineBranchInfo?.value?.isSaved == true
                  ? AppColor.highlightColor70
                  : Colors.grey,
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
          print(" API ------------------------------------");

          if (value && !subController.loadDataSuccess.value) {
            // Run getAbnormalOptions in parallel (no await)
            subController.getAbnormalOptions(
                inspectionCategory: InspectionCategory.lineRightsOfWay);
            print("API ---------- getBranchData");
            // Wait for getBranchData to complete before continuing
            await subController.getBranchData();
          }

          if (value && subController.listSubstations.isEmpty) {
            print("API ---------- getBranchNodes");
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

  Widget _renderMenuItem(
      MediumContentBranchController controller, LineBranchInfo info) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (AppShared.instance.getAppType() != AppType.HTLDHT)
                ETextArea(
                  title: 'Thông tin nhánh cha',
                  minLine: 1,
                  enable: false,
                  value: info.getParentsName(),
                  weight: FontWeight.w500,
                ),
              const SizedBox(
                height: 16,
              ),
              if (ticketController.argument.actionType != ActionType.view)
                Row(
                  children: [
                    EButton(
                        maxSize: false,
                        title: AppShared.instance.getAppType() == AppType.HTLDTT
                            ? 'Lưu và kiểm tra nhánh'
                            : 'Lưu',
                        action: () async {
                          // FocusScope.of(context).requestFocus(FocusNode());
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
              const SizedBox(
                height: 16,
              ),
              // Only show detailed content if showDetailContent is true
              if (controller.showDetailContent.value) ...[
                _renderFirstSection(controller, 'Hành lang tuyến'),
                const SizedBox(height: 16),
                ELabel(
                  title: AppShared.instance.getAppType() == AppType.HTLDHT
                      ? 'Thiết bị công trình'
                      : 'Thiết bị đường dây',
                ),
                const SizedBox(height: 10),
                _renderCheckList(controller),
                const SizedBox(
                  height: 20,
                ),
                TitleWithAutoButtonView('Diễn giải các hiện tượng bất thường',
                    controller.getAbnormalPhenomenon,
                    actionType:
                        controller.ticketController.argument.actionType),
                Obx(() {
                  controller?.lineContent?.value?.specificPhenomena ??= 'Không';
                  if (controller.abnormalPhenomenon.value != null) {}
                  return ESingleTextArea(
                    isRequire: true,
                    isEnable: ticketController.argument.isEdit(),
                    value: controller?.lineContent?.value?.specificPhenomena,
                    onChanged: (value) {
                      controller?.lineContent?.value?.specificPhenomena = value;
                    },
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
                const ELabel(
                  title: 'Các tồn tại đã xử lý',
                ),
                () {
                  controller.lineContent.value.processed ??= 'Không';
                  return ESingleTextArea(
                    value: controller.lineContent.value.processed,
                    isRequire: true,
                    isEnable: ticketController.argument.isEdit(),
                    onChanged: (value) {
                      controller.lineContent.value.processed = value;
                    },
                  );
                }(),
                const SizedBox(
                  height: 20,
                ),
                if (ticketController.argument.actionType != ActionType.view)
                  EButton(
                      maxSize: true,
                      title: AppShared.instance.getAppType() == AppType.HTLDTT
                          ? 'Lưu và kiểm tra nhánh'
                          : 'Lưu và kiểm tra nút',
                      action: () async {
                        // FocusScope.of(context).requestFocus(FocusNode());
                        await controller.updateBranchData();
                        // Force refresh sticky header to update abnormalCount and isSaved status
                        controller.lineBranchInfo.refresh();
                        setState(() {});
                      })
              ],
            ],
          ),
        ));
  }

  @override
  void updateContentSuccess() {
    widget.next();
  }
}

