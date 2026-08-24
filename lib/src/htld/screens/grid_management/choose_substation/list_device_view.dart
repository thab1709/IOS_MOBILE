// @dart=2.9
import 'package:evnmobile/src/htld/common/components/app_button.dart';
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/equipment_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_label.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_search_view.dart';
import 'package:evnmobile/src/htld/screens/grid_management/grid_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'choose_substation_controller.dart';

class ListDeviceView extends GetView<ChooseSubStationController> {
  ListDeviceView({this.create, this.submitTitle});
  final String submitTitle;
  final Function create;
  final GridManagementController _gridManagementController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ELabel(title: 'Danh sách thiết bị'),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: ESearchView(
              hint: 'Tìm thiết bị theo tên/ mã/ QR code',
              isHasScanQR: true,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Obx(
            () => controller.equipments.isNotEmpty == true
                ? _renderHeaderItem(context)
                : const Expanded(
                    child: Center(
                    child: Text('Không có dữ liệu'),
                  )),
          ),
          Obx(() => Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.equipments.length,
                    itemBuilder: (context, index) {
                      return _renderDeviceItem(
                          controller.equipments[index], index);
                    }),
              )),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: EButton(
                maxSize: true,
                title: submitTitle,
                action: create,
                color: AppColor.highlightColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _renderHeaderItem(BuildContext context) {
    const _typeTextHeader =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: AppColor.borderColor)),
      height: 60,
      child: Row(
        children: [
          const Expanded(flex: 3, child: Text('Mã thiết bị', style: _typeTextHeader,)),
          const Expanded(flex: 3,child: Text('Tên thiết bị', style: _typeTextHeader,)),
          if (_gridManagementController.argument.ticketType != TicketType.periodicNight)
            Obx(() => Expanded(flex: 1,
              child: Checkbox(value: controller.isCheckAll.value, onChanged: (value) {
                final message = controller.isCheckAll.value
                    ? 'Bạn muốn bỏ kiểm tra tất cả thiết bị?'
                    : 'Bạn muốn kiểm tra tất cả thiết bị?';
                showMyDialogOkCancel(message, secondFunction: () {
                  controller.checkAllDevices(value: value);
                });
              },),
            )) else Expanded(child: Container())
        ],
      ),
    );
  }

  Widget _renderDeviceItem(EquipmentModel item, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: AppColor.borderColor)),
      height: 60,
      child: Row(
        children: [
          Expanded(flex: 3, child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(item.code),
          )),
          Expanded(flex: 3, child: Text(item.name)),
          Expanded(flex: 1, child: (_gridManagementController.argument.ticketType != TicketType.periodicNight) ?
          Checkbox(value: item.isChecked ?? false, checkColor: Colors.white,

            activeColor: Colors.deepOrangeAccent,
            onChanged: item.isUsed ? null : (value) {
              controller.selectedItem(index, value: value);
            },
          ) : Container())
        ],
      ),
    );
  }
}

