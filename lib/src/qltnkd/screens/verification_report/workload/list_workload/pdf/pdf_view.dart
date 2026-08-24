// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/list_workload/pdf/pdf_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zoom_widget/zoom_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';

class PDFWorkloadScreen extends StatefulWidget {
  const PDFWorkloadScreen({this.id, this.code, this.consultantsImage});

  final String id;
  final String code;
  final String consultantsImage;

  @override
  _PDFWorkloadScreenState createState() => _PDFWorkloadScreenState();
}

class _PDFWorkloadScreenState extends State<PDFWorkloadScreen> {
  final _controller = PDFWorkloadController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.getPdf(widget.id, consultantsImage: widget.consultantsImage);
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
          actions: [
            IconButton(onPressed: () async {
             await Share.share(_controller.urlPdf, subject: 'Chia sẻ pdf');
            }, icon: const Icon(Icons.share))
          ],
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

  Widget _buildPdfPage(String path, int index) {
    return Image.file(File(path));
  }
}

