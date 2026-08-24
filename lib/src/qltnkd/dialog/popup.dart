// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/global_app.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_text_field.dart';
import 'package:evnmobile/src/qltnkd/common/components/single_string_dropdown.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/constance/report_work_status_type.dart';
import '../models/create_report_not_plan_model.dart';

Future<void> showDialogCancelReport(Function(String) onCancel) async {
  var note = '';

  return Get.dialog(
      WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            insetPadding: const EdgeInsets.only(left: 30, right: 30),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                          'Hủy biên bản',
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
                        title: 'Lý do',
                        line: 3,
                        value: note,
                        isRequire: true,
                        hintText: 'Vui lòng nhập lý do',
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
                              title: 'Xác nhận',
                              action: () {
                                FocusScope.of(App.globalKey.currentContext)
                                    .requestFocus(FocusNode());
                                if (note.isEmpty) {
                                  SnackBarHUD.show('Vui lòng nhập lý do');
                                  return;
                                }
                                Get.back();
                                onCancel(note);
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

Future<void> showDialogApproval(
    {@required String title,
    @required String actionText,
    @required Function positiveAction,
    @required Function negativeAction,
    @required Function onChangeContent,
    bool isRequireNote = false}) async {
  var note = '';

  return Get.dialog(
      WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            insetPadding: const EdgeInsets.only(left: 30, right: 30),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                        Text(
                          title,
                          style: const TextStyle(
                              color: RAppColor.highlightColor70,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: IconButton(
                              onPressed: () {
                                Get.back();
                                negativeAction();
                              },
                              icon: const Icon(Icons.close)),
                        ),
                      ],
                    ),
                    RTextField(
                        title: 'Ghi chú',
                        line: 3,
                        value: note,
                        isRequire: isRequireNote,
                        hintText: 'Vui lòng nhập ghi chú',
                        margin: const EdgeInsets.only(right: 26),
                        onChange: (value) {
                          onChangeContent(value);
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
                                negativeAction();
                              }),
                          const SizedBox(
                            width: 24,
                          ),
                          RButton(
                              title: actionText,
                              action: () {
                                FocusScope.of(App.globalKey.currentContext)
                                    .requestFocus(FocusNode());
                                if (note.isEmpty && isRequireNote) {
                                  SnackBarHUD.show('Vui lòng nhập ghi chú');
                                  return;
                                }
                                Get.back();
                                positiveAction();
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

Future<void> showDialogSendOperation({
  @required Function(String, String) positiveAction,
  @required Function negativeAction,
  @required List<StringOptionModel> options,
}) async {
  String userId;
  String content;
  return Get.dialog(
      WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            insetPadding: const EdgeInsets.only(left: 30, right: 30),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 150,
                // maxHeight: 250
              ),
              child: SingleChildScrollView(
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
                            RAppStrings.sendApprove,
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
                                  negativeAction();
                                },
                                icon: const Icon(Icons.close)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 26),
                        child: SingleStringDropDown(
                          options,
                          hint: 'Chọn người phê duyệt',
                          onSelected: (value) {
                            userId = value;
                          },
                        ),
                      ),
                      RTextField(
                          title: '',
                          line: 3,
                          hintText: 'Vui lòng nhập ghi chú',
                          margin: const EdgeInsets.only(right: 26),
                          onChange: (value) {
                            content = value;
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
                                  negativeAction();
                                }),
                            const SizedBox(
                              width: 24,
                            ),
                            RButton(
                                title: RAppStrings.sendApprove,
                                action: () {
                                  FocusScope.of(App.globalKey.currentContext)
                                      .requestFocus(FocusNode());
                                  if (userId != null) {
                                    Get.back();
                                    positiveAction(userId, content);
                                  }
                                })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
      barrierDismissible: true);
}

Future<void> showDialogApprovalTeam(
    {@required String title,
    @required String actionText,
    @required Function(String, String, String) positiveAction,
    @required Function negativeAction,
    @required List<StringOptionModel> presidentCenters,
    List<StringOptionModel> presidentCompanies,
    bool isReportNormal = true,
    bool isRequireNote = false}) async {
  var note = '';
  var presidentCenterId = '';
  var presidentCompanyId = '';

  return Get.dialog(
      WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Dialog(
            insetPadding: const EdgeInsets.only(left: 30, right: 30),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 150,
                // maxHeight: 250
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 26, left: 26, top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                                color: RAppColor.highlightColor70,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: IconButton(
                                onPressed: () {
                                  Get.back();
                                  negativeAction();
                                },
                                icon: const Icon(Icons.close)),
                          ),
                        ],
                      ),
                      if (isReportNormal)
                      Padding(
                        padding: const EdgeInsets.only(right: 26, top: 10),
                        child: SingleStringDropDown(
                          presidentCenters,
                          hint: 'GDTT',
                          isRequire: true,
                          onSelected: (value) {
                            presidentCenterId = value;
                          },
                        ),
                      ),
                      if (isReportNormal)
                        const SizedBox(
                          height: 20,
                        ),
                      if (isReportNormal)
                        Padding(
                          padding: const EdgeInsets.only(right: 26),
                          child: SingleStringDropDown(
                            presidentCompanies,
                            hint: 'GDCT',
                            isRequire: true,
                            onSelected: (value) {
                              presidentCompanyId = value;
                            },
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      RTextField(
                          title: 'Ghi chú',
                          line: 3,
                          isRequire: isRequireNote,
                          hintText: 'Vui lòng nhập ghi chú',
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
                                  negativeAction();
                                }),
                            const SizedBox(
                              width: 24,
                            ),
                            RButton(
                                title: actionText,
                                action: () {
                                  FocusScope.of(App.globalKey.currentContext)
                                      .requestFocus(FocusNode());
                                  if ((presidentCenterId.isEmpty ||
                                      presidentCenterId == '0') && isReportNormal) {
                                    SnackBarHUD.show(
                                        'Vui lòng chọn giám đốc trung tâm');
                                    return;
                                  }
                                  if ((presidentCompanyId.isEmpty ||
                                          presidentCompanyId == '0') &&
                                      isReportNormal) {
                                    SnackBarHUD.show(
                                        'Vui lòng chọn giám đốc công ty');
                                    return;
                                  }
                                  Get.back();
                                  positiveAction(note, presidentCenterId,
                                      presidentCompanyId);
                                })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
      barrierDismissible: true);
}

Future<List<String>> showDialogConfirm({
  @required String equipmentType,
  @required String equipmentDetail,
  @required List<StringOptionModel> equipmentTypes,
  @required List<EquipmentTypes> equipmentDetails,
  @required int workType,
}) async {
  var equipmentTypeVar = equipmentType;
  var equipmentDetailVar = equipmentDetail;
  final equipmentDetailsSelected = <EquipmentDetails>[];
  final listEquipmentDetails = <StringOptionModel>[];

  void renderEquipmentDetail(String idEquipmentType) {
    equipmentDetailsSelected.clear();
    listEquipmentDetails.clear();
    listEquipmentDetails.add(StringOptionModel('Vui lòng chọn', '0'));
    if (idEquipmentType != '0') {
      final equipmentType = equipmentDetails.firstWhere(
          (element) => idEquipmentType == element.id,
          orElse: () => null);
      for (final element in equipmentType?.equipmentDetails ?? List.empty()) {
        equipmentDetailsSelected.add(EquipmentDetails(
            id: element.id, name: element.name, forms: element.forms));
        listEquipmentDetails.add(StringOptionModel(element.name, element.id));
      }

      if (listEquipmentDetails.length == 2) {
        equipmentDetailVar = listEquipmentDetails[1].value;
      }
    }
  }

  List<Forms> renderListForms(String idEquipmentDetail) {
    final forms = <Forms>[];
    if (idEquipmentDetail != '0') {
      final equipment = equipmentDetailsSelected.firstWhere(
          (equipment) => equipment.id == idEquipmentDetail,
          orElse: () => null);
      equipment.forms.forEach((element) {
        forms
            .add(Forms(id: element.id, name: element.name, type: element.type));
      });
    }
    return forms;
  }

  return Get.dialog(
      WillPopScope(onWillPop: () async {
        return true;
      }, child: StatefulBuilder(
        builder: (context, setState) {
          renderEquipmentDetail(equipmentTypeVar);
          return Dialog(
            insetPadding: const EdgeInsets.only(left: 30, right: 30),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 150,
                // maxHeight: 250
              ),
              child: SingleChildScrollView(
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
                            'Xác nhận tạo biên bản',
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
                      Padding(
                        padding: const EdgeInsets.only(right: 26, top: 10),
                        child: SingleStringDropDown(
                          equipmentTypes,
                          hint: 'Loại VTTB',
                          isRequire: true,
                          value: equipmentTypeVar,
                          onSelected: (value) {
                            if (value == equipmentTypeVar) {
                              return;
                            }
                            equipmentTypeVar = value;
                            equipmentDetailVar = '0';
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 26),
                        child: SingleStringDropDown(
                          listEquipmentDetails,
                          key: UniqueKey(),
                          hint: 'Chi tiết VTTB',
                          value: equipmentDetailVar,
                          isRequire: true,
                          onSelected: (value) {
                            equipmentDetailVar = value;
                          },
                        ),
                      ),
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
                                title: 'Xác nhận',
                                action: () {
                                  FocusScope.of(App.globalKey.currentContext)
                                      .requestFocus(FocusNode());
                                  if (equipmentDetailVar == null || equipmentDetailVar.isEmpty ||
                                      equipmentDetailVar == '0') {
                                    SnackBarHUD.show(
                                        'Vui lòng chọn chi tiết VTTB');
                                    return;
                                  }

                                  final dataResult = [
                                    equipmentTypeVar,
                                    equipmentDetailVar
                                  ];
                                  final listForm =
                                      renderListForms(equipmentDetailVar);
                                  var form = listForm.firstWhereOrNull(
                                      (element) => element.type == workType);
                                  if (form == null) {
                                    if (WorkType.accreditationExperiment ==
                                        workType) {
                                      if (listForm.isNotEmpty) {
                                        form = listForm.first;
                                        dataResult.add(form.id);
                                      }
                                    }
                                  } else {
                                    dataResult.add(form.id);
                                  }
                                  Get.back(result: dataResult);
                                })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      )),
      barrierDismissible: true);
}

Future<void> shoDialogAddEquipmentInspection(
    Function(String, String, String) onCreate) async {
  var equipmentName = '';
  var number = '';
  var ccx = '';

  return Get.dialog(
      WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            insetPadding: const EdgeInsets.only(left: 30, right: 30),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                          'Thêm thiết bị',
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
                        title: 'Tên thiết bị',
                        value: equipmentName,
                        isRequire: true,
                        margin: const EdgeInsets.only(right: 26),
                        onChange: (value) {
                          equipmentName = value ?? '';
                        }),
                    const SizedBox(
                      height: 16,
                    ),
                    RTextField(
                        title: 'Số',
                        value: number,
                        isRequire: true,
                        margin: const EdgeInsets.only(right: 26),
                        onChange: (value) {
                          number = value ?? '';
                        }),
                    const SizedBox(
                      height: 16,
                    ),
                    RTextField(
                        title: 'CCX',
                        value: ccx,
                        isRequire: true,
                        margin: const EdgeInsets.only(right: 26),
                        onChange: (value) {
                          ccx = value ?? '';
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
                              title: 'Tạo',
                              action: () {
                                FocusScope.of(App.globalKey.currentContext)
                                    .requestFocus(FocusNode());
                                if (equipmentName.isEmpty) {
                                  SnackBarHUD.show(
                                      'Vui lòng nhập tên thiết bị');
                                  return;
                                }
                                if (number.isEmpty) {
                                  SnackBarHUD.show('Vui lòng nhập số');
                                  return;
                                }
                                if (ccx.isEmpty) {
                                  SnackBarHUD.show('Vui lòng nhập CCX');
                                  return;
                                }

                                onCreate(equipmentName, number, ccx);
                                Get.back();
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

Future<void> shoDialogAddMeasuringComment(Function(String) onCreate) async {
  var name = '';

  return Get.dialog(
      WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            insetPadding: const EdgeInsets.only(left: 30, right: 30),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                          'Thêm tùy chọn',
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
                        title: 'Tên ',
                        value: name,
                        isRequire: true,
                        margin: const EdgeInsets.only(right: 26),
                        onChange: (value) {
                          name = value ?? '';
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
                              title: 'Tạo',
                              action: () {
                                FocusScope.of(App.globalKey.currentContext)
                                    .requestFocus(FocusNode());
                                if (name.isEmpty) {
                                  SnackBarHUD.show('Vui lòng nhập tên');
                                  return;
                                }

                                onCreate(
                                  name,
                                );
                                Get.back();
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

