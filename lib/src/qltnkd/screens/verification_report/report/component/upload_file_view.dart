// @dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:evnmobile/src/app_common/networking/api_provider.dart';
import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class UploadFileView extends StatefulWidget {
  final FieldModel fieldModel;
  final bool enable;

  const UploadFileView({Key key, this.fieldModel, this.enable = true})
      : super(key: key);

  @override
  State<UploadFileView> createState() => _UploadFileViewState();
}

class _UploadFileViewState extends State<UploadFileView> {
  List<Map<String, dynamic>> _files = [];

  @override
  void initState() {
    super.initState();
    _parseInitialValue();
  }

  void _parseInitialValue() {
    final value = widget.fieldModel.value;
    if (value != null && value.isNotEmpty) {
      try {
        final parsed = jsonDecode(value);
        if (parsed is List) {
          _files = parsed.map((e) => e as Map<String, dynamic>).toList();
        }
      } catch (e) {
        debugPrint('Error parsing uploaded files: $e');
      }
    }
  }

  void _updateFieldValue() {
    if (_files.isEmpty) {
      widget.fieldModel.value = null;
    } else {
      widget.fieldModel.value = jsonEncode(_files);
    }
  }

  Future<void> _pickAndUploadFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'png', 'jpg', 'jpeg'],
      );

      if (result != null && result.files.isNotEmpty) {
        ProgressHUD.show();
        for (var pickedFile in result.files) {
          if (pickedFile.path == null) continue;
          File file = File(pickedFile.path);
          
          if (pickedFile.extension != null && ['png', 'jpg', 'jpeg'].contains(pickedFile.extension.toLowerCase())) {
            try {
              final properties = await FlutterNativeImage.getImageProperties(file.path);
              if (properties.width != null && properties.width > 800) {
                 file = await FlutterNativeImage.compressImage(
                     file.path,
                     quality: 85,
                     targetWidth: 800,
                     targetHeight: (properties.height * 800 / properties.width).round());
              }
            } catch (e) {
              debugPrint('Error compressing image: $e');
            }
          }
          
          // DO NOT upload file via API here anymore! Just store local path.
          setState(() {
            _files.add({
              'name': pickedFile.name,
              'url': '',
              'path': file.path,
              'isNew': true,
              'isLocal': true,
            });
          });
        }
        _updateFieldValue();
        ProgressHUD.dismiss();
      }
    } catch (e) {
      ProgressHUD.dismiss();
      debugPrint('Error pick and upload: $e');
      SnackBarHUD.show('Có lỗi xảy ra khi chọn file');
    }
  }

  void _removeFile(int index) {
    setState(() {
      _files.removeAt(index);
      _updateFieldValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.enable)
            OutlinedButton.icon(
              onPressed: _pickAndUploadFile,
              icon: const Icon(Icons.upload_file, size: 16, color: Colors.blueGrey),
              label: const Text('Chọn file', style: TextStyle(color: Colors.black87)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                side: BorderSide(color: Colors.grey.shade400, width: 1, style: BorderStyle.solid), // Mimic dashed if not available
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                backgroundColor: Colors.grey.shade50,
              ),
            ),
          if (_files.isNotEmpty) const SizedBox(height: 8),
          if (_files.isNotEmpty)
            ..._files.asMap().entries.map((entry) {
              int idx = entry.key;
              Map<String, dynamic> fileInfo = entry.value;
              String fileName = fileInfo['name'] ?? 'File đính kèm';
              String url = fileInfo['url'] ?? '';
              
              return Container(
                margin: const EdgeInsets.only(bottom: 6.0),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.insert_drive_file_outlined, size: 20, color: Colors.teal),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        fileName,
                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (url.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.cloud_download_outlined, size: 20, color: Colors.blueGrey),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          // Download logic if needed
                        },
                      ),
                    if (widget.enable) const SizedBox(width: 8),
                    if (widget.enable)
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: Colors.redAccent),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => _removeFile(idx),
                      ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}
