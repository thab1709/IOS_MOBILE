// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/app_bar.dart';
import 'package:evnmobile/src/qltnkd/common/components/field_infor_item.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/models/report_work.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/detail_work/detail_work_controller.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_work/work_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../work_by_transformer/work_by_transformer_controller.dart';

class DetailWorkScreen extends StatefulWidget {
  const DetailWorkScreen({this.workId, this.itemWork, this.isForX = false});

  final String workId;
  final ReportWorkItem itemWork;
  final bool isForX;

  @override
  State<StatefulWidget> createState() {
    return DetailReport();
  }
}

class DetailReport extends State<DetailWorkScreen> {
  final WorkByTransformerController workReportController = Get.find();
  final detailWorkController = DetailWorkController();

  @override
  void initState() {
    super.initState();
    if (widget.itemWork != null) {
      detailWorkController.reportWorkItem.value = widget.itemWork;
    }
    if (!widget.isForX) {
      Future.delayed(const Duration(microseconds: 100), () {
        detailWorkController.getReportDetail(widget.workId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RAppBar(
        title: 'Chi tiết công việc',
      ),
      body: SingleChildScrollView(
        child: Obx(() => Column(
              children: [_buildBody()],
            )),
      ),
    );
  }

  Widget _buildBody() {
    final itemWork = detailWorkController.reportWorkItem.value;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: PaddingSize.normal),
      child: Column(
        children: [
          FieldInfoItem(
            titleFirst: RAppStrings.location,
            valueFirst: itemWork?.location,
            titleSecond: 'Người thực hiện',
            valueSecond: itemWork?.getListNameUserImp(),
          ),
          FieldInfoItem(
            titleFirst: 'Thời gian',
            valueFirst: itemWork?.getTime(),
            titleSecond: 'Ngày',
            valueSecond: itemWork?.getDate(),
          ),
          FieldInfoItem(
            titleFirst: 'Thiết bị',
            valueFirst: itemWork?.equipmentName,
            titleSecond: 'Trạng thái',
            valueSecond: itemWork?.workProgressName,
          ),
          FieldInfoItem(
            titleFirst: 'Loại công việc',
            valueFirst: itemWork?.workType ?? '',
          ),
        ],
      ),
    );
  }
}

