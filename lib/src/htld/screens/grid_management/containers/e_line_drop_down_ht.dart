// @dart=2.9
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/src/app_common/utils/utils.dart';
import 'package:evnmobile/src/htld/common/base/base_delegate.dart';
import 'package:evnmobile/src/htld/common/constance/line_content_option.dart';
import 'package:evnmobile/src/htld/common/constance/user_role_type.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/constance.dart';
import 'package:evnmobile/src/htld/models/equipment_model.dart';
import 'package:evnmobile/src/htld/models/problem_positions_model.dart';
import 'package:evnmobile/src/htld/models/weirdo_message.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_line_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/view_photo.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/line_ticket_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../app_common/shared/app_shared.dart';
import '../../../models/attach_image_model.dart';
import '../../../models/option_model.dart';
import '../../../services/responsitory/upload_service.dart';

class ELineDropDownHT extends StatelessWidget implements LineDropDownDelegate {
  ELineDropDownHT(this.options,
      {this.title,
      this.index,
      this.isUndergroundCable = false,
      this.weight = FontWeight.w500,
      this.paddingHorizontal,
      this.onDataChange,
      this.onAttachImages,
      this.defaultValue,
      this.images,
      this.problemPositions,
      this.equipmentModel,
      this.enable = true,
      this.isShowAbnormal = false,
      this.isSelectArea = false,
      this.onSelectedAbnormalOption,
      this.onNoteChanged,
      this.disableImage,
      Key key})
      : super(key: key);

  final EDropDownController controller = EDropDownController();

  final int index;
  final int defaultValue;
  final bool isUndergroundCable;
  final bool isShowAbnormal;
  final bool enable;
  final String title;
  final FontWeight weight;
  final List<OptionModel> options;
  final bool disableImage;
  final List<Images> images;
  final double paddingHorizontal;
  final Function(OptionData, int, LineWeirdoMessage, List<OptionData>, bool)
      onDataChange;

  final Function(List<Images>, int) onAttachImages;
  final List<ProblemPositions> problemPositions;
  final List<EquipmentModel> equipmentModel;
  final defaultEnable = UserRole.hasPermissionCreate();
  final LineTicketController lineTicketController = Get.find();

  final bool isSelectArea;

  final Function(String, String, int, int) onSelectedAbnormalOption;
  final Function(String) onNoteChanged;

