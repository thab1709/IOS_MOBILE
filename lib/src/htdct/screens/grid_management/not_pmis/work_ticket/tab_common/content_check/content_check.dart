// @dart=2.9
import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:evnmobile/src/app_common/edit_picture/add_text_screen.dart';
import 'package:evnmobile/src/htdct/common/constance/app_color.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../../../../../app_common/utils/utils.dart';
import '../../../../../../../htld/common/utils/alert_dialog_utils.dart';
import '../../../../../../common/components/app_button.dart';
import '../../../../../../common/components/button_40.dart';
import '../../../../../../common/constance/app_icon.dart';
import '../../../../../../common/constance/strings.dart';
import '../../../../../../common/enum/ticket_enum.dart';
import '../../../../../../common/themes/styles.dart';
import '../../../../../../models/day_night/ticket.dart';
import '../../../../../../models/non_pmis/template_item_model.dart';
import '../../../../../../models/option_model.dart';
import '../../../../containers/auto_height_text_field.dart';
import '../../../../containers/e_button.dart';
import '../../../../containers/e_check_box.dart';
import '../../../../containers/e_single_drop_down.dart';
import '../../../../containers/e_text_form_field.dart';
import '../../../../transformer/check_by_daytime/check_sheet/common/dialog_picture.dart';
import 'content_check_controller.dart';
import 'widgets/multi_dropdown_load_more.dart';
import 'widgets/single_dropdown_load_more.dart';

class ContentCheckView extends StatefulWidget {
  const ContentCheckView();

  @override
  State<ContentCheckView> createState() => _ContentCheckViewState();
}

class _ContentCheckViewState extends State<ContentCheckView> {
  final ContentCheckController _controller = ContentCheckController();

