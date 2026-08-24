// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/models/qr_report_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scan/scan.dart';

class ScanQRReportScreen extends StatefulWidget {
  const ScanQRReportScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQRReportScreenState();
}

class _ScanQRReportScreenState extends State<ScanQRReportScreen> {
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR_REPORT');
  bool isProcessing = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét mã QR Biên Bản'),
        actions: [
          FutureBuilder(
            future: controller?.getFlashStatus(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              return IconButton(
                onPressed: () async {
                  await controller?.toggleFlash();
                  setState(() {}); // trigger rebuild to update icon
                },
                icon: Icon(
                  snapshot.data == true
                      ? Icons.flashlight_on_outlined
                      : Icons.flashlight_off_outlined,
                ),
              );
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(child: _buildQrView(context)),
          // Logo EVN đặt phía trên khung quét QR
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1, // Cách trên 10% chiều cao màn hình
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8), // Nền mờ để làm nổi bật logo trên nền camera
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  'assets/images/evn_logo_full.png', // Logo đầy đủ thường chứa chữ EVN Hà Nội
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // Icon Tải ảnh lên đặt phía dưới khung quét QR
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15, // Cách dưới 15% chiều cao màn hình
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _pickImageAndScan,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.photo_library,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tải ảnh lên',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    final scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
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
    });
    
    // Đảm bảo camera được khởi động lại đúng cách
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();

    controller.scannedDataStream.listen((scanData) {
      if (scanData.code is String && scanData.code.isNotEmpty && !isProcessing) {
        isProcessing = true;
        _handleScanResult(scanData.code);
      }
    });
  }

  void _handleScanResult(String code) {
    try {
      final qrResult = QRReportResult.fromCode(code);

      if (qrResult?.searchValue != null && qrResult.searchValue.isNotEmpty) {
        Get.back(result: qrResult);
      } else {
        _showError('Không tìm thấy thông tin biên bản trong mã QR này.');
        isProcessing = false;
      }
    } catch (e) {
      _showError('Mã QR không hợp lệ. Vui lòng quét lại.');
      isProcessing = false;
    }
  }

  Future<void> _pickImageAndScan() async {
    if (isProcessing) return;
    try {
      isProcessing = true;
      final ImagePicker picker = ImagePicker();
      final XFile image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        final result = await Scan.parse(image.path);
        if (result != null && result.isNotEmpty) {
          _handleScanResult(result);
        } else {
          _showError('Không tìm thấy mã QR nào trong ảnh này.');
          isProcessing = false;
        }
      } else {
        isProcessing = false; // Người dùng hủy chọn ảnh
      }
    } catch (e) {
      _showError('Đã xảy ra lỗi khi chọn ảnh: ${e.toString()}');
      isProcessing = false;
    }
  }

  void _showError(String message) {
    rShowDialogOneButton(message, action: () {
      // Reset trạng thái để quét lại
      isProcessing = false;
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng cấp quyền sử dụng Camera')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

