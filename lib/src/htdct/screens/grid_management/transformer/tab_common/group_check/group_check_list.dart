// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/app_common/edit_picture/add_text_screen.dart';
import 'package:evnmobile/src/app_common/utils/utils.dart';
import 'package:evnmobile/src/htdct/common/constance/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../common/components/button_40.dart';
import '../../../../../common/constance/app_icon.dart';
import '../../../../../common/constance/strings.dart';
import '../../../../../common/utils/alert_dialog_utils.dart';
import '../../check_by_daytime/check_sheet/common/dialog_picture.dart';
import 'group_check_controller.dart';

class GroupCheckListView extends StatefulWidget {
  const GroupCheckListView();

  @override
  State<GroupCheckListView> createState() => _GroupCheckListViewState();
}

class _GroupCheckListViewState extends State<GroupCheckListView> with AutomaticKeepAliveClientMixin {
  final GroupCheckController _controller = GroupCheckController();

  Widget _buildRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: HighElectricAppColor.nature05),
        ),
        Text(
          value,
          style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: HighElectricAppColor.nature06),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: HighElectricAppColor.nature01,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                _controller.tbaGroupCheckModel.value.groups[index].name,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: HighElectricAppColor.nature06),
              )),
              Wrap(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  if (_controller
                      .tbaGroupCheckModel.value.groups[index].images.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return DialogPicture(
                                isGroup: true,
                                listImage: _controller.tbaGroupCheckModel.value
                                    .groups[index].images,
                                removeImage: (file) async {
                                  await _controller.removeImage(file, index);
                                },
                                addImage: (files) async {
                                  final result = await _controller.addImage(
                                      files,
                                      _controller.tbaGroupCheckModel.value
                                          .groups[index].idImage);

                                  return result;
                                },
                              );
                            });
                      },
                      child: Button40(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SvgPicture.asset(
                              HighElectricAppIcon.collections,
                              width: 18,
                              height: 20,
                              fit: BoxFit.scaleDown,
                            ),
                            Positioned(
                                top: 3,
                                right: 3,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: HighElectricAppColor.brandColor04,
                                    border: Border.all(
                                        color: HighElectricAppColor.nature01),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _controller.tbaGroupCheckModel.value
                                        .groups[index].images.length
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: HighElectricAppColor.nature01,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  if (_controller.transformerTicketController
                      .isHasPermissionEdit())
                    const SizedBox(
                      width: 16,
                    ),
                  if (_controller.transformerTicketController
                      .isHasPermissionEdit())
                    GestureDetector(
                      onTap: () async {
                        if (_controller.tbaGroupCheckModel.value.groups[index]
                                .images.length >=
                            10) {
                          await hShowDialogOneButton(
                              HighElectricStrings.overloadImagesLength);
                        } else {
                          final result = await openCamera(context);
                          if (result != null &&
                              result.first != null &&
                              result is List<File>) {
                            final editImageResult =
                                await Get.to(EditImageScreen(
                              files: result,
                            ));
                            if (editImageResult != null) {
                              await _controller.addImage(
                                  editImageResult,
                                  _controller.tbaGroupCheckModel.value
                                      .groups[index].idImage);
                            }
                          }
                        }
                      },
                      child: Button40(
                        child: SvgPicture.asset(
                          HighElectricAppIcon.camera,
                          width: 18,
                          height: 20,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          _buildRow('Chức danh',
              _controller.tbaGroupCheckModel.value.groups[index].position),
          const SizedBox(
            height: 10,
          ),
          _buildRow(
              'Bậc thợ',
              _controller.tbaGroupCheckModel.value.groups[index].level
                  .toString()),
          const SizedBox(
            height: 10,
          ),
          _buildRow('Bậc an toàn',
              _controller.tbaGroupCheckModel.value.groups[index].atLevel),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 200), _controller.getGroupCheck);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => Scaffold(
        backgroundColor: HighElectricAppColor.bgColor,
        body: _controller.tbaGroupCheckModel.value.groups != null
            ? ListView.builder(
                itemBuilder: _buildItem,
                itemCount: _controller.tbaGroupCheckModel.value.groups.length,
              )
            : Center(
                child: Container(
                  height: 40,
                  child: const Text(HighElectricStrings.emptyList),
                ),
              ),
      ),
    );
  }

  @override
 bool get wantKeepAlive => true;
}

