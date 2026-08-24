// @dart=2.9
import 'package:flutter/material.dart';

import '../../../../common/components/r_text_field.dart';
import '../../../../models/work_merge_model.dart';

class DetailWork extends StatelessWidget {
  const DetailWork({@required this.model, Key key}) : super(key: key);
  final WorkMergeModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết công việc'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              RTextField(
                title: 'Tên thiết bị',
                isEnable: false,
                margin: const EdgeInsets.only(top: 20),
                value: model.equipmentName,
              ),
              RTextField(
                title: 'Loại thiết bị',
                isEnable: false,
                margin: const EdgeInsets.only(top: 20),
                value: model.equipmentTypeName,
              ),
              RTextField(
                title: 'Mã thiết bị',
                isEnable: false,
                margin: const EdgeInsets.only(top: 20),
                value: model.equipmentCode,
              ),
              RTextField(
                title: 'Chi tiết thiết bị',
                isEnable: false,
                margin: const EdgeInsets.only(top: 20),
                value: model.equipmentDetailName,
              ),
              RTextField(
                title: 'Ngày tạo',
                isEnable: false,
                margin: const EdgeInsets.only(top: 20),
                value: model.getDate(),
              ),
              RTextField(
                title: 'Số phiếu yêu cầu',
                isEnable: false,
                margin: const EdgeInsets.only(top: 20),
                value: model.requestCode,
              ),
              RTextField(
                title: 'Người thực hiện',
                isEnable: false,
                margin: const EdgeInsets.only(top: 20),
                value: model.getListNameUser(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

