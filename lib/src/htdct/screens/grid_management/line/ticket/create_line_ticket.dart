// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/models/line/line_equipment_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/e_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../common/constance/app_color.dart';
import '../../containers/e_button.dart';
import '../../containers/search_view.dart';
import 'create_line_ticket_controller.dart';

class CreateLineTicketView extends StatefulWidget {
  const CreateLineTicketView();

  @override
  State<CreateLineTicketView> createState() => _CreateLineTicketViewState();
}

class _CreateLineTicketViewState extends State<CreateLineTicketView> {
  final CreateLineTicketController _controller = CreateLineTicketController();
  AppBar _renderAppbar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: HighElectricAppColor.primary10,
      leading: const BackButton(
        color: Colors.white,
      ),
      title: Text(
        _controller.getTitleButton(),
        style: const TextStyle(
            fontSize: 20,
            color: HighElectricAppColor.nature01,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.workId = Get.parameters['workId'];
    _controller.idLine = Get.parameters['idLine'];
    _controller.name.value = Get.parameters['name'];

    Future.delayed(const Duration(milliseconds: 100), () async {
      await _controller.getNodesList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HighElectricAppColor.bgColor,
      appBar: _renderAppbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHead(),
            _buildListNode(),
            _buildListEquipment(),
          ],
        ),
      ),
    );
  }

  Container _buildHead() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: HighElectricAppColor.nature01,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _controller.name.value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: HighElectricAppColor.nature06,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () async {
              await _controller.onRouter();
            },
            child: EButtonWidget(
              text: _controller.getTitleButton(),
              bgColor: HighElectricAppColor.primary10,
              textColor: HighElectricAppColor.nature01,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListNode() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(left: 16, right: 16),
      color: HighElectricAppColor.nature01,
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: true,
            title: const Text(
              'Danh sách nút',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: HighElectricAppColor.nature06,
              ),
            ),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchView(
                    onChange: (value) {
                      _controller.searchNode(value);
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Obx(() {
                    if(_controller.isShowCheckedAll.value) {
                      return ECheckBox(
                          checked: _controller.isCheckedAll.value,
                          title: 'Chọn tất cả',
                          onClicked: (isCheck) {
                            _controller.getAllEquipment(isCheck: isCheck);
                          });
                    } else {
                      return Container();
                    }
                  }),
                  const SizedBox(
                    height: 12,
                  ),
                  Obx(() {
                    if(_controller?.listNode?.isNotEmpty == true) {
                      return Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: FlexColumnWidth(),
                          1: FlexColumnWidth(),
                          2: FlexColumnWidth(),
                        },
                        defaultVerticalAlignment:
                        TableCellVerticalAlignment.middle,
                        children: <TableRow>[
                          if (_controller.listNode != null)
                            for (var i = 0;
                            i < _controller.listNode.length;
                            i += 3)
                              TableRow(
                                decoration: const BoxDecoration(
                                  color: HighElectricAppColor.nature01,
                                ),
                                children: <Widget>[
                                  if (i <
                                      _controller.listNode.length)
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(bottom: 12),
                                      child: ECheckBox(
                                          isAllowEdit: _controller
                                              .listNode[i]
                                              .isAllowEdit,
                                          checked: _controller.listNode[i].isSelected,
                                          title: _controller.listNode[i].name,
                                          onClicked: (isCheck) {

                                            _controller.listNode[i]
                                                .isSelected = isCheck;
                                            _controller
                                                .getLineEquipmentList(
                                                isCheck: isCheck,
                                                idNode: _controller.listNode[i].id);
                                          }),
                                    )
                                  else
                                    const SizedBox(),
                                  if (i + 1 <
                                      _controller.listNode.length)
                                    ECheckBox(
                                      isAllowEdit: _controller
                                          .listNode[i + 1]
                                          .isAllowEdit,
                                        checked: _controller
                                            .listNode[i + 1]
                                            .isSelected,
                                        title: _controller
                                            .listNode[i + 1].name,
                                        onClicked: (isCheck) {
                                          _controller
                                              .listNode[i + 1]
                                              .isSelected = isCheck;
                                          _controller
                                              .getLineEquipmentList(
                                              isCheck: isCheck,
                                              idNode: _controller
                                                  .listNode[i + 1]
                                                  .id);
                                        })
                                  else
                                    const SizedBox(),
                                  if (i + 2 <
                                      _controller.listNode.length)
                                    ECheckBox(
                                        isAllowEdit: _controller
                                            .listNode[i + 2]
                                            .isAllowEdit,
                                        checked: _controller
                                            .listNode[i + 2]
                                            .isSelected,
                                        title: _controller
                                            .listNode[i + 2].name,
                                        onClicked: (isCheck) {
                                          _controller
                                              .listNode[i + 2]
                                              .isSelected = isCheck;
                                          _controller
                                              .getLineEquipmentList(
                                              isCheck: isCheck,
                                              idNode: _controller
                                                  .listNode[i + 2]
                                                  .id);
                                        })
                                  else
                                    const SizedBox(),
                                ],
                              ),
                        ],
                      );
                    }
                    return const Center(child: Padding(
                      padding: EdgeInsets.only(bottom: 16),
                        child: Text(HighElectricStrings.emptyList)),);
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListEquipment() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      padding: const EdgeInsets.only(left: 16, right: 16),
      color: HighElectricAppColor.nature01,
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
              initiallyExpanded: true,
              title: const Text(
                'Danh sách thiết bị',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: HighElectricAppColor.nature06,
                ),
              ),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchView(
                      onChange: (value) {
                        _controller.searchEquipment(value);
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Obx(() {
                      if(_controller?.listEquipment?.isNotEmpty == true) {
                        return Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FlexColumnWidth(),
                            1: FlexColumnWidth(),
                            2: FixedColumnWidth(70),
                          },
                          defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                          children: <TableRow>[
                            TableRow(
                              decoration: const BoxDecoration(
                                color: HighElectricAppColor.nature03,
                              ),
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 16),
                                    child: const Text(
                                      'Loại thiết bị',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color:
                                        HighElectricAppColor.nature06,
                                      ),
                                    )),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 16),
                                    child: const Text(
                                      'Tên thiết bị',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color:
                                        HighElectricAppColor.nature06,
                                      ),
                                    )),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 16),
                                    child: const Text('Nút',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color:
                                          HighElectricAppColor.nature06,
                                        ))),
                              ],
                            ),
                            if (_controller.listEquipment != null)
                              for (int i = 0;
                              i <
                                  _controller
                                      .listEquipment.length;
                              i++)
                                _buildEquipmentItem(_controller
                                    .listEquipment[i]),
                          ],
                        );
                      }

                      return const Center(child: Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Text(HighElectricStrings.emptyList)),);
                    })
                  ],
                )
              ]),
        ),
      ),
    );
  }

  TableRow _buildEquipmentItem(LineEquipmentModel equipment) {
    return TableRow(
      decoration: const BoxDecoration(
        color: HighElectricAppColor.nature01,
      ),
      children: <Widget>[
        Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Text(
              equipment?.equipmentType ?? '',
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: HighElectricAppColor.nature06,
              ),
            )),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Text(
              equipment.equipmentName,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: HighElectricAppColor.nature06,
              ),
            )),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Text(
              equipment.nodeName,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: HighElectricAppColor.nature06,
              ),
            )),
      ],
    );
  }
}