  void setupData() {
    controller.title = title;
    controller.delegate = this;
    controller.options = options;
    controller.problemPositions = problemPositions;

    controller.images =
        images?.where((element) => element.problems == index)?.toList()?.obs ??
            <Images>[].obs;
    controller.defaultValue = defaultValue;
    controller.selectedValue.value = defaultValue;
    Future.delayed(const Duration(milliseconds: 500), () async {
      await controller.getDataLine(equipmentModel);
      OptionModel option;
      if (controller.problemPositions?.isNotEmpty == true) {
        controller.selectedValue.value =
            controller.problemPositions?.first?.problemValue;
        option = options.firstWhere(
            (element) =>
                element.value ==
                controller.problemPositions?.first?.problemValue,
            orElse: () => null);
      }

      if (controller.selectedValue.value != null) {
        controller.setValue(controller.selectedValue.value);

        final isNormal =
            options.first.value == controller.selectedValue.value ||
                LineContentOption.na == controller.selectedValue.value;
        final message = LineWeirdoMessage(index,
            message: isNormal ? '' : '$title ${option?.title}',
            optionValue: option?.value,
            option: option?.title,
            problem: title);
        controller.lineWeirdoMessage = message;
        if (onDataChange != null) {
          onDataChange(controller.optionDataSelected.value, index, message,
              controller.listOptionData, !isNormal);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setupData();
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: 8, horizontal: paddingHorizontal ?? 0),
      child: Wrap(
        children: [
          _buildPhone(context),
          const SizedBox(
            height: 10,
            width: double.infinity,
          ),
          _buildNoteTextField(context),
          const SizedBox(
            height: 10,
            width: double.infinity,
          ),
          _addPhoto(context),
          // _buildAbnormal()
        ],
      ),
    );
  }

  Widget _buildPhone(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: weight, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Obx(
            () {
              // Trigger rebuild when listOptionData changes
              controller.listOptionData.length;

              return DropdownButtonFormField(
                value: controller.selectedValue.value,
                isExpanded: true,
                style: TextStyle(
                    color: controller.selectedValue.value == null
                        ? Colors.black
                        : Colors.red),
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: controller.selectedValue.value == null
                              ? Colors.red.shade700
                              : Colors.grey.shade300,
                          width: 1),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 1),
                    )),
                elevation: 1,
                onChanged: (newValue) {
                  controller.setValue(newValue);
                  controller.defaultValue = newValue;
                  final titleCategory = title.replaceAll(':', '');
                  final option = options.firstWhere(
                      (element) => element.value == newValue,
                      orElse: () => null);
                  final isNormal = options.first.value == newValue ||
                      LineContentOption.na == newValue;
                  final message = LineWeirdoMessage(index,
                      message:
                          isNormal ? '' : '$titleCategory ${option?.title}',
                      optionValue: option?.value ?? '',
                      option: option?.title ?? '',
                      problem: titleCategory);
                  controller.lineWeirdoMessage = message;
                  if (onDataChange != null && option != null) {
                    onDataChange(controller.optionDataSelected.value, index,
                        message, controller.listOptionData, !isNormal);
                  }

                  if (isNormal) {
                    if (onSelectedAbnormalOption != null) {
                      controller.initAbnormalOptionValue = null;
                      controller.problemPositions = [];
                      controller.listOptionData.forEach((element) {
                        element.listEquipment.forEach((e) {
                          e.isChecked = false;
                        });
                      });
                      onSelectedAbnormalOption(
                          titleCategory, null, index, option.value);
                    }
                    controller.selectedValue.refresh();
                  } else {
                    if (onSelectedAbnormalOption != null) {
                      onSelectedAbnormalOption(
                          titleCategory, option?.title, index, option.value);
                    }
                  }
                },
                hint: const Text(''),
                items: options.map((e) {
                  // Count selected items for this option
                  final optionData = controller.listOptionData.firstWhere(
                    (data) => data.optionModel.value == e.value,
                    orElse: () => null,
                  );
                  final selectedCount = optionData?.listEquipment
                          ?.where((equipment) => equipment.isChecked == true)
                          ?.length ??
                      0;

                  // Build display text with count
                  final displayText = selectedCount > 0
                      ? '${e.title} ($selectedCount)'
                      : e.title;

                  return DropdownMenuItem(
                      value: e.value,
                      child: Text(
                        displayText,
                        style: TextStyle(
                            color: e.value == options.first.value ||
                                    e.value == LineContentOption.na
                                ? Colors.black
                                : Colors.red),
                      ));
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }

  //

  Widget _transformerSelected(BuildContext context) {
    var textController = TextEditingController();
    return Obx(() {
      final selectedValue = controller.selectedValue.value;
      final data = controller.optionDataSelected.value;
      // controller.problemPositions
      // ProblemPositions
      if (selectedValue != options.first.value &&
          selectedValue != LineContentOption.na &&
          selectedValue != null) {
        return TextField(
          controller: textController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
          onChanged: (value) {
            controller.problemPositions.first.note = value;
          },
        );
        // return GestureDetector(
        //   onTap: () async {
        //     final data = controller.optionDataSelected.value.copy();

        //     //Chọn từng cột
        //     if (isSelectArea) {
        //       final value = await showCheckListLine(
        //           context,
        //           _RenderListSubstationChooseAreas(
        //             data,
        //             enable: enable,
        //           ),
        //           AppShared.instance.getAppType() == AppType.HTLDHT
        //               ? "Chọn thiết bị"
        //               : 'Chọn đoạn cột',
        //           enable: enable);
        //       if (value != null) {
        //         final isNormal =
        //             options.first.value == controller.selectedValue.value ||
        //                 LineContentOption.na == controller.selectedValue.value;
        //         controller.setDataOptionLines(value);
        //         onDataChange(
        //             controller.optionDataSelected.value,
        //             index,
        //             controller.lineWeirdoMessage,
        //             controller.listOptionData,
        //             !isNormal);
        //       }
        //       // Refresh to ensure count is up-to-date even if user clicked close
        //       controller.listOptionData.refresh();

        //       //Chọn nhiều đoạn
        //     } else {
        //       final value = await showCheckListLine(
        //           context,
        //           _RenderListSubstation(
        //             data,
        //             enable: enable,
        //           ),
        //           isUndergroundCable
        //               ? 'Chọn đoạn cáp ngầm'
        //               : AppShared.instance.getAppType() == AppType.HTLDHT
        //                   ? "Chọn thiết bị"
        //                   : 'Chọn cột',
        //           enable: enable);
        //       if (value != null) {
        //         final isNormal =
        //             options.first.value == controller.selectedValue.value ||
        //                 LineContentOption.na == controller.selectedValue.value;
        //         controller.setDataOptionLines(value);
        //         onDataChange(
        //             controller.optionDataSelected.value,
        //             index,
        //             controller.lineWeirdoMessage,
        //             controller.listOptionData,
        //             !isNormal);
        //       }
        //       // Refresh to ensure count is up-to-date even if user clicked close
        //       controller.listOptionData.refresh();
        //     }
        //   },
        //   child: Container(
        //     padding: const EdgeInsets.only(left: 10),
        //     width: double.infinity,
        //     decoration: BoxDecoration(
        //         border: Border.all(color: Colors.grey.shade300),
        //         borderRadius: BorderRadius.circular(6)),
        //     child: Obx(() => Stack(
        //           children: [
        //             ConstrainedBox(
        //               constraints: const BoxConstraints(minHeight: 46),
        //               child: Container(
        //                 padding: const EdgeInsets.only(right: 30),
        //                 child: isSelectArea
        //                     ? _buildContentArea()
        //                     : Wrap(
        //                         direction: Axis.horizontal,
        //                         spacing: 10,
        //                         children: controller.optionEquipmentsSelected
        //                             .where(
        //                                 (element) => element.isChecked == true)
        //                             .toList()
        //                             .map((e) =>
        //                                 _buildChip(e, isHasDelete: enable))
        //                             .toList()),
        //               ),
        //             ),
        //             const Positioned(
        //                 top: 0,
        //                 right: 0,
        //                 bottom: 0,
        //                 child: IconButton(
        //                   icon: Icon(Icons.arrow_drop_down),
        //                   onPressed: null,
        //                 ))
        //           ],
        //         )),
        //   ),
        // );
      } else {
        return Container();
      }
    });
  }

  // Simple TextField for note input
  Widget _buildNoteTextField(BuildContext context) {
    return Obx(() {
      final selectedValue = controller.selectedValue.value;
      // Show TextField only when abnormal option is selected
      if (selectedValue != options.first.value &&
          selectedValue != LineContentOption.na &&
          selectedValue != null) {
        return TextField(
          enabled: enable,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            hintText: 'Nhập ghi chú...',
            fillColor: Colors.white,
            filled: true,
          ),
          onChanged: (value) {
            // Call callback to pass note to parent
            if (onNoteChanged != null) {
              onNoteChanged(value);
            }
          },
        );
      } else {
        return Container();
      }
    });
  }

  Widget _buildChip(EquipmentModel equipmentModel, {bool isHasDelete = true}) {
    return Chip(
      label: Text(equipmentModel.getNameNodeLine(
          isAllBranch: lineTicketController.isSelectedAllLine)),
      deleteIcon: isHasDelete
          ? const Icon(
              Icons.close,
              color: Colors.red,
            )
          : null,
      onDeleted: isHasDelete
          ? () {
              controller.removeEquipment(equipmentModel);
            }
          : null,
    );
  }

  Widget _buildContentArea() {
    final listListSelected = <List<EquipmentModel>>[];

    controller.optionEquipmentsSelected.forEach((element) {
      if (element.groupId != null) {
        final singleSelected = listListSelected.firstWhere(
            (v) => v.isNotEmpty && v[0]?.groupId == element.groupId,
            orElse: () => null);

        if (singleSelected == null) {
          listListSelected.add([element]);
        } else {
          singleSelected.add(element);
        }
      }
    });

    return Wrap(
      direction: Axis.horizontal,
      spacing: 10,
      children: listListSelected?.map(_buildChipArea)?.toList() ?? List.empty(),
    );
  }

  Widget _buildChipArea(List<EquipmentModel> data) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6)),
        child: Wrap(
          direction: Axis.horizontal,
          spacing: 10,
          children: data
              .where((element) => element.isChecked == true)
              .toList()
              .map((e) => _buildChip(e, isHasDelete: false))
              .toList(),
        ));
  }

  Widget _addPhoto(BuildContext context) {
    return Obx(() {
      final selectedValue = controller.selectedValue.value;
      if (selectedValue != options.first.value &&
          selectedValue != LineContentOption.na &&
          (disableImage ?? false) == false &&
          selectedValue != null) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Wrap(
                children: [
                  Container(
                    height: 70,
                    child: ListView.builder(
                      itemCount: controller.images?.length ?? 0,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = controller.images[index];
                        return renderItem(context, item, () {
                          controller.remove(item);
                        });
                      },
                    ),
                  )
                ],
              ),
              if ((controller.images?.length ?? 0) < limitImageNumber && enable)
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: Colors.grey.shade400,
                          style: BorderStyle.solid)),
                  width: 55,
                  height: 55,
                  alignment: Alignment.center,
                  child: IconButton(
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Colors.grey.shade400,
                      ),
                      onPressed: () async {
                        final file = await showSelectImageBottomSheet(context);
                        if (file != null) {
                          await controller.setFile(file);
                        }
                      }),
                ),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }

  Widget renderItem(BuildContext context, Images item, Function removeImage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewPhotoScreen(
                      image: item,
                    ),
                fullscreenDialog: true));
      },
      child: Container(
          margin: const EdgeInsets.only(right: 10),
          height: GetPlatform.isMobile ? 70 : 90,
          width: GetPlatform.isMobile ? 70 : 90,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.grey.shade100, style: BorderStyle.solid)),
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
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
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
                    onTap: () {
                      if (enable ?? defaultEnable) {
                        removeImage();
                      }
                    },
                    child: (enable ?? defaultEnable)
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

  @override
  void loadFailed(String message) {}

  @override
  void loadSuccess() {
    onAttachImages(controller.images, index);
  }

  @override
  void onLoading() {}

  @override
  void onRemoveEquipmentDone() {
    final isNormal = options.first.value == controller.selectedValue.value ||
        LineContentOption.na == controller.selectedValue.value;
    onDataChange(controller.optionDataSelected.value, index,
        controller.lineWeirdoMessage, controller.listOptionData, !isNormal);
  }
}

