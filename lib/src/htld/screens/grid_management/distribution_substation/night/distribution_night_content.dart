// @dart=2.9

import 'package:evnmobile/src/htld/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/models/transformer_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_page_view.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_section_title.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/popup_mobile_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/title_with_auto_button_view.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/distribution_day_content_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/components/app_button.dart';
import '../../../../common/extension/extension.dart';
import '../../../../common/themes/colorx.dart';
import '../../../../common/utils/alert_dialog_utils.dart';
import '../../containers/content_checklist_button.dart';
import '../../containers/e_label.dart';
import '../../containers/e_single_text_area.dart';
import '../../containers/e_text_field.dart';
import 'distribution_night_content_controller.dart';
import 'popups/joint_contact.dart';
import 'popups/light_system.dart';
import 'popups/substation.dart';

class DistributionNightContent extends StatefulWidget {
  final Function next;

  const DistributionNightContent({this.next});

  @override
  State<StatefulWidget> createState() {
    return DistributionContentState();
  }
}

class DistributionContentState extends State<DistributionNightContent>
    implements DistributionDayContentDelegate {
  final DistributionNightContentController _contentCheckController =
      DistributionNightContentController();
  final TicketController _ticketController = Get.find();
  bool isProcessing = false;
  @override
  void initState() {
    super.initState();
    _contentCheckController.delegate = this;
    Future.delayed(const Duration(microseconds: 200), () {
      _contentCheckController.getContentNight(_ticketController.ticketID);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _contentCheckController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.grey.shade50,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _renderListMBA(),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ESectionTitle('Nội dung kiểm tra'),
                      ),
                      _renderCheckList(),
                      const SizedBox(
                        height: 16,
                      ),
                      TitleWithAutoButtonView(
                        'Diễn giải các hiện tượng bất thường',
                        _contentCheckController.getAbnormalPhenomenon,
                        horizontalPadding: 16,
                        actionType:
                            _ticketController.ticketScreenArgument.actionType,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Obx(() {
                            if (_contentCheckController.abnormalPhenomenon.value != null) {}
                            return ESingleTextArea(
                              isEnable: _ticketController.ticketScreenArgument.actionType != ActionType.view,
                              value: _contentCheckController.distributionContentNightResponse.value.abnormalPhenomenon,
                              onChanged: (value) {
                                _contentCheckController.distributionContentNightResponse.value.abnormalPhenomenon = value;
                              },
                            );
                          })),
                      const SizedBox(
                        height: 16,
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: ELabel(
                            title: 'Các tồn tại đã xử lý',
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Obx(() => ESingleTextArea(
                          isEnable: _ticketController.ticketScreenArgument.actionType != ActionType.view,
                          value: _contentCheckController
                              .distributionContentNightResponse.value.processed,
                          onChanged: (value) {
                            _contentCheckController
                                .distributionContentNightResponse.value.processed = value;
                          },
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_ticketController.ticketScreenArgument.actionType !=
                ActionType.view)
              Container(
                margin: const EdgeInsets.all(16),
                child: EButton(
                  maxSize: true,
                  title: 'Lưu và thực hiện kiểm tra',
                  action: () {
                    _contentCheckController.createContent();
                  },
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _renderListMBA() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24,),
        if (_contentCheckController?.transformers?.isNotEmpty ?? false) const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ESectionTitle('Thông số vận hành'),
        ),
        Obx(() {
          if (_contentCheckController?.transformers?.isEmpty ?? true) {
            return Container();
          }
          return Column(
            children: _contentCheckController?.transformers?.map((e) {
              final i = _contentCheckController.transformers.indexOf(e);
              final mbaIIndex = i + 1;
              return GetPlatform.isMobile
                  ? _renderMBAMobile('MBA $mbaIIndex', e)
                  : _renderMBA('MBA $mbaIIndex', e);
            })?.toList() ??
                <Container>[],
          );
        })
      ],
    );
  }

  Widget _renderMBA(String title, TransformerModel transformerModel) {
    final fields2 = <Map<String, String>>[
      {'title': 'UhA(V) =', 'id': 'uha'},
      {'title': 'IhA(A) =', 'id': 'iha'},
      {'title': '', 'id': ''},
      {'title': 'CosΦ A =', 'id': 'cosA'},
      {'title': 'UhB(V) =', 'id': 'uhb'},
      {'title': 'IhB(A) =', 'id': 'ihb'},
      {'title': 'I0(A) =', 'id': 'i0'},
      {'title': 'CosΦ B = ', 'id': 'cosB'},
      {'title': 'UhC(V) =', 'id': 'uhc'},
      {'title': 'IhC(A) =', 'id': 'ihc'},
      {'title': '', 'id': ''},
      {'title': 'CosΦ C =', 'id': 'cosC'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            title,
            style: const TextStyle(
                color: AppColor.highlightColor, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          childAspectRatio: 6 / 3,
          physics: const NeverScrollableScrollPhysics(),
          children: fields2.mapIndexed((e, i) {
                final title = e['title'];
                final key = e['id'];
                return title.isEmpty
                    ? Container()
                    : Obx(() => ETextField(
                        title: title,
                        spaceBetween: 4,
                        contentHorizontalPadding: 4,
                        textAlign: TextAlign.center,
                        enable: _ticketController.ticketScreenArgument.actionType != ActionType.view,
                        value: _contentCheckController.getValueMBAField(
                            transformerModel.equipmentId, key),
                        onChange: (value) {
                          _contentCheckController.updateValueTransformer(
                              key, transformerModel.equipmentId, value);
                        }));
              })?.toList() ??
              <Container>[],
        )
      ],
    );
  }

  Widget _renderMBAMobile(String title, TransformerModel transformerModel) {
    final page1 = [
      EPageViewModel('UhA(V)', 'uha'),
      EPageViewModel('UhB(V)', 'uhb'),
      EPageViewModel('UhC(V)', 'uhc'),
    ];
    final page2 = [
      EPageViewModel('IhA(A)', 'iha'),
      EPageViewModel('IhB(A)', 'ihb'),
      EPageViewModel('IhC(A)', 'ihc'),
      EPageViewModel('I0(A)', 'i0'),

    ];
    final page3 = [
      EPageViewModel('CosΦ A', 'cosA'),
      EPageViewModel('CosΦ B', 'cosB'),
      EPageViewModel('CosΦ C', 'cosC')
    ];
    final listMBA = [page1, page2, page3];
    listMBA.forEach((element) {
      element.forEach((elementChild) {
        elementChild.value = _contentCheckController.getValueMBAField(
            transformerModel.equipmentId, elementChild.id);
      });
    });
    return EPageView(
      listMBA ?? [],
      title: title,
      onChange: (value, key) {
        _contentCheckController.updateValueTransformer(
            key, transformerModel.equipmentId, value);
      },
    );
  }

  Widget _renderCheckList() {
    return Obx(() => GridView.count(
          crossAxisCount: GetPlatform.isMobile ? 1 : 2,
          shrinkWrap: true,
          childAspectRatio: 6 / 1.1,
          crossAxisSpacing: 10,
          physics: const NeverScrollableScrollPhysics(),
          //children: checkConnect(),
          children: _contentCheckController?.listPopups
                  ?.map((e) => ContentCheckListDayButton(
                        e,
                        onTap: () {
                          _handleChecklistNightTap(e, e.equipmentName);
                        },
                      ))
                  ?.toList() ??
              <Container>[],
        ));
  }
  Future _handleChecklistNightTap(
      PopupsDataModel popupsDataModel, String name) async {
    final actionType = _ticketController.ticketScreenArgument.actionType;
    popupsDataModel.isAllowEdit = !(actionType == ActionType.view);
    switch (popupsDataModel.inspectionCategory) {
      case InspectionCategory.substationNightTime:
        await openPopup(
            popupsDataModel,
            name,
            SubStationNightTimePopup(
              popupsDataModel: popupsDataModel,
            ),
            actionType);
        break;

      case InspectionCategory.jointNightTime:
        await openPopup(
            popupsDataModel,
            name,
            JointContactPopup(
              popupsDataModel: popupsDataModel,
            ),
            actionType);
        break;

      case InspectionCategory.lightingSystemNightTime:
        await openPopup(
            popupsDataModel,
            name,
            LightSystemPopup(
              popupsDataModel: popupsDataModel,
            ),
            actionType);
        break;
    }
  }

  Future openPopup(PopupsDataModel model, String name, Widget child,
      ActionType actionType) async {
    if (GetPlatform.isMobile) {
      final value = await Get.to(() => PopupMobileScreen(
            name: name,
            actionType: actionType,
            child: child,
          ));
      if (value == true) {
        _contentCheckController.updatePopupSuccess(model);
      }
      return;
    }
    final value = await showPopupCheckList(context, name, child, actionType);
    if (value == true) {
      _contentCheckController.updatePopupSuccess(model);
    }
  }

  @override
  void createContentSuccess({bool isSuccess}) {
    if (isSuccess) {
      widget.next();
    }
    isProcessing = false;
  }
}

