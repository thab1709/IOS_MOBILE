// @dart=2.9
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:evnmobile/src/app_common/edit_picture/add_text_screen.dart';
import 'package:evnmobile/src/app_common/utils/utils.dart';
import 'package:evnmobile/src/htdct/common/components/photo/report_photo_controller.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:evnmobile/src/qltnkd/models/image_report.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/alert_dialog_utils.dart';
import 'view_photos_screen.dart';

class ReportPhotoScreen extends StatefulWidget {
  const ReportPhotoScreen({@required this.fieldModel, this.isEnable = true, Key key})
      : super(key: key);

  final FieldModel fieldModel;
  final bool isEnable;

  @override
  _ReportPhotoScreenState createState() => _ReportPhotoScreenState();
}

class _ReportPhotoScreenState extends State<ReportPhotoScreen> {
  final _controller = ReportPhotoController();

  @override
  void initState() {
    super.initState();
    _controller.fieldModel = widget.fieldModel;
    Future.delayed(const Duration(milliseconds: 100), _controller.getImageByIDs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách hình ảnh'),
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(() => GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: Get.size.width >= 600 ? 3 : 2,
              children: _controller.images.map(_buildItemImage).toList(),
            )),
      ),
      floatingActionButton: widget.isEnable ? FloatingActionButton(
        onPressed: () async {
          if (_controller.images.length >= 10) {
            await hShowDialogOneButton('Bạn chỉ có thể lưu tối đa 10 ảnh');
            return;
          }
          final result = await showSelectMultiImageBottomSheet(context, 10 - _controller.fieldModel.getArrValue().length);
          if (result != null && result is List<File> && result.isNotEmpty) {
            final editImageResult = await Get.to(EditImageScreen(files: result,));
            if(editImageResult != null) {
              await _controller.uploadImage(editImageResult);
            }
          }
        },
        child: const Icon(Icons.add_a_photo),
      ) : null,
    );
  }

  Widget _buildItemImage(ImageReport item) {
    return InkWell(
      onTap: () {
        Get.to(() => ViewPhotosScreen(initialIndex: _controller.images.indexOf(item), galleryItems: _controller.images,));
      },
      child: Container(
          margin: const EdgeInsets.only(right: 10),
          height: Get.size.width >= 600 ? 100 : 46,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade100, style: BorderStyle.solid)),
                margin: const EdgeInsets.only(top: 12, right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: item.url?.isNotEmpty == true
                      ? CachedNetworkImage(
                          imageUrl: item?.url ?? '',
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Container(
                              padding: const EdgeInsets.all(10),
                              child: const CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          height: double.infinity,
                          width: double.infinity,
                        )
                      : item?.path?.isNotEmpty == true
                          ? Image.file(
                              File(item?.path ?? ''),
                              fit: BoxFit.fill,
                              height: double.infinity,
                              width: double.infinity,
                            )
                          : Container(),
                ),
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () async {
                      if (widget.isEnable) {
                        await rShowMyDialogOkCancel(
                          'Bạn có chắc muốn xóa ảnh này không?',
                          secondFunction: () {
                            _controller.remove(item);
                          },
                        );
                      }
                    },
                    child: (widget.isEnable)
                        ? const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          )
                        : Container(),
                  ))
            ],
          )),
    );
  }
}