abstract class LineDropDownDelegate extends BaseDelegate {
  void onRemoveEquipmentDone();
}

class EDropDownController extends GetxController {
  RxInt selectedValue = 0.obs;
  RxList<Images> images = <Images>[].obs;
  final listOptionData = <OptionData>[].obs;
  final allLines = <EquipmentModel>[];
  final optionEquipmentsSelected = <EquipmentModel>[].obs;
  final optionDataSelected = OptionData().obs;
  List<OptionModel> options;
  final service = UploadService();
  final RxBool uploadSuccess = false.obs;
  final RxBool isAddedAbnormal = false.obs;
  LineDropDownDelegate delegate;
  List<ProblemPositions> problemPositions;
  String title = '';
  String initAbnormalOptionValue;
  LineWeirdoMessage lineWeirdoMessage;
  int defaultValue;

  void refreshAbnormal() {
    isAddedAbnormal.value = !isAddedAbnormal.value;
    update();
  }

  Future getDataLine(List<EquipmentModel> data) async {
    // Add null safety check to prevent NoSuchMethodError
    if (data == null) {
      return;
    }

    allLines.assignAll(data);
    listOptionData.assignAll(options
        .map((e) => OptionData(
            title: title,
            optionModel: e,
            listEquipment: allLines.map((e) => e.copy()).toList()))
        .toList());
    problemPositions?.forEach((element) {
      final equipment = listOptionData
          ?.firstWhere((e) => e.optionModel.value == element.problemValue,
              orElse: () => null)
          ?.listEquipment
          ?.firstWhere((element1) => element1.id == element.positionId,
              orElse: () => null);

      equipment?.isChecked = true;
      equipment?.groupId = element.groupId;
    });
    listOptionData.refresh();
    update();
  }

