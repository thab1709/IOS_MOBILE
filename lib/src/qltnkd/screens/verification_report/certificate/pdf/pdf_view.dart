// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/certificate/pdf/pdf_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zoom_widget/zoom_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';

class RPdfCertificateScreen extends StatefulWidget {
  const RPdfCertificateScreen({this.id, this.code, this.link});

  final String id;
  final String code;
  final String link;

  @override
  _RPdfCertificateScreenState createState() => _RPdfCertificateScreenState();
}

class _RPdfCertificateScreenState extends State<RPdfCertificateScreen> {
  final _controller = RPdfCertificateController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if(widget.link != null) {
        _controller.showPdf(widget.link);
      } else {
        _controller.getPdf(widget.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: RAppColor.backgroundColorGray,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: Text(
            widget.code ?? '',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: RAppColor.highlightColor70,
          leading: const BackButton(
            color: Colors.white,
          ),
        ),
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
}

