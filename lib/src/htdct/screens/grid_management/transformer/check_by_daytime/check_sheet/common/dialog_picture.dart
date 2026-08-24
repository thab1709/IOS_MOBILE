// @dart=2.9
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:evnmobile/src/app_common/utils/utils.dart';
import 'package:evnmobile/src/htdct/common/constance/image_path.dart';
import 'package:evnmobile/src/htdct/common/themes/styles.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/images/view_images_screen.dart';
import 'package:evnmobile/src/qltnkd/models/image_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../../app_common/edit_picture/add_text_screen.dart';
import '../../../../../../models/day_night/popups/images_model.dart';
import '../../../transformer_ticket_controller.dart';

class DialogPicture extends StatefulWidget {
  final List<Images> listImage;
  final Function removeImage;
  final Function addImage;
  final bool isGroup;
  final bool isLogbook;
  final bool showRemove;
  const DialogPicture(
      {Key key,
      this.listImage,
      this.removeImage,
      this.addImage,
      this.isGroup = false,
      this.isLogbook = false,
      this.showRemove=true})
      : super(key: key);

  @override
  State<DialogPicture> createState() => _DialogPictureState();
}

class _DialogPictureState extends State<DialogPicture> {
  List<Images> listImageCurrent = [];
  final TransformerTicketController transformerTicketController = Get.find();

  @override
  void initState() {
    super.initState();
    listImageCurrent = widget.listImage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 200),
      child: _buildPictureView(context),
    );
  }

  Widget _buildPictureView(BuildContext popupContext) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ảnh',
                  style: Styles.headerTitle,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(Icons.close, size: 30),
                )
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: listImageCurrent.length + 1,
              padding: const EdgeInsets.all(15),
              itemBuilder: (context, index) {
                if (index < listImageCurrent.length) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewImagesScreen(
                        galleryItems: listImageCurrent,
                        initialIndex: index,
                      )));
                      // Get.to(ViewImagesScreen(
                      //   galleryItems: listImageCurrent,
                      //   initialIndex: index,
                      // ));
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: listImageCurrent[index]?.url?.contains('http') == true
                                ? CachedNetworkImage(
                                    imageUrl:
                                        listImageCurrent[index]?.url ?? '',
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => Center(
                                      child: Container(
                                          height: 20,
                                          width: 20,
                                          child:
                                              const CircularProgressIndicator(
                                            strokeWidth: 3,
                                          )),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    height: double.infinity,
                                    width: double.infinity,
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        image: DecorationImage(
                                          image: Image.file(File(
                                                  listImageCurrent[index]?.url))
                                              .image,
                                          fit: BoxFit.fill,
                                        )),
                                  ),
                          ),
                        ),
                       if(transformerTicketController.isHasPermissionEdit() && widget.showRemove==true)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              widget.removeImage(listImageCurrent[index]);
                              setState(() {
                                if(!widget.isLogbook) {
                                  listImageCurrent.remove(listImageCurrent[index]);
                                }
                                if (listImageCurrent.isEmpty && widget.isGroup) {
                                  Get.back();
                                }
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.red,
                              ),
                              child: const Text('-',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                } else if (widget.isGroup == false &&
                    listImageCurrent.length != 10 &&
                    index == listImageCurrent.length && transformerTicketController.isHasPermissionEdit()) {
                  return GestureDetector(
                    onTap: () async {
                      final result = await openCamera(context);

                      if (result != null && result.isNotEmpty && result.first != null) {
                        final editImageResult = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditImageScreen(
                                      files: result,
                                    )));
                        if (editImageResult != null) {

                       final result = await widget.addImage(editImageResult);
                       if(result is List<ImageReport>){
                         result.forEach((element) {
                           listImageCurrent.add(Images(
                             imageStorageId: element.imageStorageId,
                             url: element.url,
                             problems: 0,
                           ));
                         });
                       }
                        setState(() {

                        });
                        }
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: DottedBorder(
                        padding: const EdgeInsets.all(0),
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 10],
                        color: Colors.grey,
                        strokeWidth: 2,
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SvgPicture.asset(
                            HighElectricImagePath.iconCamera,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

