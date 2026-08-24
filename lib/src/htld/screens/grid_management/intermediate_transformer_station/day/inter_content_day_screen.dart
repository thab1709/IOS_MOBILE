// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_section_title.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/popup_mobile_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/text_special_char.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/title_with_auto_button_view.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/components/inter_outline_mobile_view.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/components/inter_transformer_mobile_view.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/inter_content_day_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/popups/fill_cabinets_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/popups/inter_cable_head_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/popups/inter_clamp_row_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/popups/inter_cutter_lbs_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/popups/inter_disconnectors_switches.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/popups/inter_electrical_cabinets_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/popups/inter_fall_of_fuse_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/popups/inter_grounding_system_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/popups/inter_immediary_station_cleaning_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/popups/inter_insulation_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/popups/inter_joint.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/popups/inter_lightning_conductor_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/popups/inter_measuring_system_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/popups/inter_r_d_t_system_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/popups/inter_variable_current_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/popups/inter_variable_voltage_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/popups/low_pressure_cable_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/day/popups/one_way_system_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/night/inter_content_night_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/components/app_button.dart';
import '../../containers/content_checklist_button.dart';
import '../../containers/e_label.dart';
import '../../containers/e_single_text_area.dart';
import '../../containers/e_single_text_field.dart';
import 'popups/a_c_system_screen.dart';
import 'popups/battery_screen.dart';
import 'popups/construction_structures_screen.dart';
import 'popups/cutting_machines_screen.dart';
import 'popups/high_pressure_cable_screen.dart';
import 'popups/inter_substation_popup.dart';
import 'popups/inter_supstation_room_popup.dart';
import 'popups/recloser.dart';

class InterContentDayScreen extends StatefulWidget {
  const InterContentDayScreen({this.next});

  final Function next;

  @override
  _InterContentDayScreenState createState() => _InterContentDayScreenState();
}

class _InterContentDayScreenState extends State<InterContentDayScreen>  implements InterContentDelegate{
  final InterContentDayController _controller = Get.put(InterContentDayController());