  void setDataOptionLines(OptionData data) {
    listOptionData
        .firstWhere(
            (element) => element.optionModel.value == data.optionModel.value,
            orElse: () => null)
        ?.listEquipment
        ?.assignAll(data.listEquipment);
    optionDataSelected.value = data;
    optionEquipmentsSelected.assignAll(optionDataSelected.value.listEquipment);
    optionEquipmentsSelected.refresh();
    listOptionData.refresh(); // Trigger dropdown rebuild to update counts
    update();
  }

  void removeEquipment(EquipmentModel equipmentModel) {
    optionEquipmentsSelected
        .firstWhere((element) => element.id == equipmentModel.id,
            orElse: () => null)
        ?.isChecked = false;
    optionEquipmentsSelected.refresh();
    optionDataSelected.value.listEquipment.assignAll(optionEquipmentsSelected);
    update();
    delegate.onRemoveEquipmentDone();
  }

  Future setFile(File _file) async {
    final isOnline = await Connection.shared.checkConnection();
    if (isOnline) {
      delegate.onLoading();
      final data = await uploadImage(_file);
      if (data != null) {
        images.add(data);
        images.refresh();
        uploadSuccess.value = true;
        delegate.loadSuccess();
      }
    } else {
      final dictionary = await getApplicationDocumentsDirectory();
      final path = dictionary.path;
      final newImage = await _file.copy('$path/${_file.path.split('/').last}');
      //save image to fixed path
      images.add(Images(path: newImage.path, problems: selectedValue.value));
      images.refresh();
      uploadSuccess.value = true;
      delegate.loadSuccess();
    }
  }

