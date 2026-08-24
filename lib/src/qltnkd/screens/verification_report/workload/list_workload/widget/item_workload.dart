// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/field_infor_item.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/list_workload/pdf/pdf_view.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/list_workload/signature/signature_image_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../models/workload/workload_model.dart';
import '../../common/constance_workload.dart';
import '../list_workload_controller.dart';

class ItemWorkload extends StatelessWidget {
  const ItemWorkload(
      {@required this.model,
      @required this.isFirst,
      @required this.isLast,
      @required this.onGoToDetail,
      @required this.onSend,
      @required this.onDelete,
      @required this.onSelect,
      @required this.onSign,
      this.isShowCheckBox = false,
      Key key})
      : super(key: key);
  final WorkloadModel model;
  final bool isFirst;
  final bool isLast;
  final Function() onGoToDetail;
  final Function() onDelete;
  final Function() onSend;
  final Function() onSign;
  final bool isShowCheckBox;
  final Function(String, bool) onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onGoToDetail,
      child: Container(
        margin: EdgeInsets.only(top: isFirst ? 20 : 0, bottom: isLast ? 30 : 0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        color: Colors.white,
        child: Column(
          children: [
            _buildHeader(),
            _buildBody(),
            const SizedBox(
              height: 16,
            ),
            _buildBottom()
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final controller = Get.find<ListWorkloadController>();
    return Row(
      children: [
        if (isShowCheckBox)
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: model.isSelected ?? false,
              activeColor: RAppColor.highlightColor70,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              onChanged: (value) {
                onSelect(model.id, value);
              },
            ),
          ),
        Expanded(
          child: Text(
            'Số phiếu: ${model.code}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: RAppColor.highlightColor70,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
        if ((model.status == WorkloadStatusCode.newWork ||
                model.status == WorkloadStatusCode.reject) &&
            controller.userProfile.isHasPermissionDeleteConfirmSheet())
          IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ))
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(
          thickness: 1,
          height: 30,
        ),
        FieldInfoItem(
          titleFirst: 'Đơn vị yêu cầu',
          valueFirst: model.unitName,
          titleSecond: 'Người thực hiện',
          valueSecond: model.createdByName,
        ),
        FieldInfoItem(
          titleFirst: 'Loại phiếu yêu cầu',
          valueFirst: model.requestType,
          titleSecond: 'Ngày thực hiện',
          valueSecond: model.date?.fromFormatUtcToFormatLocal(RAppStrings.ddMMyyyy),
        ),
        FieldInfoItem(
          titleFirst: 'Trạng thái',
          valueFirst: model.statusName,
          titleSecond: 'Ngày xác nhận',
          valueSecond: model?.confirmedDate
              ?.fromFormatUtcToFormatLocal(RAppStrings.ddmmyyyyHHmm),
        ),
        if (model?.signDate?.isNotNullOrEmpty() == true)
          FieldInfoItem(
            titleFirst: 'Mã yêu cầu',
            valueFirst: model.requestCode,
            titleSecond: 'Ngày ký',
            valueSecond: model.signDate
                ?.fromFormatUtcToFormatLocal(RAppStrings.ddmmyyyyHHmm),
          ),
        if (model?.signDate == null || model.signDate.isEmpty)
          FieldInfoItem(
            titleFirst: 'Mã yêu cầu',
            valueFirst: model.requestCode,
          ),
        if (SignatureImageHelper.isValidConsultantsImage(model?.consultantsImage))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Đơn vị tư vấn', style: TextStyle(color: Colors.grey, fontSize: 15)),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Text('Đã ký', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildBottom() {
    final controller = Get.find<ListWorkloadController>();
    final canSend = (model.status == WorkloadStatusCode.newWork ||
            model.status == WorkloadStatusCode.reject) &&
        model.isAllowSend == true &&
        controller.userProfile.isHasPermissionSendConfirmSheet();
    final canShowHandwrittenSign =
        _isAllowedHandwrittenStatus(model.status) && !_isSigned();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          if (canSend) ...[
            Expanded(
              child: RButton(action: onSend, maxSize: true, title: 'Gửi xác nhận'),
            ),
            const SizedBox(width: 12),
          ],
          if (canShowHandwrittenSign) ...[
            Expanded(
              child: RButton(
                action: onSign,
                maxSize: true,
                title: 'Ký tay',
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: RButton(
              action: () {
                Get.to(() => PDFWorkloadScreen(
                      id: model.id,
                      code: model.code,
                    ));
              },
              maxSize: true,
              title: 'Xem PDF',
            ),
          ),
        ],
      ),
    );
  }

  bool _isAllowedHandwrittenStatus(int status) {
    return status == WorkloadStatusCode.newWork ||
        status == WorkloadStatusCode.waitConfirm ||
        status == WorkloadStatusCode.reject;
  }

  bool _isSigned() {
    return model?.signDate?.isNotNullOrEmpty() == true ||
        SignatureImageHelper.isValidConsultantsImage(model?.consultantsImage);
  }
}

