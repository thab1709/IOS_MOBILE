// @dart=2.9
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:evnmobile/src/app_common/utils/utils.dart';
import 'package:evnmobile/src/htld/common/base/base_delegate.dart';
import 'package:evnmobile/src/htld/common/constance/user_role_type.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/constance.dart';
import 'package:evnmobile/src/htld/models/weirdo_message.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/view_photo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../../common/constance/content_option.dart';
import '../../../models/attach_image_model.dart';
import '../../../models/option_model.dart';
import '../../../services/responsitory/upload_service.dart';

final BTOptions = [
  ContentOptions.normal,
  ContentOptions.weirdo,
];

final BTNAOptions = [
  ContentOptions.normal,
  ContentOptions.weirdo,
  ContentOptions.na,
];

final BTPROptions = [
  ContentOptions.normal,
  ContentOptions.blistering,
];

final BTBTDPDOptions = [
  ContentOptions.normal,
  ContentOptions.abnormalitiesDischarge,
];

final BTBTDPDNAOptions = [
  ContentOptions.normal,
  ContentOptions.abnormalitiesDischarge,
  ContentOptions.na,
];

final BTRNOptions = [
  ContentOptions.normal,
  ContentOptions.rift,
];

final BTRNNAOptions = [
  ContentOptions.normal,
  ContentOptions.rift,
  ContentOptions.na,
];

final BTHHOptions = [
  ContentOptions.normal,
  ContentOptions.weirdo,
  ContentOptions.damaged,
];

final BTHHNAOptions = [
  ContentOptions.normal,
  ContentOptions.weirdo,
  ContentOptions.damaged,
  ContentOptions.na,
];

final BTKBTHHNAOptions = [
  ContentOptions.normal,
  ContentOptions.notNormal,
  ContentOptions.damaged,
  ContentOptions.na,
];

final BTGGNAOptions = [
  ContentOptions.normal,
  ContentOptions.rusty,
  ContentOptions.brokenSegment,
  ContentOptions.na,
];

final BTNDDMOptions = [
  ContentOptions.normal,
  ContentOptions.hotRed,
];

final BTNDDMNAOptions = [
  ContentOptions.normal,
  ContentOptions.hotRed,
  ContentOptions.na,
];

final BTNDDMPDOptions = [
  ContentOptions.normal,
  ContentOptions.hotRed,
  ContentOptions.discharge,
];

final BTNDDMPDNAOptions = [
  ContentOptions.normal,
  ContentOptions.hotRed,
  ContentOptions.discharge,
  ContentOptions.na,
];

final BTCDHHOptions = [
  ContentOptions.normal,
  ContentOptions.oilSpill,
  ContentOptions.damaged,
  ContentOptions.absorbOil,
];

final PHOptions = [
  ContentOptions.fit,
  ContentOptions.inappropriate,
];

final TCDOptions = [
  ContentOptions.good,
  ContentOptions.oilSpill,
];

final BTTDOptions = [
  ContentOptions.normal,
  ContentOptions.fiberForm,
  ContentOptions.brokenWire,
];

final BTTDNAOptions = [
  ContentOptions.normal,
  ContentOptions.fiberForm,
  ContentOptions.brokenWire,
  ContentOptions.na,
];

final BTTCNPDptions = [
  ContentOptions.normal,
  ContentOptions.fire,
  ContentOptions.melasma,
  ContentOptions.discharge,
];

final BTTCNPDNAOptions = [
  ContentOptions.normal,
  ContentOptions.fire,
  ContentOptions.melasma,
  ContentOptions.discharge,
  ContentOptions.na,
];

final BTNVCPBOptions = [
  ContentOptions.normal,
  ContentOptions.cracked,
  ContentOptions.broken,
  ContentOptions.oilSpill,
  ContentOptions.discharge,
  ContentOptions.dirty,
];

final BTRNBPDCDOptions = [
  ContentOptions.normal,
  ContentOptions.rift,
  ContentOptions.dirty,
  ContentOptions.discharge,
  ContentOptions.oilSpill,
];

final BTNVPNAOptions = [
  ContentOptions.normal,
  ContentOptions.cracked,
  ContentOptions.broken,
  ContentOptions.discharge,
  ContentOptions.na,
];

final BTPDNVBOptions = [
  ContentOptions.normal,
  ContentOptions.discharge,
  ContentOptions.cracked,
  ContentOptions.broken,
];