  Widget _buildItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? '',
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: HighElectricAppColor.nature05),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            value ?? '',
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: HighElectricAppColor.nature06),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), getTemplateItem);
  }

  Future getTemplateItem() async {
    await _controller.getTemplateItem();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: HighElectricAppColor.nature01,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              Visibility(
                visible: false,
                child: Text(_controller.invalid.value.toString()),
              ),
              if (_controller.itemList.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < _controller.itemList.length; i++)
                          rederTypeItem(model: _controller.itemList[i]),
                      ],
                    ),
                  ),
                ),
              Column(
                children: [
                  if (_controller.itemList.isNotEmpty &&
                      _controller
                              .transformerTicketController.actionTicketType !=
                          ActionTicketType.view)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: EButton(
                        maxSize: true,
                        title: 'Lưu',
                        action: () {
                          _controller.updateData();
                        },
                      ),
                    ),
                  if (((_controller.transformerTicketController.testType ==
                                  TestType.unKnow &&
                              _controller.itemList.isEmpty) ||
                          _controller.itemList.isNotEmpty) &&
                      _controller
                              .transformerTicketController.actionTicketType !=
                          ActionTicketType.view)
                    InkWell(
                      onTap: () async {
                        if ((_controller.transformerTicketController
                                        .triggerCompleteTicket ==
                                    true &&
                                _controller.invalid.value == false) ||
                            (_controller.transformerTicketController.testType ==
                                    TestType.unKnow &&
                                _controller.itemList.isEmpty)) {
                          await _controller.completeTicket();
                        }
                      },
                      child: Container(
                        // margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: EButtonWidget(
                          width: MediaQuery.of(context).size.width,
                          text: 'Hoàn Thành',
                          bgColor: ((_controller.transformerTicketController
                                              .triggerCompleteTicket ==
                                          true &&
                                      _controller.invalid.value == false) ||
                                  (_controller.transformerTicketController
                                              .testType ==
                                          TestType.unKnow &&
                                      _controller.itemList.isEmpty))
                              ? HighElectricAppColor.primary10
                              : HighElectricAppColor.backgroundColorGray,
                          textColor: ((_controller.transformerTicketController
                                              .triggerCompleteTicket ==
                                          true &&
                                      _controller.invalid.value == false) ||
                                  (_controller.transformerTicketController
                                              .testType ==
                                          TestType.unKnow &&
                                      _controller.itemList.isEmpty))
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget rederTypeItem({@required TemplateItemModel model}) {
    switch (model.itemType) {
      case 1 /*textbox*/ :
        return ETextFormField(
          hint: 'Nhập thông tin',
          title: model.title,
          isNumpad: false,
          isRequied: model.required,
          invalid: _controller.invalid.value,
          readOnly: _controller.transformerTicketController.actionTicketType ==
              ActionTicketType.view,
          value: model.inputTextValue,
          onChangeInput: (value) {
            model.inputTextValue = value;
          },
        );
      case 2 /*single dropdown*/ :
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(model: model),
            SingleDropdownLoadMore(
              controller: _controller,
              model: model,
            )
          ],
        );
      case 3 /*multi dropdown*/ :
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(model: model),
            MultiDropdownLoadMore(
              controller: _controller,
              model: model,
            ),
          ],
        );
      case 4 /*TextArea*/ :
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(model: model),
            AutoHeightTextField(
              textFieldController:
                  TextEditingController(text: model.inputTextValue),
              maxHeight: 150,
              onChange: (value) {
                model.inputTextValue = value;
              },
              isEnable:
                  _controller.transformerTicketController.actionTicketType !=
                      ActionTicketType.view,
              hintText: 'Nhập thông tin',
              invalid: model.required &&
                  _controller.invalid.value &&
                  model.inputTextValue.isNullOrBlank(),
            ),
          ],
        );
      case 5 /*Checkbox*/ :
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(model: model),
            ECheckBox(
              isSubstation: false,
              onClicked: (value) {
                model.inputCheckboxValue = value;
              },
              checked: model.inputCheckboxValue ?? false,
              isAllowEdit:
                  _controller.transformerTicketController.actionTicketType !=
                      ActionTicketType.view,
              invalid: model.required &&
                  _controller.invalid.value &&
                  (model.inputCheckboxValue == null ||
                      model.inputCheckboxValue == false),
            ),
          ],
        );
        break;
      case 6 /*Datetime picker*/ :
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTitle(model: model),
              Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: (_controller.invalid.value &&
                                model.required &&
                                model.inputTimeValue.isNullOrBlank())
                            ? Colors.red
                            : Colors.grey,
                        style: BorderStyle.solid)),
                child: DateTimeField(
                  enabled: _controller
                          .transformerTicketController.actionTicketType !=
                      ActionTicketType.view,
                  onChanged: (value) {
                    value != null
                        ? model.inputTimeValue = value.toString()
                        : model.inputTimeValue = null;
                  },
                  initialValue: model.inputTimeValue == null
                      ? null
                      : DateTime.parse(model.inputTimeValue),
                  format: DateFormat('HH:mm'),
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                      builder: (context, child) {
                        final Widget mediaQueryWrapper = MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                            alwaysUse24HourFormat: true,
                          ),
                          child: Localizations.override(
                            context: context,
                            locale: const Locale('vi', 'VN'),
                            child: child,
                          ),
                        );

                        return mediaQueryWrapper;
                      },
                    );
                    return DateTimeField.convert(time);
                  },
                ),
              ),
            ]);

      case 7 /*Images*/ :
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(model: model),
            Wrap(
              children: [
                if (_controller.transformerTicketController.actionTicketType !=
                    ActionTicketType.view)
                  GestureDetector(
                    onTap: () async {
                      if (model.inputImagesValue.length == 10) {
                        await showDialogOneButton(
                            HighElectricStrings.overloadImagesLength);
                      } else {
                        final result = await showSelectMultiImageBottomSheet(
                            context,
                            10 -
                                (model.inputImagesValue != null
                                    ? model.inputImagesValue.length
                                    : 0));
                        if (result != null && result is List<File> && result.isNotEmpty) {
                          final editImageResult = await Get.to(EditImageScreen(
                            files: result,
                          ));
                          if (editImageResult != null) {
                            await _controller.addImage(
                                images: editImageResult, model: model);
                          }
                        }
                      }
                    },
                    child: Button40(
                      child: SvgPicture.asset(
                        HighElectricAppIcon.camera,
                        color: (_controller.invalid.value &&
                                model.inputImagesValue.isEmpty &&
                                model.required)
                            ? Colors.red
                            : Colors.white,
                        width: 18,
                        height: 20,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                Visibility(
                  visible: model.inputImagesValue != null &&
                      model.inputImagesValue.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return DialogPicture(
                                    listImage: model.inputImagesValue,
                                    removeImage: (file) {
                                      _controller.removeImage(file, model);
                                    },
                                    addImage: (item) => _controller.addImage(
                                        images: item, model: model),
                                    isGroup: _controller
                                            .transformerTicketController
                                            .actionTicketType ==
                                        ActionTicketType.view,
                                  );
                                });
                          },
                          child: Button40(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  HighElectricAppIcon.collections,
                                  width: 18,
                                  height: 20,
                                  fit: BoxFit.scaleDown,
                                ),
                                Positioned(
                                    top: 3,
                                    right: 3,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color:
                                            HighElectricAppColor.brandColor04,
                                        border: Border.all(
                                            color:
                                                HighElectricAppColor.nature01),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        model.inputImagesValue.length
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: HighElectricAppColor.nature01,
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
        break;
      case 8 /*Date picker*/ :
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(model: model),
            Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: (_controller.invalid.value &&
                              model.required &&
                              model.inputDateValue.isNullOrBlank())
                          ? Colors.red
                          : Colors.grey,
                      style: BorderStyle.solid)),
              child: DateTimeField(
                enabled:
                    _controller.transformerTicketController.actionTicketType !=
                        ActionTicketType.view,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  value != null
                      ? model.inputDateValue = value.toString()
                      : model.inputDateValue = null;
                },
                initialValue: model.inputDateValue == null
                    ? null
                    : DateTime.parse(model.inputDateValue),
                format: DateFormat(HighElectricStrings.ddMMyyyy),
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      locale: const Locale('vi', 'VN'),
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                  return date;
                },
              ),
            ),
          ],
        );
        break;
      case 9 /*label*/ :
        return Text(
          model.title,
          style: Styles.titleTextField,
        );
      default:
        return Container();
    }
  }

  Widget _buildTitle({@required TemplateItemModel model}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: model.title,
                        style: Styles.titleTextField,
                      ),
                      if (model.required)
                        const TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        )
                    ]
                  ),

                ),
              ),

            ],
          ),
        ),
      ],
    );
  }
}

