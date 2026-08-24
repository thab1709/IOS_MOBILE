// @dart=2.9
import 'package:collection/collection.dart';
import 'package:evnmobile/src/htdct/common/constance/app_color.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/auto_height_text_field.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/equipment_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/components/app_button.dart';
import '../../../../../common/components/popup_mobile_screen.dart';
import '../../equipment_list/equipment_list_screen.dart';
import 'content_check_controller.dart';
import 'test_info_general/test_info_general.dart';

class TBACheckContentView extends StatefulWidget {
  const TBACheckContentView();

  @override
  State<TBACheckContentView> createState() => _TBACheckContentViewState();
}

class _TBACheckContentViewState extends State<TBACheckContentView> with AutomaticKeepAliveClientMixin {
  final TBAContentCheckController _controller = TBAContentCheckController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
          const Duration(milliseconds: 200), _controller.getContentCheck);
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
          _buildListTestType(),
          _buildExplanationOfUnusualPhenomena(),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildListTestType() {
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
              'Danh sách loại kiểm tra',
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
                              popup: _controller
                                  .tbaContentCheck.value.popups[index],
                              onTap: () async {
                                await Get.to(
                                  () => ListDevicesView(
                                    popup: _controller
                                        .tbaContentCheck.value.popups[index],
                                    isSuggestAbnormal:
                                        _controller.isSuggestAbnormal.value,
                                  ),
                                );
                                if(_controller.transformerTicketController.isHasPermissionEdit()) {
                                  await _controller.getContentCheck();
                                }
                              }))
                          .toList()),
                  const SizedBox(
                    height: 24,
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
          AutoHeightTextField(
            textFieldController:
                TextEditingController(text: _controller.textAbnormal.value),
            isEnable:
                _controller.transformerTicketController.isHasPermissionEdit() &&
                    !_controller.isSuggestAbnormal.value,
            maxHeight: 150,
            onChange: (value) {
              _controller.textAbnormal.value = value;
            },
            hintText: 'Thông tin bất thường',
          ),
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
                          isSuggestAbnormal: isChecked);
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
                              isSuggestAbnormal: false);
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

  @override
  bool get wantKeepAlive => !_controller.transformerTicketController.isHasPermissionEdit();
}