final BTRDOptions = [
  ContentOptions.normal,
  ContentOptions.abnormalitiesDischarge,
];

final BTBTDPDBMOptions = [
  ContentOptions.normal,
  ContentOptions.abnormalitiesDischargeAlongInsulation,
];

final BTCPDOptions = [
  ContentOptions.normal,
  ContentOptions.fire,
  ContentOptions.discharge,
];

final BTCNPDOptions = [
  ContentOptions.normal,
  ContentOptions.fire,
  ContentOptions.discharge,
];

final BTCNPDNAOptions = [
  ContentOptions.normal,
  ContentOptions.fire,
  ContentOptions.discharge,
  ContentOptions.na,
];

final BTPDOptions = [
  ContentOptions.normal,
  ContentOptions.discharge,
];

final BTPTLDOptions = [
  ContentOptions.normal,
  ContentOptions.electricSparkDischarge,
];

final BTPTLDNAOptions = [
  ContentOptions.normal,
  ContentOptions.electricSparkDischarge,
  ContentOptions.na,
];

final BTNVOptions = [
  ContentOptions.normal,
  ContentOptions.cracked,
  ContentOptions.broken,
];

final BT_NVOptions = [
  ContentOptions.normal,
  ContentOptions.crackedBroken,
];

final BTNVCDOptions = [
  ContentOptions.normal,
  ContentOptions.cracked,
  ContentOptions.broken,
  ContentOptions.oilSpill,
];

final BSOptions = [
  ContentOptions.clean,
  ContentOptions.dirty,
];

final BTNVGNNTRCBLUKCDOptions = [
  ContentOptions.normal,
  ContentOptions.cracked,
  ContentOptions.broken,
  ContentOptions.brokenSegment,
  ContentOptions.inclined,
  ContentOptions.melasma,
  ContentOptions.peelOffTheYeast,
  ContentOptions.fireSem,
  ContentOptions.dirty,
  ContentOptions.differrence,
  ContentOptions.winding
];

final BTPNOptions = [
  ContentOptions.normal,
  ContentOptions.heatGeneration,
];

final BTPNNAOptions = [
  ContentOptions.normal,
  ContentOptions.heatGeneration,
  ContentOptions.na,
];

final NVTDNAOptions = [
  ContentOptions.original,
  ContentOptions.isChanged,
  ContentOptions.na,
];

final CKKTOptions = [
  OptionModel('Chu kỳ kiểm tra', 0),
];

final TDDOptions = [
  OptionModel('Tên đường dây', 0),
];

final TXTOptions = [
  OptionModel('Nút/nhánh', 0),
];

final KCLDOptions = [
  OptionModel('Cáp ngầm', 0),
  OptionModel('Đường dây không', 1),
  OptionModel('Hỗn hợp ngầm, nổi', 2),
];

final CutTreeOptions = [
  OptionModel("Xử lý ngay tại thời điểm kiểm tra", 0),
  OptionModel("Lập kế hoạch", 1)
];

final NDDOptions = [
  OptionModel('Nhánh đường dây', 0),
];

final KCOptions = [
  ContentOptions.no,
  ContentOptions.yes,
];

final CKOptions = [
  ContentOptions.yes,
  ContentOptions.no,
];

final CKNAOptions = [
  ContentOptions.yes,
  ContentOptions.no,
  ContentOptions.na,
];

final TTOptions = [
  OptionModel("Đảm bảo vận hành", 0),
  OptionModel("Đứt", 1),
  OptionModel("Phát nhiệt", 2)
];

final HTOptions = [
  OptionModel("Xử lý hoàn toàn", 0),
  OptionModel("Xử lý chưa hoàn toàn", 1)
];

final OilNAOptions = [
  ContentOptions.enough,
  ContentOptions.lack,
  ContentOptions.noOil,
  ContentOptions.na
];

final DTNAOptions = [
  ContentOptions.enough,
  ContentOptions.lack,
  ContentOptions.na,
];

final DT_KHH_NAOptions = [
  ContentOptions.enough,
  ContentOptions.lack,
  ContentOptions.notExist,
  ContentOptions.na,
];

final DTGasOptions = [
  ContentOptions.enough,
  ContentOptions.lack,
  ContentOptions.outOfGas,
];

final DTGasNAOptions = [
  ContentOptions.enough,
  ContentOptions.lack,
  ContentOptions.outOfGas,
  ContentOptions.na,
];

