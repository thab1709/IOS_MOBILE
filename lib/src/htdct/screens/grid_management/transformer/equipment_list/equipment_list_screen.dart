// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/app_color.dart';
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/e_button.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/e_check_box.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/search_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/components/app_bar_common.dart';
import '../../../../common/enum/ticket_enum.dart';
import '../../../../models/day_night/tba_content_check.dart';
import 'equipment_list_controller.dart';

class ListDevicesView extends StatefulWidget {
  const ListDevicesView({this.isSuggestAbnormal = false, this.popup});

  final bool isSuggestAbnormal;
  final Popups popup;

  @override
  State<ListDevicesView> createState() => _ListDevicesViewState();
}

class _ListDevicesViewState extends State<ListDevicesView> {
  final EquipmentController _controller = EquipmentController();

  @override
  void initState() {
    super.initState();
    _controller.categoryId = widget.popup.inspectionCategory;
    _controller.isSuggestAbnormal = widget.isSuggestAbnormal;
    _controller.categoryName.value = widget.popup.categoryName;
    Future.delayed(
        const Duration(milliseconds: 100), _controller.getEquipmentList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const AppBarCommon(
        title: 'Danh sách thiết bị kiểm tra',
      ),
      body: _buildBody(),
    );
  }

  void _showDialogCopy(int position) {
    _controller.isCheckedCopyAll.value = false;
    _controller.listEquipmentCopy.assignAll(_controller.listEquipmentOriginal.map((e) => e.copy()).toList());
    _controller.listEquipmentCopy.removeAt(position);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Obx(() {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)), //this right here
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Chọn thiết bị kiểm tra ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                            onTap: () {
                              _controller.refreshList();
                              Get.back();
                            },
                            child: const Icon(Icons.close))
                      ],
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sao chép từ thiết bị:',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: HighElectricAppColor.nature05),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            _controller.listEquipmentOriginal[position].name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: HighElectricAppColor.nature06),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchView(
                            onChange: (value) {
                              _controller.searchTermCopy.value = value ?? '';
                              _controller.searchEquipmentCopy(value);
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Obx(() {
                            if(_controller.searchTermCopy.value.isEmpty) {
                              return  ECheckBox(
                                title: 'Chọn tất cả',
                                checked: _controller.isCheckedCopyAll.value,
                                onClicked: (value) {
                                  _controller.onCheckAllSelectCopy(isCheck: value);
                                },
                                isHeader: true,
                              );
                            }
                            return const SizedBox();
                          }),
                          const SizedBox(
                            height: 16,
                          ),
                          Expanded(
                            child: _controller?.listEquipmentCopy?.isNotEmpty ==
                                true
                                ? Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        color:
                                        HighElectricAppColor.nature03,
                                        padding:
                                        const EdgeInsets.symmetric(
                                            vertical: 10),
                                        height: 40,
                                        child: const Text(
                                          'Tên thiết bị',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: HighElectricAppColor
                                                .nature06,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _controller
                                        ?.listEquipmentCopy?.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          _controller.setCheckedCopy(index);
                                        },
                                        child: Container(
                                          color: _controller
                                              .listEquipmentCopy[index]
                                              .isAllowEditOrCopy
                                              ? HighElectricAppColor
                                              .greenLightGreenAccentAccent
                                              : index % 2 == 0
                                              ? HighElectricAppColor
                                              .nature02
                                              : HighElectricAppColor
                                              .nature01,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10),
                                                child: ECheckBox(
                                                  onClicked: (value) {
                                                    _controller
                                                        .setCheckedCopy(index);
                                                  },
                                                  checked: _controller
                                                      .listEquipmentCopy[index]
                                                      .isChecked,
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 20),
                                                  child: Text(
                                                    _controller
                                                        .listEquipmentCopy[
                                                    index]
                                                        .name,
                                                    textAlign:
                                                    TextAlign.start,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      color:
                                                      HighElectricAppColor
                                                          .nature06,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                                : const Center(
                              child: Text(HighElectricStrings.emptyList),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          GestureDetector(
                            onTap: () {
                              final equipmentsDestination = _controller
                                  .listEquipmentCopy
                                  .where((element) => element.isChecked)
                                  .toList();
                              if(equipmentsDestination?.isNotEmpty == true) {
                                Get.back();
                                if (equipmentsDestination.isNotEmpty) {
                                  final testedList = equipmentsDestination
                                      .where((element) =>
                                  element.isAllowEditOrCopy)
                                      .toList();
                                  if (testedList.isEmpty) {
                                    _controller.onRouter(
                                        _controller
                                            .listEquipmentOriginal[position],
                                        equipmentsDestination:
                                        equipmentsDestination);
                                  } else {
                                    hShowMyDialogOkCancel(
                                        HighElectricStrings
                                            .contentPopupCopyEquipment,
                                        firstTitle: 'Không',
                                        secondTitle: 'Có', secondFunction: () {
                                      _controller.onRouter(
                                          _controller
                                              .listEquipmentOriginal[position],
                                          equipmentsDestination:
                                          equipmentsDestination);
                                    });
                                  }
                                }
                                _controller.refreshList();
                              } else {
                                hShowDialogOneButton('Vui lòng chọn thiết bị');
                              }
                            },
                            child: EButtonWidget(
                              text: 'Kiểm tra',
                              textColor: HighElectricAppColor.nature01,
                              bgColor: HighElectricAppColor.primary10,
                              width: double.infinity,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }


  Widget _buildBody() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: HighElectricAppColor.nature01,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Loại thiết bị',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: HighElectricAppColor.nature06),
              ),
              Obx(() => Text(
                    _controller.categoryName.value=='Tủ nạp'?'Tủ chỉnh lưu 1 chiều':_controller.categoryName.value,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: HighElectricAppColor.nature06),
                  )),
            ],
          ),
        ),
        Expanded(
          child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: HighElectricAppColor.nature01,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchView(
                    onChange: (value) {
                      _controller.searchText = value;
                      _controller.searchEquipment(value, isPopup: false);
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(child: Obx(() {
                    if (_controller?.listEquipment?.isNotEmpty == true) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  color: HighElectricAppColor.nature03,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  height: 40,
                                  child: const Text(
                                    'Tên thiết bị',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: HighElectricAppColor.nature06,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: HighElectricAppColor.nature03,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  height: 40,
                                  child: const Text(
                                    'Tên ngăn lộ',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: HighElectricAppColor.nature06,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: HighElectricAppColor.nature03,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                height: 40,
                                width: 100,
                                child: const Center(
                                  child: Text('Tác vụ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: HighElectricAppColor.nature06,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _controller?.listEquipment?.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  color: index % 2 == 1
                                      ? HighElectricAppColor.nature02
                                      : HighElectricAppColor.nature01,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        // flex:2,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 16),
                                          child: Text(
                                            _controller.listEquipment[index].name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  HighElectricAppColor.nature06,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        // flex:1,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 16),
                                          child: Text(
                                            _controller.listEquipment[index].prevent??'',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color:
                                              HighElectricAppColor.nature06,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: index % 2 == 1
                                            ? HighElectricAppColor.nature02
                                            : HighElectricAppColor.nature01,
                                        height: 40,
                                        width: 100,
                                        alignment: Alignment.center,
                                        child: !_controller
                                                .transformerTicketController
                                                .isHasPermissionEdit()
                                            ? InkWell(
                                                onTap: () {
                                                  _controller.onRouter(_controller
                                                      .listEquipment[index]);
                                                },
                                                child: const SizedBox(
                                                  child: Icon(
                                                    Icons.remove_red_eye_rounded,
                                                    color: HighElectricAppColor
                                                        .primary10,
                                                  ),
                                                ),
                                              )
                                            : _controller.listEquipment[index]
                                                        .isAllowEditOrCopy ||
                                                    _controller
                                                            .listEquipment[index]
                                                            .isAllowLineCopy ==
                                                        true
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          _controller.transformerTicketController.actionPopupType = ActionTicketType.edit;
                                                          _controller.onRouter(
                                                              _controller
                                                                      .listEquipment[
                                                                  index]);
                                                        },
                                                        child: const SizedBox(
                                                          child: Icon(
                                                            Icons.edit_outlined,
                                                            color:
                                                                HighElectricAppColor
                                                                    .primary10,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 17,
                                                      ),
                                                      Opacity(
                                                        opacity: _controller
                                                                .isShowCopy(index)
                                                            ? 1
                                                            : 0,
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (_controller
                                                                .isShowCopy(
                                                                    index)) {
                                                              _controller
                                                                  .listEquipment
                                                                  .assignAll(RxList
                                                                      .from(_controller
                                                                          .listEquipmentOriginal));
                                                              _controller
                                                                      .idEquipmentCopy =
                                                                  _controller
                                                                      .listEquipment[
                                                                          index]
                                                                      .id;
                                                              _controller
                                                                      .positionCopy =
                                                                  index;
                                                              _controller
                                                                  .listEquipment
                                                                  .removeAt(
                                                                      index);
                                                              _showDialogCopy(
                                                                  index);
                                                            }
                                                          },
                                                          child: const SizedBox(
                                                            child: Icon(
                                                              Icons.copy,
                                                              color:
                                                                  HighElectricAppColor
                                                                      .primary10,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      _controller.transformerTicketController.actionPopupType = ActionTicketType.create;
                                                      _controller.onRouter(
                                                          _controller
                                                                  .listEquipment[
                                                              index]);
                                                    },
                                                    child: const SizedBox(
                                                      child: Icon(
                                                        Icons.add,
                                                        color:
                                                            HighElectricAppColor
                                                                .primary10,
                                                      ),
                                                    ),
                                                  ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      );
                    }

                    return const Center(
                      child: Text(HighElectricStrings.emptyList),
                    );
                  }))
                ],
              )),
        ),
      ],
    );
  }
}

