// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/person_performing_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_section_title.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_single_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/tabs/group/group_check_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/line_ticket_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/components/app_button.dart';
import '../../e_text.dart';

class GroupCheckScreen extends StatefulWidget {
  const GroupCheckScreen({this.next, this.isLine});
  final bool isLine;
  final Function next;
  @override
  _GroupCheckScreenState createState() => _GroupCheckScreenState();
}

class _GroupCheckScreenState extends State<GroupCheckScreen>
    implements GroupCheckDelegate {
  final GroupCheckController _controller = GroupCheckController();

  TicketController ticketController;
  LineTicketController lineTicketController;
  ActionType actionType;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
    if (widget.isLine) {
      lineTicketController = Get.find();
      actionType = lineTicketController.argument.actionType;
    } else {
      ticketController = Get.find();
      actionType = ticketController.ticketScreenArgument.actionType;
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      _controller?.getListPersonPerforming(isLine: widget?.isLine == true);
      _controller?.getGroup(isLine: widget?.isLine == true);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      color: Colors.grey.shade100,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: ESectionTitle('Danh sách nhóm kiểm tra'),
                  ),
                  // Obx(() {
                  //   if (_controller.listPersonInGroup.isNotEmpty) {
                  //      if (Get.context.isTablet) {
                  //        return _buildHeaderItemForTablet();
                  //      } else {
                  //        return Container();
                  //      }
                  //   }
                  //   return Container();
                  // }),
                  _buildContent(),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
          _buildButtonSave()
        ],
      ),
    ));
  }

  Widget _buildContent() {
    return Obx(() => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _controller.listPersonInGroup.length,
        itemBuilder: (context, i) => _renderItemForMobile(
            index: i, model: _controller.listPersonInGroup[i])));

    // itemBuilder: (context, i) => Get.context.isTablet
    //         ? _buildItemForTablet(_controller.listPersonInGroup[i], i)
    //         : _renderItemForMobile(
    //         index: i, model: _controller.listPersonInGroup[i])));
  }

  // Widget _buildHeaderItemForTablet(){
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 24),
  //     child: Row(children: [
  //       Expanded(
  //           flex: 5,
  //           child: Container(margin: _cellMargin, child:  Center(child: Text('Họ tên', style: _style,)))),
  //       Expanded(
  //           flex: 4,
  //           child: Container(margin: _cellMargin, child:  Center(child: Text('Chức danh', style: _style,)))),
  //       Expanded(
  //           flex: 3,
  //           child: Container(margin: _cellMargin, child:  Center(child: Text('Bậc thợ', style: _style,)))),
  //       Expanded(
  //           flex: 2,
  //           child: Container(margin: _cellMargin, child:  Center(child: Text('Bậc AT', style: _style,)))),
  //
  //     ],),
  //   );
  // }

  // Widget _buildItemForTablet(PersonPerformingModel person, int index){
  //   const EdgeInsetsGeometry _cellMargin = EdgeInsets.all(6);
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 24),
  //     child: Row(children: [
  //       Expanded(
  //           flex: 5,
  //           child: Container(margin: _cellMargin, child:  Center(child: ESingleTextField(textAlign: TextAlign.left, horizontalPaddingContent: 10, value: person.name ?? '', isEnable: false))),
  //       ),
  //       Expanded(
  //           flex: 4,
  //           child: Container(margin: _cellMargin, child:  Center(child: ESingleTextField(textAlign: TextAlign.center, value: person.position ?? '', isEnable: false)))),
  //       Expanded(
  //           flex: 3,
  //           child: Container(margin: _cellMargin, child:  Center(child: ESingleTextField(textAlign: TextAlign.center, value: '${person.level ?? ''}', isEnable: false)))),
  //       Expanded(
  //           flex: 2,
  //           child: Container(margin: _cellMargin, child:  Center(child: ESingleTextField(textAlign: TextAlign.center, value: '${person.atLevel ?? ''}', isEnable: false)))),
  //     ],),
  //   );
  // }

  Widget _renderItemForMobile({PersonPerformingModel model, int index}) {
    final isPeriodic = _controller.getTicketType() == TicketType.periodicDay ||
        _controller.getTicketType() == TicketType.periodicNight;
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          if (index == 0 || actionType == ActionType.view || isPeriodic)
            EText(
              title: 'Họ tên',
              value: model?.name,
              childFlex: 3,
            )
          else if (isPeriodic)
            EText(
              title: 'Họ tên',
              value: model?.name,
              childFlex: 3,
            )
          else
            E2SingleDropDown(
              _controller.optionPerson,
              title: 'Họ tên',
              childFlex: 3,
              padding: 0,
              value: model?.userId,
              onSelected: (value) {
                _controller.setPerson(position: index, personId: value);
              },
            ),
          EText(
            title: 'Chức danh',
            value: model?.position,
            childFlex: 3,
          ),
          EText(
            title: 'Bậc thợ',
            value: model?.level?.toString(),
            childFlex: 3,
          ),
          EText(
            title: 'Chức AT',
            value: model?.atLevel,
            childFlex: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSave() {
    if (actionType != ActionType.view) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: EButton(
          maxSize: true,
          title: 'Lưu và thực hiện kiểm tra',
          action: () {
            if (!isProcessing) {
              isProcessing = true;
              _controller.createGroup(isLine: widget.isLine);
            }
          },
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  void onUpdateGroupSuccess({bool isSuccess}) {
    isProcessing = false;
    if (isSuccess) {
      SnackBarHUD.show('Cập nhật nhóm thành công');
      widget.next();
    }
  }
}

