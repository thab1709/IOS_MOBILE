// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

import '../../../common/constance/inspection_category.dart';
import '../containers/e_text_form_field.dart';
import '../transformer/check_by_daytime/check_sheet/common/title_text_row.dart';
import 'base_popup_controller_inter.dart';

abstract class BasePopupWidget extends StatelessWidget{
  void saveData();

  Widget buildCommonInfo(BasePopupController _controller) {
    return Column(
      children: [
        TitleTextRow(
            title: 'Loại thiết bị',
            text: _controller.equipmentModel.equipmentCategoryEx??HighElectricInspectionCategory.getPopupName(
                _controller.equipmentModel.equipmentCategory)),
        TitleTextRow(
            title: 'Tên thiết bị',
            isVertical: (_controller.equipmentsDestination?.length ?? 0) > 1,
            text: _controller.transformerTicketController.abnormalNotify? _controller.transformerTicketController.equipmentNameNotify??'' : _controller.equipmentsDestination
                    ?.map((e) => e.name)
                    ?.join(', ') ??
                _controller.equipmentModel.name ??
                ''),
        // ETextFormField(
        //   /*formKey: formKey,*/
        //   hint: 'Nhập thông tin',
        //   title: 'Nhiệt độ môi trường',
        //   isNumpad: true,
        //   isRequied: true,
        //   invalid: _controller.invalid.value,
        //   value: _controller.temperature.value,
        //   onChangeInput: (value) {
        //     _controller.temperature.value = value;
        //   },
        // ),
        // ETextFormField(
        //   /*formKey: formKey,*/
        //   hint: 'Nhập thông tin',
        //   title: 'Độ ẩm môi trường',
        //   isNumpad: true,
        //   isRequied: true,
        //   invalid: _controller.invalid.value,
        //   value: _controller.humidity.value,
        //   onChangeInput: (value) {
        //     _controller.humidity.value = value;
        //   },
        // ),
      ],
    );
  }

  Widget buildCommonInfoLine(BasePopupController _controller) {
    return Column(
      children: [
        TitleTextRow(
            title: 'Loại thiết bị',
            text: HighElectricInspectionCategory.getPopupName(
                _controller.equipmentModel.equipmentCategory)),
        TitleTextRow(
            title: 'Nút',
            isVertical: (_controller.equipmentsDestination?.length ?? 0) > 1,
            text:_controller.transformerTicketController.abnormalNotify? _controller.transformerTicketController.nodeNameNotify??'': _controller.equipmentsDestination
                    ?.map((e) => e.substationName)
                    ?.join(', ') ??
                _controller.equipmentModel.substationName ??
                ''),
        TitleTextRow(
            title: 'Tên thiết bị',
            isVertical: (_controller.equipmentsDestination?.length ?? 0) > 1,
            text:_controller.transformerTicketController.abnormalNotify? _controller.transformerTicketController.equipmentNameNotify??'': _controller.equipmentsDestination
                    ?.map((e) => e.name)
                    ?.join(', ') ??
                _controller.equipmentModel.name ??
                ''),
      ],
    );
  }
}
