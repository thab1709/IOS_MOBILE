// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/equipment_model.dart';
import 'package:evnmobile/src/htld/models/line/line_branch_info.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_underground_cable.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_label.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_line_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../../../app_env.dart';
import '../../../../../../app_common/shared/app_shared.dart';
import '../../../containers/e_text_area.dart';

class LineSubCablePopup extends BasePopupWidget {
  LineSubCablePopup(
      {@required PopupsDataModel popupsDataModel,
      @required LineBranchInfo lineBranchInfo,
      @required this.equipmentModels}) {
    _controller.popupsDataModel = popupsDataModel;
    _controller.lineBranchInfo = lineBranchInfo;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  final List<EquipmentModel> equipmentModels;
  final _controller = LineSubCableController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ELabel(title: '1. Hành lang tuyến'),
              if (AppShared.instance.getAppType() == AppType.HTLDHT)
                const Text("Tồn tại",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const ELabel(
                title: 'Tình trạng',
              ),
              EDropDown(
                KCOptions,
                title: 'Vi phạm',
                index: 1,
                enable: _controller.isEnable(),
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.violation,
                onChange: (option, mess) {
                  _controller.model.value.violation = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ELineDropDown(
                LineOption.ValidatorOption,
                title: 'Đối tượng vi phạm',
                index: 2,
                enable: _controller.isEnable(),
                isUndergroundCable: true,
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 2)
                    ?.toList(),
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  _controller.setAbnormalLine(categoryName,
                      _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                  _controller.model.value.setLineUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              const ELabel(title: 'Các thay đổi xung quanh cáp ngầm'),
              ELineDropDown(
                KCOptions,
                isUndergroundCable: true,
                title: 'Sụt lún đất, hào cáp, mương cáp',
                index: 3,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 3)
                    ?.toList(),
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  _controller.setAbnormalLine(categoryName,
                      _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                  _controller.model.value.setLineUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ELineDropDown(
                KCOptions,
                defaultValue: _controller.model.value.worksUnderConstruction,
                isUndergroundCable: true,
                title: 'Công trình đang xây dựng',
                index: 4,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 4)
                    ?.toList(),
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  _controller.setAbnormalLine(categoryName,
                      _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  _controller.model.value.worksUnderConstruction =
                      optionData?.optionModel?.value;
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                  _controller.model.value.setLineUnusually(mess, listData);

                  _controller.setHasConstructor(optionData?.optionModel?.value);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              Obx(() {
                if (_controller.hasConstructor.value) {
                  return ETextArea(
                    title: 'Mô tả công trình đang xây dựng',
                    isRequire: true,
                    enable: _controller.isEnable(),
                    value: _controller
                        .model.value.worksUnderConstructionDescription,
                    onChange: (value) {
                      _controller.model.value
                          .worksUnderConstructionDescription = value;
                    },
                  );
                }
                return const SizedBox();
              }),
              if (AppShared.instance.getAppType() == AppType.HTLDHT)
                const Text("Cảnh báo",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              EDropDown(
                KCOptions,
                title: '-  Có khả năng gây sự cố ',
                index: 5,
                enable: _controller.isEnable(),
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.possibleProblematic,
                onChange: (option, mess) {
                  _controller.model.value.possibleProblematic = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, 5);
                },
              ),
              EDropDown(
                KCOptions,
                title: '-  Xử lý ngay trong kiểm tra',
                index: 6,
                enable: _controller.isEnable(),
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  // _controller.setAbnormal(
                  //     categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue:
                    _controller.model.value.handlingImmediatelyInspection,
                onChange: (option, mess) {
                  _controller.model.value.handlingImmediatelyInspection =
                      option.value;
                  // _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, 6);
                },
              ),
              ETextArea(
                title: 'Các hiện tượng cụ thể',
                isRequire: true,
                enable: _controller.isEnable(),
                value: _controller.model.value.specificPhenomena,
                onChange: (value) {
                  _controller.model.value.specificPhenomena = value;
                },
              ),
              ETextArea(
                title: '-  Đề xuất xử lý bất thường/ hư hỏng',
                isRequire: true,
                enable: _controller.isEnable(),
                value: _controller.model.value.suggestedHandlingOfAbnormal,
                onChange: (value) {
                  _controller.model.value.suggestedHandlingOfAbnormal = value;
                },
              ),
              const ELabel(title: '2. Mốc cáp'),
              ELineDropDown(
                LineOption.LineDistanceOption,
                isUndergroundCable: true,
                title: 'Khoảng cách giữa các mốc, cọc báo cáp',
                index: 7,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 7)
                    ?.toList(),
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  _controller.setAbnormalLine(categoryName,
                      _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                  _controller.model.value.setLineUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                CKOptions,
                title: 'Mốc cáp tại vị trí bẻ góc, qua đường',
                index: 8,
                enable: _controller.isEnable(),
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.cableMold,
                onChange: (option, mess) {
                  _controller.model.value.cableMold = option.value;
                  //no set unusually for this case: VU-PH said
                  //_controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, 8);
                },
              ),
              ELineDropDown(
                LineOption.D_T_M_N_M_Options,
                isUndergroundCable: true,
                title: 'Tình trạng mốc/ cọc báo cáp',
                index: 9,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 9)
                    ?.toList(),
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  _controller.setAbnormalLine(categoryName,
                      _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                  _controller.model.value.setLineUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                title: 'Các hiện tượng cụ thể',
                isRequire: true,
                enable: _controller.isEnable(),
                value: _controller.model.value.specificPhenomena,
                onChange: (value) {
                  _controller.model.value.specificPhenomena = value;
                },
              ),
              const ELabel(
                title: '3. Biển tên cáp',
              ),
              ELineDropDown(
                LineOption.DQC_M_H_SQC_Options,
                isUndergroundCable: true,
                title: 'Tình trạng',
                index: 10,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 10)
                    ?.toList(),
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  _controller.setAbnormalLine(categoryName,
                      _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                  _controller.model.value.setLineUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                title: 'Các hiện tượng cụ thể',
                isRequire: true,
                enable: _controller.isEnable(),
                value: _controller.model.value.seaCableSpecificPhenomena,
                onChange: (value) {
                  _controller.model.value.seaCableSpecificPhenomena = value;
                },
              ),
              const ELabel(
                title: '4. Đầu cáp ngoài trời',
              ),
              ELineDropDown(
                LineOption.DBVH_BD_PD_B_Options,
                isUndergroundCable: true,
                title: 'Tình trạng',
                index: 11,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 11)
                    ?.toList(),
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  _controller.setAbnormalLine(categoryName,
                      _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                  _controller.model.value.setLineUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ELineDropDown(
                LineOption.CK_D_KDB,
                isUndergroundCable: true,
                title: 'Tiếp địa đầu cáp',
                index: 12,
                enable: _controller.isEnable(),
                equipmentModel: equipmentModels,
                problemPositions: _controller.model.value?.problemPositions
                    ?.where((element) => element.fieldValue == 12)
                    ?.toList(),
                onSelectedAbnormalOption:
                    (categoryName, abnormal, index, optionCategory) {
                  _controller.setAbnormalLine(categoryName,
                      _controller.model.value, abnormal, index, optionCategory);
                },
                images: _controller.model.value.images,
                onDataChange: (optionData, index, mess, listData, isAbnormal) {
                  _controller.model.value.setProblemPositions(
                      mess, optionData, index,
                      isAbnormal: isAbnormal);
                  _controller.model.value.setLineUnusually(mess, listData);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                title: 'Các hiện tượng cụ thể',
                isRequire: true,
                enable: _controller.isEnable(),
                value: _controller.model.value.outSideCableSpecificPhenomena,
                onChange: (value) {
                  _controller.model.value.outSideCableSpecificPhenomena = value;
                },
              ),
              ETextArea(
                title: '5. Các hiện tượng bất thường khác ',
                weight: FontWeight.bold,
                enable: _controller.isEnable(),
                value: _controller.model.value.otherUnusualPhenomenon,
                onChange: (value) {
                  _controller.model.value.otherUnusualPhenomenon = value;
                },
              ),
            ],
          )),
    );
  }

  @override
  void saveData() {
    _controller.updateData();
  }
}

class LineSubCableController extends BasePopupController {
  Rx<LineUndergroundCable> model = LineUndergroundCable().obs;
  RxBool hasConstructor = false.obs;

  String endPoint = 'underground-cables';

  @override
  void onInit() {
    super.onInit();
    createDefault();
  }

  void setHasConstructor(int selectedValue) {
    hasConstructor.value = selectedValue == KCOptions.last.value;
    if (hasConstructor.value == false) {
      model.value?.problemPositions
          ?.removeWhere((element) => element.fieldValue == 4);
    }

    hasConstructor.refresh();
  }

  @override
  void refresh() {
    model.refresh();
    super.refresh();
  }

  @override
  Future getData() async {
    await super.getData();
    Future online() async {
      final response = await repository.getLineUndergroundCable(
          lineTicketController.ticketId,
          popupsDataModel.equipmentId,
          endPoint,
          lineBranchInfo.id);

      if (response.statusCode == 200) {
        model.value = response?.data ?? LineUndergroundCable();
        model.value.title = popupsDataModel.equipmentName;

        hasConstructor.value = model.value.problemPositions
                ?.firstWhere((element) => element.fieldValue == 4,
                    orElse: () => null)
                ?.problemValue ==
            KCOptions.last.value;

        createDefault();
        update();
      } else {
        await showDialogError(response.message);
      }
    }

    void offline() {
      final response = LocalDataManager.shared
          .getLinePopup<LineUndergroundCable>(
              lineTicketController.ticketId,
              lineBranchInfo.id,
              popupsDataModel.equipmentId,
              popupsDataModel.inspectionCategory);
      model.value = response ?? LineUndergroundCable();
      model.value.title = popupsDataModel.equipmentName;
      update();
    }

    final isHandleDataOnline = await lineTicketController.isHandleDataOnline();

    if (isHandleDataOnline) {
      await online();
    } else {
      offline();
    }
  }

  void createDefault() {
    model.value.worksUnderConstruction ??= KCOptions.first.value;
    // model.value.possibleProblematic ??= KCOptions.first.value;
    // model.value.violation ??= KCOptions.first.value;
    // model.value.cableMold ??= KCOptions.first.value;
    // model.value.handlingImmediatelyInspection ??= KCOptions.first.value;
  }

  @override
  Future updateData() async {
    if (!validateAllData(model.value)) {
      await showDialogValidateData();
      model.refresh();
      return;
    }

    Future offline({bool isOffline = true}) async {
      model.value.isUpdateOffline = isOffline;
      final result = await LocalDataManager.shared
          .saveLinePopup<LineUndergroundCable>(
              model.value,
              lineTicketController.ticketId,
              lineBranchInfo.id,
              popupsDataModel.equipmentId,
              workId: lineTicketController?.argument?.workModel?.workId,
              ticketType: lineTicketController?.argument?.ticketType,
              isOffline: isOffline,
              inspectionCategory: popupsDataModel.inspectionCategory);
      if (isOffline) {
        if (!result) {
          SnackBarHUD.show(AppStrings.updateOfflineFalse);
          return;
        }
        Get.back(result: true);
        SnackBarHUD.show('Cập nhật offline thành công');
      }
    }

    Future online() async {
      final params = {
        'equipmentId': popupsDataModel.equipmentId,
        'lineUndergroundCable': model.value.toJson()
      };

      final response = await repository.updateLinePopup(
          lineTicketController.ticketId, endPoint, params, lineBranchInfo.id);

      if (response.isLoadSuccess) {
        await offline(isOffline: false);
        Get.back(result: true);
        SnackBarHUD.show(response.message);
      } else {
        await showDialogError(response.message);
      }
    }

    final isHandleDataOnline = await lineTicketController.isHandleDataOnline();

    if (isHandleDataOnline) {
      await online();
    } else {
      await offline();
    }
  }
}

