// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../htdct/common/utils/alert_dialog_utils.dart';
import '../../../../../common/components/app_button.dart';
import '../../../../../common/components/r_text_field.dart';
import '../../../../../dialog/popup.dart';
import '../../../../../offline_service/local_data_manager.dart';
import '../detail_workload_controller.dart';
import 'widget/workload_work_item.dart';

class ListWorkWorkLoad extends StatefulWidget {
  const ListWorkWorkLoad({Key key}) : super(key: key);

  @override
  State<ListWorkWorkLoad> createState() => _ListWorkWorkLoadState();
}

class _ListWorkWorkLoadState extends State<ListWorkWorkLoad> {
  final DetailWorkloadController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        children: [_buildListWork()],
      ),
    );
  }

  Widget _buildListWork() {
    return Expanded(
      child: Obx(() {
        return Stack(
          fit: StackFit.expand,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_controller.isEdit == true)
                  Obx(
                    () => CheckboxListTile(
                        value: _controller.isCheckAll.value,
                        title: const Text('Chọn tất cả'),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (value) {
                          _controller.setCheckAllWorks(value: value);
                        }),
                  ),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        final model = _controller.works[index];
                        return WorkloadWorkItem(
                          work: model,
                          isLast: index == _controller.works.length - 1,
                          index: index,
                          onShowReason: () async {
                            await showDialogApproval(
                                reason: model.reason,
                                onSave: (reason) {
                                  _controller.setWorkReason(model, reason);
                                });
                          },
                          onCreateTicket: () async {
                            if (model.isConfirmComplete == true) {
                              await rShowMyDialogOkCancel(
                                  'Bạn có muốn xác nhận công việc này',
                                  secondFunction: () async {
                                await _controller.confirmComplete(model);
                              });
                              return;
                            }

                            if (await RLocalDataManager.instance
                                .checkReportExist(model.id)) {
                              await rShowMyDialogOkCancel(
                                'Biên bản này đã được tạo offline, Vui lòng đồng bộ lên trước khi thực hiện tiếp',
                              );
                              return;
                            } else {
                              //create
                              final result = await showDialogConfirm(
                                  equipmentType: model.equipmentTypeId,
                                  equipmentDetail: model.equipmentDetailId,
                                  workType: 0,
                                  equipmentTypes: _controller.equipmentTypes,
                                  equipmentDetails:
                                      _controller.equipmentTypeList);
                              if (result is List<String> &&
                                  result.length == 2) {
                                model.equipmentTypeId = result[0];
                                model.equipmentDetailId = result[1];
                                await _controller.handleCreateFormReport(model);
                              }
                            }
                          },
                          isCreate: _controller.detailWorkloadModel == null,
                          onShowOrEditNote: () async {
                            await showDialogShowOrEditNote(
                                noteOriginal: model.note,
                                isAllowEdit: _controller.isEdit,
                                onSave: (note) {
                                  _controller.setWorkNote(model, note);
                                });
                          },
                          onChecked: (value) {
                            _controller.setCheckedWork(model, checked: value);
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 20,
                        );
                      },
                      itemCount: _controller.works.length),
                ),
              ],
            ),
            if (_controller.works.isEmpty)
              const Center(
                child: Text('Danh sách công việc trống'),
              )
          ],
        );
      }),
    );
  }

  Future<void> showDialogApproval(
      {Function(String) onSave, String reason}) async {
    var note = reason ?? '';

    return Get.dialog(
        WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Dialog(
              insetPadding: const EdgeInsets.only(left: 30, right: 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 150,
                  // maxHeight: 250
                ),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 26, left: 26, top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Lý do không thực hiện',
                            style: TextStyle(
                                color: RAppColor.highlightColor70,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(Icons.close)),
                          ),
                        ],
                      ),
                      RTextField(
                          title: 'Lý do không thực hiện',
                          line: 3,
                          value: note,
                          hintText: 'Vui lòng nhập',
                          margin: const EdgeInsets.only(right: 26),
                          onChange: (value) {
                            note = value;
                          }),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 26),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RButton(
                                title: 'Hủy',
                                titleColor: Colors.black,
                                color: Colors.grey.shade100,
                                action: () {
                                  Get.back();
                                }),
                            const SizedBox(
                              width: 24,
                            ),
                            RButton(
                                title: 'Lưu',
                                action: () {
                                  Get.back();
                                  onSave(note);
                                })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
        barrierDismissible: true);
  }

  Future<void> showDialogShowOrEditNote(
      {Function(String) onSave, String noteOriginal, bool isAllowEdit}) async {
    var note = noteOriginal ?? '';

    return Get.dialog(
        WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Dialog(
              insetPadding: const EdgeInsets.only(left: 30, right: 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 150,
                  // maxHeight: 250
                ),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 26, left: 26, top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Ghi chú công việc',
                            style: TextStyle(
                                color: RAppColor.highlightColor70,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(Icons.close)),
                          ),
                        ],
                      ),
                      RTextField(
                          title: '',
                          line: 3,
                          value: note,
                          isEnable: isAllowEdit,
                          hintText: 'Vui lòng nhập',
                          margin: const EdgeInsets.only(right: 26),
                          onChange: (value) {
                            note = value;
                          }),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 26),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RButton(
                                title: 'Hủy',
                                titleColor: Colors.black,
                                color: Colors.grey.shade100,
                                action: () {
                                  Get.back();
                                }),
                            if (isAllowEdit)
                              const SizedBox(
                                width: 24,
                              ),
                            if (isAllowEdit)
                              RButton(
                                  title: 'Lưu',
                                  action: () {
                                    Get.back();
                                    onSave(note);
                                  })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
        barrierDismissible: true);
  }
}

