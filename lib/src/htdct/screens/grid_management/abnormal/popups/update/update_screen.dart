// @dart=2.9
import 'package:evnmobile/src/htdct/common/components/e_text_field.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../htld/common/components/app_button.dart';
import '../../../../../common/components/app_bar_common.dart';
import '../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../log_book/common/widget_items.dart';
import '../../../not_pmis/work_ticket/tab_common/content_check/content_check_controller.dart';
import 'update_controller.dart';

class UpdateViolateScreen extends StatefulWidget {
  final String id;
  final bool isViolate;

  const  UpdateViolateScreen({Key key, this.id, this.isViolate = false})
      : super(key: key);

  @override
  State<UpdateViolateScreen> createState() => _UpdateViolateScreenState();
}

class _UpdateViolateScreenState extends State<UpdateViolateScreen> {
  final _controller = UpdateController();

  @override
  void initState() {
    super.initState();
    _controller.isAbnormal = widget.isViolate;
    Future.delayed(const Duration(milliseconds: 200),
        () async => {await _controller.getDetail(widget.id)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCommon(
        title: widget.isViolate ? 'Cập nhật vi phạm' : 'Cập nhật tồn tại',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: Obx(_buildBody),
            ),
            Container(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: EButton(
                        title: 'Đóng',
                        action: () {
                          hShowMyDialogOkCancel('Bạn có chắc muốn hủy không?',
                              secondFunction: () {
                            Get.back();
                          });
                        }),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: EButton(
                        title: 'Lưu',
                        action: () async {
                          await _controller.updateAbnormal();
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ETextField(
              //   title: ,
              //   isEnable: true,
              // ),
              WidgetItems(
                typeItem: TypeItem.singleDropdown,
                title: 'Trạng thái',
                textValue: '',
                required: true,
                function: (value) {
                  _controller.model.value.status = value.toString().toIntOrNull();
                  _controller.invalid.refresh();
                },
                defaultOptionsNumber: _controller.model.value.status,
                optionsNumber: _controller.listStatus,
                isNumber: true,
                invalid: _controller.invalid.value,
                readOnly: false,
              ),
              if (_controller.model.value.date != null)
                WidgetItems(
                    typeItem: TypeItem.dateTimePicker,
                    title: 'Thời gian xử lý',
                    // textValue: DateTime.now().toString(),
                    required: true,
                    function: (value) {
                      if (value == null) {
                        _controller.model.value.date = null;
                      } else {
                        _controller.model.value.date = value.toString();
                      }
                      _controller.invalid.refresh();
                    },
                    invalid: _controller.invalid.value,
                    timeController: TextEditingController()
                      ..text = _controller.model.value.date,
                    readOnly: false),
              WidgetItems(
                typeItem: TypeItem.singleDropdown,
                title: 'Người xử lý',
                textValue: '',
                required: true,
                function: (value) {
                  _controller.model.value.userId = value;
                  _controller.invalid.refresh();
                },
                invalid: _controller.invalid.value,
                optionsString: _controller.listUser ?? [],
                defaultSingleOptionsString: _controller.model.value.userId,
                readOnly: false,
              ),
              WidgetItems(
                typeItem: TypeItem.textArea,
                title: 'Nội dung xử lý',
                textValue: _controller.model.value.content,
                required: true,
                function: (value) {
                  _controller.model.value.content = value;
                },
                invalid: _controller.invalid.value,
                readOnly: false,
              ),
              WidgetItems(
                typeItem: TypeItem.images,
                title: 'Tải ảnh',
                required: false,
                function: (value) {},
                imagesValue: _controller.model.value.imageProblem ?? [],
                //_controller.model.images,
                removeImage: (file) async {
                  await _controller.removeImage(file);
                  _controller.model.refresh();
                },
                addImage: (file) async {
                  await _controller.uploadImage(file);
                  _controller.model.refresh();
                },
                invalid: false,
                //_controller.invalid.value,
                readOnly:
                    false, // _controller.transformerTicketController.actionPopupType==ActionTicketType.view,
              ),
            ]),
      ),
    );
  }
}

