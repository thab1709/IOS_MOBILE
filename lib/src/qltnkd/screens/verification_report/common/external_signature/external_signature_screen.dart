// @dart=2.9
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/list_workload/signature/signature_pad_widget.dart';

class ExternalHandwrittenSignatureResult {
  final Uint8List signatureImageBytes;
  final String fullName;
  final String position;
  ExternalHandwrittenSignatureResult({this.signatureImageBytes, this.fullName, this.position});
}

class ExternalSignatureScreen extends StatefulWidget {
  const ExternalSignatureScreen({
    this.fullName,
    this.position,
    this.onAddSigner,
    Key key,
  }) : super(key: key);

  final String fullName;
  final String position;
  final VoidCallback onAddSigner;

  @override
  _ExternalSignatureScreenState createState() => _ExternalSignatureScreenState();
}

class _ExternalSignatureScreenState extends State<ExternalSignatureScreen> {
  final _signatureController = SignaturePadController();
  final _signatureKey = GlobalKey();
  
  TextEditingController _nameController;
  TextEditingController _positionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.fullName);
    _positionController = TextEditingController(text: widget.position);
  }

  @override
  void dispose() {
    _signatureController.dispose();
    _nameController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double contentWidth = width > 700 ? 640.0 : null;
    return Scaffold(
      backgroundColor: RAppColor.backgroundColorGray,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text(
          'Ký biên bản ĐV tư vấn',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: RAppColor.highlightColor70,
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Container(
              width: contentWidth,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vui lòng nhập họ tên và ký xác nhận',
                    style: TextStyle(fontSize: 14, color: RAppColor.inActiveColor),
                  ),
                  const SizedBox(height: 16),
                  _buildInputField('Họ và tên', _nameController),
                  const SizedBox(height: 12),
                  _buildInputField('Chức danh', _positionController),
                  const SizedBox(height: 18),
                  _buildSignatureTitle(),
                  const SizedBox(height: 8),
                  const Text(
                    'Ký trực tiếp vào khung bên dưới',
                    style: TextStyle(fontSize: 14, color: RAppColor.inActiveColor),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: width > 700 ? 280 : 220,
                    child: SignaturePadWidget(
                      controller: _signatureController,
                      repaintKey: _signatureKey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Chữ ký của bạn sẽ được dùng để xác nhận biên bản.',
                    style: TextStyle(fontSize: 13, color: RAppColor.inActiveColor),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: RButton(
                          title: 'Xóa ký',
                          maxSize: true,
                          color: Colors.white,
                          titleColor: RAppColor.highlightColor70,
                          borderColor: RAppColor.highlightColor70,
                          action: () {
                            _signatureController.clear();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RButton(
                          title: 'Xác nhận ký',
                          maxSize: true,
                          action: _confirmSignature,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'Thông tin của bạn được bảo mật',
                      style: TextStyle(fontSize: 12, color: RAppColor.inActiveColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildInputField(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            const Text(
              '*',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSignatureTitle() {
    return Row(
      children: const [
        Text(
          'Chữ ký',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          '*',
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      ],
    );
  }

  Future<void> _confirmSignature() async {
    if (_signatureController.isEmpty) {
      await rShowMyDialogOkCancel(
        'Vui lòng ký tên vào khung chữ ký',
        title: 'Thông báo',
        secondTitle: 'Đóng',
        secondFunction: () {},
      );
      return;
    }

    final bytes = await _exportSignature();
    if (bytes == null || bytes.isEmpty) {
      await rShowMyDialogOkCancel(
        'Không thể lưu ảnh chữ ký. Vui lòng ký lại',
        title: 'Thông báo',
        secondTitle: 'Đóng',
        secondFunction: () {},
      );
      return;
    }

    Get.back(result: ExternalHandwrittenSignatureResult(
      signatureImageBytes: bytes,
      fullName: _nameController.text,
      position: _positionController.text,
    ));
  }

  Future<Uint8List> _exportSignature() async {
    try {
      final boundary = _signatureKey.currentContext.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;
      return byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    } catch (_) {
      return null;
    }
  }
}
