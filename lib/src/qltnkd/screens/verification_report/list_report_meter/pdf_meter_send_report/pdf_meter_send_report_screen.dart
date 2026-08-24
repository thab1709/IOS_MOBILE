// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/pdf_view/pdf_view.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report_meter/pdf_meter_send_report/pdf_meter_send_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../models/report_meter_model.dart';

class PDFMeterSendReportScreen extends StatefulWidget {
  const PDFMeterSendReportScreen(
      {@required this.workMergeModel, @required this.statusReport, Key key})
      : super(key: key);
  final ReportMeterModel workMergeModel;
  final String statusReport;

  @override
  _PDFMeterSendReportScreenState createState() =>
      _PDFMeterSendReportScreenState();
}

class _PDFMeterSendReportScreenState extends State<PDFMeterSendReportScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final _controller = PDFMeterSendReportController();

  @override
  void initState() {
    _controller.statusReport = widget.statusReport;
    _controller.workMergeModel = widget.workMergeModel;
    _controller.renderTextBtn();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // await _controller.getMergeReportPDF(widget.workMergeModel.id, () {
      //   _tabController = TabController(
      //       length: _controller.mergeReportPDFs.length, vsync: this);
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
          length: _controller.mergeReportPDFs.length,
          child: Scaffold(
            backgroundColor: RAppColor.backgroundColorGray,
            appBar: AppBar(
              backgroundColor: RAppColor.highlightColor70,
              elevation: 1,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              centerTitle: false,
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                tabs: _controller.mergeReportPDFs
                    .map<Tab>((optionModel) => Tab(
                          text: optionModel.reportNumber,
                        ))
                    .toList(),
              ),
              title: const Text(
                'Duyệt biên bản',
                style: TextStyle(fontSize: TextSize.normal),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: buildListTab(),
                    ),
                  ),
                  Row(
                    children: [
                      if (_controller.isHasReject)
                        Expanded(
                          child: RButton(
                              title: 'Từ chối',
                              borderRadius: 0,
                              color: RAppColor.colorOrange,
                              action: _controller.actionReject),
                        ),
                      if (_controller.isHasApproval)
                        Expanded(
                          child: RButton(
                              title: _controller.textBtn,
                              borderRadius: 0,
                              action: _controller.actionApproval),
                        )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  List<Widget> buildListTab() {
    final list = _controller.mergeReportPDFs
        .map<Widget>((pdfModel) => RPdfScreen(
              link: pdfModel.url,
            ))
        .toList();
    return list;
  }
}