final TKTOptions = [
  ContentOptions.good,
  ContentOptions.bad,
];

final TKTNAOptions = [
  ContentOptions.good,
  ContentOptions.bad,
  ContentOptions.na,
];

final TXSVTNAOptions = [
  ContentOptions.good,
  ContentOptions.bad,
  ContentOptions.wrongPosition,
  ContentOptions.na,
];

final TRSHHOptions = [
  ContentOptions.good,
  ContentOptions.rust,
  ContentOptions.damaged,
];

final BTLOptions = [
  ContentOptions.normal,
  ContentOptions.loose,
];

final BTLNAOptions = [
  ContentOptions.normal,
  ContentOptions.loose,
  ContentOptions.na,
];

final CVKTTOptions = [
  ContentOptions.normal,
  ContentOptions.warping,
  ContentOptions.difficultToManipulate,
];

final CVKTTNAOptions = [
  ContentOptions.normal,
  ContentOptions.warping,
  ContentOptions.difficultToManipulate,
  ContentOptions.na,
];

final DMOptions = [
  ContentOptions.closed,
  ContentOptions.open,
];

final DCNAOptions = [
  ContentOptions.closed,
  ContentOptions.cut,
  ContentOptions.na,
];

final NVGTOption = [
  ContentOptions.original,
  ContentOptions.rusty,
  ContentOptions.punctured,
];

final NVGDOption = [
  ContentOptions.original,
  ContentOptions.rustOil,
];

final NVGDNAOption = [
  ContentOptions.original,
  ContentOptions.rustOil,
  ContentOptions.na,
];

final NVKNVOption = [
  ContentOptions.original,
  ContentOptions.notOriginal,
];

final NVKNVNAOption = [
  ContentOptions.original,
  ContentOptions.notOriginal,
  ContentOptions.na,
];

final BTNMNAOption = [
  ContentOptions.normal,
  ContentOptions.inclined,
  ContentOptions.punk,
  ContentOptions.rust,
  ContentOptions.na,
];

final BTNGOption = [
  ContentOptions.normal,
  ContentOptions.inclined,
  ContentOptions.rust,
];

final BTNGNAOption = [
  ContentOptions.normal,
  ContentOptions.inclined,
  ContentOptions.rust,
  ContentOptions.na,
];

final BTCBDGNAOption = [
  ContentOptions.normal,
  ContentOptions.warpingOp,
  ContentOptions.deformation,
  ContentOptions.na,
];

final BTLVNOption = [
  ContentOptions.normal,
  ContentOptions.subsidence,
  ContentOptions.rift,
  ContentOptions.broken,
];

final BTLVNNAOption = [
  ContentOptions.normal,
  ContentOptions.subsidence,
  ContentOptions.rift,
  ContentOptions.broken,
  ContentOptions.na,
];

final BTCDGOption = [
  ContentOptions.normal,
  ContentOptions.slack,
  ContentOptions.brokenWire,
  ContentOptions.rusty,
];

final BTCDGNAOption = [
  ContentOptions.normal,
  ContentOptions.slack,
  ContentOptions.brokenWire,
  ContentOptions.rusty,
  ContentOptions.na,
];

final BTGGCBDOption = [
  ContentOptions.normal,
  ContentOptions.rusty,
  ContentOptions.brokenSegment,
  ContentOptions.warping,
  ContentOptions.deformation,
];

final BTGGCBDNAOption = [
  ContentOptions.normal,
  ContentOptions.rusty,
  ContentOptions.brokenSegment,
  ContentOptions.warping,
  ContentOptions.deformation,
  ContentOptions.na,
];

final BTNOption = [
  ContentOptions.normal,
  ContentOptions.warping,
  ContentOptions.deformation,
];

final BTCVHHOption = [
  ContentOptions.normal,
  ContentOptions.warping,
  ContentOptions.damaged,
];

final BTCVHHNAOption = [
  ContentOptions.normal,
  ContentOptions.warping,
  ContentOptions.damaged,
  ContentOptions.na,
];

final BTGRCOption = [
  ContentOptions.normal,
  ContentOptions.rusty,
  ContentOptions.fallingTheLatch
];

final BTGRCNAOption = [
  ContentOptions.normal,
  ContentOptions.rusty,
  ContentOptions.fallingTheLatch,
  ContentOptions.na
];

final BTHCNAOption = [
  ContentOptions.normal,
  ContentOptions.failure,
  ContentOptions.na,
];

