// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/field_infor_item.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../models/workload/request_model.dart';
import '../../common/constance_workload.dart';
import '../list_request_controller.dart';

class ItemRequest extends StatelessWidget {
  const ItemRequest(
      {@required this.model,
      @required this.isFirst,
      @required this.isLast,
      @required this.onCreate,
      Key key})
      : super(key: key);
  final RequestModel model;
  final bool isFirst;
  final bool isLast;
  final Function() onCreate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    return Row(
      children: [
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
          titleSecond: 'Loại yêu cầu',
          valueSecond: model.typeName,
        ),
        FieldInfoItem(
          titleFirst: 'Nội dung',
          valueFirst: model.content,
          titleSecond: 'Vị trí',
          valueSecond: model.location,
        ),
        FieldInfoItem(
          titleFirst: 'Trạng thái',
          valueFirst: model.statusName,
        ),
      ],
    );
  }

  Widget _buildBottom() {
    final listRequestController = Get.find<ListRequestController>();

    return Row(
      children: [
        if (model.status != RequestStatusCode.created &&
            listRequestController.userProfile
                .isHasPermissionCreateConfirmSheet())
          Expanded(
              child: RButton(
                  action: onCreate,
                  maxSize: true,
                  title: 'Tạo phiếu xác nhận')),
      ],
    );
  }
}

