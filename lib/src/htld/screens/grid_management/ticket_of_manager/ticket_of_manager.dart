// @dart=2.9
import 'package:evnmobile/src/app_common/utils/utils.dart';
import 'package:evnmobile/src/htld/common/components/app_button.dart';
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/option_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_single_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_single_text_field.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket_of_manager/ticket_of_manager_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketOfManagerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TicketOfManagerScreenState();
  }
}

class TicketOfManagerScreenState extends State<TicketOfManagerScreen> {
  final TicketOfManagerController _controller = TicketOfManagerController();
  final _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.ticketScreenArgument = Get.arguments;
    // Set gia tri default khi chua filter
    _controller.inspectionType = _controller.ticketScreenArgument.ticketType.code.toString();
    _controller.inspectType = _controller.ticketScreenArgument.subStationType.code.toString();
    
    final currentTime = DateTime.now();
    _controller.fromDate = DateTime(currentTime.year, currentTime.month, currentTime.day - 30).formatFirstDate();
    _controller.toDate = currentTime.formatSecondDate();
    _timeController.text = 'Từ ${DateTime(currentTime.year, currentTime.month, currentTime.day - 30).toStringFormat(AppStrings.ddMMyyyy)} đến ${currentTime.toStringFormat(AppStrings.ddMMyyyy)}';

