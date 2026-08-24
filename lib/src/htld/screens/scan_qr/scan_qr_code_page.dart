// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrCodeScreen extends StatefulWidget {
  const ScanQrCodeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQrCodeScreenState();
}

class _ScanQrCodeScreenState extends State<ScanQrCodeScreen> {
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
              if (!snapshot.hasData) return Container();
              return IconButton(
                onPressed: () async {
                  await controller?.toggleFlash();
                },
                icon: Icon(
                  snapshot.data
                      ? Icons.flashlight_on_outlined
                      : Icons.flashlight_off_outlined,
                ),
              );
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
    final scanArea = (MediaQuery.of(context).size.width < 600 ||
            MediaQuery.of(context).size.height < 600)
        ? 250.0
        : 400.0;
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
    var isProcessing = false;
    controller.scannedDataStream.listen((scanData) {
      debugPrint(
          'haudau123 scanData: ${scanData.code} | isProcessing: $isProcessing');
      // setState(() {
      //   result = scanData;
      // });
      if (scanData.code != null && scanData.code.isNotEmpty && !isProcessing) {
        isProcessing = true;
        if (scanData.code.contains('http://')) {
          debugPrint('haudau123 scanData1: ${scanData.code}');
          final qrResultModel = scanData.code.replaceAll('http://', '');
          rShowMyDialogOkCancel('Mã thiết bị: $qrResultModel', firstAction: () {
            Get.back();
          }, secondFunction: () async {
            Get.back(result: qrResultModel);
          });
        } else {
          rShowMyDialogOkCancel('Text: ${scanData.code}', firstAction: () {
            Get.back();
          }, secondFunction: () async {
            Get.back(result: scanData.code);
          });
        }
      } else {}
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
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

