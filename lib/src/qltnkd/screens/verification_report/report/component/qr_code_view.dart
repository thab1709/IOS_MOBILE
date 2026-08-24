// @dart=2.9

import 'package:evnmobile/src/qltnkd/common/constance/field_type.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:evnmobile/src/qltnkd/models/qr_code_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report/scan_qr/scan_qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../report_controller.dart';

class QRCodeView extends StatelessWidget {
  QRCodeView({this.enable = true, this.fieldModel});

  final bool enable;
  final FieldModel fieldModel;
  final ReportController reportController = Get.put(ReportController());


  @override
  Widget build(BuildContext context) {
    return enable ? InkWell(
      onTap: () async {
       final result = await Get.to(() => const ScanQRScreen());
       if(result != null) {
          if(result != null && result is QRResultModel) {
            if (fieldModel?.relationKey?.isNotEmpty == true) {
           await reportController.reportModel.value.fieldsModel
                  .firstWhere((element) => element.fieldType == FieldType.taps,
                  orElse: () => null).getAdditionDataFieldDropdown(fieldModel?.relationKey, fieldModel);
              final fieldSelected = fieldModel?.additionalData?.options?.firstWhere((element) => element.value == result.id, orElse: () => null);
              if(fieldSelected == null){
                await rShowDialogOneButton('Không tìm thấy dữ liệu tương ứng');
                return;
              }
              await reportController.reportModel.value.fieldsModel
                  .firstWhere((element) => element.fieldType == FieldType.taps,
                  orElse: () => null)
                  .fillValueToAllFieldDropdown(fieldModel?.relationKey, result.id);
              await reportController.reportModel.value.fieldsModel
                  .firstWhere((element) => element.fieldType == FieldType.taps,
                  orElse: () => null)
                  .fillValueToAllFieldText(fieldModel?.relationKey, result.fabricationNumber);
            }
          } else {
           await rShowDialogOneButton('Có lỗi xảy ra vui lòng quét lại');
          }
       }
      },
      child: Container(
        height: 46,
        child: Container(
          padding: const EdgeInsets.only(top: 10, right: 8),
          child: const Icon(Icons.qr_code, size: 36,),
        ),
      ),
    ) : Container();
  }
}

