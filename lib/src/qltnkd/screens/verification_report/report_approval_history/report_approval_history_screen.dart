// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/app_bar.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report_approval_history/report_approval_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportApprovalHistoryScreen extends StatefulWidget {
  const ReportApprovalHistoryScreen({this.id});

  final String id;

  @override
  State<StatefulWidget> createState() {
    return HistoryReportApproveState();
  }
}

class HistoryReportApproveState extends State<ReportApprovalHistoryScreen> {
  final _controller = ReportApprovalHistoryController();

  @override
  void initState() {
    super.initState();
    _controller.getApprovalHistory(formReportId: widget.id);
  }

  Widget _buildList() {
    return Container(
        height: Get.height,
        child: ListView.separated(
            itemCount: _controller.approvalHistory.length,
            itemBuilder: (context, index) {
              final approvalHistory = _controller.approvalHistory[index];
              return ListTile(
                leading: const Icon(Icons.history),
                subtitle: Text(
                  'Ghi chú: ${approvalHistory.note ?? ''}',
                  style: const TextStyle(color: RAppColor.highlightColor70, fontSize: 16),
                ),
                title: Text(
                  '${approvalHistory.type} bởi ${approvalHistory.username} vào lúc ${approvalHistory.createdDate.fromFormatUtcToFormatLocal(RAppStrings.hhmmddMMyyyy)} ',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
              );
            },
          separatorBuilder: (context, index) {
            return Container(
              height: 1,
              color: Colors.grey.shade300,
              margin: const EdgeInsets.symmetric(horizontal: 16),
            );
        },));
  }

  Widget _buildBody() {
    return Container(
      child: _controller?.approvalHistory?.isEmpty == true
          ? const Center(
              child: Text(
                RAppStrings.emptyData,
                style: TextStyle(fontSize: 20),
              ),
            )
          : _buildList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const RAppBar(
          title: 'Lịch sử phê duyệt',
        ),
        body: Obx(_buildBody));
  }
}

