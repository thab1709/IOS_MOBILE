// @dart=2.9
import 'package:evnmobile/src/htdct/common/components/app_bar_common.dart';
import 'package:evnmobile/src/htdct/common/components/button_40.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htdct/models/day_night/ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../app_common/shared/app_shared.dart';
import '../../../../htdct/common/constance/app_color.dart';
import '../../../common/constance/app_icon.dart';
import '../../../common/constance/strings.dart';
import '../../../common/enum/ticket_enum.dart';
import '../../../common/themes/styles.dart';
import '../../../models/log_book/group_note_info_model.dart';
import '../../../models/log_book/operation_model.dart';
import '../../../models/profile_model.dart';
import '../../grid_management/containers/e_button.dart';
import '../../grid_management/transformer/transformer_ticket_controller.dart';
import '../common/content_option.dart';
import '../group_check_logs/group_check_log_screen.dart';
import '../operation_logs/operation_log_screen.dart';
import 'test_plan_controller.dart';

class TestPlanView extends StatefulWidget {
  const TestPlanView();

  @override
  State<TestPlanView> createState() => _TestPlanViewState();
}

class _TestPlanViewState extends State<TestPlanView>
    implements HistoryCheckDelegate {
  final TestPlanController _controller = TestPlanController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormFieldState> _keyTypeEvents = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyGroup = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyUser = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyTBA = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyLine = GlobalKey<FormFieldState>();

  _TestPlanViewState();

  Future<void> _showFilter() async {
    if (_controller.fromDateTime != null && _controller.toDateTime != null) {
      _controller.timeController.value.text =
          '${_controller.fromDateTime.toStringFormat(HighElectricStrings.ddMMyyyy)} - ${_controller.toDateTime.toStringFormat(HighElectricStrings.ddMMyyyy)}';
    } else {
      _controller.timeController.value.text = null;
    }
    if (_controller.fromDateTimeWork != null &&
        _controller.toDateTimeWork != null) {
      _controller.timeWorkController.value.text =
          '${_controller.fromDateTimeWork.toStringFormat(HighElectricStrings.ddMMyyyy)} - ${_controller.toDateTimeWork.toStringFormat(HighElectricStrings.ddMMyyyy)}';
    } else {
      _controller.timeWorkController.value.text = null;
    }
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Obx(() => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)), //this right here
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Bộ lọc',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(Icons.close))
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              //chọn loại sự kiện
                              MultiSelectDialogField(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: Colors.grey.shade300)),
                                key: _keyTypeEvents,
                                cancelText: const Text('Hủy'),
                                title: Text(_controller.ticketType ==
                                        TicketType.operationLog
                                    ? 'Loại sự kiện'
                                    : 'Đoàn kiểm tra'),
                                buttonText: Text(
                                    _controller.ticketType ==
                                            TicketType.operationLog
                                        ? 'Chọn loại sự kiện'
                                        : 'Chọn đoàn kiểm tra',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: HighElectricAppColor.nature04)),
                                buttonIcon: const Icon(Icons.arrow_drop_down),
                                initialValue:
                                    _controller.listTypeEventsSelected,
                                items: _controller.listTypeEvents
                                    .map((e) => MultiSelectItem(e, e.title))
                                    .toList(),
                                listType: MultiSelectListType.LIST,
                                onConfirm: (values) {
                                  _controller.listTypeEventsSelected = values;
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              MultiSelectDialogField(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: Colors.grey.shade300)),
                                key: _keyGroup,
                                cancelText: const Text('Hủy'),
                                title: const Text('Đội/Phòng'),
                                buttonText: const Text('Chọn Đội/Phòng',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: HighElectricAppColor.nature04)),
                                buttonIcon: const Icon(Icons.arrow_drop_down),
                                initialValue: _controller.listGroupSelected,
                                items: _controller.listGroup
                                    .map((e) => MultiSelectItem(e, e.title))
                                    .toList(),
                                listType: MultiSelectListType.LIST,
                                onConfirm: (values) async {
                                  _controller.listGroupSelected = values;
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              if (_controller.ticketType ==
                                  TicketType.operationLog)
                                MultiSelectDialogField(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Colors.grey.shade300)),
                                  key: _keyUser,
                                  cancelText: const Text('Hủy'),
                                  title: const Text('Người tạo'),
                                  buttonText: const Text('Chọn người tạo',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              HighElectricAppColor.nature04)),
                                  buttonIcon: const Icon(Icons.arrow_drop_down),
                                  initialValue: _controller.listUserSelected,
                                  items: _controller.listUser
                                      .map((e) => MultiSelectItem(e, e.title))
                                      .toList(),
                                  listType: MultiSelectListType.LIST,
                                  onConfirm: (values) async {
                                    _controller.listUserSelected = values;
                                  },
                                ),

                              //chọn TBA/Đường dây
                              MultiSelectDialogField(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: Colors.grey.shade300)),
                                key: _keyTBA,
                                cancelText: const Text('Hủy'),
                                title: const Text('Trạm'),
                                buttonText: const Text('Chọn trạm',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: HighElectricAppColor.nature04)),
                                buttonIcon: const Icon(Icons.arrow_drop_down),
                                initialValue: _controller.listTBASelected,
                                items: _controller.listTBA
                                    .map((e) => MultiSelectItem(e, e.title))
                                    .toList(),
                                listType: MultiSelectListType.LIST,
                                onConfirm: (values) {
                                  _controller.listTBASelected = values;
                                },
                              ),
                              // if (_controller.ticketType ==
                              //     TicketType.operationLog)
                              //   Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       const SizedBox(
                              //         height: 8,
                              //       ),
                              //       MultiSelectDialogField(
                              //         decoration: BoxDecoration(
                              //             borderRadius:
                              //                 BorderRadius.circular(4),
                              //             border: Border.all(
                              //                 color: Colors.grey.shade300)),
                              //         key: _keyLine,
                              //         cancelText: const Text('Hủy'),
                              //         title: const Text('Đường dây'),
                              //         buttonText: const Text('Chọn đường dây',
                              //             style: TextStyle(
                              //                 fontSize: 16,
                              //                 fontWeight: FontWeight.w400,
                              //                 color: HighElectricAppColor
                              //                     .nature04)),
                              //         buttonIcon:
                              //             const Icon(Icons.arrow_drop_down),
                              //         // initialValue: _controller.groupID.value,
                              //         items: _controller.listLine
                              //             .map((e) =>
                              //                 MultiSelectItem(e, e.title))
                              //             .toList(),
                              //         listType: MultiSelectListType.LIST,
                              //         onConfirm: (values) async {
                              //           // _controller.groupID.value = values;
                              //         },
                              //       ),
                              //       const Padding(
                              //         padding:
                              //             EdgeInsets.symmetric(vertical: 8),
                              //         child: Text(
                              //           'Chọn thời gian Bắt đầu - Kết thúc',
                              //           style: Styles.titleTextField,
                              //         ),
                              //       ),
                              //       GestureDetector(
                              //
                              //           onTap: () async {
                              //             await _showTimePicker(context,
                              //                 toDate: _controller.toWorkDate,
                              //                 fromDate:
                              //                     _controller.fromWorkDate,
                              //                 fromDateTime:
                              //                     _controller.fromDateTimeWork,
                              //                 timeController: _controller
                              //                     .timeWorkController.value,
                              //                 toDateTime:
                              //                     _controller.toDateTimeWork,
                              //                 isCreateTime: false);
                              //             _controller
                              //                 .timeWorkController.refresh();
                              //           },
                              //           child: Container(
                              //               padding: const EdgeInsets.all(6),
                              //               decoration: BoxDecoration(
                              //                   borderRadius:
                              //                       BorderRadius.circular(5),
                              //                   border: Border.all(
                              //                       width: 1,
                              //                       color:
                              //                           Colors.grey.shade300)),
                              //               child: Row(
                              //                 children: [
                              //                   Expanded(
                              //                     child: Obx(()=>TextField(
                              //                       controller: _controller
                              //                           .timeWorkController.value,
                              //                       decoration:
                              //                           const InputDecoration(
                              //                         enabled: false,
                              //                         border: InputBorder.none,
                              //                         hintText:
                              //                             'Chọn khoảng thời gian',
                              //                         isDense: true,
                              //                       ),
                              //                     ),
                              //                   ),),
                              //                   const SizedBox(
                              //                     width: 16,
                              //                   ),
                              //                   const Padding(
                              //                     padding: EdgeInsets.only(
                              //                         right: 10),
                              //                     child: Icon(
                              //                       Icons.calendar_today,
                              //                       color: HighElectricAppColor
                              //                           .nature05,
                              //                       size: 20,
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ))),
                              //     ],
                              //   ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  _controller.ticketType ==
                                          TicketType.operationLog
                                      ? 'Chọn thời gian bắt đầu'
                                      : 'Chọn thời gian kiểm tra',
                                  style: Styles.titleTextField,
                                ),
                              ),

                              GestureDetector(
                                  onTap: () async {
                                    await _showTimePicker(context,
                                        fromDateTime: _controller.fromDateTime,
                                        timeController:
                                            _controller.timeController.value,
                                        toDateTime: _controller.toDateTime,
                                        isCreateTime: true);
                                    _controller.timeController.refresh();
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey.shade300)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Obx(
                                            () => TextField(
                                              controller: _controller
                                                  .timeController.value,
                                              decoration: const InputDecoration(
                                                enabled: false,
                                                border: InputBorder.none,
                                                hintText:
                                                    'Chọn khoảng thời gian',
                                                isDense: true,
                                              ),
                                            ),
                                          )),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.calendar_today,
                                              color:
                                                  HighElectricAppColor.nature05,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ))),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                              _controller.toDateTime = null;
                              _controller.fromDateTime = null;
                              _controller.timeController.value.text = '';

                              _controller.toDateTimeWork = null;
                              _controller.fromDateTimeWork = null;
                              _controller.toWorkDate.value = '';
                              _controller.fromWorkDate.value = '';
                              _controller.timeWorkController.value.text = '';

                              _keyTypeEvents.currentState.reset();
                              _keyGroup.currentState.reset();
                              _keyUser.currentState.reset();
                              _keyTBA.currentState.reset();
                              _keyLine.currentState.reset();

                              _controller.getWorkList();
                            },
                            child: EButtonWidget(
                              width: MediaQuery.of(context).size.width / 3.2,
                              text: 'Bỏ lọc',
                              bgColor: Colors.white,
                              textColor: HighElectricAppColor.primary10,
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Get.back();
                                _controller.getWorkList();
                              },
                              child: EButtonWidget(
                                width: MediaQuery.of(context).size.width / 3.2,
                                text: 'Lọc',
                                bgColor: HighElectricAppColor.primary10,
                                textColor: Colors.white,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ));
        });
  }

  Future<void> _showTimePicker(
    BuildContext context, {
    DateTime fromDateTime,
    DateTime toDateTime,
    TextEditingController timeController,
    bool isCreateTime = false,
  }) async {
    final arrDateSearch = await showTimePickerSearch(
        context,
        fromDateTime ?? DateTime(DateTime.now().year, DateTime.now().month, 1),
        toDateTime ??
            DateTime(DateTime.now().year, DateTime.now().month + 1, 0));
    if (arrDateSearch != null) {
      timeController.text =
          '${arrDateSearch.start.toStringFormat(HighElectricStrings.ddMMyyyy)} - ${arrDateSearch.end.toStringFormat(HighElectricStrings.ddMMyyyy)}';

      if (isCreateTime) {
        _controller.fromDateTime = arrDateSearch.start;
        _controller.toDateTime = arrDateSearch.end;
      } else {
        _controller.fromDateTimeWork = arrDateSearch.start;
        _controller.toDateTimeWork = arrDateSearch.end;
        _controller.fromWorkDate.value = arrDateSearch.start.formatFirstDate();
        _controller.toWorkDate.value = arrDateSearch.end.formatSecondDate();
      }
      if (Get.context.isTablet) {
        await _controller.getWorkList();
      }
    }
  }

  Future<DateTimeRange> showTimePickerSearch(
    BuildContext context,
    DateTime fromDate,
    DateTime toDate,
  ) async {
    final currentTime = DateTime.now().toUtc();
    final dateTimeRangeInit = DateTimeRange(start: fromDate, end: toDate);
    return showDateRangePicker(
        context: context,
        locale: const Locale('vi', 'VN'),
        initialDateRange: dateTimeRangeInit,
        firstDate:
            DateTime(currentTime.year - 5, currentTime.month, currentTime.day),
        lastDate:
            DateTime(currentTime.year + 2, currentTime.month, currentTime.day));
  }

  Widget _renderAppbar() {
    if (!_controller.isSearching.value) {
      return AppBarCommon(
        title: 'DS ${_controller.ticketType.title}',
        actions: [
          GestureDetector(
            onTap: () {
              _controller.isSearching.value = true;
            },
            child: Container(
                color: Colors.white.withAlpha(0),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                )),
          ),
          GestureDetector(
            onTap: () {
              _showFilter();
            },
            child: Container(
                color: Colors.white.withAlpha(0),
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  HighElectricAppIcon.filter,
                  color: _controller.hasFilter()
                      ? HighElectricAppColor.orange
                      : Colors.white,
                )),
          ),
          if (profileModel.isCreateOperationNote())
            GestureDetector(
              onTap: () async {
                await goToSubstationTicketScreen(
                    actionTicketType: ActionTicketType.edit,
                    actionPopupType: ActionTicketType.create);
                await _controller.getWorkList();
              },
              child: Container(
                  color: Colors.white.withAlpha(0),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.add)),
            ),
          Container(
            width: 5,
          ),
        ],
      );
    } else {
      return AppBar(
        backgroundColor: HighElectricAppColor.primary10,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: HighElectricAppColor.nature01,
          ),
          child: Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Padding(
                padding:
                    EdgeInsets.only(left: 15, right: 5, top: 11, bottom: 11),
                child: Icon(
                  Icons.search,
                  color: HighElectricAppColor.nature05,
                ),
              ),
              Expanded(
                  child: TextFormField(
                style: const TextStyle(color: Colors.black87),
                cursorHeight: 0,
                cursorWidth: 0,
                focusNode: _focusNode,
                autofocus: true,
                onChanged: (value) {
                  _controller.searchTerm.value = value;
                },
                onEditingComplete: () {
                  _focusNode.unfocus();
                  _controller.getWorkList();
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: HighElectricAppColor.nature04,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  hintText: 'Nhập thông tin tìm kiếm',
                ),
              )),
              GestureDetector(
                  onTap: () {
                    _controller.searchTerm.value = '';
                    _controller.getWorkList();
                    _controller.isSearching.value = false;
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 19, vertical: 11),
                    child: Icon(
                      Icons.close,
                      color: HighElectricAppColor.nature05,
                    ),
                  ))
            ],
          ),
        ),
        titleSpacing: 0,
        centerTitle: false,
      );
    }
  }

  UserProfileModel profileModel;

  @override
  void initState() {
    _controller.initData();
    super.initState();
    _controller.delegate = this;
    Future.delayed(const Duration(milliseconds: 100), () async {
      await _controller.getWorkList();
    });
    profileModel = AppShared.instance.getUserProfileDCT();
  }

  Future<void> _onRefresh() async {
    await _controller.refreshList();
  }

  Future<void> _onLoadMore() async {
    await _controller.loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: _renderAppbar(),
        body: Column(
          children: [_buildListItem()],
        ),
      ),
    );
  }

  Widget _buildListItem() {
    if (_controller.workList.isNotEmpty == true) {
      return Expanded(
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: _controller.isHasLoadMore.value ?? false,
          header: WaterDropHeader(
            refresh: Container(),
            complete: const Icon(
              Icons.done,
              color: HighElectricAppColor.highlightColor70,
            ),
          ),
          footer: const ClassicFooter(
            loadStyle: LoadStyle.HideAlways,
            loadingText: '',
            noDataText: '',
            canLoadingText: '',
            failedText: '',
            idleText: '',
          ),
          controller: _controller.refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoadMore,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return Container(
                height: 0.5,
                color: Colors.grey.shade200,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              );
            },
            itemBuilder: (_, index) {
              return _renderHistoryItem(_, _controller.workList[index]);
            },
            itemCount: _controller.workList.length,
          ),
        ),
      );
    } else {
      if (_controller.isFirstLoad) {
        return Container();
      }
      return const Expanded(
        child: Center(
          child: Text(HighElectricStrings.emptyList),
        ),
      );
    }
  }

  Widget _renderHistoryItem(BuildContext context, work) {
    // if (Device.get().isPhone) {

    var works;
    if (_controller.ticketType == TicketType.operationLog) {
      works = work as OperationModel;
    } else {
      works = work as GroupCheckNoteInfoModel;
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                  '${_controller.ticketType == TicketType.operationLog ? _controller.getNameEvent(works.eventType.toString()) : ''}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: HighElectricAppColor.nature06),
                )),
                const SizedBox(
                  width: 10,
                ),
                Wrap(
                  children: [
                    InkWell(
                      onTap: () async {
                        await goToSubstationTicketScreen(
                            actionTicketType: ActionTicketType.edit,
                            actionPopupType: ActionTicketType.view,
                            id: works.id);
                        await _controller.getWorkList();
                      },
                      child: Button40(
                          child: const Icon(Icons.remove_red_eye_outlined,
                              color: HighElectricAppColor.nature01)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (profileModel.isCreateOperationNote())
                      InkWell(
                        onTap: () async {
                          await goToSubstationTicketScreen(
                              actionTicketType: ActionTicketType.edit,
                              actionPopupType: ActionTicketType.copy,
                              id: works.id);
                          await _controller.getWorkList();
                        },
                        child: Button40(
                          child: const Icon(
                            Icons.copy,
                            color: HighElectricAppColor.nature01,
                          ),
                        ),
                      ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (profileModel.isUpdateOperationNote())
                      InkWell(
                        onTap: () async {
                          await goToSubstationTicketScreen(
                              actionTicketType: ActionTicketType.edit,
                              actionPopupType: ActionTicketType.edit,
                              id: works.id);
                          await _controller.getWorkList();
                        },
                        child: Button40(
                          child: const Icon(
                            Icons.edit_outlined,
                            color: HighElectricAppColor.nature01,
                          ),
                        ),
                      ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (profileModel.isDeleteOperationNote())
                      InkWell(
                        onTap: () async {
                          await rShowMyDialogOkCancel(
                            HighElectricStrings.confirmDelete,
                            secondFunction: () async {
                              await _controller.delete(id: works.id);
                            },
                          );
                        },
                        child: Button40(
                          child: const Icon(
                            Icons.delete_outline,
                            color: HighElectricAppColor.nature01,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (_controller.ticketType == TicketType.operationLog)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ngày tạo',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: HighElectricAppColor.nature05),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        works.createdDate == null
                            ? ''
                            : works.createdDate
                                .toString()
                                .fromFormatUtcToFormatLocal(
                                    HighElectricStrings.ddmmyyyyHHmm),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: HighElectricAppColor.nature06),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Người tạo',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: HighElectricAppColor.nature05),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              '${works.createdUser ?? ''}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: HighElectricAppColor.nature06,
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Phòng/ Đội',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: HighElectricAppColor.nature05),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              '${works.userGroupName ?? ''}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: HighElectricAppColor.nature06,
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildWithTypeEvent(works)
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thời gian kiểm tra',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: HighElectricAppColor.nature05),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              works.dateCheck == null
                                  ? ''
                                  : works.dateCheck
                                      .toString()
                                      .fromFormatUtcToFormatLocal(
                                          HighElectricStrings.ddmmyyyyHHmm),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: HighElectricAppColor.nature06,
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Đoàn kiểm tra',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: HighElectricAppColor.nature05),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              works.nameTeamCheck ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: HighElectricAppColor.nature06,
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Phòng/Đội',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: HighElectricAppColor.nature05),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              works.userGroup ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: HighElectricAppColor.nature06,
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Trạm',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: HighElectricAppColor.nature05),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              works.substation ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: HighElectricAppColor.nature06,
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nội dung kiểm tra',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: HighElectricAppColor.nature05),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        works.contentCheck ?? '',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: HighElectricAppColor.nature06),
                      )
                    ],
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }

  Widget _buildWithTypeEvent(OperationModel works) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1,
          color: Colors.grey.shade200,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      works.eventType == ContentOptions.MCTTN.value
                          ? 'Thời gian nhảy'
                          : 'Thời gian bắt đầu${works.eventType == ContentOptions.workUnit.value ? ' thực tế' : ''}',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: HighElectricAppColor.nature05),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      works.eventType == ContentOptions.MCTTN.value
                          ? works.timeJump == null
                              ? ''
                              : works.timeJump.fromFormatUtcToFormatLocal(
                                  HighElectricStrings.ddmmyyyyHHmm)
                          : works.eventType == ContentOptions.workUnit.value
                              ? works.startDateReal == null
                                  ? ''
                                  : works.startDateReal
                                      .fromFormatUtcToFormatLocal(
                                          HighElectricStrings.ddmmyyyyHHmm)
                              : works.dateStart == null
                                  ? ''
                                  : works.dateStart.fromFormatUtcToFormatLocal(
                                      HighElectricStrings.ddmmyyyyHHmm),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: HighElectricAppColor.nature06,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      works.eventType == ContentOptions.MCTTN.value
                          ? 'Thời khôi phục'
                          : 'Thời gian kết thúc${works.eventType == ContentOptions.workUnit.value ? ' thực tế' : ''}',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: HighElectricAppColor.nature05),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      works.eventType == ContentOptions.MCTTN.value
                          ? works.timeRecover == null
                              ? ''
                              : works.timeRecover.fromFormatUtcToFormatLocal(
                                  HighElectricStrings.ddmmyyyyHHmm)
                          : works.eventType == ContentOptions.workUnit.value
                              ? works.endDateReal == null
                                  ? ''
                                  : works.endDateReal
                                      .fromFormatUtcToFormatLocal(
                                          HighElectricStrings.ddmmyyyyHHmm)
                              : works.endDate == null
                                  ? ''
                                  : works.endDate.fromFormatUtcToFormatLocal(
                                      HighElectricStrings.ddmmyyyyHHmm),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: HighElectricAppColor.nature06,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (works.eventType == ContentOptions.other.value)
          Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
        if (works.eventType == ContentOptions.other.value)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trạm',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: HighElectricAppColor.nature05),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        works.substationId ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: HighElectricAppColor.nature06,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        works.eventType == ContentOptions.workUnit.value
                            ? 'Đối tượng công tác'
                            : 'Tên thiết bị',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: HighElectricAppColor.nature05),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        works.equipmentsName ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: HighElectricAppColor.nature06,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> goToSubstationTicketScreen({
    ActionTicketType actionTicketType,
    ActionTicketType actionPopupType,
    String id,
  }) async {
    final controller = Get.put(TransformerTicketController());

    controller.actionTicketType = actionTicketType;
    controller.actionPopupType = actionPopupType;

    if (actionPopupType == ActionTicketType.create) {
      if (_controller.ticketType == TicketType.operationLog) {
        await Get.to(() => OperationLogScreen());
      } else {
        await Get.to(() => GroupCheckLogScreen());
      }
    } else if (actionPopupType == ActionTicketType.edit ||
        actionPopupType == ActionTicketType.view ||
        actionPopupType == ActionTicketType.copy) {
      if (_controller.ticketType == TicketType.operationLog) {
        await Get.to(() => OperationLogScreen(id: id));
      } else {
        await Get.to(() => GroupCheckLogScreen(id: id));
      }
    }
  }

  @override
  void onLoadMoreSuccess() {
    _controller.refreshController.loadComplete();
  }

  @override
  void onRefreshSuccess() {
    _controller.refreshController.refreshCompleted();
  }
}

