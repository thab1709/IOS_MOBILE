// @dart=2.9
import 'package:evnmobile/src/htdct/common/components/app_bar_common.dart';
import 'package:evnmobile/src/htdct/common/components/button_40.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../app_common/shared/app_shared.dart';
import '../../../../../htdct/common/constance/app_color.dart';
import '../../../../common/constance/app_icon.dart';
import '../../../../common/constance/strings.dart';
import '../../../../common/enum/ticket_enum.dart';
import '../../../../models/abnormal/abnormal_info_model.dart';
import '../../../../models/profile_model.dart';
import '../../containers/e_button.dart';
import '../../containers/e_check_box.dart';
import '../../line/tab_check/popups/violate_popup/violate_popup_screen.dart';
import '../popups/detail/detail_screen.dart';
import '../popups/detail/detail_violate.dart';
import '../popups/history/history_screen.dart';
import '../popups/update/update_screen.dart';
import 'abnormal_list_controller.dart';

class AbnormalListView extends StatefulWidget {
  const AbnormalListView();

  @override
  State<AbnormalListView> createState() => _AbnormalListViewState();
}

class _AbnormalListViewState extends State<AbnormalListView>
    implements HistoryCheckDelegate {
  final AbnormalListController _controller = AbnormalListController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormFieldState> _keyNode = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyCategories = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyEquipments = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyStatus = GlobalKey<FormFieldState>();

  _AbnormalListViewState();

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
                              if (_controller.testType != TestType.subStation)
                                MultiSelectDialogField(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Colors.grey.shade300)),
                                  // key: _keyTBA,
                                  key: _keyNode,
                                  cancelText: const Text('Hủy'),
                                  title: const Text('Nút'),
                                  buttonText: const Text('Chọn nút',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              HighElectricAppColor.nature04)),
                                  buttonIcon: const Icon(Icons.arrow_drop_down),
                                  initialValue: _controller.nodes,
                                  items: _controller.listNode
                                      .map((e) => MultiSelectItem(e, e.title))
                                      .toList(),
                                  listType: MultiSelectListType.CHIP,
                                  onConfirm: (values) async {
                                    _keyCategories.currentState.reset();
                                    _keyEquipments.currentState.reset();
                                    _controller.nodes.value = values;
                                    await _controller.getCategoryList(
                                        listNodeId: values
                                            .map((e) => e.value)
                                            .toList()
                                            .join(','));
                                  },
                                ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: MultiSelectDialogField(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Colors.grey.shade300)),
                                  key: _keyCategories,
                                  cancelText: const Text('Hủy'),
                                  title: const Text('Loại thiết bị'),
                                  buttonText: const Text('Chọn loại thiết bị',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              HighElectricAppColor.nature04)),
                                  buttonIcon: const Icon(Icons.arrow_drop_down),
                                  initialValue: _controller.categories,
                                  items: _controller.listCategory
                                      .map((e) => MultiSelectItem(e, e.title))
                                      .toList(),
                                  listType: MultiSelectListType.CHIP,
                                  onConfirm: (values) async {
                                    _keyEquipments.currentState.reset();
                                    _controller.categories.value = values;

                                    await _controller.getListEquipmentTBAorLine(
                                        category: values
                                            .map((e) => e.value)
                                            .toList()
                                            .join(','));
                                  },
                                ),
                              ),
                              Obx(() {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: MultiSelectDialogField(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                            color: Colors.grey.shade300)),
                                    key: _keyEquipments,
                                    cancelText: const Text('Hủy'),
                                    title: const Text('Thiết bị'),
                                    buttonText: const Text('Chọn thiết bị',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                HighElectricAppColor.nature04)),
                                    buttonIcon:
                                        const Icon(Icons.arrow_drop_down),
                                    initialValue: _controller.equipments,
                                    items: _controller.listEquipment
                                        .map((e) => MultiSelectItem(e, e.title))
                                        .toList(),
                                    listType: MultiSelectListType.CHIP,
                                    onConfirm: (values) async {
                                      _keyEquipments.currentState.reset();
                                      _controller.equipments.value = values;
                                      // await _controller.getTeamByIdGroup(
                                      //     _controller.parseId(values));
                                    },
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
                              if (_controller.testType == TestType.line &&
                                  _controller.ticketType ==
                                      TicketType.periodicMonth)
                                Container(
                                  width: double.infinity,
                                  height: 30,
                                  child: ECheckBox(
                                    title: 'Tồn tại vi phạm',
                                    checked: _controller.isViolate,
                                    onClicked: (value) {
                                      _controller.isViolate = value;
                                    },
                                  ),
                                ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
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
                              _keyEquipments.currentState.reset();
                              _keyCategories.currentState.reset();
                              if (_controller.testType != TestType.subStation) {
                                _keyNode.currentState.reset();
                              }
                              _controller.worksStatus.value = RxList.empty();
                              _controller.isViolate = false;
                              _controller.equipments = RxList.empty();
                              _controller.categories = RxList.empty();
                              _controller.listNode = RxList.empty();
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
                              onTap: () async {
                                Get.back();
                                await _controller.getWorkList();
                                _controller.workList.refresh();
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
        title: 'DS mục tồn tại của phiếu',
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
          if (_controller.isViolate == true)
            GestureDetector(
              onTap: () async {
                await Get.to(() => const ViolatePopup(
                      tiketType: ActionTicketType.create,
                      title: 'Tạo mới vi phạm',
                      fromAbnormal: true,
                      nameViolate: '',
                    ));
              },
              child: Container(
                  color: Colors.white.withAlpha(0),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.add_outlined,
                    color: Colors.white,
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
                  hintText: 'Nhập tên bất thường, tên thiết bị',
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
          children: [
            _buildHeaderInfo(),
            _buildListItem(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildInfoWidget(
              title: 'Tổng số: ',
              value: '${_controller.paging.value?.totalCount ?? 0}',
              bgColor: HighElectricAppColor.nature06.withOpacity(0.4),
              textStyle: const TextStyle(
                  color: HighElectricAppColor.nature06, fontSize: 16)),
          _buildInfoWidget(
              title: 'Chưa xử lý: ',
              value: '${_controller.paging.value?.processingCount ?? 0}',
              bgColor: HighElectricAppColor.colorOrange.withOpacity(0.4),
              textStyle: const TextStyle(
                  color: HighElectricAppColor.colorOrange, fontSize: 16)),
          _buildInfoWidget(
              title: 'Đã xử lý: ',
              value: '${_controller.paging.value?.completeCount ?? 0}',
              bgColor: HighElectricAppColor.greenColor.withOpacity(0.4),
              textStyle: const TextStyle(
                  color: HighElectricAppColor.greenColor, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildInfoWidget(
      {String title, String value, TextStyle textStyle, Color bgColor}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: bgColor,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: textStyle,
          ),
          Text(
            value,
            style: textStyle.copyWith(fontWeight: FontWeight.bold),
          )
        ],
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

  Widget _renderHistoryItem(BuildContext context, AbnormalInfoModel works) {
    // if (Device.get().isPhone) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
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
                  '${_controller.isViolate ? (works.nameViolate ?? '') : (works.equipmentName ?? '')}',
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
                          if(!_controller.isViolate) {
                            await Get.to(() => DetailAbnormalScreen(id: works.id,));
                          } else {
                            await Get.to(() => DetailViolateScreen(id: works.id));
                          }

                          await _controller.refreshList();
                        },
                        child: Button40(
                          child: const Icon(
                            Icons.info_outline,
                            color: HighElectricAppColor.nature01,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () async {
                          await Get.to(() => HistoryScreen(id: works.id));
                          await _controller.refreshList();
                        },
                        child: Button40(
                          child: const Icon(
                            Icons.history_outlined,
                            color: HighElectricAppColor.nature01,
                          ),
                        ),
                      ),
                    ),
                    if(works.isAllowEdit == true)
                    InkWell(
                      onTap: () async {
                        await Get.to(() => UpdateViolateScreen(
                            id: works.id, isViolate: _controller.isViolate));
                        await _controller.refreshList();
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _controller.isViolate
                ? [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Thời gian vi phạm',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: HighElectricAppColor.nature05),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  works.timeViolate == null
                                      ? ''
                                      : works.timeViolate
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Loại vi phạm',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: HighElectricAppColor.nature05),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  works.typeViolation ?? '',
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8, left: 16, right: 16, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tên vi phạm',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: HighElectricAppColor.nature05),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            works.name ?? '',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: HighElectricAppColor.nature06),
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
                            'Tình trạng vi phạm',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: HighElectricAppColor.nature05),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            works.statusViolate ?? '',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: HighElectricAppColor.nature06),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                Text(works.getStatusNameViolate(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: works.getColorViolate()))
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Thời gian xử lý',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: HighElectricAppColor.nature05),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  (works.date == null)
                                      ? ''
                                      : works.date.fromFormatUtcToFormatLocal(
                                          HighElectricStrings.ddmmyyyyHHmm),
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
                    ),
                  ]
                : [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8, left: 16, right: 16, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Thời gian bất thường',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: HighElectricAppColor.nature05),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            works.abnormalDate == null
                                ? ''
                                : works.abnormalDate.fromFormatUtcToFormatLocal(
                                    HighElectricStrings.ddmmyyyyHHmm),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: HighElectricAppColor.nature06),
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
                            'Mục bất thường',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: HighElectricAppColor.nature05),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            works.category ?? '',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: HighElectricAppColor.nature06),
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
                            'Tên bất thường',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: HighElectricAppColor.nature05),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            works.name ?? '',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: HighElectricAppColor.nature06),
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
                            'Biểu hiện bất thường',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: HighElectricAppColor.nature05),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            works.description ?? '',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: HighElectricAppColor.nature06),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                Text(works.status ?? '',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: works.getColor()))
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Thời gian xử lý',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: HighElectricAppColor.nature05),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  works.date == null
                                      ? ''
                                      : works.date.fromFormatUtcToFormatLocal(
                                          HighElectricStrings.ddmmyyyyHHmm),
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
                    ),
                  ],
          ),
        ],
      ),
    );
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

