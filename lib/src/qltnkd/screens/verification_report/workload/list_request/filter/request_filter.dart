// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_dropdown.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../app_common/utils/utils.dart';
import '../../../../../common/components/r_date_time.dart';
import '../../../../../common/constance/strings.dart';
import '../../common/constance_workload.dart';
import '../list_request_controller.dart';

class RequestFilter extends StatefulWidget {
  @override
  State<RequestFilter> createState() => _RequestFilterState();
}

class _RequestFilterState extends State<RequestFilter> {
  final ListRequestController _controller = Get.find();
  final _timeController = TextEditingController();

  String unit = '';
  String fromDate = DateTime.now().formatFirstDate();
  String toDate = DateTime.now().formatSecondDate();
  DateTime fromDateTime = DateTime.now();
  DateTime toDateTime = DateTime.now();
  int ticketRequestType = 0;


  @override
  void initState() {
    super.initState();
    if (_controller.toDate.isNotEmpty) {
      _timeController.text =
      'Từ ${_controller.fromDateTime.toStringFormat(RAppStrings.ddMMyyyy)} đến ${_controller.toDateTime.toStringFormat(RAppStrings.ddMMyyyy)}';
    }

    unit = _controller.unit;
    fromDate = _controller.fromDate;
    toDate = _controller.toDate;
    fromDateTime = _controller.fromDateTime;
    toDateTime = _controller.toDateTime;
    ticketRequestType = _controller.ticketRequestType;
  }

  void _setFilterToPreviousState() {
    _controller.unit = unit;
    _controller.fromDate = fromDate;
    _controller.toDate = toDate;
    _controller.fromDateTime = fromDateTime;
    _controller.toDateTime = toDateTime;
    _controller.ticketRequestType = ticketRequestType;
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RDateTime(
                          title: 'Ngày thực hiện',
                          onClear: () {
                            _timeController.text = '';
                            _controller.fromDate = '';
                            _controller.toDate = '';
                            _controller.fromDateTime = DateTime.now();
                            _controller.toDateTime = DateTime.now();
                          },
                          isShowClear: true,
                          onTap: () {
                            _showTimePicker(context);
                          },
                          textController: _timeController,
                        ),
                        RDropDown(
                          title: 'Đơn vị',
                          options: _controller.unitOptions,
                          value: _controller.unit,
                          parentMargin: const EdgeInsets.only(bottom: 16),
                          isHasDefaultValue: true,
                          onSelected: (value) {
                            _controller.unit = value;
                          },
                        ),
                        RDropDown(
                          title: 'Loại phiếu',
                          value: _controller.ticketRequestType,
                          options: TicketRequestType.listOption,
                          parentMargin: const EdgeInsets.only(bottom: 16),
                          isHasDefaultValue: true,
                          onSelected: (value) {
                            _controller.ticketRequestType = value.toIntOrNull();
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
    final arrDateSearch =
    await showTimePickerSearch(context, _controller.fromDateTime, _controller.toDateTime);
    if (arrDateSearch != null) {
      _timeController.text =
      'Từ ${arrDateSearch.start.toStringFormat(RAppStrings.ddMMyyyy)} đến ${arrDateSearch.end.toStringFormat(RAppStrings.ddMMyyyy)}';
      _controller.fromDateTime = arrDateSearch.start;
      _controller.toDateTime = arrDateSearch.end;
      _controller.fromDate = arrDateSearch.start.formatFirstDate();
      _controller.toDate = arrDateSearch.end.formatSecondDate();
    }
  }
}

