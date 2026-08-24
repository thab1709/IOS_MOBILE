// @dart=2.9
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_text_field.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/models/workload/workload_handwritten_signature.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'signature_pad_widget.dart';

class WorkloadSignaturePage extends StatefulWidget {
  const WorkloadSignaturePage({
    this.fullName,
    this.position,
    this.note,
    Key key,
  }) : super(key: key);

  final String fullName;
  final String position;
  final String note;

  @override
  _WorkloadSignaturePageState createState() => _WorkloadSignaturePageState();
}

class _WorkloadSignaturePageState extends State<WorkloadSignaturePage> {
  final _signatureController = SignaturePadController();
  final _signatureKey = GlobalKey();
  String _fullName;
  String _position;
  String _note;

  @override
  void initState() {
    super.initState();
    _fullName = widget.fullName ?? '';
    _position = widget.position ?? '';
    _note = widget.note ?? '';
  }

  @override
  void dispose() {
    _signatureController.dispose();
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
                  RTextField(
                    title: 'Họ và tên',
                    value: _fullName,
                    isRequire: true,
                    hintText: 'Nhập họ và tên',
                    onChange: (value) {
                      _fullName = value;
                    },
                  ),
                  const SizedBox(height: 12),
                  RTextField(
                    title: 'Chức danh',
                    value: _position,
                    isRequire: true,
                    hintText: 'Nhập chức danh',
                    onChange: (value) {
                      _position = value;
                    },
                  ),
                  // const SizedBox(height: 12),
                  // RTextField(
                  //   title: 'Ghi chú',
                  //   value: _note,
                  //   line: 3,
                  //   hintText: 'Nhập ghi chú nếu có',
                  //   onChange: (value) {
                  //     _note = value;
                  //   },
                  // ),
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

  Widget _buildSignatureTitle() {
    return Row(children: const [
      Text(
        'Chữ ký',
        style: TextStyle(fontSize: 16),
      ),
      Text(
        '*',
        style: TextStyle(fontSize: 16, color: Colors.red),
      ),
    ],);
  }

  Future<void> _confirmSignature() async {
    if ((_fullName ?? '').trim().isEmpty) {
      await rShowDialogOneButton('Vui lòng nhập họ và tên');
      return;
    }
    if ((_position ?? '').trim().isEmpty) {
      await rShowDialogOneButton('Vui lòng nhập chức danh');
      return;
    }
    if (_signatureController.isEmpty) {
      await rShowDialogOneButton('Vui lòng ký tên vào khung chữ ký');
      return;
    }

    final bytes = await _exportSignature();
    if (bytes == null || bytes.isEmpty) {
      await rShowDialogOneButton('Không thể lưu ảnh chữ ký. Vui lòng ký lại');
      return;
    }

    Get.back(result: WorkloadHandwrittenSignature(
      fullName: _fullName.trim(),
      position: _position.trim(),
      note: (_note ?? '').trim(),
      signatureImageBytes: bytes,
      signedAt: DateTime.now(),
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

