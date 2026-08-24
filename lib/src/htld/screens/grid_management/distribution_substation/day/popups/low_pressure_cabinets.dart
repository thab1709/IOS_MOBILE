// @dart=2.9
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/low_pressure_cabinet.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_text_area.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_text_field.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/popups/substation_room.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LowPressureCabinetPopup extends BasePopupWidget {
  LowPressureCabinetPopup({@required PopupsDataModel popupsDataModel}) {
    _controller.popupsDataModel = popupsDataModel;
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  static String endPoint = 'low-pressure-cabinet';
  final _controller = _LowPressureCabinetController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EDropDown(CKOptions,
                  index: 0,
                  enable: _controller.popupsDataModel.isAllowEdit,
                  onSelectedAbnormalOption: (categoryName, abnormal, index) {
                    _controller.setAbnormal(
                        categoryName, _controller.model.value, abnormal, index);
                  },
                  images: _controller.model.value.images,
                  onAttachImages: (images, index) {
                    _controller.model.value.setImages(images, index);
                  }),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                child: Text(
                  'Thông số vận hành',
                  style: TextStyle(
                      color: AppColor.highlightColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              if (Get.context.isPhone) _renderMBAForMobile() else _renderMBA(),
              EDropDown(
                BTOptions,
                title: 'Tình trạng:',
                enable: _controller.popupsDataModel.isAllowEdit,
                index: 1,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.operationStatus,
                onChange: (option, mess) {
                  _controller.model.value.operationStatus = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                NVGTOption,
                index: 2,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.appearance,
                title: 'Tình trạng bên ngoài:',
                onChange: (option, mess) {
                  _controller.model.value.appearance = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                index: 3,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.doorWedge,
                title: 'Nêm cửa',
                onChange: (option, mess) {
                  _controller.model.value.doorWedge = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                index: 4,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.clearance,
                title: 'Khoảng hở giữa ống luồn cáp và đáy tủ hạ áp',
                onChange: (option, mess) {
                  _controller.model.value.clearance = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTOptions,
                index: 5,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.contactSurface,
                title: 'Thiết bị đóng cắt',
                onChange: (option, mess) {
                  _controller.model.value.contactSurface = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                index: 6,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.fixedClamp,
                title:
                    'Bề mặt tiếp xúc giữa đầu cốt cáp hạ áp và đầu cực các thiết bị đóng cắt hạ áp:',
                onChange: (option, mess) {
                  _controller.model.value.fixedClamp = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                index: 7,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.fixedClamp,
                title: 'Kẹp cố định giữa các dây dẫn hạ áp ',
                onChange: (option, mess) {
                  _controller.model.value.fixedClamp = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTNAOptions,
                index: 8,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.meteringSystem,
                title: 'Hệ thống đo đếm:',
                onChange: (option, mess) {
                  _controller.model.value.meteringSystem = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                BTHHNAOptions,
                index: 9,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.workingMeter,
                title: 'Công tơ làm việc:',
                onChange: (option, mess) {
                  _controller.model.value.workingMeter = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              // ETextArea(
              //   title: 'Điện áp tại trạm',
              //   value: _controller.model.value.voltage,
              //   onChange: (value) {
              //     _controller.model.value.voltage = value;
              //   },
              // ),
              EDropDown(
                BTOptions,
                index: 10,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.housingGrounding,
                title: 'Nối đất vỏ tủ: ',
                onChange: (option, mess) {
                  _controller.model.value.housingGrounding = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                title: 'Các hiện tượng cụ thể: ',
                isRequire: true,
                enable: _controller.popupsDataModel.isAllowEdit,
                value: _controller.model.value.getSpecificPhenomena(),
                onChange: (value) {
                  _controller.model.value.specificPhenomena = value;
                },
              ),
              EDropDown(
                KCOptions,
                index: 11,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  _controller.setAbnormal(
                      categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.possibleProblematic,
                title: 'Có khả năng gây sự cố: ',
                onChange: (option, mess) {
                  _controller.model.value.possibleProblematic = option.value;
                  _controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              EDropDown(
                KCOptions,
                index: 12,
                onSelectedAbnormalOption: (categoryName, abnormal, index) {
                  // _controller.setAbnormal(
                  //     categoryName, _controller.model.value, abnormal, index);
                },
                enable: _controller.popupsDataModel.isAllowEdit,
                images: _controller.model.value.images,
                defaultValue: _controller.model.value.handlingInCheck,
                title: 'Xử lý ngay trong kiểm tra:',
                onChange: (option, mess) {
                  _controller.model.value.handlingInCheck = option.value;
                  //_controller.model.value.setUnusually(mess);
                },
                onAttachImages: (images, index) {
                  _controller.model.value.setImages(images, index);
                },
              ),
              ETextArea(
                title: 'Đề xuất xử lý bất thường/ hư hỏng:',
                isRequire: true,
                enable: _controller.popupsDataModel.isAllowEdit,
                value: _controller.model.value.getSuggestedHandlingOfAbnormal(),
                onChange: (value) {
                  _controller.model.value.suggestedHandlingOfAbnormal = value;
                },
              ),
            ],
          )),
    );
  }

  Widget _renderMBA() {
    final fields2 = <Map<String, String>>[
      {'title': 'UhA(V)', 'id': 'uhA'},
      {'title': 'IhA(A)', 'id': 'ihA'},
      {'title': '', 'id': ''},
      {'title': 'CosΦ A', 'id': 'cosA'},
      {'title': 'UhB(V)', 'id': 'uhB'},
      {'title': 'IhB(A)', 'id': 'ihB'},
      {'title': 'I0(A)', 'id': 'i0'},
      {'title': 'CosΦ B', 'id': 'cosB'},
      {'title': 'UhC(V)', 'id': 'uhC'},
      {'title': 'IhC(A)', 'id': 'ihC'},
      {'title': '', 'id': ''},
      {'title': 'CosΦ C', 'id': 'cosC'},
    ];

    return Obx(() => GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          childAspectRatio: 6 / 3,
          physics: const NeverScrollableScrollPhysics(),
          children: fields2.mapIndexed((e, i) {
            final title = e['title'];
            final key = e['id'];
            final value = _controller.model.value == null
                ? ''
                : _controller.model.value.toJson()[key];
            return title.isEmpty
                ? Container()
                : ETextField(
                    horizontalPadding: 6,
                    title: title,
                    isRequire: true,
                    spaceBetween: 4,
                    contentHorizontalPadding: 4,
                    textAlign: TextAlign.center,
                    value: value,
                    onChange: (value) {
                      _controller.model.value.addValueForKey(key, value);
                    });
          }).toList(),
        ));
  }

  Widget _renderMBAForMobile() {
    final dataPageOne = <Map<String, String>>[
      {'title': 'UhA(V)', 'id': 'uhA'},
      {'title': 'UhB(V)', 'id': 'uhB'},
      {'title': 'UhC(V)', 'id': 'uhC'},
    ];

    final dataPageTwo = <Map<String, String>>[
      {'title': 'IhA(A)', 'id': 'ihA'},
      {'title': 'IhB(A)', 'id': 'ihB'},
      {'title': 'IhC(A)', 'id': 'ihC'},
      {'title': 'I0(A)', 'id': 'i0'},
    ];

    final dataPageThree = <Map<String, String>>[
      {'title': 'CosΦ A', 'id': 'cosA'},
      {'title': 'CosΦ B', 'id': 'cosB'},
      {'title': 'CosΦ C', 'id': 'cosC'},
    ];

    Widget buildDot(int index) {
      return Obx(() => Container(
            margin: const EdgeInsets.all(8),
            height: 10,
            width: 10,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _controller.pageIndex.value == index
                    ? AppColor.highlightColor70
                    : Colors.grey),
          ));
    }

    Widget buildIndicator() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildDot(0),
          buildDot(1),
          buildDot(2),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
      height: 280,
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.highlightColor70),
          borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Expanded(
            child: PageView(
              scrollDirection: Axis.horizontal,
              controller: PageController(initialPage: 0),
              onPageChanged: (index) {
                _controller.pageIndex.value = index;
              },
              children: [
                _renderPage(dataPageOne),
                _renderPage(dataPageTwo),
                _renderPage(dataPageThree),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          buildIndicator()
        ],
      ),
    );
  }

  Widget _renderPage(List<Map<String, String>> data) {
    return Obx(() => GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          childAspectRatio: 6 / 4,
          physics: const NeverScrollableScrollPhysics(),
          children: data.mapIndexed((e, i) {
            final title = e['title'];
            final key = e['id'];
            final value = _controller.model.value == null
                ? ''
                : _controller.model.value.toJson()[key];
            return title.isEmpty
                ? Container()
                : ETextField(
                    horizontalPadding: 6,
                    isRequire: true,
                    title: title,
                    spaceBetween: 4,
                    contentHorizontalPadding: 4,
                    textAlign: TextAlign.center,
                    value: value,
                    onChange: (value) {
                      _controller.model.value.addValueForKey(key, value);
                    });
          }).toList(),
        ));
  }

  @override
  void saveData() {
    _controller.updateData();
  }
}

class _LowPressureCabinetController extends BasePopupController {
  final model = LowPressureCabinetModel().obs;

  final pageIndex = 0.obs;

  String endPoint = 'low-pressure-cabinet';

  void createDefaultIfNeeded() {
    // model.value?.operationStatus ??= BTNVCPBOptions.first.value;
    // model.value?.appearance ??= NVGTOption.first.value;
    // model.value?.doorWedge ??= BTOptions.first.value;
    // model.value?.clearance ??= BTOptions.first.value;
    // model.value?.contactSurface ??= BTOptions.first.value;
    // model.value?.fixedClamp ??= BTOptions.first.value;
    // model.value?.meteringSystem ??= BTOptions.first.value;
    // model.value?.workingMeter ??= BTHHOptions.first.value;
    // model.value?.housingGrounding ??= BTOptions.first.value;
    // model.value?.possibleProblematic ??= KCOptions.first.value;
    // model.value?.handlingInCheck ??= KCOptions.first.value;
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

  @override
  Future getData() async {
    await super.getData();
    final isConnectInternet = await Connection.shared.checkConnection();

    if (!isConnectInternet) {
      await getOffine(ticketController.ticketID);
    } else {
      // To do : check update time between LocalData and ServerData
      final response = await repository.getLowPressureCabinet(
          ticketController.ticketID, popupsDataModel.equipmentId, endPoint);

      if (response.isLoadSuccess) {
        model.value = response?.data ?? LowPressureCabinetModel();
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
      final params = {
        'equipmentId': popupsDataModel.equipmentId,
        'lowPressureCabinet': model.value.toJson()
      };
      await updateOffine(params, ticketController.ticketID);
      Get.back(result: true);
    } else {
      if (!validateAllData(model.value)) {
        await showDialogValidateData();
        model.refresh();
        return;
      }
      final params = {
        'equipmentId': popupsDataModel.equipmentId,
        'lowPressureCabinet': model.value.toJson()
      };
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
    model.value = LowPressureCabinetModel.fromJson(data['lowPressureCabinet']);
    model.value.title = popupsDataModel.getPopupName();
  }
}

