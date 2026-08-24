// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/components/item_driver.dart';
import '../work_by_transformer_controller.dart';
import '../../../../common/components/item_work.dart';
import '../../../../common/constance/r_user_role_type.dart';
import '../../../../models/report_work.dart';
import '../../../../models/work_by_transformer_model.dart';

class ItemWorkByTransformer extends StatelessWidget {
  const ItemWorkByTransformer(
      {@required this.model,
      this.index,
      this.onReloadData,
      this.onCreateReport,
      this.callbackChangePaperReport,
      Key key})
      : super(key: key);

  final WorkByTransformerModel model;
  final int index;
  final Function onReloadData;
  final Function(ReportWorkItem) onCreateReport;
  final Function(ReportWorkItem) callbackChangePaperReport;

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      tileColor: Colors.grey.shade300,
      style: ListTileStyle.list,
      child: ExpansionTile(
        backgroundColor: Colors.grey.shade200,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          title: ListTile(
            title: Text(
              model?.transformerName ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        onExpansionChanged: (value) {},
        children: [
          ...model.mergeModels.mapIndexed((work, index) {
            return RUserRole.isDriver
                ? ItemDriver(
                    reportWorkItem: work,
                    index: index,
                    isLast: index == model.mergeModels.length - 1,
                  )
                : ItemWork(
                    reportWorkItem: work,
                    index: index,
                    isLast: index == model.mergeModels.length - 1,
                    isForX: Get.find<WorkByTransformerController>().workGroupType.value == 1,
                    callbackLoadData: onReloadData,
                    callbackChangePaperReport: () {
                      callbackChangePaperReport(work);
                    },
                    callbackCreateReport: () {
                      onCreateReport(work);
                    },
                  );
          }).toList()
        ],
      ),
    );
  }
}

