// @dart=2.9
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/substation_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_search_view.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../app_common/utils/utils.dart';
import 'choose_substation_controller.dart';
import 'list_device_view.dart';

class ChooseSubStation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChooseSubStationState();
  }
}

class ChooseSubStationState extends State<ChooseSubStation> {
  final ChooseSubStationController _controller =
      Get.put(ChooseSubStationController());
  TicketScreenArgument argument;

  DateTime clickTime;

  final TextEditingController _editingController = TextEditingController();
  SubStationType _stationType;
  TicketType _ticketType;

  @override
  void initState() {
    super.initState();
    argument = Get.arguments;
    if (argument.inspectionModel != null) {
      _editingController.text = argument.inspectionModel.substationName ?? '';
    }
    getTicketType();
    Future.delayed(const Duration(milliseconds: 200), getDevices);
  }

  //MARK: View
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColor.highlightColor70,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Get.back(result: 'reload');
          },
        ),
        title: Text(
          'KIỂM TRA ${_stationType?.title?.toUpperCase()}',
          style: const TextStyle(fontSize: 16),
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10),
            child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                    'Loại kiểm tra: ${_ticketType?.title?.capitalizeFirst}',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)))),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              _renderHeader(),
              Obx(() {
                if (_controller.isSearching.value) {
                  return Container(
                    constraints:
                        const BoxConstraints(minWidth: 0, maxHeight: 400),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border:
                            Border.all(width: 1, color: AppColor.borderColor),
                        color: Colors.grey.shade100),
                    child: Scrollbar(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _controller.searchValues.length,
                          itemBuilder: (context, index) => _renderSearchItem(
                              _controller.searchValues[index])),
                    ),
                  );
                }
                if (_controller.isSelectedSubstation.value) {
                  return Expanded(
                      child: ListDeviceView(
                          submitTitle: (argument.inspectionModel != null ||
                                  argument.ticketId != null)
                              ? 'Sửa'
                              : 'Khởi tạo',
                          create: () {
                            if (!isClickAble(
                                (p0) => clickTime = p0, clickTime)) {
                              return;
                            }
                            _createTicket();
                          }));
                }
                return Container();
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          // Nếu đã có mã phiếu thì chỉ có thể sửa , ko thể tạo mới phiếu
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ESearchView(
            hint: 'Tìm kiếm theo mã, tên TBA...',
            isHasClear: true,
            enable: argument.inspectionModel == null &&
                argument.ticketId == null &&
                argument.workId == null,
            editingController: _editingController,
            onSubmitted: (value) {
              _controller.search(value, _stationType.code.toString());
            },
          ),
        ),
      ],
    );
  }

  Widget _renderSearchItem(SubstationModel substationModel) {
    return GestureDetector(
      onTap: () {
        _handleChooseSearchItem(substationModel);
      },
      child: Container(
        color: Colors.white,
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 55,
        child: Text(substationModel?.name),
      ),
    );
  }

  //MARK: Functions
  void _createTicket() {
    if (_controller.isHanding) {
      return;
    }
    _controller.isHanding = true;
    if (_ticketType == TicketType.periodicNight) {
      _controller.checkAllDevices(value: true);
    }
    argument.equipments = _controller.getDevicesSelected();
    argument.substationModel =
        _controller.substationSelected ?? argument.substationModel;
    argument.ticketType = _ticketType;
    argument.subStationType = _stationType;
    if (_controller.getDevicesSelected().isEmpty) {
      showDialogError('Không có thiết bị để thực hiện kiểm tra.');
      _controller.isHanding = false;
      return;
    }
    _controller.isHanding = false;
    Get.to(() => TicketScreen(
          ticketScreenArgument: argument,
        ));
  }

  void _handleChooseSearchItem(SubstationModel substationModel) {
    if (substationModel.id == null) {
      return;
    }
    _controller.substationSelected = substationModel;
    _editingController.text = substationModel?.name ?? '';
    _controller.isSearching.value = false;
    _controller.isSelectedSubstation.value = true;
    _controller.getEquipments(substationModel?.id ?? '',
        inspectType: _stationType.code.toString(),
        ticketType: _ticketType.code.toString());
  }

  void getTicketType() {
    final argument = Get.arguments;
    if (argument is TicketScreenArgument) {
      _stationType = argument.subStationType;
      _ticketType = argument.ticketType;
    }
  }

  void getDevices() {
    if (argument?.inspectionModel != null) {
      final inspectionModel = argument.inspectionModel;
      _editingController.text = inspectionModel.substationName ?? '';
      _controller.getEquipments(inspectionModel.substationId ?? '',
          ticketId: inspectionModel.id,
          inspectType: _stationType.code.toString(),
          ticketType: _ticketType.code.toString());
    }
    if (argument.substationModel != null) {
      final substationModel = argument.substationModel;
      _editingController.text = substationModel.name ?? '';
      _controller.getEquipments(substationModel.id ?? '',
          ticketId: argument.ticketId,
          inspectType: _stationType.code.toString(),
          ticketType: _ticketType.code.toString());
    }
  }
}