    _controller.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.highlightColor70,
        leading: const BackButton(color: Colors.white,),
        title: Text(AppStrings.titleList, style: const TextStyle(color: Colors.white),),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _renderHeader(),
            _renderHeaderListItemHistory(),
            Expanded(child: Obx(() =>
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: _controller.listItemTicket.length,
                    itemBuilder: (ctx, index) => _renderHistoryItem(index, context)))
            )
          ],
        ),
      ),
    );
  }

  Widget _renderHeader() {
    final substationOptions = [
      OptionModel('Trạm biến áp phân phối', SubStationType.distribution.code),
      OptionModel('Trạm biến trung gian', SubStationType.intermediate.code),
      OptionModel('Đường dây trung áp', SubStationType.mediumVoltage.code)
    ];

    final ticketOptions = [
      OptionModel(TicketType.periodicDay.title.capitalizeFirst, TicketType.periodicDay.code),
      OptionModel(TicketType.periodicNight.title.capitalizeFirst, TicketType.periodicNight.code),
      OptionModel(TicketType.techDay.title.capitalizeFirst, TicketType.techDay.code),
      OptionModel(TicketType.fortuityDay.title.capitalizeFirst, TicketType.fortuityDay.code),
      OptionModel(TicketType.incidentDay.title.capitalizeFirst, TicketType.incidentDay.code)];

    final statusOptions = [
      OptionModel('Tất cả', 0),
      OptionModel('Chưa ký duyệt', 2),
      OptionModel('Đã ký duyệt', 5),
    ];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(flex: 6,
                  child: ESingleTextField(value: 'Công ty điện lực Hoàn Kiếm', isEnable: false,)),
              Expanded(flex: 5, child: ESingleDropDown(substationOptions,
                value: _controller.ticketScreenArgument.subStationType.code, onSelected: (value) {
                  _controller.inspectType = value;
                  _controller.fetchData();
                },))
            ],
          ),
          const SizedBox(height: 4,),
          Row(
            children: [
              Expanded(flex: 3, child: ESingleDropDown(ticketOptions,
                value: _controller.ticketScreenArgument.ticketType.code, onSelected: (value) {
                  _controller.inspectionType = value;
                  _controller.fetchData();
                },)),
              Expanded(flex: 3,
                  child: ESingleDropDown(
                    statusOptions, value: statusOptions.first.value, onSelected: (value) {
                    _controller.inspectionStatus = value;
                    _controller.fetchData();
                  },)),
              Expanded(
                flex: 5,
                child: GestureDetector(
                    onTap: () async {
                      await _showTimePicker(context);
                    },
                    child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded, color: Colors.black87, size: 20,),
                            const SizedBox(width: 16,),
                            Expanded(
                              child: TextField(
                                controller: _timeController,
                                decoration: const InputDecoration(
                                  enabled: false,
                                  border: InputBorder.none,
                                  hintText: 'Chọn khoảng thời gian',
                                  isDense: true,
                                ),
                              ),
                            ),
                          ],
                        ))),
              ),
            ],
          ),
          const SizedBox(height: 8,),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(flex: 2, child: renderSearchView()),
                    const SizedBox(
                      width: 10,
                    ),
                    EButton(
                        title: 'Tìm',
                        action: () {
                          _controller.fetchData();
                        })
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderHeaderListItemHistory() {
    const _typeTextHeader =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

    return Container(
      color: Colors.white,
      height: 60,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 1),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            child: const Text(
              'Ngày',
              style: _typeTextHeader,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
              padding: const EdgeInsets.only(left: 16),
              width: 100,
              child: const Text(
                'Số công việc kiểm tra',
                style: _typeTextHeader,
                textAlign: TextAlign.center,
              )),
          const Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Tên trạm',
                style: _typeTextHeader,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          Container(
              width: 100,
              child: const Text(
                'Loại',
                style: _typeTextHeader,
                textAlign: TextAlign.center,
              )),

          Container(
              width: 150,
              child: const Text(
                'Trạng thái',
                style: _typeTextHeader,
                textAlign: TextAlign.center,

              )),
          const Opacity(
            opacity: 0,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Icon(CupertinoIcons.pen),
            ),
          ),
          const SizedBox(width: 8,),
          const Opacity(
            opacity: 0,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.picture_as_pdf),
            ),
          )
        ],
      ),
    );
  }

  Widget _renderHistoryItem(int index, BuildContext context) {
    final model = _controller.listItemTicket[index];
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        color: Colors.white,
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(width: 80,
                child: Text(model.lastInspectTime.fromFormatServerToFormat(AppStrings.ddMMyyyy),
                  textAlign: TextAlign.center,)),
            Container(
                padding: const EdgeInsets.only(left: 16),
                width: 100,
                child: Text(model.code, textAlign: TextAlign.center)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(model.substationName, textAlign: TextAlign.center),
              ),
            ),
            Container(
                width: 100,
                child: Text(model.inspectionTypeName, textAlign: TextAlign.center,)),

            Container(
                width: 150,
                child: Text(model.statusName, textAlign: TextAlign.center,)),

            InkWell(
              onTap: () {

              },
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  CupertinoIcons.pen,
                  color: AppColor.highlightColor70
                  ,
                ),
              ),
            ),
            const SizedBox(width: 8,),
            InkWell(
              onTap: () {
                // Get.to(() => PdfView(model, _controller.ticketScreenArgument.subStationType));
              },
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.picture_as_pdf,
                  color: AppColor.highlightColor70
                  ,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final currentTime = DateTime.now();
    final picked = await showTimePickerSearch(
        context, DateTime(currentTime.year, currentTime.month, currentTime.day - 30), currentTime);
    if (picked != null) {
      _timeController.text =
      'Từ ${picked.start.toStringFormat(AppStrings.ddMMyyyy)} đến ${picked.end.toStringFormat(
          AppStrings.ddMMyyyy)}';
      _controller.fromDate =
          picked.start.formatFirstDate();
      _controller.toDate =
          picked.end.formatSecondDate();
      await _controller.fetchData();
    }
  }

  Widget renderSearchView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(width: 1, color: AppColor.borderColor1),
      ),
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.search, size: 24),
          const SizedBox(width: 8),
          Expanded(
              child: TextField(
                controller: TextEditingController(),
                onChanged: (value) {
                  _controller.searchTerm = value;
                },
                decoration: const InputDecoration(
                    hintText: 'Tìm kiếm theo tên, mã...',
                    border: InputBorder.none),
              )),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

