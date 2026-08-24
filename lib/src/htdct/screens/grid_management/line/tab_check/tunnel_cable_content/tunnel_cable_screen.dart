// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../htld/common/utils/snack_bar_h_u_d.dart';
import '../../../../../common/components/app_button.dart';
import '../../../../../common/components/button_40.dart';
import '../../../../../common/constance/app_color.dart';
import '../../../../../common/constance/app_icon.dart';
import '../../../../../common/constance/strings.dart';
import '../../../../../common/enum/ticket_enum.dart';
import '../../../../../common/utils/alert_dialog_utils.dart';
import '../../../containers/auto_height_text_field.dart';
import '../../../containers/e_button.dart';
import '../../../containers/e_check_box.dart';
import '../../../containers/search_view.dart';
import 'tunnel_cable_controller.dart';

class TunnelCableContentView extends StatefulWidget {
  const TunnelCableContentView();

  @override
  State<TunnelCableContentView> createState() => _TunnelCableContentViewState();
}

class _TunnelCableContentViewState extends State<TunnelCableContentView> with AutomaticKeepAliveClientMixin {
  final TunnelCableContentController _controller =
      TunnelCableContentController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _controller.getNodesList(null, isSelected: true);
        _controller.getContentCheck();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
       backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildListNode(),
                const Divider(height: 1),
                const SizedBox(height: 16,),
                if(_controller?.transformerTicketController?.actionTicketType != ActionTicketType.view)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      EButton(
                          title: 'Xác nhận vị trí',
                          action: () async {
                            await hShowMyDialogOkCancel('Xác nhận vị trí kiểm tra',
                                secondFunction: () async {
                                  final result = await _controller.transformerTicketController
                                      .sendLocation(isAwait: true, isCheckIn: true);
                                  if (result == true) {
                                    SnackBarHUD.show('Xác nhận vị trí kiểm tra thành công');
                                  }
                                });
                          }),
                      const SizedBox(width: 10,)
                    ],
                  ),
                const Divider(height: 1),
                const SizedBox(height: 10,),
                _buildListEquipment(),
                const Divider(height: 1),
                _buildExplanationOfUnusualPhenomena(),
              ],
            ),
          ),
        ),
        Obx(() {
          if (!_controller.isSuggestAbnormal.value &&
              _controller.transformerTicketController.isHasPermissionEdit()) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: EButton(
                maxSize: true,
                title: 'Lưu và tiếp tục',
                action: () {
                  _controller.saveContent(_controller.textAbnormal.value ?? '',
                      isSuggestAbnormal: false);
                },
              ),
            );
          }
          return Container();
        })
      ],
    );
  }

  Widget _buildListNode() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(left: 16, right: 16),
      color: HighElectricAppColor.nature01,
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: true,
            title: const Text(
              'Danh sách nút',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: HighElectricAppColor.nature06,
              ),
            ),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SearchView(
                          onChange: (value) {
                            _controller.searchNodeSelected(value);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          _showDialogAddNode();
                        },
                        child: Button40(
                          child: SvgPicture.asset(
                            HighElectricAppIcon.add,
                            width: 18,
                            height: 20,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Obx(
                    () {
                      if (_controller?.listNodeSelected?.isNotEmpty == true) {
                        return Table(
                          columnWidths: <int, TableColumnWidth>{
                            0: const FlexColumnWidth(),
                            if (_controller.transformerTicketController
                                .isHasPermissionEdit())
                              1: const FixedColumnWidth(92),
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: <TableRow>[
                            TableRow(
                              decoration: const BoxDecoration(
                                color: HighElectricAppColor.nature03,
                              ),
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 16,
                                    ),
                                    height: 40,
                                    child: const Text(
                                      'Nút',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: HighElectricAppColor.nature06,
                                      ),
                                    )),
                                if (_controller.transformerTicketController
                                    .isHasPermissionEdit())
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 16,
                                    ),
                                    height: 40,
                                    child: const Center(
                                      child: Text(
                                        'Tác vụ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: HighElectricAppColor.nature06,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            for (int i = 0;
                                i < _controller.listNodeSelected.length;
                                i++)
                              TableRow(
                                decoration: const BoxDecoration(
                                  color: HighElectricAppColor.nature01,
                                ),
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 16,
                                    ),
                                    height: 40,
                                    child: Text(
                                      _controller.listNodeSelected[i].name,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: HighElectricAppColor.nature06,
                                      ),
                                    ),
                                  ),
                                  if (_controller.transformerTicketController
                                      .isHasPermissionEdit())
                                    Center(
                                      child: InkWell(
                                        onTap: () async {
                                          if (_controller
                                                  .listNodeSelected.length ==
                                              1) {
                                            await hShowDialogOneButton(
                                                'Không thể xóa tất cả nút của công việc kiểm tra');
                                            return;
                                          }
                                          await rShowMyDialogOkCancel(
                                            HighElectricStrings.confirmDelete,
                                            secondFunction: () {
                                              _controller.deleteNode(
                                                _controller.listNodeSelected[i],
                                              );
                                            },
                                          );
                                        },
                                        child: const SizedBox(
                                          child: Icon(
                                            Icons.delete_outline_outlined,
                                            color:
                                                HighElectricAppColor.primary10,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              )
                          ],
                        );
                      }
                      return Center(
                        child: Container(
                          height: 40,
                          child: const Text(HighElectricStrings.emptyList),
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExplanationOfUnusualPhenomena() {
    return Container(
      decoration: const BoxDecoration(color: HighElectricAppColor.nature01),
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: true,
            title: const Text(
              'Diễn giải các hiện tượng bất thường',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: HighElectricAppColor.nature06,
              ),
            ),
            children: [
              Obx(() => AutoHeightTextField(
                    textFieldController: TextEditingController(
                        text: _controller.textAbnormal.value),
                    maxHeight: 150,
                    onChange: (value) {
                      _controller.textAbnormal.value = value;
                    },
                    isEnable: _controller.transformerTicketController
                            .isHasPermissionEdit() &&
                        !_controller.isSuggestAbnormal.value,
                    hintText: 'Thông tin bất thường',
                  )),
              const SizedBox(
                height: 13,
              ),
              Obx(
                () => ECheckBox(
                  isAllowEdit: _controller.transformerTicketController
                      .isHasPermissionEdit(),
                  checked: _controller.isSuggestAbnormal.value,
                  onClicked: (isChecked) async {
                    if (isChecked) {
                      await _controller.getAbnormalPhenomenon();
                    } else {
                      _controller.textAbnormal.value = '';
                    }
                    _controller.isSuggestAbnormal.value = isChecked;
                    await _controller.saveContent(
                        _controller.textAbnormal.value ?? '',
                        isSuggestAbnormal: isChecked);
                  },
                  title: 'Tự động điền',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _showDialogAddNode() async {
    await _controller.getNodesList(null, isSelected: false);
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)), //this right here
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Danh sách nút',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  SearchView(
                    onChange: (value) {
                      _controller.searchNodeUnSelected(value.toLowerCase());
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Obx(() {
                    if (_controller.isShowCheckedAll.value) {
                      return ECheckBox(
                          checked: _controller.isCheckedAll.value,
                          title: 'Chọn tất cả',
                          onClicked: (isCheck) {
                            _controller.onCheckAllSelect(isCheck: isCheck);
                          });
                    }
                    return Container();
                  }),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: Obx(
                      () {
                        if (_controller.listNodeUnSelected?.isNotEmpty ==
                            true) {
                          return SingleChildScrollView(
                            child: Table(
                              columnWidths: const <int, TableColumnWidth>{
                                0: FlexColumnWidth(),
                                1: FlexColumnWidth(),
                              },
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: <TableRow>[
                                if (_controller.listNodeUnSelected != null)
                                  for (var i = 0;
                                      i < _controller.listNodeUnSelected.length;
                                      i += 2)
                                    TableRow(
                                      decoration: const BoxDecoration(
                                        color: HighElectricAppColor.nature01,
                                      ),
                                      children: <Widget>[
                                        if (i <
                                            _controller
                                                .listNodeUnSelected.length)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child: ECheckBox(
                                              checked: _controller
                                                  .listNodeUnSelected[i]
                                                  .isSelected,
                                              title: _controller
                                                  .listNodeUnSelected[i].name,
                                              onClicked: (isCheck) {
                                                _controller
                                                    .listNodeUnSelected[i]
                                                    .isSelected = isCheck;
                                                _controller.onNodeSelected(
                                                  isCheck: isCheck,
                                                  index: i,
                                                );
                                              },
                                            ),
                                          )
                                        else
                                          const SizedBox(),
                                        if (i + 1 <
                                            _controller
                                                .listNodeUnSelected.length)
                                          ECheckBox(
                                            checked: _controller
                                                .listNodeUnSelected[i + 1]
                                                .isSelected,
                                            title: _controller
                                                .listNodeUnSelected[i + 1].name,
                                            onClicked: (isCheck) {
                                              _controller
                                                  .listNodeUnSelected[i + 1]
                                                  .isSelected = isCheck;
                                              _controller.onNodeSelected(
                                                isCheck: isCheck,
                                                index: i + 1,
                                              );
                                            },
                                          )
                                        else
                                          const SizedBox(),
                                      ],
                                    ),
                              ],
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
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
                            await _controller.updateNode();
                            Get.back();
                          },
                          child: EButtonWidget(
                            text: 'Thêm',
                            textColor: HighElectricAppColor.nature01,
                            bgColor: HighElectricAppColor.primary10,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
    // });
  }

  void _showDialogCopy(int position) {
    _controller.listEquipmentCopy.assignAll(
        _controller.listEquipmentOriginal.map((e) => e.copy()).toList());
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
                            if (_controller.searchTermCopy.value.isEmpty) {
                              return ECheckBox(
                                title: 'Chọn tất cả',
                                checked: _controller.isCheckedCopyAll.value,
                                onClicked: (value) {
                                  _controller.onCheckAllSelectCopy(
                                      isCheck: value);
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
                                                        .listEquipmentCopy[
                                                            index]
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
                                                              .setCheckedCopy(
                                                                  index);
                                                        },
                                                        checked: _controller
                                                            .listEquipmentCopy[
                                                                index]
                                                            .isChecked,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 20),
                                                        child: Text(
                                                          _controller
                                                              .listEquipmentCopy[
                                                                  index]
                                                              .name,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style:
                                                              const TextStyle(
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
                                                        padding:
                                                            const EdgeInsets
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
                                                          style:
                                                              const TextStyle(
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
                              if (equipmentsDestination?.isNotEmpty == true) {
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

  Widget _buildListEquipment() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(left: 16, right: 16),
      color: HighElectricAppColor.nature01,
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: true,
            title: const Text(
              'Danh sách thiết bị',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: HighElectricAppColor.nature06,
              ),
            ),
            children: [
              Column(
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
                  Obx(() {
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
                                    'Mã thiết bị',
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
                                    'Nút',
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
                          for (int index = 0;
                              index < _controller?.listEquipment?.length;
                              index++)
                            Container(
                              color: index % 2 == 1
                                  ? HighElectricAppColor.nature02
                                  : HighElectricAppColor.nature01,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 16),
                                      child: Text(
                                        _controller.listEquipment[index].code,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: HighElectricAppColor.nature06,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
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
                                          color: HighElectricAppColor.nature06,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 16),
                                      child: Text(
                                        _controller.listEquipment[index]
                                            .substationName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: HighElectricAppColor.nature06,
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
                                                _controller.listEquipment[index]
                                                        .isAllowLineCopy ==
                                                    true
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () async{
                                                      await _controller.onRouter(
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
                                                              .removeAt(index);
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
                                                onTap: () async {
                                                  await _controller.onRouter(
                                                      _controller.listEquipment[
                                                          index]);
                                                },
                                                child: const SizedBox(
                                                  child: Icon(
                                                    Icons.add,
                                                    color: HighElectricAppColor
                                                        .primary10,
                                                  ),
                                                ),
                                              ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    }

                    return const Center(
                      child: Text(HighElectricStrings.emptyList),
                    );
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => !_controller.transformerTicketController.isHasPermissionEdit();
}

