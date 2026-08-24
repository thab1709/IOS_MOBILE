// @dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/models/qr_code_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét mã QR'),
        actions: [
          FutureBuilder(
            future: controller?.getFlashStatus(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) return Container();
            return  IconButton(onPressed: () async {
              await controller?.toggleFlash();
              }, icon: Icon(
              snapshot.data ?  Icons.flashlight_on_outlined :  Icons.flashlight_off_outlined,
              ),);
            },
          )

        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    final scanArea =
        (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400)
            ? 150.0
            : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      this.controller.pauseCamera();
      this.controller.resumeCamera();
    });
    var isProssessing = false;
    controller.scannedDataStream.listen((scanData) {
      // setState(() {
      //   result = scanData;
      // });
      if (scanData.code is String && !isProssessing) {
        isProssessing = true;
        try {
          final qrResultModel = QRResultModel.fromJson(jsonDecode(scanData.code));
          if (qrResultModel != null) {
            if(qrResultModel.equipmentStatus == 1){
              Get.back(result: qrResultModel);
            } else {

              rShowMyDialogOkCancel(
                  '${qrResultModel?.equipmentName != null ? 'Hiện tại thiết bị ${qrResultModel?.equipmentName ?? ''}' : ''}  - ${qrResultModel.fabricationNumber} đang có tình trạng ${qrResultModel.equipmentStatus.getStatus()}. Bạn có muốn chọn thiết bị này không?',
                  firstAction: () {
                    Get.back();
                  },
                  secondFunction: () async {
                    Get.back(result: qrResultModel);
                  });
            }
          } else {
            isProssessing = false;
            rShowDialogOneButton('Có lỗi xảy ra vui lòng quét lại');
          }
        } catch (_) {
          rShowDialogOneButton('Có lỗi xảy ra vui lòng quét lại');
          isProssessing = false;
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    //log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có quyền')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

