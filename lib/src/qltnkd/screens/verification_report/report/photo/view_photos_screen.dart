// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/qltnkd/models/image_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
//import 'package:image_downloader/image_downloader.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewPhotosScreen extends StatefulWidget {
  ViewPhotosScreen({this.initialIndex = 0, this.galleryItems, Key key}) : super(key: key) {
    pageController = PageController(initialPage: initialIndex);
  }

  PageController pageController;
  final int initialIndex;
  final List<ImageReport> galleryItems;

  @override
  State<ViewPhotosScreen> createState() => _ViewPhotosScreenState();
}

class _ViewPhotosScreenState extends State<ViewPhotosScreen> {
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
            leading:  BackButton(
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
                imageProvider: NetworkImage(widget.galleryItems[index].url, headers: {
                  'Authorization': 'Bearer ${AppShared.instance.getUserToken()}'
                }),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes:
                PhotoViewHeroAttributes(tag: widget.galleryItems[index].imageStorageId),
              );
            },
            itemCount: widget.galleryItems.length,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes,
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

  // Future<void> _downloadImage(
  //     String url, {
  //       AndroidDestinationType destination,
  //       bool whenError = false,
  //       String outputMimeType,
  //     }) async {
  //   try {
  //     String imageId;
  //
  //     if (whenError) {
  //       imageId = await ImageDownloader.downloadImage(url,
  //           outputMimeType: outputMimeType)
  //           .catchError((error) {
  //         if (error is PlatformException) {
  //           rShowDialogOneButton(error.toString());
  //         }
  //
  //         debugPrint(error);
  //       }).timeout(const Duration(seconds: 10), onTimeout: () {
  //         debugPrint('timeout');
  //         return;
  //       });
  //     } else {
  //       if (destination == null) {
  //         imageId = await ImageDownloader.downloadImage(
  //           url,
  //           outputMimeType: outputMimeType,
  //         );
  //       } else {
  //         imageId = await ImageDownloader.downloadImage(
  //           url,
  //           destination: destination,
  //           outputMimeType: outputMimeType,
  //         );
  //       }
  //     }
  //
  //     if (imageId == null) {
  //       return;
  //     }
  //   } on PlatformException catch (error) {
  //     await rShowDialogOneButton(error.toString());
  //     return;
  //   }
  //
  //   if (!mounted) return;
  //   SnackBarHUD.show('Tải ảnh xuống thành công');
  // }
}

