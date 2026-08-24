// @dart=2.9
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/line/line_branch_info.dart';
import 'package:evnmobile/src/htld/models/line/line_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/choose_line/choose_line_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/choose_line/list_line_ht_view.dart';
import 'package:evnmobile/src/htld/screens/grid_management/choose_line/list_line_view.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_search_view.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/line_ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../app_env.dart';
import '../../../../app_common/shared/app_shared.dart';
import 'choose_line_popup.dart';

class BranchArgument {
  LineBranchInfo lineBranchInfo;
  ChooseLineEnum chooseLineEnum;
  List<String> listBranchSelected;

  BranchArgument(
      {this.lineBranchInfo, this.chooseLineEnum, this.listBranchSelected});
}

class ChooseLineScreen extends StatefulWidget {
  @override
  _ChooseLineScreenState createState() => _ChooseLineScreenState();

  final BranchArgument testArgument = Get.arguments;
}

class _ChooseLineScreenState extends State<ChooseLineScreen> {
  final ChooseLineController _controller = Get.put(ChooseLineController());
  final LineTicketController _lineTicketController = Get.find();

  final TextEditingController _editingController = TextEditingController();

  void showPopup() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChooseLinePopup(
                  title: 'Hướng dẫn',
                  description1:
                      'Chọn 1 nút: Bạn nhấn chọn nút muốn kiểm tra và giữ khoảng 2 giây đến khi xuất hiện loading trên màn hình.',
                  description2:
                      'Chọn khoảng nút: Bạn nhấn chọn 2 nút trong danh sách nút trên màn hình.',
                  buttonTitle: 'Đã hiểu',
                  actions: <Widget>[
                    Container(
                      height: 60,
                      width: 150,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.highlightColor70,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 40),
                            child: Text(
                              'Đã hiểu',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      final dialogOpen = prefs.getInt('dialog_open') ?? 0;
      if (dialogOpen == 0 &&
          widget?.testArgument?.chooseLineEnum == ChooseLineEnum.createTicket) {
        Future.delayed(const Duration(microseconds: 1000), () {
          showPopup();
          prefs.setInt('dialog_open', 1);
        });
      }
    });
    _editingController.text =
        _lineTicketController.argument.inspectionModel?.substationName ??
            _lineTicketController.argument?.workModel?.line?.name ??
            '';
  }

  //MARK: View
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
            child: IconButton(
              icon: const Icon(Icons.help),
              iconSize: 25,
              onPressed: () {
                showPopup();
              },
            ),
          )
        ],
        backgroundColor: AppColor.highlightColor70,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        title: Text(
          AppShared.instance.getAppType() == AppType.HTLDHT
              ? 'KIỂM TRA CÔNG TRÌNH HẠ ÁP'
              : 'KIỂM TRA ĐƯỜNG DÂY TRUNG ÁP',
          style: TextStyle(fontSize: 16),
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10),
            child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                    'Loại kiểm tra: ${_lineTicketController.argument.ticketType?.title?.capitalizeFirst}',
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
                height: 24,
              ),
              _renderHeader(),
              Obx(() {
                if (_controller.isSearching.value) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _controller.searchValues.length,
                          itemBuilder: (context, index) => _renderSearchItem(
                              _controller.searchValues[index])),
                    ),
                  );
                }
                return Expanded(
                    child: AppShared.instance.getAppType() == AppType.HTLDHT
                        ? ListLineHTView(
                            lineModel: _controller.substationSelected.value,
                            chooseLineEnum:
                                widget?.testArgument?.chooseLineEnum ??
                                    ChooseLineEnum.createTicket,
                            lineBranchInfo:
                                widget?.testArgument?.lineBranchInfo,
                            listBranchSelected:
                                widget?.testArgument?.listBranchSelected ?? [],
                          )
                        : ListLineView(
                            lineModel: _controller.substationSelected.value,
                            chooseLineEnum:
                                widget?.testArgument?.chooseLineEnum ??
                                    ChooseLineEnum.createTicket,
                            lineBranchInfo:
                                widget?.testArgument?.lineBranchInfo,
                            listBranchSelected:
                                widget?.testArgument?.listBranchSelected ?? [],
                          ));
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ESearchView(
            hint: 'Tìm kiếm theo mã, tên TBA...',
            isHasClear: true,
            isHasScanQR: true,
            enable: _lineTicketController.argument.inspectionModel == null &&
                _lineTicketController.argument.workModel == null,
            editingController: _editingController,
            onSubmitted: (value) {
              _controller.search(value);
            },
          ),
        ),
      ],
    );
  }

  Widget _renderSearchItem(LineModel lineModel) {
    return GestureDetector(
      onTap: () {
        _handleChooseSearchItem(lineModel);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.grey.shade50),
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(lineModel?.name)),
            const SizedBox(
              width: 16,
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.black54,
            )
          ],
        ),
      ),
    );
  }

  //MARK: Functions

  void _handleChooseSearchItem(LineModel lineModel) {
    if (lineModel.id == null) {
      return;
    }
    _controller.substationSelected.value = lineModel;
    _editingController.text = lineModel?.name ?? '';
    _controller.isSearching.value = false;
    _controller.isSelectedSubstation.value = true;
    _controller.getLineChilds(lineModel);
  }

  void getDevices() {
    if (_lineTicketController.argument?.inspectionModel != null) {
      final inspectionModel = _lineTicketController.argument.inspectionModel;
      _editingController.text = inspectionModel.substationName ?? '';
    }
  }
}

