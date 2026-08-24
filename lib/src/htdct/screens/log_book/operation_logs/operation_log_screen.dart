// @dart=2.9
import 'package:evnmobile/src/htdct/common/enum/ticket_enum.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import '../../../common/constance/app_color.dart';
import '../../../common/themes/colorx.dart';
import '../../../common/themes/styles.dart';
import '../../../common/utils/alert_dialog_utils.dart';
import '../../../models/log_book/operation_model.dart';
import '../../grid_management/containers/e_button.dart';
import '../../grid_management/containers/e_single_drop_down.dart';
import '../common/content_option.dart';
import '../common/option_type.dart';
import 'contents/index.dart';
import 'operation_log_controller.dart';

class OperationLogScreen extends StatefulWidget {
  final String id;

  OperationLogScreen({Key key, this.id}) : super(key: key);

  @override
  State<OperationLogScreen> createState() => _OperationLogScreenState();
}

class _OperationLogScreenState extends State<OperationLogScreen> {
  final _controller = OperationLogController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.initData();
    // if (widget.model != null) {
    //   _controller.model = widget.model;
    //   _controller.typeEventId.value = widget.model.eventType;
    // }
    Future.delayed(const Duration(milliseconds: 200), () {
      _controller.ticketId = widget.id;
      if(widget.id != null) {
        if(_controller.transformerTicketController.actionPopupType == ActionTicketType.edit || _controller.transformerTicketController.actionPopupType == ActionTicketType.view) {
          _controller.getData();
        }
        else if(_controller.transformerTicketController.actionPopupType == ActionTicketType.copy) {
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
          if(_controller.transformerTicketController.actionPopupType == ActionTicketType.view)
          {Get.back();}
          else {
            hShowMyDialogOkCancel('Bạn có chắc muốn hủy không?',
                secondFunction: () {
                  Get.back();
                });
          }
        },
      ),
      title: Text(
        '${widget.id.isNullOrEmpty()?'Tạo':_controller.transformerTicketController.actionPopupType!=ActionTicketType.view?'Chỉnh sửa':'Chi tiết'} sổ nhật ký vận hành',
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
            buildHeader(),
            Visibility(visible: false,child: Text(_controller.invalid.toString())),
            const SizedBox(
              height: 10,
            ),
            Expanded(child: SingleChildScrollView(child: buildContent())),
            if (_controller.transformerTicketController.isHasPermissionEdit() && _controller.transformerTicketController.actionPopupType!=ActionTicketType.view)
              buildFooter(),
          ],
        ),
      ),
    );
  }

  buildHeader() {
    return Column(
      children: [
        const Text(
          'Loại sự kiện',
          style: Styles.titleTextField,
        ),
        ESingleDropDown(
          OptionsType.EventType.getOptions,
          hint: 'Chọn loại sự kiện',
          value: _controller.typeEventId.value == 0
              ? null
              : _controller.typeEventId.value,
          padding: 0,
          onSelected: (value) {
            _controller.typeInspect = null;
            _controller.model.eventType = value.toIntOrNull();
            _controller.typeEventId.value = value.toIntOrNull();
            _controller.refreshView();
          },
          isDisable:  _controller.transformerTicketController.actionPopupType==ActionTicketType.view,
        ),
      ],
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
    if (_controller.typeEventId.value == ContentOptions.workUnit.value) {
      return BuildWorkUnit(_controller);
    } else if (_controller.typeEventId.value == ContentOptions.abnormal.value) {
      return BuildAbnormal(_controller);
    } else if (_controller.typeEventId.value == ContentOptions.MCTTN.value) {
      _controller.typeInspect =
          ContentOptions.subStationInspect.value;
      return BuildMcMedium(_controller);
    } else if (_controller.typeEventId.value == ContentOptions.fullLoad.value) {
      _controller.typeInspect =
          ContentOptions.subStationInspect.value;
      final keyboardVisibilityController = KeyboardVisibilityController();
      keyboardVisibilityController.onChange.listen((visible) {
        if (!visible) {
          if (_controller.keyboardVisibilityTrigger) {
            _controller.keyboardVisibilityTrigger = false;
            _controller.refreshView();
          }
        }
      });
      return BuildFullOperation(_controller);
    } else if (_controller.typeEventId.value ==
        ContentOptions.troubleshot.value) {
      if(_controller.model.reporters.isNullOrEmpty())
        {
          _controller.model.reporters = _controller.userProfile.name;
        }
      return BuildTrouble(_controller);
    } else if (_controller.typeEventId.value ==
        ContentOptions.guaranteeElectricity.value) {
      return BuildEnsure(_controller);
    } else if (_controller.typeEventId.value == ContentOptions.other.value) {
      return BuildOther(_controller);
    }

    return Container();
  }
}

