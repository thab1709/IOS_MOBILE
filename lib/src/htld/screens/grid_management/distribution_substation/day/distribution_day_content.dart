// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_section_title.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/popup_mobile_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/title_with_auto_button_view.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/distribution_day_content_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/breaker.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/building_structure.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/cut.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/distribution_grounding_system.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/distribution_power_cable.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/fuse_fall_off.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/insulation.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/lightning_conductor.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/low_pressure_cabinets.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/low_voltage_capacito.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/rmu.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/components/app_button.dart';
import '../../../../common/utils/alert_dialog_utils.dart';
import '../../containers/content_checklist_button.dart';
import '../../containers/e_label.dart';
import '../../containers/e_single_text_area.dart';
import 'popups/substation.dart';
import 'popups/ti.dart';
import 'popups/tu.dart';

class DistributionDayContent extends StatefulWidget {
  const DistributionDayContent({this.next});

  final Function next;

  @override
  State<StatefulWidget> createState() {
    return DistributionContentState();
  }
}

class DistributionContentState extends State<DistributionDayContent> implements
DistributionDayContentDelegate {
  final DistributionDayContentController _contentCheckController =
      DistributionDayContentController();
  final TicketController _ticketController = Get.find();
  bool isProcessing = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 200), () {
      _contentCheckController.getContentDay(_ticketController.ticketID);
    });
    _contentCheckController.delegate = this;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16,),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: ESectionTitle('Nội dung kiểm tra'),
                    ),
                    _renderCheckList(),
                    const SizedBox(
                      height: 16,
                    ),
                    TitleWithAutoButtonView(
                      'Diễn giải các hiện tượng bất thường',
                      _contentCheckController.getAbnormalPhenomenon,
                      horizontalPadding: 16, actionType: _ticketController.ticketScreenArgument.actionType
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Obx(() {
                          if (_contentCheckController.abnormalPhenomenon.value != null) {}
                          return ESingleTextArea(
                              isEnable: _ticketController.ticketScreenArgument.actionType != ActionType.view,
                            value: _contentCheckController.contentResponse.value
                                .abnormalPhenomenon,
                            onChanged: (value) {
                              _contentCheckController.contentResponse.value
                                  .abnormalPhenomenon = value;
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
                        child: Obx(
                          () => ESingleTextArea(
                            isEnable: _ticketController.ticketScreenArgument.actionType != ActionType.view,
                            value: _contentCheckController
                                .contentResponse.value.processed,
                            onChanged: (value) {
                              _contentCheckController
                                  .contentResponse.value.processed = value;
                            },
                          ),
                        )),
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
                  if (!_contentCheckController.contentResponse.value.validateData()) {
                    return showDialogValidateData();
                  }
                  if (!isProcessing) {
                    isProcessing = true;
                    _contentCheckController.createContent();
                  }
                },
              ),
            )
        ],
      ),
    );
  }

  Widget _renderCheckList() {
    return Obx(() => GridView.count(
          crossAxisCount: GetPlatform.isMobile ? 1 : 2,
          shrinkWrap: true,
          childAspectRatio: 6 / 1.1,
          crossAxisSpacing: 10,
          physics: const NeverScrollableScrollPhysics(),
          children: _contentCheckController.listPopups?.map((e) => ContentCheckListDayButton(e, onTap: () {
            _handleCheckListDayTap(e, e.getPopupName());
          },
          ))?.toList()
        ));
  }
  Future _handleCheckListDayTap(
      PopupsDataModel popupsDataModel, String name) async {
    if (popupsDataModel.inspectionCategory == 0) {
      await showDialogError('Không tìm thấy kiểu thiết bị');
      return;
    }
    final actionType = (popupsDataModel?.isAllowEdit ?? true) ? _ticketController.ticketScreenArgument.actionType : ActionType.view;
    popupsDataModel.isAllowEdit = !(actionType == ActionType.view);
    switch (popupsDataModel.inspectionCategory) {
      case InspectionCategory.distributionSubstationRoom:
        await openPopup(popupsDataModel, name, SubstationRoomPopup(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.distributionTransformer:
        await openPopup(popupsDataModel, name, SubstationPopup(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.distributionCuttingMachine:
        await openPopup(popupsDataModel, name, CutMachinePopup(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;
      case InspectionCategory.distributionRMU:
        await openPopup(popupsDataModel, name, RMUPopup(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;
      case InspectionCategory.distributionBreaker:
        await openPopup(popupsDataModel, name, BreakerPopup(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.distributionFalloffFuse:
        await openPopup(popupsDataModel, name, FallOffFusesPopup(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.distributionLightningConductor:
        await openPopup(popupsDataModel, name, LightningConductorPopup(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.distributionLowPressureCabinet:
        await openPopup(popupsDataModel, name, LowPressureCabinetPopup(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.distributionTI:
        await openPopup(popupsDataModel, name, TIPopup(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.distributionTU:

        await openPopup(popupsDataModel, name, TUPopup(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.distributionInsulation:

        await openPopup(popupsDataModel, name, InsulationPopup(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.distributionCapacitor:

        await openPopup(popupsDataModel, name, LowVoltageCapacitoPopup(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.distributionPowerCable:
        await openPopup(popupsDataModel, name, DistributionPowerCablePopup(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;
      case InspectionCategory.distributionGroundingSystem:
        await openPopup(popupsDataModel, name, DistributionGroundingSystemPopup(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.distributionConstructionStructure:
        await openPopup(popupsDataModel, name, DistributionBuildingStructurePopup(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      default:
        break;
    }
  }

  Future openPopup( PopupsDataModel model,
      String name, Widget child, ActionType actionType) async {
    var value = false;
    if (GetPlatform.isMobile) {
       value = await Get.to(() => PopupMobileScreen(name: name, actionType: actionType, child: child,));
    }else{
       value = await showPopupCheckList(context, name, child, actionType);
    }

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

