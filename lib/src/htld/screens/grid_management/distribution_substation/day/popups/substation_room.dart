// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/substation_room.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_controller.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/htld/services/responsitory/ticket_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../models/abnormal/abnormal_raw.dart';
import '../../../../../models/line/line_branch_info.dart';
import '../../../../../models/option_model.dart';
import '../../../../../models/popup_base_model.dart';
import '../../../../../services/responsitory/abnormal_repository.dart';
import '../../../containers/e_drop_down.dart';
import '../../../containers/e_text_area.dart';
import '../../../grid_management_controller.dart';
import '../../../medium_voltage_line/common/line_ticket_screen.dart';

abstract class BasePopupController extends GetxController {
  final repository = TicketRepository();
  final abnormalRepository = TAbnormalRepository();
  TicketController ticketController = Get.put(TicketController());
  GridManagementController gridManagementController = Get.find();
  PopupsDataModel popupsDataModel;
  List<OptionModelString> abnormalOptions = [];

  LineTicketController lineTicketController = Get.put(LineTicketController());
  LineBranchInfo lineBranchInfo;
  List<AbnormalRaw> abnormals = [];

  bool isEnable() {
    return lineTicketController?.argument?.isEdit() ?? false;
  }

  Future getData() async {
    await getAbnormalOptions(isBackground: false);
  }

  Future updateData();

  bool validateAllData(PopupBaseModel model) {
    return model.validateData() && validateAbnormal(model);
  }

  Future setAbnormal(
    String categoryName,
    PopupBaseModel model,
    String nameAbnormal,
    int index,
  ) async {
    model.abnormals ??= [];
    final abnormalOld = model.abnormals.firstWhereOrNull((element) => element.categoryIndex == index && element.abnormalId != null);
    if (abnormalOld != null) {
      abnormalOld.abnormalId = null;
    }
    final existAbnormal = abnormals?.firstWhereOrNull((element) => element.name == nameAbnormal);
    if (nameAbnormal != null) {
      if (existAbnormal != null) {
        final abnormal = TAbnormal(
            abnormalId: existAbnormal.id,
            categoryIndex: index,
            childCategory: categoryName,
            description: nameAbnormal);
        model.abnormals.add(abnormal);
      } else {
        final result = await addAbnormalOption(
            index: index, name: nameAbnormal, categoryName: categoryName);
        if (result != null) {
          model.abnormals.add(result);
        }
      }
    } else {
      final abnormal = model.abnormals.firstWhereOrNull((element) => element.categoryIndex == index && element.abnormalId != null);
      if (abnormal != null) {
        abnormal.abnormalId = null;
      }
    }
  }

  Future setAbnormalLine(String categoryName, PopupBaseModel model,
      String nameAbnormal, int index, int optionCategory) async {
    model.abnormals ??= [];
    final existAbnormal =
        abnormals?.firstWhereOrNull((element) => element.name == nameAbnormal);
    if (nameAbnormal != null) {
      if (existAbnormal != null) {
        final abnormalOld = model.abnormals.firstWhereOrNull((element) =>
        element.categoryIndex == index &&
            optionCategory == element.optionCategory && element.abnormalId != null);
        if (abnormalOld != null) {
          abnormalOld.abnormalId = null;
        }
        final abnormal = TAbnormal(
            abnormalId: existAbnormal.id,
            categoryIndex: index,
            optionCategory: optionCategory,
            childCategory: categoryName,
            description: nameAbnormal);
        model.abnormals.add(abnormal);
      } else {
        final result = await addAbnormalOption(
            index: index, name: nameAbnormal, categoryName: categoryName);
        if (result != null) {
          model.abnormals.add(result);
        }
      }
    } else {
      final abnormal =
          model.abnormals.where((element) => element.categoryIndex == index);
      if (abnormal != null) {
        abnormal.forEach((element) {
          element.abnormalId = null;
        });
      }
    }
  }

  Future getAbnormalOptions({bool isBackground}) async {
    if (gridManagementController?.argument?.ticketType == null) {
      return;
    }
    final response = await abnormalRepository.getAbnormalOptions(
        equipmentCategory: popupsDataModel.inspectionCategory,
        entityType: gridManagementController?.argument?.subStationType?.code,
        inspectionType: gridManagementController?.argument?.ticketType?.code,
        isBackground: isBackground ?? false);

    if (response.isLoadSuccess) {
      abnormals.clear();
      abnormals = List.empty(growable: true);
      abnormals.addAll(response.data.list);
    } else {
      abnormals = [];
      await showDialogOneButton(response.message);
    }
  }