  void remove(Images item) {
    images.remove(item);
    images.refresh();
    delegate.loadSuccess();
  }

  void setValue(int value) {
    selectedValue.value = value;
    optionDataSelected.value = listOptionData
        .firstWhere((e) => e.optionModel.value == value, orElse: () => null);
    optionEquipmentsSelected
        .assignAll(optionDataSelected?.value?.listEquipment ?? []);
    optionEquipmentsSelected.refresh();
    update();
  }

  Future<Images> uploadImage(File file) async {
    final response = await service.upload(file);

    if (response.isLoadSuccess) {
      return response.data;
    } else {
      await showDialogError(response.message);
    }
    return null;
  }
}

class _RenderListSubstation extends BasePopupWidget {
  _RenderListSubstation(this.optionData, {this.enable = true}) {
    _controller.setData(optionData.listEquipment);
  }

  final ListSubstationController _controller = ListSubstationController();

  final OptionData optionData;

  final bool enable;

  final _scrollController = ItemScrollController();

  final searchNodeController = TextEditingController();
  final LineTicketController lineTicketController = Get.find();

  void search(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    final searchTerm = searchNodeController.text.toLowerCase();
    final node = _controller?.listSubstation?.firstWhere(
        (element) =>
            element
                    .getTextSearch(
                        isAllBranch: lineTicketController.isSelectedAllLine)
                    ?.toLowerCase()
                    ?.startsWith(searchTerm) ==
                true ||
            element?.code?.toLowerCase()?.startsWith(searchTerm) == true,
        orElse: () => null);

    if (node != null) {
      final index = _controller.listSubstation.indexOf(node);
      if (index < 4) {
        return;
      }
      _scrollController.scrollTo(
          index: index, duration: const Duration(seconds: 1));
    } else {
      showDialogError('Không tìm thấy vị trí');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: searchNodeController,
                maxLines: 1,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  search(context);
                },
                decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Tìm cột theo tên hoặc mã',
                    suffix: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        search(context);
                      },
                    )),
              ),
            ),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                controller: ScrollController(),
                child: ScrollablePositionedList.builder(
                  itemScrollController: _scrollController,
                  itemCount: _controller.listSubstation.length,
                  itemBuilder: (context, index) {
                    return _renderItem(
                        _controller.listSubstation[index], index);
                  },
                ),
              ),
            )
          ],
        ));
  }

  Widget _renderItem(EquipmentModel equipmentModel, int index) {
    return Padding(
      padding: EdgeInsets.only(top: index == 0 ? 16 : 0),
      child: CheckboxListTile(
          value: equipmentModel?.isChecked ?? false,
          title: Text(equipmentModel.getNameNodeLine(
              isAllBranch: lineTicketController.isSelectedAllLine)),
          onChanged: enable
              ? (isCheck) {
                  _controller.setCheck(equipmentModel);
                }
              : null),
    );
  }

  @override
  void saveData() {
    optionData.listEquipment = _controller.listSubstation;
    Get.back(result: optionData);
  }
}

