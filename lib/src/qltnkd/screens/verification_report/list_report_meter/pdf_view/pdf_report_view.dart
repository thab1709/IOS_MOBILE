// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report_meter/pdf_view/pdf_view_meter_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';

class PdfMeterScreen extends StatefulWidget {
  const PdfMeterScreen({this.id, this.code, this.link});

  final String id;
  final String code;
  final String link;

  @override
  _PdfMeterScreenState createState() => _PdfMeterScreenState();
}

class _PdfMeterScreenState extends State<PdfMeterScreen> with AutomaticKeepAliveClientMixin<PdfMeterScreen> {
  final _controller = PdfMeterController();

  @override
  void initState() {
    super.initState();
      Future.delayed(const Duration(milliseconds: 100), () {
      if(widget.link != null) {
        _controller.showPDF(widget.link);
      } else {
        _controller.getPdf(widget.id);
      }});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: RAppColor.backgroundColorGray,
        appBar: widget.code != null ? AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: Text(
            widget.code ?? '',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: RAppColor.highlightColor70,
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Get.back();
            },
          ),
        ) : null,
        body: Obx(() {
          if(_controller.isSuccess.value && _controller.urlPdf != null) {
            return SfPdfViewer.network(
              _controller.urlPdf,
              headers: {'Authorization': 'Bearer ${AppShared.instance.getUserToken()}'},
            );
          } else {
            return Container();
          }
        })
    );
  }

  @override
  bool get wantKeepAlive => true;
}
