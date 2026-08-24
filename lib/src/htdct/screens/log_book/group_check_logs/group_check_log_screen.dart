// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/enum/ticket_enum.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/constance/app_color.dart';
import '../../../common/themes/colorx.dart';
import '../../../common/utils/alert_dialog_utils.dart';
import '../../grid_management/containers/e_button.dart';
import '../../grid_management/not_pmis/work_ticket/tab_common/content_check/content_check_controller.dart';
import '../common/option_type.dart';
import '../common/widget_items.dart';
import 'contents/build_component_team.dart';
import 'contents/build_component_team_check.dart';
import 'group_check_log_controller.dart';

class GroupCheckLogScreen extends StatefulWidget {
  final String id;

  GroupCheckLogScreen({Key key, this.id}) : super(key: key);

  @override
  State<GroupCheckLogScreen> createState() => _GroupCheckLogScreenState();
}

class _GroupCheckLogScreenState extends State<GroupCheckLogScreen> {
  final _controller = GroupCheckLogController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.initData();
    Future.delayed(const Duration(milliseconds: 200), () {
      _controller.ticketId = widget.id;
      if (widget.id != null) {
        if (_controller.transformerTicketController.actionPopupType ==
                ActionTicketType.edit ||
            _controller.transformerTicketController.actionPopupType ==
                ActionTicketType.view) {
          _controller.getData();
        } else if (_controller.transformerTicketController.actionPopupType ==
            ActionTicketType.copy) {
          _controller.copyData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _renderAppbar(),
      body: _renderBody(),
    );
  }

  AppBar _renderAppbar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: AppColor.highlightColor70,
      leading: BackButton(
        color: Colors.white,
        onPressed: () {
          if (_controller.transformerTicketController.actionPopupType ==
              ActionTicketType.view) {
            Get.back();
          } else {
            hShowMyDialogOkCancel('Bạn có chắc muốn hủy không?',
                secondFunction: () {
              Get.back();
            });
          }
        },
      ),
      title: Text(
        '${widget.id.isNullOrEmpty() ? 'Tạo' : _controller.transformerTicketController.actionPopupType != ActionTicketType.view ? 'Chỉnh sửa' : 'Chi tiết'} sổ ghi ý kiến đoàn kiểm tra',
        style: TextStyle(fontSize: 16),
      ),
      titleSpacing: 0,
      centerTitle: false,
    );
  }

  Widget _renderBody() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Obx(
        () => Column(
          children: [
            Visibility(
              visible: false,
              child: Text(_controller.invalid.toString()),
            ),
            Expanded(child: SingleChildScrollView(child: buildContent())),
            if (_controller.transformerTicketController.isHasPermissionEdit() &&
                _controller.transformerTicketController.actionPopupType !=
                    ActionTicketType.view)
              buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                hShowMyDialogOkCancel('Bạn có chắc muốn hủy không?',
                    secondFunction: () {
                  Get.back();
                });
              },
              child: EButtonWidget(
                text: 'Hủy',
                textColor: HighElectricAppColor.nature01,
                bgColor: HighElectricAppColor.primary10,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                await _controller.updateData();
              },
              child: EButtonWidget(
                text: 'Lưu',
                textColor: HighElectricAppColor.nature01,
                bgColor: HighElectricAppColor.primary10,
                width: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent() {
    return Column(
      children: [
        if (_controller.transformerTicketController.actionPopupType ==
                ActionTicketType.create ||
            _controller.triggerGetData == true)
          WidgetItems(
            typeItem: TypeItem.dateTimePicker,
            title: 'Thời gian kiểm tra',
            required: false,
            function: (value) {
              _controller.model.dateCheck = (value as DateTime)
                  ?.toUtc()
                  ?.toStringFormat(HighElectricStrings.utcFormat);
              _controller.refreshView();
            },
            timeController: TextEditingController()
              ..text = _controller.model.dateCheckLocalTZ,
            invalid: _controller.invalid.value,
            readOnly: _controller.transformerTicketController.actionPopupType ==
                ActionTicketType.view,
          ),
        WidgetItems(
          typeItem: TypeItem.singleDropdown,
          title: 'Đoàn kiểm tra',
          required: false,
          function: (value) {
            _controller.model.teamCheck = value?.toString()?.toIntOrNull();
          },
          optionsNumber: OptionsType.TeamCheck.getOptions,
          defaultOptionsNumber: _controller.model.teamCheck,
          isNumber: true,
          invalid: _controller.invalid.value,
          readOnly: _controller.transformerTicketController.actionPopupType ==
              ActionTicketType.view,
        ),
        WidgetItems(
          typeItem: TypeItem.textBox,
          title: 'Đoàn kiểm tra khác (Nếu có)',
          textValue: _controller.model.nameTeamCheck,
          required: false,
          function: (value) {
            _controller.model.nameTeamCheck = value.toString();
          },
          invalid: _controller.invalid.value,
          readOnly: _controller.transformerTicketController.actionPopupType ==
              ActionTicketType.view,
        ),
        WidgetItems(
          typeItem: TypeItem.textArea,
          title: 'Nội dung kiểm tra',
          textValue: _controller.model.contentCheck,
          required: false,
          function: (value) {
            _controller.model.contentCheck = value?.toString();
          },
          invalid: _controller.invalid.value,
          readOnly: _controller.transformerTicketController.actionPopupType ==
              ActionTicketType.view,
        ),
        BuildComponentTeamCheck(_controller),
        BuildComponentTeam(_controller),
        WidgetItems(
          typeItem: TypeItem.textArea,
          title: 'Nhận xét, kiến nghị của đoàn kiểm tra',
          textValue: _controller.model.commentTeamCheck,
          required: false,
          function: (value) {
            _controller.model.commentTeamCheck = value?.toString();
          },
          invalid: _controller.invalid.value,
          readOnly: _controller.transformerTicketController.actionPopupType ==
              ActionTicketType.view,
        ),
        WidgetItems(
          typeItem: TypeItem.textBox,
          title: 'Đơn vị quản lý',
          textValue: 'X6',
          // _controller.model.assetManage,
          required: false,
          function: (value) {
            _controller.model.assetManage = value.toString();
          },
          invalid: _controller.invalid.value,
          readOnly: true,
        ),
        WidgetItems(
          typeItem: TypeItem.singleDropdown,
          title: 'Đội TT&QLVH',
          required: true,
          function: (value) {
            if (value != null) {
              _controller.model.userGroupId = value.toString();
            } else {
              _controller.model.userGroupId = null;
            }
          },
          defaultSingleOptionsString: _controller.model.userGroupId,
          optionsString: _controller.listGroup.value,
          invalid: _controller.invalid.value,
          readOnly: _controller.transformerTicketController.actionPopupType ==
              ActionTicketType.view,
        ),
        WidgetItems(
          typeItem: TypeItem.singleDropdown,
          title: 'Tổ vận hành trạm',
          required: true,
          function: (value) {
            if (value != null) {
              _controller.model.substationId = value.toString();
            } else {
              _controller.model.substationId = null;
            }
          },
          defaultSingleOptionsString: _controller.model.substationId,
          optionsString: _controller.listTBA.value,
          invalid: _controller.invalid.value,
          readOnly: _controller.transformerTicketController.actionPopupType ==
              ActionTicketType.view,
        ),
      ],
    );
  }
}

