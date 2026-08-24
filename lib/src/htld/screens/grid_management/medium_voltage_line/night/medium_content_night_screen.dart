// @dart=2.9
import 'package:evnmobile/src/htld/common/components/app_button.dart';
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/models/line/line_branch_info.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_line_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_section_title.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_single_text_area.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/title_with_auto_button_view.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/line_ticket_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/medium_content_branch_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/constance/inspection_category.dart';
import '../../containers/e_drop_down.dart';
import '../../containers/e_label.dart';
import '../../containers/e_text_area.dart';
import '../../containers/e_text_field.dart';
import '../medium_content_controller.dart';

class MediumContentNightScreen extends StatefulWidget {
  final Function next;

  const MediumContentNightScreen({this.next});

  @override
  _MediumContentNightScreenState createState() =>
      _MediumContentNightScreenState();
}

class _MediumContentNightScreenState extends State<MediumContentNightScreen>
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

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: ESectionTitle('Nội dung kiểm tra'),
                    ),
                    Obx(() => Column(
                          children: mediumContentController?.listLineBranchInfo
                                  ?.mapIndexed(_renderMenu)
                                  ?.toList() ??
                              List.empty(),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  // - First Section
  Widget _renderFirstSection(
      MediumContentBranchController controller, String title) {
    const _paddingHorizontal = 16.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ELabel(
          title: title,
          padding: const EdgeInsets.symmetric(horizontal: _paddingHorizontal),
        ),
        _renderRowA(controller, 'Mối nối, nối lèo'),
        _renderRowB(controller, 'Dây dẫn'),
        _renderRowC(controller, 'Cách điện'),
      ],
    );
  }

  // - A
  Widget _renderRowA(MediumContentBranchController controller, String title) {
    controller.lineContent.value.lineJoint.title = title;
    const _paddingHorizontal = 16.0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          margin: const EdgeInsets.only(left: _paddingHorizontal),
          padding: const EdgeInsets.only(top: _paddingHorizontal),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )),
      Container(
        margin: const EdgeInsets.only(left: 8),
        child: Column(
          children: [
            ELineDropDown(
              LineOption.DBVH_D_PN_Option,
              title: 'Tình trạng',
              paddingHorizontal: _paddingHorizontal,
              index: 1,
              onSelectedAbnormalOption:
                  (categoryName, abnormal, index, optionCategory) {
                controller.setAbnormalLine(
                    categoryName,
                    controller.lineContent.value.lineJoint,
                    abnormal,
                    index,
                    optionCategory,
                    InspectionCategory.lineNightJoint);
              },
              isShowAbnormal: false,
              enable: ticketController.argument.isEdit(),
              equipmentModel: controller.listSubstations,
              problemPositions: controller
                  .lineContent.value.lineJoint?.problemPositions
                  ?.where((element) => element.fieldValue == 1)
                  ?.toList(),
              images: controller.lineContent.value.lineJoint?.images,
              onDataChange: (optionData, index, mess, listData, isAbnormal) {
                controller.lineContent.value.lineJoint?.setProblemPositions(
                    mess, optionData, index,
                    isAbnormal: isAbnormal);
                controller.lineContent.value.lineJoint
                    .setLineUnusually(mess, listData);
              },
              onAttachImages: (images, index) {
                controller.lineContent.value.lineJoint?.setImages(images, 1);
              },
            ),
            ETextField(
              title: 'Nhiệt độ',
              isRequire: true,
              enable: ticketController.argument.isEdit(),
              value: controller.lineContent.value.lineJoint.jointTemperature,
              onChange: (value) {
                controller.lineContent.value.lineJoint.jointTemperature = value;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(_paddingHorizontal),
              child: ETextArea(
                title: 'Các hiện tượng cụ thể',
                value: controller.lineContent.value.lineJoint.specificPhenomena,
                isRequire: true,
                enable: ticketController.argument.isEdit(),
                onChange: (value) {
                  controller.lineContent.value.lineJoint.specificPhenomena =
                      value;
                },
              ),
            ),
            EDropDown(
              KCOptions,
              title: 'Có khả năng gây sự cố',
              weight: FontWeight.normal,
              isShowAbnormal: false,
              enable: ticketController.argument.isEdit(),
              paddingHorizontal: _paddingHorizontal,
              images: controller.lineContent.value.lineJoint.images,
              index: 2,
              onSelectedAbnormalOption: (categoryName, abnormal, index) {
                controller.setAbnormal(
                    categoryName,
                    controller.lineContent.value.lineJoint,
                    abnormal,
                    index,
                    InspectionCategory.lineNightJoint);
              },
              onAttachImages: (images, index) {
                controller.lineContent.value.lineJoint.setImages(images, 2);
              },
              defaultValue:
                  controller.lineContent.value.lineJoint.possibleProblematic,
              onChange: (option, mess) {
                controller.lineContent.value.lineJoint.possibleProblematic =
                    option.value;
                controller.lineContent.value.lineJoint.setUnusually(mess);
              },
            ),
            EDropDown(
              KCOptions,
              title: 'Xử lý ngay trong kiểm tra',
              weight: FontWeight.normal,
              enable: ticketController.argument.isEdit(),
              isShowAbnormal: false,
              paddingHorizontal: _paddingHorizontal,
              images: controller.lineContent.value.lineJoint.images,
              index: 3,
              onAttachImages: (images, index) {
                controller.lineContent.value.lineJoint.setImages(images, 3);
              },
              defaultValue: controller.lineContent.value.lineJoint
                  .jointHandlingImmediatelyInspection,
              onChange: (option, mess) {
                controller.lineContent.value.lineJoint
                    .jointHandlingImmediatelyInspection = option.value;
                // controller.lineContent.value.lineJoint.setUnusually(mess);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(_paddingHorizontal),
              child: ETextArea(
                title: 'Đề xuất xử lý bất thường/ hư hỏng',
                isRequire: true,
                enable: ticketController.argument.isEdit(),
                value: controller
                    .lineContent.value.lineJoint.suggestedHandlingOfAbnormal,
                onChange: (value) {
                  controller.lineContent.value.lineJoint
                      .suggestedHandlingOfAbnormal = value;
                },
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  // - B
  Widget _renderRowB(MediumContentBranchController controller, String title) {
    controller.lineContent.value.lineWire.title = title;
    const _paddingHorizontal = 16.0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          margin: const EdgeInsets.only(left: _paddingHorizontal),
          padding: const EdgeInsets.only(top: _paddingHorizontal),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )),
      Container(
        margin: const EdgeInsets.only(left: 8),
        child: Column(
          children: [
            EDropDown(KCOptions,
                title: 'Âm thanh bất thường',
                weight: FontWeight.normal,
                isShowAbnormal: false,
                images: controller.lineContent.value.lineWire.images,
                index: 1,
                enable: ticketController.argument.isEdit(),
                onAttachImages: (images, index) {
                  controller.lineContent.value.lineWire.setImages(images, 1);
                },
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  controller.setAbnormal(
                      categoryName,
                      controller.lineContent.value.lineWire,
                      abnormal,
                      index,
                      InspectionCategory.lineNightWire);
                },
                defaultValue:
                    controller.lineContent.value.lineWire.unusualSound,
                onChange: (option, mess) {
                  controller.lineContent.value.lineWire.unusualSound =
                      option.value;
                  controller.lineContent.value.lineWire.setUnusually(mess);
                },
                paddingHorizontal: _paddingHorizontal),
            ETextField(
              title: 'Vật liệu lạ bám vào dây',
              value:
                  controller.lineContent.value.lineWire.materialClingingToWire,
              isRequire: true,
              enable: ticketController.argument.isEdit(),
              onChange: (value) {
                controller.lineContent.value.lineWire.materialClingingToWire =
                    value;
              },
            ),
            EDropDown(
              KCOptions,
              title: 'Phóng điện',
              enable: ticketController.argument.isEdit(),
              weight: FontWeight.normal,
              isShowAbnormal: false,
              paddingHorizontal: _paddingHorizontal,
              images: controller.lineContent.value.lineWire.images,
              index: 2,
              onSelectedAbnormalOption: (categoryName, abnormal, index) {
                controller.setAbnormal(
                    categoryName,
                    controller.lineContent.value.lineWire,
                    abnormal,
                    index,
                    InspectionCategory.lineNightWire);
              },
              onAttachImages: (images, index) {
                controller.lineContent.value.lineWire.setImages(images, 2);
              },
              defaultValue:
                  controller.lineContent.value.lineWire.electricDischarge,
              onChange: (option, mess) {
                controller.lineContent.value.lineWire.electricDischarge =
                    option.value;
                controller.lineContent.value.lineWire.setUnusually(mess);
              },
            ),
            Padding(
                padding: const EdgeInsets.all(_paddingHorizontal),
                child: ETextArea(
                  title: 'Các hiện tượng cụ thể',
                  enable: ticketController.argument.isEdit(),
                  value: controller.lineContent.value.lineWire
                      .getSpecificPhenomena(),
                  isRequire: true,
                  onChange: (value) {
                    controller.lineContent.value.lineWire.specificPhenomena =
                        value;
                  },
                )),
            EDropDown(
              KCOptions,
              title: 'Có nguy cơ sự cố',
              weight: FontWeight.normal,
              isShowAbnormal: false,
              enable: ticketController.argument.isEdit(),
              paddingHorizontal: _paddingHorizontal,
              images: controller.lineContent.value.lineWire.images,
              index: 3,
              onSelectedAbnormalOption: (categoryName, abnormal, index) {
                controller.setAbnormal(
                    categoryName,
                    controller.lineContent.value.lineWire,
                    abnormal,
                    index,
                    InspectionCategory.lineNightWire);
              },
              onAttachImages: (images, index) {
                controller.lineContent.value.lineWire.setImages(images, 3);
              },
              defaultValue:
                  controller.lineContent.value.lineWire.possibleProblematic,
              onChange: (option, mess) {
                controller.lineContent.value.lineWire.possibleProblematic =
                    option.value;
                controller.lineContent.value.lineWire.setUnusually(mess);
              },
            ),
            EDropDown(
              KCOptions,
              title: 'Xử lý ngay trong kiểm tra',
              weight: FontWeight.normal,
              isShowAbnormal: false,
              enable: ticketController.argument.isEdit(),
              paddingHorizontal: _paddingHorizontal,
              images: controller.lineContent.value.lineWire.images,
              index: 4,
              onAttachImages: (images, index) {
                controller.lineContent.value.lineWire.setImages(images, 4);
              },
              defaultValue: controller
                  .lineContent.value.lineWire.handlingImmediatelyInspection,
              onChange: (option, mess) {
                controller.lineContent.value.lineWire
                    .handlingImmediatelyInspection = option.value;
                //   controller.lineContent.value.lineWire.setUnusually(mess);
              },
            ),
            Padding(
                padding: const EdgeInsets.all(_paddingHorizontal),
                child: ETextArea(
                  title: 'Đề xuất xử lý bất thường/ hư hỏng',
                  isRequire: true,
                  enable: ticketController.argument.isEdit(),
                  value: controller.lineContent.value.lineWire
                      .getSuggestedHandlingOfAbnormal(),
                  onChange: (value) {
                    controller.lineContent.value.lineWire
                        .suggestedHandlingOfAbnormal = value;
                  },
                )),
          ],
        ),
      ),
    ]);
  }

  // - C
  Widget _renderRowC(MediumContentBranchController controller, String title) {
    controller.lineContent.value.lineInsulationContent.title = title;
    const _paddingHorizontal = 16.0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          margin: const EdgeInsets.only(left: _paddingHorizontal),
          padding: const EdgeInsets.only(top: _paddingHorizontal),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )),
      Container(
        margin: const EdgeInsets.only(left: 8),
        child: Column(
          children: [
            EDropDown(
              KCOptions,
              title: 'Phóng điện',
              weight: FontWeight.normal,
              isShowAbnormal: false,
              enable: ticketController.argument.isEdit(),
              paddingHorizontal: _paddingHorizontal,
              images: controller.lineContent.value.lineInsulationContent.images,
              index: 1,
              onSelectedAbnormalOption: (categoryName, abnormal, index) {
                controller.setAbnormal(
                    categoryName,
                    controller.lineContent.value.lineInsulationContent,
                    abnormal,
                    index,
                    InspectionCategory.lineNightInsulation);
              },
              onAttachImages: (images, index) {
                controller.lineContent.value.lineInsulationContent
                    .setImages(images, 1);
              },
              defaultValue: controller
                  .lineContent.value.lineInsulationContent.electricDischarge,
              onChange: (option, mess) {
                controller.lineContent.value.lineInsulationContent
                    .electricDischarge = option.value;
                controller.lineContent.value.lineInsulationContent
                    .setUnusually(mess);
              },
            ),
            Padding(
                padding: const EdgeInsets.all(_paddingHorizontal),
                child: ETextArea(
                  title: 'Các hiện tượng cụ thể',
                  isRequire: true,
                  enable: ticketController.argument.isEdit(),
                  value: controller.lineContent.value.lineInsulationContent
                      .getSpecificPhenomena(),
                  onChange: (value) {
                    controller.lineContent.value.lineInsulationContent
                        .specificPhenomena = value;
                  },
                )),
            EDropDown(
              KCOptions,
              title: 'Có nguy cơ sự cố',
              weight: FontWeight.normal,
              isShowAbnormal: false,
              enable: ticketController.argument.isEdit(),
              paddingHorizontal: _paddingHorizontal,
              images: controller.lineContent.value.lineInsulationContent.images,
              index: 2,
              onAttachImages: (images, index) {
                controller.lineContent.value.lineInsulationContent
                    .setImages(images, 2);
              },
              onSelectedAbnormalOption: (categoryName, abnormal, index) {
                controller.setAbnormal(
                    categoryName,
                    controller.lineContent.value.lineInsulationContent,
                    abnormal,
                    index,
                    InspectionCategory.lineNightInsulation);
              },
              defaultValue: controller
                  .lineContent.value.lineInsulationContent.possibleProblematic,
              onChange: (option, mess) {
                controller.lineContent.value.lineInsulationContent
                    .possibleProblematic = option.value;
                controller.lineContent.value.lineInsulationContent
                    .setUnusually(mess);
              },
            ),
            EDropDown(
              KCOptions,
              title: 'Xử lý ngay trong kiểm tra',
              weight: FontWeight.normal,
              isShowAbnormal: false,
              enable: ticketController.argument.isEdit(),
              paddingHorizontal: _paddingHorizontal,
              images: controller.lineContent.value.lineInsulationContent.images,
              index: 3,
              onAttachImages: (images, index) {
                controller.lineContent.value.lineInsulationContent
                    .setImages(images, 3);
              },
              defaultValue: controller.lineContent.value.lineInsulationContent
                  .handlingImmediatelyInspection,
              onChange: (option, mess) {
                controller.lineContent.value.lineInsulationContent
                    .handlingImmediatelyInspection = option.value;
                controller.lineContent.value.lineInsulationContent
                    .setUnusually(mess);
              },
            ),
            Padding(
                padding: const EdgeInsets.all(_paddingHorizontal),
                child: ETextArea(
                  title: 'Đề xuất xử lý bất thường/ hư hỏng',
                  value: controller.lineContent.value.lineInsulationContent
                      .getSuggestedHandlingOfAbnormal(),
                  isRequire: true,
                  enable: ticketController.argument.isEdit(),
                  onChange: (value) {
                    controller.lineContent.value.lineInsulationContent
                        .suggestedHandlingOfAbnormal = value;
                  },
                )),
          ],
        ),
      ),
    ]);
  }

  Widget _renderMenu(LineBranchInfo info, int index) {
    final subController = mediumContentController.listController[index];
    subController.lineBranchInfo.value = info;
    return Container(
      key: UniqueKey(),
      padding: const EdgeInsets.only(top: 8),
      child: ListTileTheme(
        key: UniqueKey(),
        tileColor: Colors.grey.shade100,
        child: ExpansionTile(
          key: UniqueKey(),
          initiallyExpanded: false,
          onExpansionChanged: (value) {
            if (value && subController.listSubstations.isEmpty) {
              subController.getBranchNodes();
            }
            if (value && !subController.loadDataSuccess.value) {
              subController.getAbnormalOptions(inspectionCategory: InspectionCategory.lineNightJoint);
              subController.getAbnormalOptions(inspectionCategory: InspectionCategory.lineNightInsulation);
              subController.getAbnormalOptions(inspectionCategory: InspectionCategory.lineNightWire);
              subController.getBranchData();
            }
          },
          childrenPadding: const EdgeInsets.only(bottom: 10),
          title: _renderHeaderTitle(subController, info.lineBranchName),
          children: [_renderMenuItem(subController, info)],
        ),
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
              minLine: 1,
              enable: false,
              value: info.getParentsName(),
              weight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          _renderFirstSection(controller, 'Hành lang tuyến'),
          const SizedBox(
            height: 20,
          ),
          TitleWithAutoButtonView('Diễn giải các hiện tượng bất thường',
              controller.getAbnormalPhenomenon,
              horizontalPadding: 16,
              actionType: controller.ticketController.argument.actionType),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() {
              if (controller.abnormalPhenomenon.value != null) {}
              return ESingleTextArea(
                isRequire: true,
                isEnable: ticketController.argument.isEdit(),
                value: controller?.lineContent?.value?.specificPhenomena ?? '',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ESingleTextArea(
              isRequire: true,
              isEnable: ticketController.argument.isEdit(),
              value: controller.lineContent.value.processed ?? '',
              onChanged: (value) {
                controller.lineContent.value.processed = value;
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          if (ticketController.argument.actionType != ActionType.view)
            Padding(
              padding: const EdgeInsets.all(16),
              child: EButton(
                  maxSize: true,
                  title: 'Lưu và kiểm tra nhánh',
                  action: () {
                    controller.updateBranchData();
                  }),
            )
        ],
      );
    });
  }

  @override
  void updateContentSuccess() {
    widget.next();
  }
}

