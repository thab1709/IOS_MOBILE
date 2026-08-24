// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/htld/models/attach_image_model.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewPhotoScreen extends StatelessWidget {
  final Images image;
  const ViewPhotoScreen({Key key, this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: PhotoView(
        imageProvider: image?.url?.isNotEmpty == true
            ? NetworkImage(image?.url ?? '',)
            : image?.path?.isNotEmpty == true
                ? Image.file(
                    File(image?.path ?? ''),
                    fit: BoxFit.fill,
                    height: double.infinity,
                    width: double.infinity,
                  )
                : Container(),
      ),
    );
  }
}