class _RenderListSubstationChooseAreas extends BasePopupWidget {
  _RenderListSubstationChooseAreas(this.optionData, {this.enable = true}) {
    _controller.setData(optionData.listEquipment);
  }

  final LineTicketController lineTicketController = Get.find();

  final ListSubstationChooseAreaController _controller =
      ListSubstationChooseAreaController();

  final OptionData optionData;

  final bool enable;

  final _scrollController = ItemScrollController();

  final searchNodeController = TextEditingController();

  void search(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    final searchTerm = searchNodeController.text.toLowerCase();
    final node = _controller.listSubstation.firstWhere(
        (element) =>
            element
                .getTextSearch(
                    isAllBranch: lineTicketController.isSelectedAllLine)
                .toLowerCase()
                .startsWith(searchTerm) ||
            element.code.toLowerCase().startsWith(searchTerm),
        orElse: () => null);

    if (node != null) {
      final index = _controller.listSubstation.indexOf(node);
      if (index < 4) {
        return;
      }
      _scrollController.scrollTo(
          index: index, duration: const Duration(seconds: 1));
    } else {
      showDialogError('Không tìm thấy vị trí');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: searchNodeController,
              maxLines: 1,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                search(context);
              },
              decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Tìm cột theo tên hoặc mã',
                  suffix: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      search(context);
                    },
                  )),
            ),
          ),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              controller: ScrollController(),
              child: ScrollablePositionedList.builder(
                itemScrollController: _scrollController,
                itemCount: _controller.listSubstation.length,
                itemBuilder: (context, index) {
                  return renderEquipmentItem(
                      _controller.listSubstation[index], index);
                },
              ),
            ),
          )
        ]));
  }

  Container renderEquipmentItem(EquipmentModel model, int index) {
    final selectedIndex = _controller.getIndex(model);
    return Container(
      height: 60,
      padding: EdgeInsets.only(top: index == 0 ? 16 : 0, left: 8, right: 8),
      child: Row(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: 1,
                  color: (model.isChecked &&
                          selectedIndex > 0 &&
                          model.groupId ==
                              _controller
                                  .listSubstation[selectedIndex - 1]?.groupId)
                      ? Colors.black
                      : Colors.black.withOpacity(0),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (enable) {
                    _controller.chooseSubstation(model);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 40,
                  height: 30,
                  color: Colors.white.withOpacity(0),
                  child: Stack(
                    children: [
                      const Icon(
                        CupertinoIcons.circle,
                        size: 24,
                        color: Colors.black87,
                      ),
                      Icon(
                        CupertinoIcons.circle_fill,
                        size: 24,
                        color: model.isChecked
                            ? Colors.black87
                            : Colors.black87.withOpacity(0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: 1,
                  color:
                      (selectedIndex != _controller.listSubstation.length - 1 &&
                              model.isChecked &&
                              _controller.listSubstation[selectedIndex + 1]
                                      ?.isChecked ==
                                  true &&
                              model.groupId ==
                                  _controller.listSubstation[selectedIndex + 1]
                                      ?.groupId)
                          ? Colors.black87
                          : Colors.black87.withOpacity(0),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Text(
                  model.getNameNodeLine(
                      isAllBranch: lineTicketController.isSelectedAllLine),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3)),
        ],
      ),
    );
  }

  @override
  void saveData() {
    if (_controller.listSubstation.length > 1) {
      _controller.removeSingleSelected();
    }

    optionData.listEquipment = _controller.listSubstation;
    Get.back(result: optionData);
  }
}

class ListSubstationController extends GetxController {
  final listSubstation = <EquipmentModel>[].obs;

  void setData(List<EquipmentModel> data) {
    listSubstation.assignAll(data);
    listSubstation.refresh();
    update();
  }

  void setCheck(EquipmentModel model) {
    listSubstation
        .firstWhere((element) => element.id == model.id, orElse: () => null)
        ?.isChecked = !model.isChecked;
    listSubstation.refresh();
    update();
  }
}

class ListSubstationChooseAreaController extends GetxController {
  final listSubstation = <EquipmentModel>[].obs;

  final listListSelected = <List<EquipmentModel>>[];

  void setData(List<EquipmentModel> data) {
    listSubstation.assignAll(data);
    listSubstation.forEach((element) {
      if (element.groupId != null) {
        final singleSelected = listListSelected.firstWhere(
            (v) => v.isEmpty && v[0]?.groupId == element.groupId,
            orElse: () => null);

        if (singleSelected == null) {
          listListSelected.add([element]);
        } else {
          singleSelected.add(element);
        }
      }
    });

    listSubstation.refresh();
    update();
  }

  int getIndex(EquipmentModel model) {
    return listSubstation.indexWhere((element) => element.id == model.id);
  }

  void chooseSubstation(EquipmentModel substationSelected) {
    if (listSubstation?.length == 1) {
      if (listListSelected.isEmpty) {
        substationSelected.groupId =
            DateTime.now().millisecondsSinceEpoch.toString();
        listSubstation.first.groupId = substationSelected.groupId;
        listSubstation.first.isChecked = true;
        listListSelected.add([substationSelected]);
      } else {
        listSubstation.first.groupId = null;
        listSubstation.first.isChecked = false;
        listListSelected.removeAt(0);
      }

      _mapToList();
      listSubstation.refresh();
      return;
    }

    final piece = listListSelected.firstWhere(
        (element) =>
            element.firstWhere(
                    (elementSub) => elementSub.id == substationSelected.id,
                    orElse: () => null) !=
                null &&
            element.length >= 2,
        orElse: () => null);

    if (piece != null) {
      listListSelected.remove(piece);
      listSubstation.forEach((element) {
        piece.forEach((elementSelected) {
          if (elementSelected.id == element.id) {
            element.isChecked = false;
            element.groupId = null;
          }
        });
      });
    }

    final singleSelected = listListSelected
        .firstWhere((element) => element.length == 1, orElse: () => null);

    if (singleSelected == null) {
      substationSelected.groupId =
          DateTime.now().millisecondsSinceEpoch.toString();
      listListSelected.add([substationSelected]);
    } else if (singleSelected.first.id == substationSelected.id) {
      listListSelected
          .removeWhere((element) => element.first.id == substationSelected.id);
      final equip = listSubstation.firstWhere(
          (element) => singleSelected.first.id == element.id,
          orElse: () => null);
      equip.groupId = null;
      equip.isChecked = false;
    } else {
      final startIndex = listSubstation
          .indexWhere((element) => element.id == singleSelected[0].id);
      final endIndex = listSubstation.indexOf(substationSelected);

      var start = startIndex;
      var end = endIndex;

      if (startIndex > endIndex) {
        start = endIndex;
        end = startIndex;
      }

      final subList = listSubstation.sublist(start, end + 1);
      subList.forEach((element) {
        element.groupId = singleSelected[0].groupId;
        element.isChecked = true;
      });

      singleSelected.clear();
      singleSelected.addAll(subList);
    }

    _mapToList();

    listSubstation.refresh();
  }

  void removeSingleSelected() {
    final singleSelected = listListSelected
        .firstWhere((element) => element.length == 1, orElse: () => null);
    if (singleSelected != null) {
      final equip = listSubstation.firstWhere(
          (element) => singleSelected.first.id == element.id,
          orElse: () => null);
      equip.groupId = null;
      equip.isChecked = false;
    }
  }

  void _mapToList() {
    listListSelected.forEach((element) {
      element.forEach((elementSelected) {
        listSubstation
            .firstWhere(
                (elementOrigin) => elementOrigin.id == elementSelected.id,
                orElse: () => null)
            ?.isChecked = true;
      });
    });
  }
}