  Future<TAbnormal> addAbnormalOption(
      {int index, String name, String categoryName}) async {
    final response = await abnormalRepository.addAbnormalOption(
      name: name,
      equipmentCategory: popupsDataModel.inspectionCategory,
      entityType: gridManagementController?.argument?.subStationType?.code,
      inspectionType: gridManagementController?.argument?.ticketType?.code,
    );

    if (response.isLoadSuccess) {
      abnormals.add(response.data);

      return TAbnormal(
          abnormalId: response.data.id,
          categoryIndex: index,
          childCategory: categoryName,
          description: name);
    } else {
      await showDialogOneButton(response.message);
      return null;
    }
  }

  // List<TAbnormal> _getListAbnormal(PopupBaseModel model) {
  //   model?.abnormals ??= [];
  //   return model?.abnormals ?? [];
  // }

  bool validateAbnormal(PopupBaseModel model) {
    //for line
    // if (lineBranchInfo != null) {
    //   for (final element in model.errorModels) {
    //     if (getAbnormalByCategoryIndex(model, element.index) == null) {
    //       return false;
    //     }
    //   }
    // } else {
    //   for (final element in model.unusually) {
    //     if (getAbnormalByCategoryIndex(model, element.index) == null) {
    //       return false;
    //     }
    //   }
    // }

    return true;
  }

// TAbnormal getAbnormalByCategoryIndex(
//     PopupBaseModel model, int categoryIndex) {
//   final list = _getListAbnormal(model)
//       ?.where((element) => element.categoryIndex == categoryIndex);
//   if (list.isNotEmpty) {
//     return list.first;
//   }
//   return null;
// }
}

class SubstationRoomController extends BasePopupController {
  Rx<SubstationRoom> model = SubstationRoom().obs;

  void setFieldIsExist(int value) {
    model?.value?.isExist = value;
    model?.value = model.value.copy();
    update();
  }

  void createDefaultIfNeeded() {
    model?.value?.isExist ??= CKOptions.first.value;
    // model?.value?.entrance ??= BTOptions.first.value;
    // model?.value?.vent ??= BTOptions.first.value;
    // model?.value?.lighting ??= BTOptions.first.value;
    // model?.value?.shield ??= BTOptions.first.value;
    //
    // model?.value?.possibleProblematic ??= KCOptions.first.value;
    // model?.value?.handlingInCheck ??= KCOptions.first.value;
  }

  @override
  void onInit() {
    super.onInit();
    createDefaultIfNeeded();
  }

  @override
  void refresh() {
    model.refresh();
    super.refresh();
  }

  String endPoint = 'substation-room';

  @override
  Future getData() async {
    await super.getData();
    final isConnectInternet = await Connection.shared.checkConnection();

    if (!isConnectInternet) {
      await getOffine(ticketController.ticketID);
      createDefaultIfNeeded();
    } else {
      // To do : check update time between LocalData and ServerData
      final response = await repository.getSubstationRoom(
        ticketController.ticketID,
        popupsDataModel.equipmentId,
      );

      if (response.isLoadSuccess) {
        model.value = response?.data ?? SubstationRoom();
        model.value.title = popupsDataModel.getPopupName();
        createDefaultIfNeeded();
        update();
      } else {
        await showDialogError(response.message);
      }
    }
  }

  @override
  Future updateData() async {
    final isConnectInternet = await Connection.shared.checkConnection();

    if (!isConnectInternet) {
      if (!validateAllData(model.value)) {
        await showDialogValidateData();
        model.refresh();
        return;
      }
      final params = {'substationRoom': model.value.toJson()};
      await updateOffine(params, ticketController.ticketID);
      Get.back(result: true);
    } else {
      if (!validateAllData(model.value)) {
        await showDialogValidateData();
        model.refresh();
        return;
      }
      final params = {'substationRoom': model.value.toJson()};
      await updateOffine(params, ticketController.ticketID);
      final response = await repository.updatePopup(
          ticketController.ticketID, endPoint, params);

      if (response.isLoadSuccess) {
        Get.back(result: true);
        SnackBarHUD.show(response.message);
      } else {
        await showDialogError(response.message);
      }
    }
  }