final KHNAOption = [
  ContentOptions.private,
  ContentOptions.hollow,
  ContentOptions.na,
];

final BTNLMDNAOption = [
  ContentOptions.normal,
  ContentOptions.spit_it_out_of_the_ground,
  ContentOptions.na,
];

class EDropDown extends StatelessWidget implements BaseDelegate {
  EDropDown(this.options,
      {this.title,
      this.enable = true,
      this.index,
      this.weight = FontWeight.w500,
      this.paddingHorizontal,
      this.onChange,
      this.onAttachImages,
      this.images,
      this.disableImage,
      this.defaultValue,
      this.isHasDefault = false,
      this.isShowAbnormal = false,
      this.changeTextColorIfNotDefault = true,
      this.onSelectedAbnormalOption,
      Key key})
      : super(key: key);

  final EDropDownController controller = EDropDownController();

  final int index;
  final String title;
  final bool disableImage;
  final bool isShowAbnormal;
  final FontWeight weight;
  final List<OptionModel> options;
  final List<Images> images;
  final double paddingHorizontal;
  final bool enable;
  final bool changeTextColorIfNotDefault;
  final bool isHasDefault;
  final Function(OptionModel, WeirdoMessage) onChange;
  final Function(List<Images>, int) onAttachImages;
  final RxBool _isSelecting = false.obs;
  final defaultEnable = UserRole.hasPermissionCreate();

  final Function(String, String, int) onSelectedAbnormalOption;
  final int defaultValue;
  final formGlobalKey = GlobalKey<FormState>();

  void setDefaultValueValue(int value) {
    // if (blankDefault ?? true) {
    //   options = [OptionModel('', 999)] + options;
    // }
    var initValue = value;
    if (isHasDefault) {
      if (value == 0) {
        initValue = options.first.value;
      } else if (options.firstWhere((element) => element.value == value,
              orElse: () => null) ==
          null) {
        initValue = options.first.value;
      }
    }
    controller.selectedValue.value = initValue;
    var optionModel = options.firstWhere(
        (element) => element.value == initValue,
        orElse: () => null);
    if (optionModel == null) {
      if (isHasDefault) {
        optionModel = options.first;
        controller.defaultValue = options.first.value;
        controller.selectedValue.value = options.first.value;
      }
    }

    if (isHasDefault) {
      final message = WeirdoMessage(index, message: '');
      onChange(optionModel, message);
    }

    if (onChange != null &&
        optionModel != null &&
        optionModel.value != options.first.value &&
        ContentOptions.na.value != optionModel.value) {
      final message = WeirdoMessage(index,
          message:
              '${title?.replaceAll(':', '') ?? ''}: ${optionModel?.title ?? ''}');
      onChange(optionModel, message);
    }
  }

  void setupData() {
    controller.changeTextColorIfNotDefault = changeTextColorIfNotDefault;
    controller.delegate = this;
    controller.defaultValue = defaultValue;
    if (isHasDefault) {
      controller.defaultValue ??= options.first.value;
    }
    setDefaultValueValue(controller.defaultValue);

    controller.images =
        images?.where((element) => element.problems == index)?.toList()?.obs ??
            <Images>[].obs;
    debugPrint(
        'EDropdown: Title: $title, value: ${controller.selectedValue.value}');
  }

  @override
  Widget build(BuildContext context) {
    setupData();

    return Container(
      margin:
          EdgeInsets.symmetric(vertical: 8, horizontal: paddingHorizontal ?? 0),
      child: Wrap(
        children: [
          if (index != 0) buildPhone(context),
          _addPhoto(context),
          //  _buildAbnormal()
        ],
      ),
    );
  }

