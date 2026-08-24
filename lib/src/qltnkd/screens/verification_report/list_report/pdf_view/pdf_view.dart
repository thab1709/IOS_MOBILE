// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/pdf_view/r_pdf_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class RPdfScreen extends StatefulWidget {
  const RPdfScreen({this.id, this.code, this.link, this.isMonitor = false, this.isViewPDFUnscheduled = false, this.isCbm = false});

  final String id;
  final String code;
  final String link;
  final bool isMonitor;
  final bool isViewPDFUnscheduled;
  final bool isCbm;

  @override
  _RPdfScreenState createState() => _RPdfScreenState();
}

class _RPdfScreenState extends State<RPdfScreen> with AutomaticKeepAliveClientMixin<RPdfScreen> {
  final _controller = RPdfController();

  @override
  void initState() {
    super.initState();
      _controller.isMonitor = widget.isMonitor;
      _controller.isViewPDFUnscheduled = widget.isViewPDFUnscheduled;
      Future.delayed(const Duration(milliseconds: 100), () {
      if(widget.link != null) {
        _controller.showPDF(widget.link);
      } else {
        _controller.getPdf(widget.id, isCbm: widget.isCbm);
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
            if (GetPlatform.isAndroid && _controller.parts != null && _controller.parts.isNotEmpty) {
              return InteractiveViewer(
                minScale: 1.0,
                maxScale: 5.0,
                child: ListView.builder(
                  itemCount: _controller.parts.length,
                  itemBuilder: (context, index) {
                    return Image.file(File(_controller.parts[index]));
                  },
                ),
              );
            }
            return SfPdfViewer.network(
              _controller.urlPdf,
              headers: {'Authorization': 'Bearer ${AppShared.instance.getUserToken()}'},
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        })
    );
  }

  @override
  bool get wantKeepAlive => true;
}
