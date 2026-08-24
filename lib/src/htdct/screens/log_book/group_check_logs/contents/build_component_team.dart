// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/components/button_40.dart';
import '../../../../common/enum/ticket_enum.dart';
import '../../../grid_management/not_pmis/work_ticket/tab_common/content_check/content_check_controller.dart';
import '../../common/widget_items.dart';
import '../group_check_log_controller.dart';

Widget BuildComponentTeam(GroupCheckLogController _controller) {
  return Obx(()=>Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const WidgetItems(
        typeItem: TypeItem.title,
        title: 'Thành phần đơn vị được kiểm tra',
      ),
      for (var i = 0; i < _controller.listTeam.length; i++)
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Stack(
            children: [
              Column(
                children: [
                  WidgetItems(
                    typeItem: TypeItem.textBox,
                    title: '${i+1}.Ông bà',
                    textValue: _controller.listTeam[i]['user'],//,model['userCheck$i'],
                    required: false,
                    function: (value) {
                      _controller.listTeam[i]['user'] = value.toString();
                    },
                    invalid: _controller.invalid.value,
                    isChildrenItem: true,
                    readOnly: _controller.transformerTicketController.actionPopupType==ActionTicketType.view,
                  ),
                  WidgetItems(
                    typeItem: TypeItem.textBox,
                    title: '${i+1}.Chức vụ',
                    textValue: _controller.listTeam[i]['roleUser'],//model['roleUserCheck$i'],
                    required: false,
                    function: (value) {
                      _controller.listTeam[i]['roleUser'] = value.toString();
                    },
                    invalid: _controller.invalid.value,
                    isChildrenItem: true,
                    readOnly: _controller.transformerTicketController.actionPopupType==ActionTicketType.view,
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: GestureDetector(
                    onTap: () => {
                      _controller.removeTeamCheck(index: i,isTeamCheck: false),
                      // _controller.refreshView(),
                    },
                    child: Button40(
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      Row(
        children: [
          GestureDetector(
            onTap: () {
              if (_controller.listTeam.length < 10) {
                _controller.addTeamCheck(isTeamCheck: false);
                // _controller.refreshView();
              }
            },
            child: const Icon(
              Icons.add,
              size: 50,
            ),
          ),
        ],
      )
    ],
  )) ;
}

