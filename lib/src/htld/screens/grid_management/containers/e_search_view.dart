// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../routes.dart';
import '../../../common/themes/colorx.dart';

class ESearchView extends StatelessWidget {
  const ESearchView(
      {this.editingController,
      this.onChange,
      this.hint,
      this.isHasScanQR = false,
      this.onSubmitted,
      this.enable = true,
      this.isHasClear = false});
  //final ChooseSubStationController _controller = Get.find();

  final TextEditingController editingController;
  final Function(String) onChange;
  final Function(String) onSubmitted;
  final String hint;
  final bool isHasScanQR;
  final bool isHasClear;
  final bool enable;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: enable ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(width: 1, color: AppColor.borderColor1),
      ),
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.search, size: 24),
          const SizedBox(width: 8),
          Expanded(
              child: TextField(
            enabled: enable,
            controller: editingController,
            onChanged: (value) {
              if (onChange != null) onChange(value);
            },
            onSubmitted: onSubmitted,
            decoration:
                InputDecoration(hintText: hint, border: InputBorder.none),
          )),
          const SizedBox(width: 8),
          if (isHasScanQR)
            IconButton(
                icon: const Icon(
                  Icons.qr_code,
                  size: 24,
                ),
                onPressed: () async {
                  // SnackBarHUD.show('Chức năng đang phát triển');
                  final data = await Get.toNamed(Routes.interScanQRScreen);
                  debugPrint('haudau123 data back: $data');
                  if (data != null) {
                    editingController.text = data;
                  }
                  // if (data is List<String> && data?.isNotEmpty == true) {
                  //   for (var index = 0; index < _controller.equipments.length; index++) {
                  //     final model = data.firstWhere((e) => e == _controller.equipments[index].name, orElse: () => null);
                  //     if (model != null) {
                  //       _controller.equipments[index].isChecked = true;
                  //     }
                  //   }
                  //   _controller.equipments.refresh();
                  // }
                }),
          if (isHasClear && enable)
            IconButton(
                icon: const Icon(
                  Icons.clear,
                  size: 24,
                ),
                onPressed: () async {
                  editingController.text = '';
                }),
        ],
      ),
    );
  }
}

