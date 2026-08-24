// @dart=2.9
import 'package:badges/badges.dart' as badges;
import 'package:evnmobile/routes.dart';
import 'package:evnmobile/src/app_common/utils/utils.dart';
import 'package:evnmobile/src/htld/common/constance/group_color.dart';
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/constance/user_role_type.dart';
import 'package:evnmobile/src/htld/common/constance/work_status_type.dart';
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/common/utils/common.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/option_model.dart';
import 'package:evnmobile/src/htld/models/work_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_single_drop_down.dart';
import 'package:evnmobile/src/htld/screens/grid_management/history_check/controller/history_check_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/line_ticket_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/periodic_inspection_plan/periodic_inspection_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../../app_env.dart';
import '../../../../app_common/shared/app_shared.dart';
import '../abnormal/abnormal_list/abnormal_list.dart';

class PeriodicInspectionPlanView extends StatefulWidget {
  final TicketScreenArgument argument;

  const PeriodicInspectionPlanView({this.argument});

  @override
  State<StatefulWidget> createState() {
    return PeriodicInspectionPlanState();
  }
}

class PeriodicInspectionPlanState extends State<PeriodicInspectionPlanView>
    implements HistoryCheckDelegate {
  final _timeController = TextEditingController();
  final PeriodicInspectionPlanController _controller =
      Get.put(PeriodicInspectionPlanController());
  List<OptionModel> options1 = <OptionModel>[];
  final _refreshController = RefreshController(initialRefresh: false);
  final FocusNode _focusNode = FocusNode();
  RxBool isSearching = false.obs;

  final options = [
    OptionModel('Tất cả', 0),
    OptionModel('Chưa thực hiện', 1),
    OptionModel('Đang thực hiện', 2),
    OptionModel('Hoàn thành', 3)
  ];

  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
    _controller.ticketScreenArgument = Get.arguments ?? widget.argument;
    _initDateSearch();
    _controller.prepareData();
    if (_controller.ticketScreenArgument.subStationType ==
        SubStationType.distribution) {
      options1 = [
        OptionModel('Định kì ngày', 1),
        OptionModel('Định kì đêm', 2)
      ];
    } else if (_controller.ticketScreenArgument.subStationType ==
        SubStationType.intermediate) {
      options1 = [
        OptionModel('Định kì ngày', 5),
        OptionModel('Định kì đêm', 6)
      ];
    } else if (_controller.ticketScreenArgument.subStationType ==
        SubStationType.mediumVoltage) {
      options1 = [
        OptionModel('Định kì ngày', 3),
        OptionModel('Định kì đêm', 4)
      ];
    }
    _controller.defaultWordType = getWorkType(
        _controller.ticketScreenArgument.subStationType,
        _controller.ticketScreenArgument.ticketType);

    _controller.workType.value = _controller.defaultWordType.toString();
    Future.delayed(const Duration(milliseconds: 200), _controller.getData);
  }

  Future<void> _onRefresh() async {
    await _controller.refreshList();
  }

  Future<void> _onLoadMore() async {
    await _controller.loadMore();
  }

  Future action(WorkModel workModel) async {
    if (UserRole.hasPermissionCreate() && workModel.isAllowEdit) {
      // NOTE(hau):
      if (workModel.workStatus == WorkStatusType.Done) {
        if (_controller.ticketScreenArgument.subStationType ==
                SubStationType.mediumVoltage ||
            _controller.ticketScreenArgument.subStationType ==
                SubStationType.lowVoltage) {
          final argument = LineTicketArgument(
              workModel: workModel,
              ticketType: _controller.ticketScreenArgument.ticketType,
              actionType: ActionType.view);
          final _lineTicketController = Get.put(LineTicketController());
          _lineTicketController.ticketId = workModel.entityId;
          _lineTicketController.argument = argument;
          await Get.to(() => const LineTicketScreen());
          await _controller.getData();
        } else {
          final argument = TicketScreenArgument(
              ticketType: _controller.ticketScreenArgument.ticketType,
              ticketId: workModel.entityId,
              subStationType: _controller.ticketScreenArgument.subStationType,
              substationModel: workModel.substationModel,
              actionType: ActionType.view,
              workId: workModel.workId);
          await Get.to(() => TicketScreen(
                ticketScreenArgument: argument,
              ));
          await _controller.getData();
        }
      } else if (workModel.workStatus == WorkStatusType.Inprogress) {
        if (_controller.ticketScreenArgument.subStationType ==
                SubStationType.mediumVoltage ||
            _controller.ticketScreenArgument.subStationType ==
                SubStationType.lowVoltage) {
          final argument = LineTicketArgument(
              workModel: workModel,
              ticketType: _controller.ticketScreenArgument.ticketType,
              actionType: ActionType.edit);
          final _lineTicketController = Get.put(LineTicketController());
          _lineTicketController.ticketId = workModel.entityId;
          _lineTicketController.argument = argument;
          await Get.to(() => const LineTicketScreen());
          await _controller.getData();
        } else {
          _controller.ticketScreenArgument.substationModel =
              workModel.substationModel;
          _controller.ticketScreenArgument.workId = workModel.workId;
          _controller.ticketScreenArgument.ticketId = workModel.entityId;
          _controller.ticketScreenArgument.actionType =
              workModel.entityId == null ? ActionType.create : ActionType.edit;
          await Get.toNamed(Routes.chooseSubstation,
              arguments: _controller.ticketScreenArgument);
          await _controller.getData();
        }
      } else {
        if (_controller.ticketScreenArgument.subStationType ==
                SubStationType.mediumVoltage ||
            _controller.ticketScreenArgument.subStationType ==
                SubStationType.lowVoltage) {
          // Chọn đường dây
          final lineArgument = LineTicketArgument(
              workModel: workModel,
              ticketType: _controller.ticketScreenArgument.ticketType,
              actionType: ActionType.create,
              fre: workModel.frequency);
          final _lineTicketController = Get.put(LineTicketController());
          _lineTicketController.argument = lineArgument;
          await Get.toNamed(Routes.chooseLine);
          await _controller.getData();
        } else {
          // Chon tram bien ap
          _controller.ticketScreenArgument.fre = workModel.frequency;
          _controller.ticketScreenArgument.substationModel =
              workModel.substationModel;
          _controller.ticketScreenArgument.workId = workModel.workId;
          _controller.ticketScreenArgument.ticketId = workModel.entityId;
          _controller.ticketScreenArgument.actionType =
              workModel.entityId == null ? ActionType.create : ActionType.edit;
          await Get.toNamed(Routes.chooseSubstation,
              arguments: _controller.ticketScreenArgument);
          await _controller.getData();
        }
      }
    } else {
      if (_controller.ticketScreenArgument.subStationType ==
              SubStationType.mediumVoltage ||
          _controller.ticketScreenArgument.subStationType ==
              SubStationType.lowVoltage) {
        final argument = LineTicketArgument(
            workModel: workModel,
            ticketType: _controller.ticketScreenArgument.ticketType,
            actionType: ActionType.view);
        final _lineTicketController = Get.put(LineTicketController());
        _lineTicketController.ticketId = workModel.entityId;
        _lineTicketController.argument = argument;
        await Get.to(() => const LineTicketScreen());
        await _controller.getData();
      } else {
        final argument = TicketScreenArgument(
            ticketType: _controller.ticketScreenArgument.ticketType,
            ticketId: workModel.entityId,
            subStationType: _controller.ticketScreenArgument.subStationType,
            substationModel: workModel.substationModel,
            actionType: ActionType.view,
            workId: workModel.workId);
        await Get.to(() => TicketScreen(
              ticketScreenArgument: argument,
            ));
        await _controller.getData();
      }
    }
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

  void _showFilter() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
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
                      _controller.setUnitId(option);
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Obx(() => E2SingleDropDown(
                        _controller.groups.value,
                        padding: 0,
                        value: _controller.groupId,
                        hint: 'Tổ đội',
                        contentHorizontalPadding: 10,
                        onSelected: (option) {
                          _controller.groupId = option;
                        },
                      )),
                  const SizedBox(
                    height: 24,
                  ),
                  ESingleDropDown(
                    options1,
                    value: int.parse(_controller.workType.value),
                    padding: 0,
                    contentHorizontalPadding: 10,
                    onSelected: (value) {
                      _controller.workType.value = value;
                      _controller.setTicketType();
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ESingleDropDown(
                    options,
                    value: _controller?.workStatus?.value,
                    padding: 0,
                    contentHorizontalPadding: 10,
                    hint: 'Trạng thái',
                    onSelected: (value) {
                      _controller.workStatus.value = int.parse(value);
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
                                Icons.calendar_today_outlined,
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
                  Obx(
                    () => CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Tồn tại bất thường'),
                        value: _controller.isAbnormal.value,
                        onChanged: (value) {
                          _controller.setIsAbnormal();
                        }),
                  ),
                  const SizedBox(
                    height: 16,
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
                            padding: const EdgeInsets.symmetric(horizontal: 24),
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
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: _renderAppbar(),
        body: Column(
          children: [
            //if (Device.get().isTablet) _renderHeader(context),
            //if (Device.get().isTablet) _renderHeaderListItemHistory(),
            _buildListItem()
          ],
        )));
  }

  Widget _buildListItem() {
    return Expanded(
      child: Obx(
        () {
          if (_controller?.works?.obs?.value?.isEmpty == true) {
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
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 32),
                separatorBuilder: (context, index) {
                  return Container(
                    height: 0.5,
                    color: Colors.grey.shade200,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  );
                },
                itemBuilder: (context, index) {
                  return _renderHistoryItem(_controller.works[index], context);
                },
                itemCount: _controller.works.length,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _renderHistoryItem(WorkModel model, BuildContext context) {
    final title = _controller.ticketScreenArgument.subStationType ==
                SubStationType.mediumVoltage ||
            _controller.ticketScreenArgument.subStationType ==
                SubStationType.lowVoltage
        ? model.line.name ?? ''
        : model.substationModel.name ?? '';
    final isHighlight = model.highlight == 1 &&
        AppShared.instance.getAppType() == AppType.HTLDHT;
    // if (Device.get().isPhone) {
    return GestureDetector(
      onTap: () {
        action(model);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 16, right: 16, left: 16),
        decoration: BoxDecoration(
            color: isHighlight ? Colors.blue.shade50 : Colors.white,
            border: Border.all(
                color:
                    isHighlight ? Colors.blue.shade300 : Colors.grey.shade200,
                width: isHighlight ? 1.5 : 1),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  )),
                  if ((model?.totalAbnormal ?? 0) > 0)
                    InkWell(
                      onTap: () async {
                        await Get.to(() => TAbnormalListView(
                              subStationType: _controller
                                  .ticketScreenArgument.subStationType,
                              ticketId: model.entityId,
                              ticketType:
                                  _controller.ticketScreenArgument.ticketType,
                            ));
                        await _controller.refreshList();
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: (model.totalAbnormal != null &&
                                  model.totalAbnormal > 0)
                              ? badges.Badge(
                                  badgeContent: Text(
                                    model.totalAbnormal.toString(),
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
                  GestureDetector(
                    onTap: () {
                      action(model);
                    },
                    child: (model.isAllowEdit && UserRole.hasPermissionCreate())
                        ? Icon(
                            getIcon(model.workStatus),
                            color: Colors.black87,
                          )
                        : const Icon(Icons.arrow_forward_outlined,
                            color: Colors.black87),
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
                          'Ngày dự kiến',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          model.planDate.fromFormatUTCToFormat(
                              AppStrings.planDate, AppStrings.ddMMyyyy),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Trạng thái',
                            style: TextStyle(fontSize: 13, color: Colors.grey)),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(model.workStatusName,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: getStatusTextColor(model.workStatus)))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tổ đội',
                      style: TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(
                    height: 3,
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 10,
                    runSpacing: 10,
                    children: model?.groups
                            ?.map(
                              (e) => Text(e.name ?? '',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: getStatusGroupTextColor(e.color))),
                            )
                            ?.toList() ??
                        List.empty(),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 8, left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nội dung kiểm tra',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    model.description,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData getIcon(int status) {
    if (status == WorkStatusType.New) {
      return Icons.add_circle_outline_outlined;
    } else if (status == WorkStatusType.Inprogress) {
      return Icons.edit_outlined;
    } else {
      return Icons.arrow_forward_outlined;
    }
  }

  Color getStatusTextColor(int status) {
    if (status == WorkStatusType.New) {
      return AppColor.pink;
    } else if (status == WorkStatusType.Inprogress) {
      return AppColor.yellow;
    } else {
      return AppColor.green;
    }
  }

  Color getStatusGroupTextColor(int status) {
    if (status == GroupColorType.Black) {
      return Colors.black;
    } else if (status == GroupColorType.Red) {
      return AppColor.pink;
    } else {
      return AppColor.green;
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
                hintText: 'Tìm kiếm theo tên, mã công việc',
                border: InputBorder.none),
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

  AppBar _renderAppbar() {
    if (isSearching.value == false) {
      return AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: AppColor.highlightColor70,
        leading: const BackButton(
          color: Colors.white,
        ),
        title: Text(
          'Kế hoạch kiểm tra'.toUpperCase(),
          style: const TextStyle(fontSize: 16),
        ),
        titleSpacing: 0,
        centerTitle: false,
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
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.filter_list_alt,
                  color: _controller.isFilter.value
                      ? AppColor.colorOrange
                      : Colors.white,
                )),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.historyCheck);
            },
            child: Container(
                color: Colors.white.withAlpha(0),
                padding: const EdgeInsets.only(left: 8, right: 16),
                child: const Icon(
                  Icons.list_alt_outlined,
                  color: Colors.white,
                )),
          ),
        ],
      );
    } else {
      return AppBar(
        backgroundColor: AppColor.highlightColor70,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 45,
          child: Row(
            // ignore: prefer_const_literals_to_create_immutables
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

  void _initDateSearch() {
    final currentDate = DateTime.now();
    final fromDate = DateTime(currentDate.year, currentDate.month, 1);
    final toDate = DateTime(currentDate.year, currentDate.month + 1, 0);
    _controller.fromDateTime = fromDate;
    _controller.toDateTime = toDate;

    _timeController.text =
        'Từ ${fromDate.toStringFormat(AppStrings.ddMMyyyy)} đến ${toDate.toStringFormat(AppStrings.ddMMyyyy)}';
    _controller.fromDate.value = fromDate.formatFirstDate();
    _controller.toDate.value = toDate.formatSecondDate();
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

