// @dart=2.9
import 'package:badges/badges.dart' as badges;
import 'package:evnmobile/routes.dart';
import 'package:evnmobile/src/app_common/utils/utils.dart';
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/constance/user_role_type.dart';
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/inspection_model.dart';
import 'package:evnmobile/src/htld/models/option_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_single_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/line_ticket_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../abnormal/abnormal_list/abnormal_list.dart';
import '../grid_management_controller.dart';
import 'controller/history_check_controller.dart';

class HistoryCheckScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HistoryCheckScreenState();
  }
}

class HistoryCheckScreenState extends State<HistoryCheckScreen>
    implements HistoryCheckDelegate {
  final HistoryCheckController _controller = Get.find();

  final GridManagementController _gridManagementController = Get.find();

  final _timeController = TextEditingController();

  final _refreshController = RefreshController(initialRefresh: false);

  final options = [
    OptionModel('Tất cả trạng thái', 0),
    OptionModel('Đang thực hiện', 1),
    OptionModel('Hoàn thành', 2),
    OptionModel('Quá hạn', 3)
  ];
  RxBool isSearching = false.obs;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _initDateSearch();
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //_controller.onStart();
    getArgument();
    _controller.delegate = this;
    //_initDateSearch();
    return Obx(() => Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: _renderAppBar(),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Column(
                children: [
                  //if (!Device.get().isPhone) const SizedBox(height: 24,),
                  //if (!Device.get().isPhone) _renderHeader(context),
                  //if (!Device.get().isPhone) _renderHeaderListItemHistory(),
                  _buildListItem()
                ],
              ),
            ),
          ),
        ));
  }

  void _showFilter() {
    final formTypeOption = _controller.stationType.tickets
        .mapIndexed((e, i) => OptionModel(e.title.capitalizeFirst, e.code))
        .toList();
    final defaultOption = _controller.ticketType.code;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)), //this right here
            child: Container(
              height: 390,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Lọc thông tin',
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
                    // Container(height: 1, margin: const EdgeInsets.only(top: 16), color: Colors.grey.shade200,),
                    const SizedBox(
                      height: 16,
                    ),
                    E2SingleDropDown(
                      _controller.units,
                      padding: 0,
                      value: _controller.unitId,
                      hint: 'Đơn vị',
                      contentHorizontalPadding: 10,
                      onSelected: (option) {
                        _controller.unitId = option;
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ESingleDropDown(
                      formTypeOption,
                      value: defaultOption,
                      padding: 0,
                      contentHorizontalPadding: 10,
                      onSelected: (value) {
                        _controller.ticketTypeCode.value = value;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ESingleDropDown(
                      options,
                      value: int.parse(_controller.ticketStatus.value) ?? 0,
                      padding: 0,
                      contentHorizontalPadding: 10,
                      onSelected: (value) {
                        _controller.ticketStatus.value = value.toString();
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                        onTap: () async {
                          await _showTimePicker(context);
                        },
                        child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1, color: Colors.grey.shade300)),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  color: AppColor.highlightColor70,
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
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
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            _timeController.text = '';
                            _controller.clearFilter();
                          },
                          child: Container(
                              padding: const EdgeInsets.all(16),
                              child: const Text(
                                'Bỏ lọc',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              )),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                            _controller.getData();
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: AppColor.highlightColor70,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 45,
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: const Text(
                                'Lọc',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> _onRefresh() async {
    await _controller.refreshList();
  }

  Future<void> _onLoadMore() async {
    await _controller.loadMore();
  }

  Widget _buildListItem() {
    return Expanded(
      child: Obx(() {
        if (_controller?.listItemTicket?.obs?.value?.isEmpty == true) {
          return const Center(
            child: Text('Không có dữ liệu'),
          );
        } else {
          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: _controller.isHasLoadMore.value ?? false,
            header: WaterDropHeader(
              refresh: Container(),
              complete: const Icon(
                Icons.done,
                color: AppColor.highlightColor70,
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
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoadMore,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _renderHistoryItem(
                    _controller.listItemTicket[index], context);
              },
              itemCount: _controller.listItemTicket.length,
            ),
          );
        }
      }),
    );
  }

  AppBar _renderAppBar() {
    if (isSearching?.value == false) {
      return AppBar(
        backgroundColor: AppColor.backgroundDarkGreen,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: false,
        titleSpacing: 0,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(AppStrings.titleList,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          Text('${_controller.stationType.title}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500))
        ]),
        actions: [
          GestureDetector(
            onTap: () {
              isSearching.value = true;
              _focusNode.requestFocus();
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
                padding: const EdgeInsets.only(left: 8, right: 16),
                child: Icon(
                  Icons.filter_list_alt,
                  color: _controller.isFilter.value
                      ? AppColor.colorOrange
                      : Colors.white,
                )),
          ),
          if (_controller.ticketType != TicketType.periodicNight &&
              _controller.ticketType != TicketType.periodicDay &&
              UserRole.hasPermissionCreate())
            GestureDetector(
              onTap: () {
                showChooseSubstation(actionType: ActionType.create);
              },
              child: Container(
                  color: Colors.white.withAlpha(0),
                  padding: const EdgeInsets.only(left: 8, right: 16),
                  child: const Icon(
                    Icons.add_circle_outline_outlined,
                    color: Colors.white,
                  )),
            ),
        ],
      );
    } else {
      return AppBar(
        backgroundColor: AppColor.backgroundDarkGreen,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        automaticallyImplyLeading: false,
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 45,
          child: Row(
            children: [
              Expanded(
                  child: TextFormField(
                style: const TextStyle(color: Colors.white),
                focusNode: _focusNode,
                autofocus: true,
                cursorColor: Colors.white,
                onChanged: (value) {
                  _controller.searchTerm.value = value;
                },
                onEditingComplete: () {
                  _focusNode.unfocus();
                  _controller.getData();
                },
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: 'Tìm kiếm',
                ),
              )),
              GestureDetector(
                  onTap: () {
                    _controller.searchTerm.value = '';
                    _controller.getData();
                    isSearching.value = false;
                  },
                  child: const Icon(Icons.close))
            ],
          ),
        ),
        titleSpacing: 0,
        centerTitle: false,
      );
    }
  }

  Widget _renderHistoryItem(InspectionModel _item, BuildContext context) {
    // if (Device.get().isPhone) {
    return GestureDetector(
      onTap: () {
        showChooseSubstation(
            item: _item,
            actionType: _item.canEdit && UserRole.hasPermissionCreate()
                ? ActionType.edit
                : ActionType.view);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
        decoration: BoxDecoration(
            color: _item.getStatusColor(),
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _item.code ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  if ((_item?.totalAbnormal ?? 0) > 0)
                    InkWell(
                      onTap: () async {
                        await Get.to(() => TAbnormalListView(
                              subStationType: _gridManagementController
                                  .argument.subStationType,
                              ticketId: _item.id,
                              ticketType:
                                  _gridManagementController.argument.ticketType,
                            ));
                        await _controller.refreshList();
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: (_item.totalAbnormal != null &&
                                  _item.totalAbnormal > 0)
                              ? badges.Badge(
                                  badgeContent: Text(
                                    _item.totalAbnormal.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(Icons.menu_rounded,
                                        color: Colors.black),
                                  ))
                              : const SizedBox()),
                    ),
                  if (UserRole.hasPermissionCreate())
                    GestureDetector(
                      onTap: () {
                        if (_item.canEdit) {
                          showChooseSubstation(
                              item: _item, actionType: ActionType.edit);
                        }
                      },
                      child: Icon(
                        (_item.canEdit && UserRole.hasPermissionCreate())
                            ? Icons.edit_outlined
                            : Icons.arrow_forward_outlined,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey.shade200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ngày ',
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          _item.lastInspectTime.fromFormatToFormat(
                              AppStrings.yyyyMMddTHHmmss, AppStrings.ddMMyyyy),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            (_controller.stationType ==
                                    SubStationType.mediumVoltage)
                                ? 'Đường dây'
                                : 'Trạm biến áp',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black87)),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(_item.substationName,
                            style: const TextStyle(fontWeight: FontWeight.w500))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 8, left: 16, right: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Loại',
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          _item.inspectionTypeName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 13),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Trạng thái',
                            style:
                                TextStyle(fontSize: 13, color: Colors.black87)),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(_item.statusName,
                            style: const TextStyle(fontWeight: FontWeight.w500))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    //  }
    //   else {
    //     return GestureDetector(
    //       onTap: () {
    //         showChooseSubstation(item: _item, actionType: _item.canEdit ? ActionType.edit : ActionType.view);
    //       },
    //       child: Container(
    //         color: Colors.white,
    //         height: 60,
    //         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
    //         padding: const EdgeInsets.symmetric(horizontal: 16),
    //         child: Row(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             Container(width: 80, child: Text(_item.lastInspectTime?.fromFormatUTCToFormat(AppStrings.utcFormat, AppStrings.ddMMyyyy)) ?? ''),
    //             Container(
    //                 padding: const EdgeInsets.only(left: 16),
    //                 width: 140,
    //                 child: Text(_item.code ?? '')),
    //             Expanded(
    //               child: Padding(
    //                 padding: const EdgeInsets.symmetric(horizontal: 16),
    //                 child: Text(_item?.substationName ?? ''),
    //               ),
    //             ),
    //             Container(
    //                 width: 150,
    //                 child: Text(_item.statusName ?? '')),
    //             InkWell(
    //               onTap: () {
    //                 if (_item.canEdit) {
    //                   showChooseSubstation(item: _item, actionType: ActionType.edit);
    //                 }
    //               },
    //               child: Padding(
    //                 padding: const EdgeInsets.all(8),
    //                 child: Icon((_item.canEdit && UserRole.hasPermissionCreate()) ? Icons.edit_outlined : Icons.arrow_forward_outlined,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final arrDateSearch = await showTimePickerSearch(
        context, _controller.fromDateTime, _controller.toDateTime);
    if (arrDateSearch != null) {
      _timeController.text =
          'Từ ${arrDateSearch.start.toStringFormat(AppStrings.ddMMyyyy)} đến ${arrDateSearch.end.toStringFormat(AppStrings.ddMMyyyy)}';
      _controller.fromDateTime = arrDateSearch.start;
      _controller.toDateTime = arrDateSearch.end;
      _controller.fromDate.value = arrDateSearch.start.formatFirstDate();
      _controller.toDate.value = arrDateSearch.end.formatSecondDate();

      if (Get.context.isTablet) {
        await _controller.getData();
      }
    }
  }

  Widget renderSearchView() {
    final textController = TextEditingController();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(width: 1, color: AppColor.borderColor1),
      ),
      height: 50,
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          const Icon(Icons.search, size: 24),
          const SizedBox(width: 8),
          Expanded(
              child: TextField(
            controller: textController,
            onChanged: (value) {
              _controller.searchTerm.value = value;
            },
            decoration: const InputDecoration(
                hintText: 'Tìm kiếm theo tên, mã...', border: InputBorder.none),
          )),
          const SizedBox(width: 8),
          Obx(
            () => Opacity(
              opacity: _controller.searchTerm.value == '' ? 0 : 1,
              child: IconButton(
                  icon: const Icon(
                    Icons.clear,
                    size: 24,
                  ),
                  onPressed: () async {
                    textController.text = '';
                    _controller.searchTerm.value = '';
                    await _controller.getData();
                  }),
            ),
          )
        ],
      ),
    );
  }

  void getArgument() {
    _controller.stationType = _gridManagementController.argument.subStationType;
    _controller.ticketType = _gridManagementController.argument.ticketType;
    _controller.ticketTypeCode.value =
        _gridManagementController.argument.ticketType.code.toString();
  }

  Future showChooseSubstation(
      {InspectionModel item, ActionType actionType}) async {
    // if (!UserRole.hasPermissionCreate()) {
    //   // chỉ công nhân mới có quyền sửa công việc
    //   await showDialogError('Bạn không có quyền để sửa công việc này!');
    //   return;
    // }
    if (actionType == ActionType.view) {
      if (_controller.stationType == SubStationType.mediumVoltage ||
          _controller.stationType == SubStationType.lowVoltage) {
        // Chọn đường dây
        final lineArgument = LineTicketArgument(
          inspectionModel: item,
          ticketType: _controller.ticketType,
          actionType: actionType,
        );
        final _lineTicketController = Get.put(LineTicketController());
        _lineTicketController.argument = lineArgument;
        _lineTicketController.ticketId = item.id;
        await Get.to(const LineTicketScreen());
        await _controller.getData();
      } else {
        final argument = TicketScreenArgument(
            ticketType: _controller.ticketType,
            ticketId: item?.id,
            subStationType: _controller.stationType,
            inspectionModel: item,
            actionType: actionType);
        await Get.to(() => TicketScreen(
              ticketScreenArgument: argument,
            ));
        await _controller.getData();
      }
    } else {
      if (_controller.stationType == SubStationType.mediumVoltage ||
          _controller.stationType == SubStationType.lowVoltage) {
        final argument = LineTicketArgument(
          ticketType: _controller.ticketType,
          inspectionModel: item,
          actionType: actionType,
        );
        final _lineTicketController = Get.put(LineTicketController());
        _lineTicketController.argument = argument;
        if (item == null) {
          await Get.toNamed(Routes.chooseLine);
        } else {
          _lineTicketController.ticketId = item.id;
          await Get.to(const LineTicketScreen());
        }

        await _controller.getData();
      } else {
        final argument = TicketScreenArgument(
            ticketType: _controller.ticketType,
            ticketId: item?.id,
            subStationType: _controller.stationType,
            inspectionModel: item,
            actionType: actionType);

        await Get.toNamed(Routes.chooseSubstation, arguments: argument);
        await _controller.getData();
      }
    }
  }

  void _initDateSearch() {
    final currentDate = DateTime.now();
    final date1 = DateTime(currentDate.year, currentDate.month, 1);
    final date = DateTime(currentDate.year, currentDate.month + 1, 0);
    _controller.fromDateTime = date1;
    _controller.toDateTime = date;
    _timeController.text =
        'Từ ${date1.toStringFormat(AppStrings.ddMMyyyy)} đến ${date.toStringFormat(AppStrings.ddMMyyyy)}';
    _controller.fromDate.value = date1.formatFirstDate();
    _controller.toDate.value = date.formatSecondDate();
  }

  @override
  void onLoadMoreSuccess() {
    _refreshController.loadComplete();
  }

  @override
  void onRefreshSuccess() {
    _refreshController.refreshCompleted();
  }
}

