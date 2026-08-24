// @dart=2.9
import 'dart:io';
import 'package:evnmobile/src/htld/services/location_background_service.dart';
import 'package:evnmobile/src/qltnkd/common/constance/field_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'tab_form_screen.dart';

enum ReportActionType { edit, view }

class ReportScreen extends StatefulWidget {
  const ReportScreen({
    this.reportId,
    this.isMonitor = false,
    this.isApprover = false,
    this.userImpl,
    this.isAllowEditing = false,
    this.reportType,
    this.isEdit = false,
    this.isCbm = false,
  });

  final String reportId;
  final String userImpl;
  final bool isMonitor;
  final bool isApprover;
  final bool isAllowEditing;
  final int reportType;
  final bool isEdit;
  final bool isCbm;

  @override
  State<StatefulWidget> createState() {
    return ReportScreenState();
  }
}

class ReportScreenState extends State<ReportScreen>
    with TickerProviderStateMixin {
  final controller = Get.put(ReportController());

  TabController tabController;

  Future _getData() async {
    controller.isCbm = widget.isCbm;
    if (widget.isAllowEditing && widget.isEdit) {
      await LocationServiceBackground.shared.requestPermission();
    }
    Future.delayed(const Duration(milliseconds: 100), () async {
      await controller.getReport();
      if (controller.reportModel?.value?.fieldsModel?.isNotEmpty == true) {
        final tapsList = controller.reportModel?.value?.fieldsModel
            ?.firstWhere((element) => element.fieldType == FieldType.taps,
                orElse: () => null)
            ?.fieldModels ?? [];
        tabController = TabController(length: tapsList.length, vsync: this);
        if (RUserRole.isOperator) {
          await controller.getRoleOperationApprove();
        }

        tabController.addListener(() {
          if (tabController.indexIsChanging) {
            FocusScope.of(context).requestFocus(FocusNode());
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _handleOrientation();
    controller.isMonitor = widget.isMonitor;
    controller.isAllowApprove = widget.isApprover;
    controller.isAllowEditing = widget.isAllowEditing;
    controller.userImpl = widget.userImpl;
    controller.reportType = widget.reportType;

    controller.reportId = widget.reportId;
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
    _reHandleOrientation();
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasData =
          controller.reportModel?.value?.fieldsModel?.isNotEmpty == true;
      final tapsList = hasData
          ? (controller.reportModel?.value?.fieldsModel
                  ?.firstWhere((element) => element.fieldType == FieldType.taps,
                      orElse: () => null)
                  ?.fieldModels ??
              [])
          : <FieldModel>[];

      if (hasData && tapsList.isNotEmpty && tabController != null) {
        return Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            leading: BackButton(
              onPressed: () {
                if (controller.isHasEdit()) {
                  rShowMyDialogOkCancel(
                    'Bạn hãy đảm bảo các thay đổi đã được lưu lại trước khi thoát.',
                    firstTitle: 'Huỷ',
                    secondTitle: 'Thoát',
                    secondFunction: () {
                      Get.back();
                    },
                  );
                } else {
                  Get.back();
                }
              },
            ),
            backgroundColor: RAppColor.highlightColor70,
            title: Text(controller.reportModel?.value?.name ?? ''),
            bottom: TabBar(
              controller: tabController,
              tabs: _renderTabs(tapsList),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: _renderTabContent(tapsList),
                  ),
                ),
                Obx(() {
                  if (controller.selectedFiles.isEmpty) return const SizedBox();
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: Colors.grey[300])),
                    ),
                    child: SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.selectedFiles.length,
                        itemBuilder: (context, index) {
                          final file = controller.selectedFiles[index];
                          final ext = file.path.split('.').last.toLowerCase();
                          final isImage = ['png', 'jpg', 'jpeg'].contains(ext);

                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: Stack(
                              children: [
                                if (isImage)
                                  Image.file(file,
                                      height: 60, width: 60, fit: BoxFit.cover)
                                else
                                  Container(
                                    height: 60,
                                    width: 60,
                                    color: Colors.grey[200],
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          ext == 'pdf'
                                              ? Icons.picture_as_pdf
                                              : Icons.insert_drive_file,
                                          color: ext == 'pdf'
                                              ? Colors.red
                                              : Colors.blue,
                                        ),
                                        Text(ext.toUpperCase(),
                                            style: const TextStyle(
                                                fontSize: 10)),
                                      ],
                                    ),
                                  ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () => controller.removeFile(index),
                                    child: Container(
                                      color: Colors.black54,
                                      child: const Icon(Icons.close,
                                          color: Colors.white, size: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      } else {
        if (controller.isLoading.value) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: RAppColor.highlightColor70,
              title: const Text('Lỗi tải biên bản'),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Biên bản này hiện không có dữ liệu để hiển thị.\nVui lòng kiểm tra lại phía server.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
            ),
          );
        }
      }
    });
  }

  List<Tab> _renderTabs(List<FieldModel> tabs) {
    return tabs.map((e) {
      return Tab(text: e.title);
    }).toList();
  }

  List<Widget> _renderTabContent(List<FieldModel> tabs) {
    return tabs.map((e) => TabFormScreen(e, isEdit: widget.isEdit)).toList();
  }

  void _handleOrientation() {
    if (Get.size.width < 600) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    }
  }

  void _reHandleOrientation() {
    if (Get.size.height < 600) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }
}

