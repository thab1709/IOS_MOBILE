// @dart=2.9
import 'package:badges/badges.dart' as badges;
import 'package:evnmobile/routes.dart';
import 'package:evnmobile/src/htdct/common/components/app_bar_common.dart';
import 'package:evnmobile/src/htdct/common/components/button_40.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htdct/models/day_night/ticket.dart';
import 'package:evnmobile/src/htdct/models/work_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/feedback/feed_back_screen.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/periodic_inspection_plan/periodic_inspection_plan_controller.dart';
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
import '../../../common/constance/work_status.dart';
import '../../../common/enum/ticket_enum.dart';
import '../../../common/utils/common.dart';
import '../../../models/option_model.dart';
import '../../../models/profile_model.dart';
import '../abnormal/abnormal_list/abnormal_list.dart';
import '../containers/e_button.dart';
import '../containers/e_check_box.dart';
import '../transformer/transformer_ticket_controller.dart';

class TestPlanView extends StatefulWidget {
  const TestPlanView();

  @override
  State<TestPlanView> createState() => _TestPlanViewState();
}

class _TestPlanViewState extends State<TestPlanView>
    implements HistoryCheckDelegate {
  final TestPlanController _controller = TestPlanController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormFieldState> _keyTBA = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyGroup = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyUser = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyStatus = GlobalKey<FormFieldState>();

  Future _showFilter() async {
    if (_controller.fromDateTime != null && _controller.toDateTime != null) {
      _controller.timeController.value.text =
          '${_controller.fromDateTime.toStringFormat(HighElectricStrings.ddMMyyyy)} - ${_controller.toDateTime.toStringFormat(HighElectricStrings.ddMMyyyy)}';
    } else {
      _controller.timeController.value.text = null;
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
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(Icons.close))
                        ],
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              MultiSelectDialogField(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: Colors.grey.shade300)),
                                key: _keyTBA,
                                cancelText: const Text('Hủy'),
                                title: Text(
                                    _controller.testType == TestType.subStation
                                        ? 'Trạm Biến Áp'
                                        : 'Đường Dây'),
                                buttonText: Text(
                                    _controller.testType == TestType.subStation
                                        ? 'Chọn Trạm Biến Áp'
                                        : 'Chọn Đường Đây',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: HighElectricAppColor.nature04)),
                                buttonIcon: const Icon(Icons.arrow_drop_down),
                                initialValue: _controller.subStationIDorLineID,
                                items: _controller.listTBAorLine
                                    .map((e) => MultiSelectItem(e, e.title))
                                    .toList(),
                                listType: MultiSelectListType.CHIP,
                                onConfirm: (values) {
                                  _controller.subStationIDorLineID.value =
                                      values;
                                },
                              ),
                              if (!(_controller.ticketType ==
                                      TicketType.tunnelCable &&
                                  (_controller.userProfile.position == 19 ||
                                      _controller.userProfile.position == 16)))
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: MultiSelectDialogField(
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
                                            color:
                                                HighElectricAppColor.nature04)),
                                    buttonIcon:
                                        const Icon(Icons.arrow_drop_down),
                                    initialValue: _controller.groupID,
                                    items: _controller.listGroup
                                        .map((e) => MultiSelectItem(e, e.title))
                                        .toList(),
                                    listType: MultiSelectListType.CHIP,
                                    onConfirm: (values) async {
                                      _keyUser.currentState.reset();
                                      _controller.groupID.value = values;
                                      await _controller.getTeamByIdGroup(
                                          _controller.parseId(values));
                                    },
                                  ),
                                ),
                              if (!(_controller.ticketType ==
                                      TicketType.tunnelCable &&
                                  _controller.userProfile.position == 19))
                                Obx(() {
                                  if (_controller?.listTeam?.isEmpty == true) {}
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: AbsorbPointer(
                                      absorbing:
                                          _controller.isDisableSelectTeam,
                                      child: MultiSelectDialogField<
                                          OptionModelString>(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                                color: Colors.grey.shade300)),
                                        key: _keyUser,
                                        cancelText: const Text('Hủy'),
                                        title: const Text('Tổ'),
                                        buttonText: const Text('Chọn Tổ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: HighElectricAppColor
                                                    .nature04)),
                                        buttonIcon:
                                            const Icon(Icons.arrow_drop_down),
                                        initialValue: _controller.userTeamID,
                                        items: _controller?.listTeam
                                                ?.map((e) =>
                                                    MultiSelectItem(e, e.title))
                                                ?.toList() ??
                                            [],
                                        listType: MultiSelectListType.CHIP,
                                        onConfirm: (values) {
                                          _controller.userTeamID = values;
                                        },
                                      ),
                                    ),
                                  );
                                }),
                              const SizedBox(
                                height: 8,
                              ),
                              MultiSelectDialogField(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: Colors.grey.shade300)),
                                key: _keyStatus,
                                cancelText: const Text('Hủy'),
                                title: const Text('Trạng thái'),
                                buttonText: const Text('Chọn trạng thái',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: HighElectricAppColor.nature04)),
                                buttonIcon: const Icon(Icons.arrow_drop_down),
                                initialValue: _controller.worksStatus,
                                items: _controller.listStatus
                                    .map((e) => MultiSelectItem(e, e.title))
                                    .toList(),
                                listType: MultiSelectListType.CHIP,
                                onConfirm: (values) {
                                  _keyStatus.currentState.reset();
                                  _controller.worksStatus.value = values;
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    await _showTimePicker(context);
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
                                                decoration:
                                                    const InputDecoration(
                                                  enabled: false,
                                                  border: InputBorder.none,
                                                  hintText:
                                                      'Chọn khoảng thời gian',
                                                  isDense: true,
                                                ),
                                              ),
                                            ),
                                          ),
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
                      Container(
                        width: double.infinity,
                        height: 30,
                        child: ECheckBox(
                          title: 'Lọc riêng DS phiếu tồn tại bất thường',
                          checked: _controller.showAbnormalChecked,
                          onClicked: (value) {
                            _controller.showAbnormalChecked = value;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                              _controller.toDateTime = null;
                              _controller.fromDateTime = null;
                              _controller.toDate.value = '';
                              _controller.fromDate.value = '';
                              _controller.timeController.value.text = '';
                              _keyStatus.currentState.reset();
                              if (_controller.ticketType !=
                                  TicketType.tunnelCable) {
                                _keyUser.currentState.reset();
                                _keyGroup.currentState.reset();
                              }
                              _keyTBA.currentState.reset();
                              _controller.worksStatus.value = RxList.empty();
                              _controller.userTeamID = RxList.empty();
                              _controller.groupID = RxList.empty();
                              _controller.subStationIDorLineID = RxList.empty();
                              _controller.getWorkList();
                              _controller.showAbnormalChecked = false;
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

  Future<void> _showTimePicker(BuildContext context) async {
    final arrDateSearch = await showTimePickerSearch(
        context,
        _controller.fromDateTime ??
            DateTime(DateTime.now().year, DateTime.now().month, 1),
        _controller.toDateTime ??
            DateTime(DateTime.now().year, DateTime.now().month + 1, 0));
    if (arrDateSearch != null) {
      _controller.timeController.value.text =
          '${arrDateSearch.start.toStringFormat(HighElectricStrings.ddMMyyyy)} - ${arrDateSearch.end.toStringFormat(HighElectricStrings.ddMMyyyy)}';

      _controller.fromDateTime = arrDateSearch.start;
      _controller.toDateTime = arrDateSearch.end;
      _controller.fromDate.value = arrDateSearch.start.formatFirstDate();
      _controller.toDate.value = arrDateSearch.end.formatSecondDate();
      _controller.timeController.refresh();
      if (Get.context.isTablet) {
        await _controller.getWorkList();
      }
    }
  }

  Future<DateTimeRange> showTimePickerSearch(
      BuildContext context, DateTime fromDate, DateTime toDate) async {
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
        title: 'Kế hoạch kiểm tra',
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
    super.initState();
    _controller.initData();
    _controller.delegate = this;
    profileModel = AppShared.instance.getUserProfileDCT();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _controller.getWorkList();
    });
  }

  Future<void> _onRefresh() async {
    await _controller.refreshList();
  }

  Future<void> _onLoadMore() async {
    await _controller.loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: _renderAppbar(),
        body: Column(
          children: [_buildListItem()],
        )));
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
      ));
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

  Widget _renderHistoryItem(BuildContext context, WorkModel works) {
    // if (Device.get().isPhone) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(top: 16, bottom: 10),
      decoration: BoxDecoration(
        color: works.hasAbnormal ? HighElectricAppColor.pink : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                  '${works.entity.getName(_controller.testType)}',
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
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () async {
                          final controller =
                              Get.put(TransformerTicketController());
                          controller.workId = works.workId;

                          await Get.to(() => FeedBackScreen(
                                works.workId,
                                works.workType.toString(),
                                isFromPmis: true,
                                isHasCreateInspectTicket: works.entityId?.isNotEmpty == true,
                                ticketId: works.entityId,
                              ));
                          await _controller.refreshList();
                        },
                        child: (works.countFeedBack != null &&
                                works.countFeedBack > 0)
                            ? badges.Badge(
                                badgeContent: Text(
                                  works.countFeedBack.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                child: Button40(
                                  child: SvgPicture.asset(
                                    HighElectricAppIcon.copy,
                                    width: 18,
                                    height: 20,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              )
                            : Button40(
                                child: SvgPicture.asset(
                                  HighElectricAppIcon.copy,
                                  width: 18,
                                  height: 20,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                      ),
                    ),
                    // if(works.hasAbnormal)
                    InkWell(
                      onTap: () async {
                        final controller =
                            Get.put(TransformerTicketController());
                        controller.testType = _controller.testType;
                        controller.ticketType = _controller.ticketType;
                        controller.lineId = works.entity.id;
                        controller.ticketId = works.entityId ?? '';
                        controller.workId = works.workId;
                        controller.workModel = works;

                        await Get.to(() => const AbnormalListView());
                        await _controller.refreshList();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: (works.countAbnormal != null &&
                                works.countAbnormal > 0)
                            ? badges.Badge(
                                badgeContent: Text(
                                  works.countAbnormal.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                child: Button40(
                                    child: const Icon(Icons.menu_rounded,
                                        color: HighElectricAppColor.nature01)))
                            : Button40(
                                child: const Icon(Icons.menu_rounded,
                                    color: HighElectricAppColor.nature01)),
                      ),
                    ),
                    if (works.workStatus == HWorkStatus.notImplement &&
                        profileModel.isCreateWork())
                      InkWell(
                        onTap: () async {
                          await goToSubstationTicketScreen(
                              works: works,
                              actionTicketType: ActionTicketType.edit);
                        },
                        child: Button40(
                          child: const Icon(Icons.add,
                              color: HighElectricAppColor.nature01),
                        ),
                      )
                    else
                      InkWell(
                        onTap: () async {
                          await goToSubstationTicketScreen(
                              works: works,
                              actionTicketType: ActionTicketType.view);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Button40(
                              child: const Icon(Icons.remove_red_eye_outlined,
                                  color: HighElectricAppColor.nature01)),
                        ),
                      ),
                    if (works.workStatus == HWorkStatus.implementing &&
                        profileModel.isUpdateWork())
                      InkWell(
                        onTap: () async {
                          await goToSubstationTicketScreen(
                              works: works,
                              actionTicketType: ActionTicketType.edit);
                        },
                        child: Button40(
                          child: const Icon(
                            Icons.edit_outlined,
                            color: HighElectricAppColor.nature01,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
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
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: HighElectricAppColor.nature05),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        works.planDate,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: HighElectricAppColor.nature06),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trạng thái',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: HighElectricAppColor.nature05),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(works.workStatusName,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: works.getColor()))
                    ],
                  ),
                )
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Đội/Phòng',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: HighElectricAppColor.nature05),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 2,
                        runSpacing: 10,
                        children:
                            List.generate(works.userGroups.length, (index) {
                          return Text(
                              works.userGroups[index].name +
                                  (index != works.userGroups.length - 1
                                      ? ', '
                                      : ''),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: HighElectricAppColor.nature06));
                        }),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tổ',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: HighElectricAppColor.nature05),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 2,
                        runSpacing: 10,
                        children:
                            List.generate(works.userTeams.length, (index) {
                          return Text(
                              works.userTeams[index].name +
                                  (index != works.userTeams.length - 1
                                      ? ', '
                                      : ''),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: HighElectricAppColor.nature06));
                        }),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          if (works.countFeedBack != null && works.countFeedBack > 0)
            Container(
              height: 1,
              color: Colors.grey.shade200,
            ),
          if (works.countFeedBack != null && works.countFeedBack > 0)
            Padding(
              padding: const EdgeInsets.only(
                  top: 8, left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Số phản hồi',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: HighElectricAppColor.nature05),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    '${works.countFeedBack > 99 ? '99+' : works.countFeedBack}',
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
                const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
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
                  works.description,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: HighElectricAppColor.nature06),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> goToSubstationTicketScreen(
      {WorkModel works, ActionTicketType actionTicketType}) async {
    final controller = Get.put(TransformerTicketController());
    controller.testType = _controller.testType;
    controller.ticketType = _controller.ticketType;
    controller.actionTicketType = actionTicketType;
    controller.lineId = works.entity.id;
    controller.ticketId = works.entityId ?? '';
    controller.workId = works.workId;
    controller.workModel = works;

    if (actionTicketType == ActionTicketType.view) {
      if (works?.entityId?.isNotEmpty == true) {
        await Get.toNamed(Routes.transformerTicket);
      } else {
        await hShowDialogOneButton('Công việc chưa được khởi tạo');
      }
      return;
    }
    if (controller.testType == TestType.subStation) {
      await navigateToSubstation(controller, works);
    } else {
      await navigateToLine(controller, works);
    }
  }

  Future navigateToSubstation(
      TransformerTicketController controller, WorkModel works) async {
    if (works.workStatus == HWorkStatus.notImplement) {
      final location = await getCurrentPosition();
      final locationResult =
         await checkValidDistance(location: location, entity: works?.entity);

      if (locationResult == null) {
        return;
      }

      controller.ticketId =
          await _controller.createTicket(works.workId, location: location);
      if (controller.ticketId.isEmpty) return;
    }
    await Get.toNamed(Routes.transformerTicket);
    await _controller.refreshList();
  }

  Future navigateToLine(
      TransformerTicketController controller, WorkModel works) async {
    //night
    if (controller.ticketType == TicketType.periodicNight) {
      if (works.workStatus == HWorkStatus.notImplement) {
        String ticketId;

        final location = await checkValidLocation();
        if (location == null) {
          return;
        }

        ticketId = await _controller.createNightLineTicket(
            controller.workId, controller.ticketType.testTypeCode(),
            location: location);
        controller.ticketId = ticketId;

        if (ticketId != null) {
          await Get.toNamed(Routes.transformerTicket);
        } else {
          return;
        }
      } else {
        await Get.toNamed(Routes.transformerTicket);
      }
    } else {
      //month
      await Get.toNamed(Routes.createLineTicket, parameters: {
        'workId': '${works.workId}',
        'workType': '${works.workType}',
        'idLine': '${works.entity.id}',
        'name': '${works.entity.name}'
      });
    }
    await _controller.refreshList();
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