  // Widget _buildAbnormal() {
  //   return Obx(() {
  //     final isAddedAbnormal = controller.isAddedAbnormal.value;
  //     final selectedValue = controller.selectedValue.value;
  //     if (selectedValue != options.first.value &&
  //         selectedValue != ContentOptions.na.value &&
  //         (disableImage ?? false) == false &&
  //         selectedValue != null &&
  //         index != 0 &&
  //         isShowAbnormal &&
  //         isAddedAbnormal != null) {
  //       return AbnormalDropdownWidget(
  //         options: abnormalOptions ?? <OptionModelString>[],
  //         invalid: controller.initAbnormalOptionValue == null ||
  //             controller.initAbnormalOptionValue.isEmpty,
  //         disable: !enable,
  //         onSelected: (value) {
  //           controller.initAbnormalOptionValue = value;
  //           onSelectedAbnormalOption(
  //               TAbnormal(
  //                   abnormalId: value,
  //                   categoryIndex: index,
  //                   childCategory: title.replaceAll(':', ''),
  //                   description: options
  //                           .firstWhereOrNull((element) =>
  //                               element.value == controller.selectedValue.value)
  //                           ?.title ??
  //                       ''),
  //               index);
  //           controller.refreshAbnormal();
  //         },
  //         addAbnormalOption: (value) async {
  //           addAbnormalOption(value);
  //         },
  //         defaultOption: controller.initAbnormalOptionValue,
  //       );
  //     } else {
  //       return Container();
  //     }
  //   });
  // }

  Widget buildPhone(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: weight, fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Obx(
            () => DropdownButtonFormField(
              itemHeight: 60,
              isDense: true,
              style: TextStyle(
                  color: controller.selectedValue.value == options.first.value
                      ? Colors.black
                      : Colors.red,
                  fontSize: 15),
              value: controller.selectedValue.value,
              isExpanded: true,
              dropdownColor: Colors.white,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  isDense: false,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
              elevation: 4,
              onTap: () {
                _isSelecting.value = true;
              },
              onChanged: enable ?? defaultEnable
                  ? (newValue) {
                      _isSelecting.value = false;
                      if (newValue != options.first.value) {
                        controller.images = <Images>[].obs;
                      }
                      controller.setValue(newValue);
                      controller.defaultValue = newValue;
                      if (onChange != null) {
                        final option = options
                            .firstWhere((element) => element.value == newValue);
                        final isNormal = options.first.value == newValue ||
                            ContentOptions.na.value == newValue;
                        WeirdoMessage message;
                        final titleCategory = title.replaceAll(':', '');
                        if (isNormal) {
                          message = WeirdoMessage(index, message: '');
                        } else {
                          message = WeirdoMessage(index,
                              message:
                                  '$titleCategory: ${option.title}');
                        }

                        onChange(option, message);

                        if (isNormal) {
                          if (onSelectedAbnormalOption != null) {
                            onSelectedAbnormalOption(titleCategory, null, index);
                          }
                        } else {
                          if (onSelectedAbnormalOption != null) {
                            onSelectedAbnormalOption(
                                titleCategory, option?.title, index);
                          }
                        }
                      }
                    }
                  : null,
              hint: const Text(''),
              items: options.map((e) {
                return DropdownMenuItem(
                    value: e.value,
                    child: Container(
                      width: double.maxFinite,
                      child: Text(
                        e.title,
                        style: TextStyle(
                            color: e.value != options.first.value &&
                                    changeTextColorIfNotDefault &&
                                    _isSelecting.value == false &&
                                    _isSelecting.value == false &&
                                    ContentOptions.na.value != e.value
                                ? Colors.red
                                : Colors.black),
                      ),
                    ));
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _addPhoto(BuildContext context) {
    return Obx(() {
      final selectedValue = controller.selectedValue.value;
      if (selectedValue != options.first.value &&
              selectedValue != ContentOptions.na.value &&
              (disableImage ?? false) == false &&
              selectedValue != null ||
          index == 0) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
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
                ),
              ),
              if ((controller.images?.length ?? 0) < limitImageNumber)
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
                        if (enable ?? defaultEnable) {
                          final file =
                              await showSelectImageBottomSheet(context);
                          if (file != null) {
                            await controller.setFile(file);
                          }
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
                          placeholder: (context, url) => Center(
                            child: Container(
                                height: 20,
                                width: 20,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 3,
                                )),
                          ),
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
}

class EDropDownController extends GetxController {
  RxInt selectedValue = 0.obs;
  RxList<Images> images = <Images>[].obs;
  final service = UploadService();
  final RxBool uploadSuccess = false.obs;
  final RxBool isAddedAbnormal = false.obs;
  BaseDelegate delegate;
  int defaultValue;
  bool changeTextColorIfNotDefault;

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

  void refreshAbnormal() {
    isAddedAbnormal.value = !isAddedAbnormal.value;
    update();
  }

  void remove(Images item) {
    images.remove(item);
    images.refresh();
    delegate.loadSuccess();
  }

  void setValue(int value) {
    selectedValue.value = value;
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