  Future<void> updateOffine(Map<String, dynamic> data, String ticketId) async {
    await LocalDataManager.shared
        .savePopup(endPoint, data, ticketId, popupsDataModel: popupsDataModel);
  }

  Future<void> getOffine(String ticketId) async {
    final data = await LocalDataManager.shared
        .getPopup(ticketId, equipmentId: popupsDataModel.equipmentId);
    model.value = SubstationRoom.fromJson(data['substationRoom']);
    model.value.title = popupsDataModel.getPopupName();
  }
}

class SubstationRoomPopup extends BasePopupWidget {
  SubstationRoomPopup({@required PopupsDataModel popupsDataModel}) {
    _controller.popupsDataModel = popupsDataModel;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  final SubstationRoomController _controller = SubstationRoomController();
  static String endPoint = 'substation-room';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EDropDown(CKOptions,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  index: 0,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  }),
              EDropDown(
                CKOptions,
                index: 1,
                enable: _controller.popupsDataModel.isAllowEdit,
                defaultValue: _controller.model.value.isExist,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  // _controller.setAbnormal(
                  //     categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                title: 'Hiện hữu:',
                onChange: (option, mess) {
                  if (option.value != _controller.model.value.isExist) {
                    _controller.model.value.clearAllProblem();
                    _controller.model.value.possibleProblematic = null;
                    _controller.model.value.entrance = null;
                    _controller.model.value.vent = null;
                    _controller.model.value.lighting = null;
                    _controller.model.value.shield = null;
                    _controller.model.value.handlingInCheck = null;
                    _controller.setFieldIsExist(option.value);
                  }
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              if (_controller.model.value.isExist == CKOptions.first.value)
                EDropDown(
                  BTNAOptions,
                  index: 2,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.entrance,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  title: 'Cửa ra vào:',
                  onChange: (option, mess) {
                    _controller.model.value.entrance = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  },
                ),
              if (_controller.model.value.isExist == CKOptions.first.value)
                EDropDown(
                  BTNAOptions,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  index: 3,
                  defaultValue: _controller.model.value.vent,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  title: 'Lỗ thông hơi:',
                  onChange: (option, mess) {
                    _controller.model.value.vent = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  },
                ),
              if (_controller.model.value.isExist == CKOptions.first.value)
                EDropDown(
                  BTNAOptions,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.lighting,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  index: 4,
                  title: 'Đèn chiếu sáng',
                  onChange: (option, mess) {
                    _controller.model.value.lighting = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  },
                ),
              if (_controller.model.value.isExist == CKOptions.first.value)
                EDropDown(
                  BTNAOptions,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.shield,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  index: 5,
                  title: 'Lưới chắn:',
                  onChange: (option, mess) {
                    _controller.model.value.shield = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  },
                ),
              if (_controller.model.value.isExist == CKOptions.first.value)
                ETextArea(
                    title: 'Các hiện tượng cụ thể:',
                    enable: _controller.popupsDataModel.isAllowEdit,
                    isRequire: true,
                    value: _controller.model.value.getSpecificPhenomena(),
                    onChange: (value) {
                      _controller.model.value.specificPhenomena = value;
                    }),
              if (_controller.model.value.isExist == CKOptions.first.value)
                EDropDown(
                  KCOptions,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.possibleProblematic,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  index: 6,
                  title: 'Có khả năng gây sự cố: ',
                  onChange: (option, mess) {
                    _controller.model.value.possibleProblematic = option.value;
                    _controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  },
                ),
              if (_controller.model.value.isExist == CKOptions.first.value)
                EDropDown(
                  KCOptions,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  defaultValue: _controller.model.value.handlingInCheck,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    // _controller.setAbnormal(
                    //     categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  index: 7,
                  title: 'Xử lý ngay trong kiểm tra:',
                  onChange: (option, mess) {
                    _controller.model.value.handlingInCheck = option.value;
                    //_controller.model.value.setUnusually(mess);
                  },
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  },
                ),
              if (_controller.model.value.isExist == CKOptions.first.value)
                ETextArea(
                  title: 'Đề xuất xử lý bất thường/ hư hỏng:',
                  enable: _controller.popupsDataModel.isAllowEdit,
                  isRequire: true,
                  value:
                      _controller.model.value.getSuggestedHandlingOfAbnormal(),
                  onChange: (value) {
                    _controller.model.value.suggestedHandlingOfAbnormal = value;
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

