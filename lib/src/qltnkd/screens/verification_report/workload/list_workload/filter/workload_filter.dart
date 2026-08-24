// @dart=2.9
import 'package:evnmobile/src/app_common/utils/utils.dart';
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_date_time.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_dropdown.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/constance/strings.dart';
import '../../common/constance_workload.dart';
import '../../list_request/list_request_controller.dart';
import '../list_workload_controller.dart';

class WorkloadFilter extends StatefulWidget {
  @override
  State<WorkloadFilter> createState() => _WorkloadFilterState();
}

class _WorkloadFilterState extends State<WorkloadFilter> {
  final ListWorkloadController _controller = Get.find();

  final _timeController = TextEditingController();

  final _timeImplementController = TextEditingController();

  final ListRequestController _listRequestController = Get.find();

  DateTime fromDateTime = DateTime.now();

  DateTime toDateTime = DateTime.now();

  String fromDate = DateTime.now().formatFirstDate();

  String toDate = DateTime.now().formatSecondDate();

  DateTime fromDateTimeRequest = DateTime.now();

  DateTime toDateTimeRequest = DateTime.now();

  String fromDateRequest = DateTime.now().formatFirstDate();

  String toDateRequest = DateTime.now().formatSecondDate();
  String requestTicketType;

  String unit = '';

  @override
  void initState() {
    super.initState();

    if (_controller.toDate.isNotEmpty) {
      _timeController.text =
      'Từ ${_controller.fromDateTime.toStringFormat(RAppStrings.ddMMyyyy)} đến ${_controller.toDateTime.toStringFormat(RAppStrings.ddMMyyyy)}';
    }

    if (_listRequestController.toDate.isNotEmpty) {
      _timeImplementController.text =
      'Từ ${_listRequestController.fromDateTime.toStringFormat(RAppStrings.ddMMyyyy)} đến ${_listRequestController.toDateTime.toStringFormat(RAppStrings.ddMMyyyy)}';
    }

    fromDateTime = _controller.fromDateTime;
    toDateTime = _controller.toDateTime;
    fromDate = _controller.fromDate;
    toDate = _controller.toDate;
    fromDateTime = _listRequestController.fromDateTime;
    toDateTime = _listRequestController.toDateTime;
    fromDate = _listRequestController.fromDate;
    toDate = _listRequestController.toDate;
    unit = _controller.unit;
    requestTicketType = _controller.requestTicketType;
  }

  void _setFilterToPreviousState() {
    _controller.fromDateTime = fromDateTime;
    _controller.toDateTime = toDateTime;
    _controller.fromDate = fromDate;
    _controller.toDate = toDate;
    _listRequestController.fromDateTime = fromDateTime;
    _listRequestController.toDateTime = toDateTime;
    _listRequestController.fromDate = fromDate;
    _listRequestController.toDate = toDate;
    _controller.unit = unit;
    _controller.requestTicketType = requestTicketType;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        _setFilterToPreviousState();
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: false,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                _setFilterToPreviousState();
                Get.back();
              },
            ),
            title: const Text(
              'Bộ lọc',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RDateTime(
                      title: 'Ngày tạo',
                      onTap: () {
                        _showTimePicker(context);
                      },
                      isShowClear: true,
                      onClear: () {
                        _controller.fromDate = '';
                        _controller.toDate = '';
                        _timeController.text = '';
                      },
                      textController: _timeController,
                      margin: const EdgeInsets.only(bottom: 16),
                    ),
                    RDateTime(
                      title: 'Ngày thực hiện',
                      onTap: () {
                        _showTimePickerImplement(context);
                      },
                      isShowClear: true,
                      onClear: () {
                        _timeImplementController.text = '';
                        _listRequestController.fromDate = '';
                        _listRequestController.toDate = '';
                      },
                      textController: _timeImplementController,
                      margin: const EdgeInsets.only(bottom: 16),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RDropDown(
                          title: 'Loại phiếu yêu cầu',
                          options: TicketRequestType.listOption,
                          value: _controller.requestTicketType.toIntOrNull(),
                          parentMargin: const EdgeInsets.only(bottom: 16),
                          isHasDefaultValue: true,
                          onSelected: (value) {
                            _controller.requestTicketType = value;
                          },
                        ),
                        RDropDown(
                          title: 'Đơn vị yêu cầu',
                          value: _controller.unit,
                          options: _controller.unitOptions,
                          parentMargin: const EdgeInsets.only(bottom: 16),
                          isHasDefaultValue: true,
                          onSelected: (value) {
                            _controller.unit = value;
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          _buildButton()
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      padding: const EdgeInsets.all(PaddingSize.normal),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RButton(
              title: 'Bỏ lọc',
              color: RAppColor.backgroundColorGray,
              titleColor: Colors.black,
              action: () {
                _controller.clearFilter();
                Get.back(result: true);
              }),
          const SizedBox(
            width: 24,
          ),
          RButton(
            title: 'Áp dụng',
            action: () {
              Get.back(result: true);
            },
          )
        ],
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final arrDateSearch = await showTimePickerSearch(
        context, _controller.fromDateTime, _controller.toDateTime);
    if (arrDateSearch != null) {
      _timeController.text =
          'Từ ${arrDateSearch.start.toStringFormat(RAppStrings.ddMMyyyy)} đến ${arrDateSearch.end.toStringFormat(RAppStrings.ddMMyyyy)}';
      _controller.fromDateTime = arrDateSearch.start;
      _controller.toDateTime = arrDateSearch.end;
      _controller.fromDate = arrDateSearch.start.formatFirstDate();
      _controller.toDate = arrDateSearch.end.formatSecondDate();
    }
  }

  Future<void> _showTimePickerImplement(BuildContext context) async {
    final arrDateSearch = await showTimePickerSearch(
        context, _listRequestController.fromDateTime, _listRequestController.toDateTime);
    if (arrDateSearch != null) {
      _timeImplementController.text =
          'Từ ${arrDateSearch.start.toStringFormat(RAppStrings.ddMMyyyy)} đến ${arrDateSearch.end.toStringFormat(RAppStrings.ddMMyyyy)}';
      _listRequestController.fromDateTime = arrDateSearch.start;
      _listRequestController.toDateTime = arrDateSearch.end;
      _listRequestController.fromDate = arrDateSearch.start.formatFirstDate();
      _listRequestController.toDate = arrDateSearch.end.formatSecondDate();
    }
  }
}

