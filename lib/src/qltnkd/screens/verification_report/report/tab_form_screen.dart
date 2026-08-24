// @dart=2.9
import 'dart:io';
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/common/constance/field_type.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report/report_controller.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report/tab_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import 'component/table_container.dart';

class TabFormScreen extends StatefulWidget {
  const TabFormScreen(
    this._fieldModel, {
    this.isChildren = false,
    this.isEdit = false,
  });

  final FieldModel _fieldModel;
  final bool isChildren;
  final bool isEdit;

  @override
  _TabFormScreenState createState() => _TabFormScreenState();
}

class _TabFormScreenState extends State<TabFormScreen> {
  final controller = TabFormController();
  final reportController = Get.put(ReportController());
  var _isDispose = false;

  @override
  void initState() {
    super.initState();
    controller.isChild = widget.isChildren;
    controller.setFieldModel(widget._fieldModel);
    final keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((visible) {
      if (!visible && widget.isChildren) {
        controller?.fieldModel?.refresh();
        if (!_isDispose) {
          controller?.update();
        }
      }
    });
  }

  @override
  void dispose() {
    _isDispose = true;
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.isChild) {
      return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: RAppColor.highlightColor70,
          title: Text(
              controller?.fieldModel?.value?.title?.isNotEmpty != null &&
                      controller?.fieldModel?.value?.title?.isNotEmpty == true
                  ? controller?.fieldModel?.value?.title
                  : 'Thông tin'),
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 6, right: 6),
                    child: Obx(() {
                      bool isHangMucKiemTra = controller.fieldModel.value?.title?.toLowerCase()?.contains('hạng mục') == true;
                      return Column(
                          children: [
                            if (isHangMucKiemTra)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await reportController.pickImportExcelFile(context);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF141F36),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(Icons.file_upload_outlined, color: Colors.white, size: 18),
                                            SizedBox(width: 6),
                                            Text('Nhập excel', style: TextStyle(color: Colors.white, fontSize: 14)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (reportController.importedExcelFile.value != null) ...[
                                      const SizedBox(width: 12),
                                      const Icon(Icons.description_outlined, color: Colors.green, size: 20),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          reportController.importedExcelFile.value.path.split('/').last.split('\\').last,
                                          style: const TextStyle(color: Colors.green, fontSize: 13),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      InkWell(
                                        onTap: () {
                                          reportController.importedExcelFile.value = null;
                                        },
                                        child: const Icon(Icons.close, color: Colors.red, size: 18),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            TableContainer(
                              fieldModel: controller.fieldModel.value,
                              isChild: controller.isChild,
                              refresh: () {
                                controller.fieldModel.refresh();
                                print('Ket.bv');
                              },
                            ),
                          ],
                        );
                    }),
                  )),
                ),
                if (reportController.isHasEdit())
                  KeyboardVisibilityBuilder(
                      builder: (context, isKeyboardVisible) {
                    if (isKeyboardVisible) {
                      return Container();
                    } else {
                      return RButton(
                        title: 'Lưu',
                        borderRadius: 0,
                        maxSize: true,
                        action: () async {
                          await controller.reportController.updateForm();
                        },
                      );
                    }
                  })
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Obx(() {
                      bool isHangMucKiemTra = controller.fieldModel.value?.title?.toLowerCase()?.contains('hạng mục') == true;
                      return Column(
                          children: [
                            if (isHangMucKiemTra)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await reportController.pickImportExcelFile(context);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF141F36),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(Icons.file_upload_outlined, color: Colors.white, size: 18),
                                            SizedBox(width: 6),
                                            Text('Nhập excel', style: TextStyle(color: Colors.white, fontSize: 14)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (reportController.importedExcelFile.value != null) ...[
                                      const SizedBox(width: 12),
                                      const Icon(Icons.description_outlined, color: Colors.green, size: 20),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          reportController.importedExcelFile.value.path.split('/').last.split('\\').last,
                                          style: const TextStyle(color: Colors.green, fontSize: 13),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      InkWell(
                                        onTap: () {
                                          reportController.importedExcelFile.value = null;
                                        },
                                        child: const Icon(Icons.close, color: Colors.red, size: 18),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            TableContainer(
                              fieldModel: controller.fieldModel.value,
                              refresh: () {
                                controller.fieldModel.refresh();
                              },
                              isEdit: widget.isEdit,
                            ),
                          ],
                        );
                    }),
                  ),
                ),
                _renderButton()
              ],
            ),
          ),
        ),
      );
    }
  }



  Widget _renderButton() {
    return Obx(() {
      if (reportController.reportResponse.value != null) {}

      return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          if (isKeyboardVisible) {
            return Container();
          } else {
            return Row(
              children: [
                if (reportController.isHasEdit())
                  Expanded(
                    child: RButton(
                        title: 'Lưu',
                        borderRadius: 0,
                        color: RAppColor.colorBlue,
                        action: () async {
                          await controller.reportController.updateForm();
                        }),
                  ),
                if (reportController.isHasReject)
                  Expanded(
                    child: RButton(
                        title: 'Từ chối',
                        borderRadius: 0,
                        color: RAppColor.colorOrange,
                        action: reportController.actionReject),
                  ),
                if (reportController.isHasApproval)
                  Expanded(
                    child: RButton(
                        title: reportController.textBtn,
                        borderRadius: 0,
                        action: reportController.actionApproval),
                  )
              ],
            );
          }
        },
      );
    });
  }
}