  final TextStyle _style = const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black);

  final EdgeInsetsGeometry _cellMargin = const EdgeInsets.all(4);

  final ticketController = Get.put(TicketController());
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
    Future.delayed(const Duration(microseconds: 200), () {
      _controller.getContentDay(ticketController.ticketID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: SafeArea(
        child: Container(
          color: Colors.grey.shade50,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20,),
                      const ESectionTitle('Thông số vận hành', padding: EdgeInsets.symmetric(horizontal: 16),),
                      Obx(() {
                        if (_controller.loadSuccess.value) {}
                        return _renderTransformerRow();
                      }),
                      Obx(() {
                        if (_controller.loadSuccess.value) {}
                        return _renderOutlineRow();
                      }),
                      const SizedBox(height: 20,),
                      const ESectionTitle('Nội dung kiểm tra', padding: EdgeInsets.symmetric(horizontal: 16),),
                      const SizedBox(height: 10,),
                      _renderCheckList(context),
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TitleWithAutoButtonView('Diễn giải các hiện tượng bất thường', _controller.getAbnormalPhenomenon, actionType: ticketController.ticketScreenArgument.actionType),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Obx(() {
                            if (_controller.abnormalPhenomenon.value != null) {}
                            return ESingleTextArea(
                              isEnable: !(ticketController.ticketScreenArgument.actionType == ActionType.view),
                              value: _controller
                                  .contentResponse.value.abnormalPhenomenon,
                              onChanged: (value) {
                                _controller.contentResponse.value
                                    .abnormalPhenomenon = value;
                              },
                            );
                          })),
                      const SizedBox(height: 20,),
                      const ELabel(title: 'Các tồn tại đã xử lý', padding: EdgeInsets.symmetric(horizontal: 16),),
                      Obx(() => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ESingleTextArea(isEnable: !(ticketController.ticketScreenArgument.actionType == ActionType.view), value: _controller.contentResponse.value.processed ?? '', onChanged: (value) {
                          _controller.contentResponse.value.processed = value;
                        },),
                      )),
                      const SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),
              if (ticketController.ticketScreenArgument.actionType !=
                  ActionType.view)
                Container(
                  margin: const EdgeInsets.all(16),
                  child: EButton(
                    maxSize: true,
                    title: 'Lưu và thực hiện kiểm tra',
                    action: () {
                      _controller.createContent();
                    },
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderTransformerRow() {
    if (_controller.listInterEquipment.isEmpty) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20,),
          if (GetPlatform.isMobile) InterTransformerMobileView(_controller.listInterEquipment, onChange: (value) {
            _controller.updateValueTransformer(value);
          },) else transformerRowTablet()
        ],
      ),
    );
  }

  Column transformerRowTablet() {
    return Column(
      children: [
        Row(
          children: const [
            Expanded( flex: 3,child: Text('Tên máy biến áp', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15), textAlign: TextAlign.center,),),
            Expanded( flex: 1,child: TextSpecialCharView(firstChar: 'U', lastChar: 'C',),),
            Expanded( flex: 1,child: TextSpecialCharView(firstChar: 'U', lastChar: 'H',),),
            Expanded( flex: 1,child: TextSpecialCharView(firstChar: 'I', lastChar: 'c',),),
            Expanded( flex: 1,child: TextSpecialCharView(firstChar: 'P', lastChar: 'c',),),
            Expanded( flex: 1,child: TextSpecialCharView(firstChar: 'I', lastChar: 'H',),),
            Expanded( flex: 1,child: TextSpecialCharView(firstChar: 'P', lastChar: 'H',),),
          ],
        ),
        const SizedBox(height: 8,),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _controller.listInterEquipment.length,
            itemBuilder: (context, index) {
            final e = _controller.listInterEquipment[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                 Expanded( flex: 3, child: Padding(
                   padding: const EdgeInsets.only(right: 8),
                   child: ESingleTextField(value: e.equipmentName, textAlign: TextAlign.center, onchange: (value) {
                    e.equipmentName = value;
                },),
                 ),),
                Expanded( flex: 1,child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ESingleTextField(value: e.uc, textAlign: TextAlign.center, onchange: (value) {
                    e.uc = value;
                  }),
                ),),
                Expanded( flex: 1,child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ESingleTextField(value: e.uh, textAlign: TextAlign.center, onchange: (value) {
                    e.uh = value;
                  }),
                ),),
                Expanded( flex: 1,child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ESingleTextField(value: e.ic, textAlign: TextAlign.center, onchange: (value) {
                    e.ic = value;
                  }),
                ),),
                Expanded( flex: 1,child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ESingleTextField(value: e.pc, textAlign: TextAlign.center, onchange: (value) {
                    e.pc = value;
                  }),
                ),),
                Expanded( flex: 1,child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ESingleTextField(value: e.ih, textAlign: TextAlign.center, onchange: (value) {
                    e.ih = value;
                  }),
                ),),
                Expanded( flex: 1,child: ESingleTextField(value: e.ph,textAlign: TextAlign.center, onchange: (value) {
                  e.ph = value;
                }),),
              ],
            ),
          );
        })// header
      ],
    );
  }

  Widget _outlineMachineTable(){
    List<TableRow> _renderTableRowOutlines(){
      final listRow = <TableRow>[];
      final header = TableRow(children: [
        Container(margin: _cellMargin, child:  Center(child: Text('Tên xuất tuyến', style: _style,))),
        Container(margin: _cellMargin, child:  const Center(child: TextSpecialCharView(firstChar: 'I', lastChar: 'A',))),
        Container(margin: _cellMargin, child:  const Center(child: TextSpecialCharView(firstChar: 'I', lastChar: 'B',))),
        Container(margin: _cellMargin, child:  const Center(child: TextSpecialCharView(firstChar: 'I', lastChar: 'C',))),
        Container(margin: _cellMargin, child:  Center(child: Text('P', style: _style,))),
      ]);

      listRow.add(header);

      _controller.listOutlines.forEach((element) =>
          listRow.add(TableRow(children: [
            Container(margin: _cellMargin, child:  Center(child: ESingleTextField(value: element.outLineName, textAlign: TextAlign.center, onchange: (value) {
              element.outLineName = value;
            },))),
            Container(margin: _cellMargin, child:  Center(child: ESingleTextField(value: element.ia, textAlign: TextAlign.center, onchange: (value) {
              element.ia = value;
            }))),
            Container(margin: _cellMargin, child:  Center(child: ESingleTextField(value: element.ib, textAlign: TextAlign.center, onchange: (value) {
              element.ib = value;
            }))),
            Container(margin: _cellMargin, child:  Center(child: ESingleTextField(value: element.ic, textAlign: TextAlign.center, onchange: (value) {
              element.ic = value;
            }))),
            Container(margin: _cellMargin, child:  Center(child: ESingleTextField(value: element.p, textAlign: TextAlign.center, onchange: (value) {
              element.p = value;
            }))),
          ]))
      );

      return listRow;
    }

    return Obx(() => Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
        6: FlexColumnWidth(1),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: _controller.listOutlines != null ? _renderTableRowOutlines() : <TableRow>[]
    ));
  }

  Widget _renderOutlineRow() {
    if (_controller.listOutlines.isEmpty) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20,),
          if (GetPlatform.isMobile) InterOutlineMobileView(_controller.listOutlines, onChange: (value) {
            _controller.updateValueOutlineMachine(value);
          },) else _outlineMachineTable()
        ],
      ),
    );
  }
  Widget _renderCheckList(BuildContext context) {
    return Obx(() =>  GridView
        .count(crossAxisCount: GetPlatform.isMobile ? 1 : 2 ,
      shrinkWrap: true,
      crossAxisSpacing: 10,
      childAspectRatio: 6/1.1,
      physics: const NeverScrollableScrollPhysics(),
      children: _controller.listPopups?.map((e) => ContentCheckListDayButton(e, onTap: () {
        _handleCheckListTap(context ,e, e.getPopupName()) ;}
        ,)
      )?.toList() ?? <ContentCheckListDayButton>[],
    ));
  }

 Future<void> _handleCheckListTap(BuildContext context, PopupsDataModel popupsDataModel, String name) async {
    final actionType = ticketController.ticketScreenArgument.actionType;
    popupsDataModel.isAllowEdit = !(actionType == ActionType.view);
    switch(popupsDataModel.inspectionCategory){
      case InspectionCategory.immediaryTransformer:
        await openPopup(popupsDataModel, name, InterSubstationPopup(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediarySubstationRoom:
        await openPopup(popupsDataModel, name, InterSubstationRoomPopup(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryCuttingMachine:
        await openPopup(popupsDataModel, name, CuttingMachinesScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryRecloser:
        await openPopup(popupsDataModel, name, RecloserPopup(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryDisconnectorsSwitches:
        await openPopup(popupsDataModel, name, InterDisconnectorsSwitchesScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryCutterLbs:
        await openPopup(popupsDataModel, name, InterCutterLBSScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryFalloffFuse:
        await openPopup(popupsDataModel, name, InterFallOfFuseScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryVariableVoltage:
        await openPopup(popupsDataModel, name, InterVariableVoltageScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryCurrentTransformer:
        await openPopup(popupsDataModel, name, InterVariableCurrentScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryLightningConductor:
        await openPopup(popupsDataModel, name, InterLightningConductorScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryCableHead:
        await openPopup(popupsDataModel, name, InterCableHeadScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryInsulation:
        await openPopup(popupsDataModel, name, InterInsulationScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryHighPressureCable:
        await openPopup(popupsDataModel, name, HighPressureCableScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryPressureCable:
        await openPopup(popupsDataModel, name, LowPressureCableScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryJoint:
        await openPopup(popupsDataModel, name, InterJointScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryOneWaySystem:
        await openPopup(popupsDataModel, name, OneWaySystemScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryAlternatingCurrentSystem:
        await openPopup(popupsDataModel, name, ACSystemScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryBattery:
        await openPopup(popupsDataModel, name, BatteryScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryFillingCabinet:
        await openPopup(popupsDataModel, name, FillingCabinetScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryGroundingSystem:
        await openPopup(popupsDataModel, name, InterGroundingSystemScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryMeasuringSystem:
        await openPopup(popupsDataModel, name, InterMeasuringSystemScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryElectricCabinet:
        await openPopup(popupsDataModel, name, InterElectricalCabinetsScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.immediaryClampRow:
        await openPopup(popupsDataModel, name, InterClampRowScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;
      case InspectionCategory.immediaryRTD:
        await openPopup(popupsDataModel, name, InterRDTSystemScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;
      case InspectionCategory.immediaryConstructionStructure:
        await openPopup(popupsDataModel, name, ConstructionStructuresScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;
      case InspectionCategory.immediaryStationCleaning:
        await openPopup(popupsDataModel, name, InterImmediaryStationCleaningScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;
    }
  }


  Future openPopup( PopupsDataModel model,
      String name, Widget child, ActionType actionType) async {
    if (GetPlatform.isMobile) {
      final value = await Get.to(() => PopupMobileScreen(
        name: name,
        actionType: actionType,
        child: child,
      ));
      if (value == true) {
        _controller.updatePopupSuccess(model);
      }
      return;
    }
    final value = await showPopupCheckList(
        context,
        name,
        child,
        actionType);
    if (value) {
      _controller.updatePopupSuccess(model);
    }
  }

  @override
  void onUpdateSuccess({bool isSuccess}) {
    if (isSuccess) {
      widget.next();
    }
    isProcessing = false;
  }
}

