// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/app_bar.dart';
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/field_infor_item.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/detail_report/detail_report_controller.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/detail_work/detail_work_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/pdf_view/pdf_view.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../report_approval_history/report_approval_history_screen.dart';

class DetailReportScreen extends StatefulWidget {
  final String reportId;

  const DetailReportScreen({this.reportId});

  @override
  State<StatefulWidget> createState() {
    return DetailReport();
  }
}

class DetailReport extends State<DetailReportScreen> {
  final _controller = DetailReportController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      _controller.getReportDetail(widget.reportId);
      _controller.getRoleOperationApprove();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RAppBar(
        title: RAppStrings.reportDetail,
      ),
      body: Obx(() => SafeArea(
        child: Column(
              children: [_buildBody(), _buildButton()],
            ),
      )),
    );
  }

  Widget _buildBody() {
    final report = _controller.listReportModel.value;
    return Expanded(
        child: SingleChildScrollView(
          child: Container(
      padding: const EdgeInsets.symmetric(horizontal: PaddingSize.normal),
      child: Column(
          children: [
            FieldInfoItem(
              titleFirst: RAppStrings.reportNumber,
              valueFirst: report?.reportNumber,
              titleSecond: RAppStrings.location,
              valueSecond: report?.location,
            ),
            FieldInfoItem(
              titleFirst: RAppStrings.reportType,
              valueFirst: report?.reportTypeName,
              titleSecond: RAppStrings.equipmentDetail,
              valueSecond: report?.equipmentDetail,
            ),
            FieldInfoItem(
              titleFirst: RAppStrings.performer,
              valueFirst: report?.userImp,
              titleSecond: RAppStrings.status,
              valueSecond: report?.workingStatusName,
            ),
            FieldInfoItem(
              titleFirst: RAppStrings.content,
              valueFirst: report?.content,
              titleSecond: RAppStrings.team,
              valueSecond: report?.team,
            ),
            FieldInfoItem(
              titleFirst: RAppStrings.initDate,
              valueFirst: report?.getCreateDate(),
              titleSecond: RAppStrings.titleSchedule,
              valueSecond: report?.workId == null
                  ? RAppStrings.scheduleNot
                  : RAppStrings.schedule,
            ),
            renderButton(
                title: RAppStrings.viewReport,
                action: () async {
                  await Get.to(() => ReportScreen(
                        reportType: _controller.listReportModel.value.reportType,
                        reportId: _controller.listReportModel.value.id,
                        userImpl: _controller.listReportModel.value.userImpId,
                        isMonitor: _controller.listReportModel.value.isMonitor ?? false,
                        isApprover: _controller.listReportModel.value.isApprover ?? false,
                      ));
                  await _controller.getReportDetail(widget.reportId);
                }),
            renderButton(
                title: RAppStrings.viewReportPDF,
                action: () async {
                  await Get.to(() => RPdfScreen(
                        id: report.id,
                        code: report.reportNumber,
                        isViewPDFUnscheduled: true,
                      ));
                }),
            renderButton(
                title: RAppStrings.approvalHistory,
                action: () async {
                  await Get.to(() => ReportApprovalHistoryScreen(
                        id: _controller.listReportModel.value.id,
                      ));
                }),
            if (_controller?.listReportModel?.value?.workId?.isNotEmpty == true)
            renderButton(
                title: RAppStrings.viewDetailWork,
                action: () async {
                  if (RUserRole.isWorkView) {
                    await Get.to(() => DetailWorkScreen(
                      workId: _controller.listReportModel.value.workId,
                    ));
                  } else {
                    await rShowDialogOneButton(RAppStrings.userNotPermission);
                  }
                }),
          ],
      ),
    ),
        ));
  }

  Widget renderButton({String title, Function action}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: PaddingSize.normal),
      child: RButton(
        title: title,
        maxSize: true,
        action: () {
          action();
        },
      ),
    );
  }

  Widget _buildButton() {
    // return Row(
    //   children: [
    //     if (_controller.isHasReject)
    //       Expanded(
    //         child: RButton(
    //             title: RAppStrings.actionReject,
    //             borderRadius: 0,
    //             color: RAppColor.colorOrange,
    //             action: (){
    //               _controller.actionReject();
    //             }),
    //       ),
    //     if (_controller.isHasApproval)
    //       Expanded(
    //         child: RButton(
    //             title: _controller.textBtn,
    //             borderRadius: 0,
    //             action: () {
    //               _controller.actionApproval();
    //             }),
    //       )
    //   ],
    // );
    return Container();
  }
}

