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
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/components/transformer_temperature_mobile.dart';
import 'package:evnmobile/src/htld/screens/grid_management/intermediate_transformer_station/night/inter_content_night_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/components/app_button.dart';
import '../../containers/content_checklist_button.dart';
import '../../containers/e_drop_down.dart';
import '../../containers/e_label.dart';
import '../../containers/e_single_drop_down.dart';
import '../../containers/e_single_text_area.dart';
import '../../containers/e_single_text_field.dart';
import 'popups/joint_screen.dart';
import 'popups/lighting_systems_screen.dart';
import 'popups/transformers_station_screen.dart';


class InterContentNightScreen extends StatefulWidget {
  final Function next;

  const InterContentNightScreen({this.next});

  @override
  _InterContentNightScreenState createState() => _InterContentNightScreenState();
}

class _InterContentNightScreenState extends State<InterContentNightScreen> implements InterContentDelegate {
  final TextStyle _style = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black);

  final EdgeInsetsGeometry _cellMargin = const EdgeInsets.all(2);
  final InterContentNightController _controller = InterContentNightController();
  final ticketController = Get.put(TicketController());
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
    Future.delayed(const Duration(microseconds: 200), () {
      _controller.getContent(ticketController.ticketID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    const ESectionTitle('Thông số vận hành', padding: EdgeInsets.symmetric(horizontal: 16),),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Obx(() {
                        if (_controller.loadSuccess.value) {
                          return _renderTransformerRow();
                        } else {
                          return Container();
                        }
                      }),
                    ),
                    Obx(() {
                      if (_controller.loadSuccess.value) {
                        return _renderTransformerTemperature();
                      } else {
                        return Container();
                      }
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Obx(() {
                        if (_controller.loadSuccess.value) {
                          return _renderOutlineMachineRow();
                        } else {
                          return Container();
                        }
                      }),
                    ),
                    const SizedBox(height: 20,),
                    const ESectionTitle('Nội dung kiểm tra', padding: EdgeInsets.symmetric(horizontal: 16),),
                    const SizedBox(height: 10,),
                    _renderCheckList(),
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ELabel(title: 'Các tồn tại đã xử lý',),
                    ),
                    const SizedBox(height: 10,),
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
    );
  }

  Widget _renderTransformerRow() {
    if (_controller?.listInterEquipment?.isEmpty == true) {
      return Container();
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

    return GetPlatform.isMobile ? Column(
      children: [
        const SizedBox(height: 20,),
        InterTransformerMobileView(_controller.listInterEquipment, onChange: (value) {
          _controller.updateValueTransformer(value);
        },),
      ],
    ) : transformerRowTablet();
  }

  Widget _renderOutlineMachineRow() {
    if (_controller?.listOutlines?.isNotEmpty == true) {
      return GetPlatform.isMobile ? Column(
        children: [
          const SizedBox(height: 20,),
          InterOutlineMobileView(_controller.listOutlines, onChange: (value) {
            _controller.updateValueOutlineMachine(value);
          },),
        ],
      ) : _outlineMachineTablet();
    } else {
      return Container();
    }
  }

  Widget _outlineMachineTablet(){
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Table(
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
      ),
    );
  }

  Widget _renderTransformerTemperature() {
    if (_controller?.temperatures?.isEmpty == true) {
      return Container();
    }
    Widget _temperatureMBA(){
      return Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(2),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: _controller.temperatures != null ? _renderRowTempertature() : <TableRow>[],
      );
    }

    return GetPlatform.isMobile ? Column(
      children: [
        const SizedBox(height: 20,),
        TransformerTemperatureMobile(data: _controller.temperatures,
          title: 'Nhiệt độ MBA & hệ thống làm mát', onChange: (model) {
            _controller.updateValueTemperature(model);
          },),
      ],
    ) : _temperatureMBA();
  }


  List<TableRow> _renderRowTempertature() {
    final rows = <TableRow>[];
    final header = TableRow(children: [
      Container(margin: _cellMargin, child:  Center(child: Text('Tên MBA', style: _style,))),
      Container(margin: _cellMargin, child:  Center(child: Text('Nhiệt độ MBA', style: _style,))),
      Container(margin: _cellMargin, child:  Center(child: Text('Hệ thống làm mát', style: _style,))),
    ]);
    rows.add(header);
    _controller.temperatures.forEach((element) {
      final row = TableRow(children: [
        Container(margin: _cellMargin, child:  Center(child: ESingleTextField(value: element.equipmentName, textAlign: TextAlign.center,))),
        Container(margin: _cellMargin, child:  Center(child: ESingleTextField(value: element.temperature, textAlign: TextAlign.center, onchange: (value) {
          element.temperature = value;
        }))),
        Container(margin: _cellMargin, child:  Center(child: ESingleDropDown(BTOptions,
          value: element?.coolingStatus == 0 ? null : element?.coolingStatus,
          onSelected: (value) {
            element.coolingStatus = int.parse(value);
          },
        ))),
      ]);
      rows.add(row);
    });
    return rows;
  }

  Widget _renderCheckList() {
    return Obx(() => GridView.count(
      crossAxisCount: GetPlatform.isMobile ? 1 : 2,
      shrinkWrap: true,
      childAspectRatio: 6 / 1.1,
      crossAxisSpacing: 10,
      physics: const NeverScrollableScrollPhysics(),
      children: _controller.listPopups.map((e) => ContentCheckListDayButton(e, onTap: () { _handleCheckListTap(context, e, e.equipmentName) ;},)).toList(),
    ));
  }

  Future _handleCheckListTap(BuildContext context, PopupsDataModel popupsDataModel, String name) async {
    final actionType = ticketController.ticketScreenArgument.actionType;
    popupsDataModel.isAllowEdit = !(actionType == ActionType.view);
    switch(popupsDataModel.inspectionCategory){
      case InspectionCategory.substationNightTime:
        await openPopup(popupsDataModel, name, TransformersStationScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;
      case InspectionCategory.jointNightTime:
        await openPopup(popupsDataModel, name, JointScreen(
          popupsDataModel: popupsDataModel,
        ), actionType);
        break;

      case InspectionCategory.lightingSystemNightTime:
        await openPopup(popupsDataModel, name, LightingSystemsScreen(
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
    if (value == true) {
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

