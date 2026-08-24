// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/htdct/models/day_night/popups/images_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewImagesScreen extends StatefulWidget {
  ViewImagesScreen({this.initialIndex = 0, this.galleryItems, Key key})
      : super(key: key) {
    pageController = PageController(initialPage: initialIndex);
  }

  PageController pageController;
  final int initialIndex;
  final List<Images> galleryItems;

  @override
  State<ViewImagesScreen> createState() => _ViewImagesScreenState();
}

class _ViewImagesScreenState extends State<ViewImagesScreen> {
  int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black.withAlpha(20),
            // actions: [
            //   IconButton(
            //     icon: const Icon(Icons.download_rounded),
            //     onPressed: () {
            //       _downloadImage(widget.galleryItems[currentIndex].url);
            //     },
            //   )
            // ],
            leading: BackButton(
              color: Colors.white,
              onPressed: () {
                Get.back();
              },
            ),
          ),
          body: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider:
                    widget.galleryItems[index].url?.contains('http') == true
                        ? NetworkImage(widget.galleryItems[index].url)
                        : FileImage(File(widget.galleryItems[index].url)),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes: PhotoViewHeroAttributes(
                    tag: widget.galleryItems[index].imageStorageId),
              );
            },
            itemCount: widget.galleryItems.length,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                ),
              ),
            ),
            //backgroundDecoration: widget.backgroundDecoration,
            pageController: widget.pageController,
            onPageChanged: onPageChanged,
          ),
        ),
      ],
    );
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}

