// @dart=2.9
import 'package:collection/collection.dart';
import 'package:evnmobile/routes.dart';
import 'package:evnmobile/src/htdct/common/components/button_40.dart';
import 'package:evnmobile/src/htdct/common/constance/app_color.dart';
import 'package:evnmobile/src/htdct/common/constance/app_icon.dart';
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/enum/ticket_enum.dart';
import 'package:evnmobile/src/htdct/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htdct/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/auto_height_text_field.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/e_button.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/equipment_button.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/violate_button.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/content/equipment_list/equipment_list_screen.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/content/test_info_general/test_info_general.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../common/components/app_button.dart';
import '../../../../../common/components/popup_mobile_screen.dart';
import '../../../containers/e_check_box.dart';
import '../../../containers/search_view.dart';
import 'content_check_controller.dart';

class LineCheckContentView extends StatefulWidget {
  const LineCheckContentView();

  @override
  State<LineCheckContentView> createState() => _LineCheckContentViewState();
}

class _LineCheckContentViewState extends State<LineCheckContentView> with AutomaticKeepAliveClientMixin {
  final LineContentCheckController _controller = LineContentCheckController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _controller.getContentCheck();
        _controller.getNodesList(null, isSelected: true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() => SingleChildScrollView(
          child: _buildListTest(),
        ));
  }

  Widget _buildListTest() {
    if (_controller?.tbaContentCheck?.value?.popups?.isNotEmpty == true) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCheckGeneral(),
          _buildListNode(),
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
                const SizedBox(width: 20,)
              ],
            ),
          const SizedBox(height: 10,),
          _buildListTestType(),
          _buildListViolateType(),
          _buildExplanationOfUnusualPhenomena(),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildCheckGeneral() {
    return InkWell(
      onTap: () async {
        _controller.transformerTicketController.equipmentCategory = null;
        await Get.to(() => PopupBaseEquipmentScreen(
              name: 'Thông tin kiểm tra chung',
              actionType:
                  _controller.transformerTicketController.actionTicketType,
              child: TestInfoGeneral(),
            ));
      },
      child: Container(
        decoration: const BoxDecoration(color: HighElectricAppColor.nature01),
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Thông tin kiểm tra chung',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: HighElectricAppColor.nature06,
              ),
            ),
            Icon(Icons.arrow_forward_ios_outlined),
          ],
        ),
      ),
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
            initiallyExpanded: false,
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
                      if(_controller.transformerTicketController.isHasPermissionEdit())
                      const SizedBox(
                        width: 12,
                      ),
                      if(_controller.transformerTicketController.isHasPermissionEdit())
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
                        return  Table(
                          columnWidths: <int, TableColumnWidth>{
                            0: const FlexColumnWidth(),
                            if(_controller.transformerTicketController.isHasPermissionEdit())
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
                                if(_controller.transformerTicketController.isHasPermissionEdit())
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
                                  if(_controller.transformerTicketController.isHasPermissionEdit())
                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        if(_controller.listNodeSelected.length == 1){
                                          hShowDialogOneButton('Không thể xóa tất cả nút của công việc kiểm tra');
                                          return;
                                        }
                                        _controller.deleteNode(
                                          _controller.listNodeSelected[i],
                                        );
                                      },
                                      child: const SizedBox(
                                        child: Icon(
                                          Icons.delete_outline_outlined,
                                          color: HighElectricAppColor.primary10,
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
                          child: const Text(HighElectricStrings.emptyList),),
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

  Widget _buildListTestType() {
    return Container(
      decoration: const BoxDecoration(color: HighElectricAppColor.nature01),
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Danh sách loại kiểm tra',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: HighElectricAppColor.nature06,
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          GridView.count(
              crossAxisCount: GetPlatform.isMobile ? 1 : 2,
              shrinkWrap: true,
              childAspectRatio: 6 / 1.1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: const NeverScrollableScrollPhysics(),
              children: _controller.tbaContentCheck.value.popups
                  .mapIndexed((index, element) => EquipmentButton(
                      popup: _controller.tbaContentCheck.value.popups[index],
                      onTap: () async {
                        await Get.to(
                          () => ListDevicesView(
                            popup:
                                _controller.tbaContentCheck.value.popups[index],
                            isSuggestAbnormal:
                                _controller.isSuggestAbnormal.value,
                          ),
                        );
                        if(_controller.transformerTicketController.isHasPermissionEdit()) {
                          await _controller.getContentCheck();
                          if(_controller.isSuggestAbnormal.value) {
                            await _controller.getAbnormalPhenomenon();
                          }
                        }
                      }))
                  .toList()),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildListViolateType() {
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
              'Danh sách loại vi phạm',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: HighElectricAppColor.nature06,
              ),
            ),

            children: [
              GridView.count(
                crossAxisCount: GetPlatform.isMobile ? 1 : 2,
                shrinkWrap: true,
                childAspectRatio: 6 / 1.1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                physics: const NeverScrollableScrollPhysics(),
                children: _controller.tbaContentCheck.value.violateCounts
                    .mapIndexed(
                      (index, element) => ViolateButton(
                        violate: _controller
                            .tbaContentCheck.value.violateCounts[index],
                        onTap: () async {
                          await Get.toNamed(Routes.listViolate,
                              arguments: _controller
                                  .tbaContentCheck.value.violateCounts[index]);
                          if(_controller.transformerTicketController.isHasPermissionEdit()) {
                            await _controller.getContentCheck();
                          }
                        }
                      ),
                    )
                    .toList(),
              ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Diễn giải các hiện tượng bất thường',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: HighElectricAppColor.nature06,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Obx(() => AutoHeightTextField(
                textFieldController:
                    TextEditingController(text: _controller.textAbnormal.value),
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
          if (_controller.transformerTicketController.isHasPermissionEdit())
            Obx(() {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile(
                      value: _controller.isSuggestAbnormal.value,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.all(0),
                      onChanged: (isChecked) async {
                        if (isChecked) {
                          await _controller.getAbnormalPhenomenon();
                        } else {
                          //_controller.textAbnormal.value = '';
                        }
                        _controller.isSuggestAbnormal.value = isChecked;
                        await _controller.saveContent(
                            _controller.textAbnormal.value ?? '',
                            isSuggestAbnormal: isChecked
                        );
                      },
                      title: const Text('Tự động điền'),
                    ),
                    if (!_controller.isSuggestAbnormal.value)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: EButton(
                        maxSize: true,
                        title: 'Lưu và tiếp tục',
                        action: () {
                          _controller.saveContent(
                              _controller.textAbnormal.value ?? '',
                              isSuggestAbnormal: false
                          );
                        },
                      ),
                    )
                  ],
                );
            })
        ],
      ),
    );
  }

  void _showDialogAddNode() {

    _controller.getNodesList(() {
      showDialog(
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
                       _controller
                           .searchNodeUnSelected(value.toLowerCase());
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
                      child: Obx(() {
                        if (_controller.listNodeUnSelected?.isNotEmpty == true) {
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
                                            _controller.listNodeUnSelected.length)
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(bottom: 12),
                                            child: ECheckBox(
                                              checked: _controller
                                                  .listNodeUnSelected[i]
                                                  .isSelected,
                                              title: _controller
                                                  .listNodeUnSelected[i].name,
                                              onClicked: (isCheck) {
                                                _controller.listNodeUnSelected[i]
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
                                            _controller.listNodeUnSelected.length)
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
                        return const Center(
                          child: Text(HighElectricStrings.emptyList),
                        );
                      }),
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
                            onTap: () {
                              _controller.updateNode();
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
    },
        isSelected: false,
    );
  }

  @override
  bool get wantKeepAlive => !_controller.transformerTicketController.isHasPermissionEdit();
}

