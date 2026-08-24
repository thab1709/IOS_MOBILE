// @dart=2.9
import 'package:evnmobile/src/htdct/common/components/button_40.dart';
import 'package:evnmobile/src/htdct/common/constance/app_color.dart';
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/e_button.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/e_check_box.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/search_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/components/app_bar_common.dart';
import '../../../../../../common/themes/styles.dart';
import '../../../../../../models/day_night/tba_content_check.dart';
import '../../../../../../models/equipment_model.dart';
import 'equipment_list_controller.dart';

class ListDevicesView extends StatefulWidget {
  const ListDevicesView({this.isSuggestAbnormal = false, this.popup});

  final bool isSuggestAbnormal;
  final Popups popup;

  @override
  State<ListDevicesView> createState() => _ListDevicesViewState();
}

class _ListDevicesViewState extends State<ListDevicesView> {
  final EquipmentLineController _controller = EquipmentLineController();

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
    _controller.listEquipmentCopy.assignAll(_controller.listEquipmentOriginal.map((e) => e.copy()).toList());
    _controller.listEquipmentCopy.removeAt(position);
    _controller.isCheckedCopyAll.value = false;
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
                                          Expanded(
                                            child: Container(
                                              color:
                                                  HighElectricAppColor.nature03,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              height: 40,
                                              child: const Text(
                                                'Tên nút',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: HighElectricAppColor
                                                      .nature06,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: _controller
                                              ?.listEquipmentCopy?.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                _controller
                                                    .setCheckedCopy(index);
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
                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets
                                                                .symmetric(
                                                            vertical: 20,
                                                            horizontal: 5),
                                                        child: Text(
                                                          _controller
                                                              .listEquipmentCopy[
                                                                  index]
                                                              .substationName,
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
          color: HighElectricAppColor.nature01,
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
                    _controller.categoryName.value,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: HighElectricAppColor.nature06),
                  )),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: HighElectricAppColor.nature01,
                padding: const EdgeInsets.all(16),
                child: SearchView(
                  onChange: (value) {
                    _controller.searchText=value;
                    _controller.searchEquipment(value);
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),

              Obx(() {
                if(_controller.isShowButtonCheck.value || _controller.isShowCheckAll.value) {
                  return Container(
                  padding: const EdgeInsets.all(16),
                  color: HighElectricAppColor.nature01,
                  child: Obx(
                        () => Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (_controller.isShowCheckAll.value)
                          Expanded(
                              child: ECheckBox(
                                title: 'Chọn tất cả',
                                checked: _controller.isCheckedAll.value,
                                onClicked: (value) {
                                  _controller.onCheckAllSelect(isCheck: value);
                                },
                                isHeader: true,
                              )),
                        if(_controller.isShowButtonCheck.value)
                          GestureDetector(
                            onTap: () {
                              _controller.sameLineCopyClick();
                            },
                            child: Container(
                              height: 35,
                              width: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: HighElectricAppColor.primary10,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Kiểm tra',
                                style: TextStyle(
                                    color: HighElectricAppColor.nature01,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
                }

                return const SizedBox();
              }),
              const SizedBox(
                height: 5,
              ),
              Expanded(child: Obx(() {
                if (_controller?.listEquipment?.isNotEmpty == true) {
                  return SingleChildScrollView(
                      child: Column(
                    children: [
                      for (int i = 0; i < _controller.listEquipment.length; i++)
                        _buildListItem(_controller.listEquipment[i], i)
                    ],
                  ));
                }

                return const Center(
                  child: Text(HighElectricStrings.emptyList),
                );
              }))
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(EquipmentModel equipmentModel, int index) {
    return Container(
      color: HighElectricAppColor.nature01,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: equipmentModel.isShowCheckBox
                      ? ECheckBox(
                          title: equipmentModel.name,
                          checked: equipmentModel.isChecked,
                          onClicked: (value) {
                            equipmentModel.isChecked = value;
                            _controller.onNodeSelected(
                              isCheck: value,
                              index: index,
                            );
                          },
                          isHeader: true,
                        )
                      : Text(
                          equipmentModel.name,
                          style: Styles.textNormal,
                          softWrap: true,
                        )),
              const SizedBox(height: 20),
              _buildListItemAction(equipmentModel, index),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Tên nút',
            style: Styles.tabBarTitle,
          ),
          const SizedBox(height: 10),
          Text(
            equipmentModel.substationName,
            style: Styles.textNormal,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              color: HighElectricAppColor.nature02,
              height: 1,
            ),
          ),
          const Text(
            'Tuyến đi chung',
            style: Styles.tabBarTitle,
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              for (int i = 0; i < equipmentModel.listSameLine.length; i++)
                Text(
                  equipmentModel.listSameLine[i],
                  style: Styles.textNormal,
                  softWrap: true,
                )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildListItemAction(EquipmentModel equipmentModel, int index) {
    return Center(
      child: !_controller.transformerTicketController.isHasPermissionEdit()
          ? InkWell(
              onTap: () {
                _controller.transformerTicketController.nodeName = equipmentModel.substationName;
                _controller.onRouter(equipmentModel);
              },
              child: const SizedBox(
                child: Icon(
                  Icons.remove_red_eye_rounded,
                  color: HighElectricAppColor.primary10,
                ),
              ),
            )
          : equipmentModel.isAllowEditOrCopy ||
                  equipmentModel.isAllowLineCopy == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        _controller.transformerTicketController.nodeName = equipmentModel.substationName;
                        _controller.onRouter(equipmentModel);
                      },
                      child: Button40(
                        child: const Icon(
                          Icons.edit_outlined,
                          color: HighElectricAppColor.nature01,
                        ),
                      ),
                    ),
                    if (_controller.isShowCopy(index))
                      const SizedBox(
                        width: 16,
                      ),
                    if (_controller.isShowCopy(index))
                      InkWell(
                        onTap: () {
                          _controller.transformerTicketController.nodeName = equipmentModel.substationName;
                          if (_controller.isShowCopy(index)) {
                            _controller.listEquipment.assignAll(
                                RxList.from(_controller.listEquipmentOriginal));
                            _controller.idEquipmentCopy = equipmentModel.id;
                            _controller.positionCopy = index;
                            _controller.listEquipment.removeAt(index);
                            _showDialogCopy(index);
                          }
                        },
                        child: Button40(
                          child: const Icon(
                            Icons.copy,
                            color: HighElectricAppColor.nature01,
                          ),
                        ),
                      ),
                  ],
                )
              : InkWell(
                  onTap: () {
                    _controller.transformerTicketController.nodeName = equipmentModel.substationName;
                    _controller.onRouter(_controller.listEquipment[index]);
                  },
                  child: Button40(
                    child: const Icon(
                      Icons.add,
                      color: HighElectricAppColor.nature01,
                    ),
                  ),
                ),
    );
  }
}

