// @dart=2.9
import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:evnmobile/src/app_common/utils/utils.dart';
import 'package:evnmobile/src/htdct/common/constance/image_path.dart';
import 'package:evnmobile/src/htdct/common/themes/styles.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/image_problem_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/transformer/check_by_daytime/check_sheet/common/check_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../../app_common/edit_picture/add_text_screen.dart';
import '../../../../../../common/constance/strings.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../../models/day_night/popups/images_model.dart';
import '../../../transformer_ticket_controller.dart';
import 'dialog_picture.dart';

class ExpansionWidget extends StatefulWidget {
  const ExpansionWidget(
      {@required this.children,
      @required this.title,
      this.isCamera = true,
      this.isHeader = false,
      this.addImage,
      this.invalid,
      this.allImage,
      this.isRequireImage = false,
      this.listImage,
      this.removeImage});

  final List<Widget> children;
  final List<Images> allImage;
  final String title;
  final bool isCamera;
  final bool isHeader;
  final Function addImage;
  final Function removeImage;
  final List<Images> listImage;
  final bool invalid;
  final bool isRequireImage;

  @override
  State<ExpansionWidget> createState() => _ExpansionWidgetState();
}

class _ExpansionWidgetState extends State<ExpansionWidget> {
  List<ImageProblem> listImageCurent;
  final TransformerTicketController transformerTicketController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.children.forEach((element) async {
      if (element is CheckWidget) {
        element.label = widget.title;
        element.allImage = widget.allImage;
      }
    });
    return ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
              initiallyExpanded: true,
              title: _buildTitle(context),
              children: widget.children),
        ));
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(widget.title,
              textAlign: TextAlign.left,
              style: widget.isHeader ? Styles.headerTitle : Styles.textNormal),
        ),
        if (widget.isCamera)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: widget.listImage.isNotEmpty,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DialogPicture(
                            listImage: widget.listImage,
                            removeImage: widget.removeImage,
                            addImage: widget.addImage,
                          );
                        });
                  },
                  child: badges.Badge(
                    badgeContent: Text(
                      widget.listImage != null
                          ? widget.listImage.length.toString()
                          : '0',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    child: SvgPicture.asset(
                      HighElectricImagePath.iconPicture,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              if (transformerTicketController.isHasPermissionEdit())
                const SizedBox(
                  width: 10,
                ),
              if (transformerTicketController.isHasPermissionEdit())
                IconButton(
                  icon: Icon(
                    Icons.add_a_photo_outlined,
                    color: widget.isRequireImage &&
                            widget.invalid &&
                            widget.listImage.isEmpty
                        ? Colors.red
                        : Colors.black,
                  ),
                  onPressed: () async {
                    if (widget.listImage.length == 10) {
                      await hShowDialogOneButton(
                          HighElectricStrings.overloadImagesLength);
                    } else {
                      final result = await showSelectMultiImageBottomSheet(
                          context,
                          10 -
                              (widget.listImage != null
                                  ? widget.listImage.length
                                  : 0),
                          imagesSelectedInPopup: widget?.allImage
                              ?.map((e) => e?.name ?? '')
                              ?.toList());
                      if (result != null && result is List<File> && result.isNotEmpty) {
                        final editImageResult = await Get.to(EditImageScreen(
                          files: result,
                        ));
                        if (editImageResult != null) {
                          widget.addImage(editImageResult);
                        }
                      }
                    }
                  },
                ),
            ],
          )
        else
          const SizedBox()
      ],
    );
  }
}

