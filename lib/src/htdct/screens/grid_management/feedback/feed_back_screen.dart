// @dart=2.9
import 'package:evnmobile/src/htdct/common/components/app_bar_common.dart';
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/feedback/feed_back_controller.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/feedback/send_feedback/send_feedback_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../app_common/utils/utils.dart';
import '../../../common/components/button_40.dart';
import '../../../common/constance/app_color.dart';
import '../../../common/constance/app_icon.dart';
import '../../../common/enum/list.dart';
import '../../../common/themes/colorx.dart';
import '../../../common/themes/styles.dart';
import '../../../models/feed_back.dart';
import '../base/list_delegate.dart';
import '../containers/e_button.dart';
import 'feedback_detail/feedback_detail_screen.dart';

class FeedBackScreen extends StatefulWidget {
  const FeedBackScreen(this.workId, this.workType, {@required this.isFromPmis,@required this.isHasCreateInspectTicket, @required this.ticketId});

  final String workId;
  final String workType;
  final bool isFromPmis;
  final bool isHasCreateInspectTicket;
  final String ticketId;

  @override
  State<StatefulWidget> createState() {
    return _FeedBackState();
  }
}

class _FeedBackState extends State<FeedBackScreen> implements ListDelegate {
  final controller = FeedBackController();
  final _refreshController = RefreshController(initialRefresh: false);
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.workId = widget.workId;
    controller.delegate = this;
    Future.delayed(const Duration(milliseconds: 100),
        () => {controller.loadData(ListTypeLoad.load)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCommon(
        title: 'Phản hồi',
        actions: [
          IconButton(
              onPressed: () async {
                await Get.to(() => SendFeedbackScreen(
                      workType: widget.workType,
                      ticketId: widget.ticketId,
                      isFromPmis: widget.isFromPmis,
                      isHasCreateInspectTicket: widget.isHasCreateInspectTicket,
                    ));
                await controller.loadData(ListTypeLoad.refresh);
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
      backgroundColor: HighElectricAppColor.nature02,
      body: Obx(() {
        if (controller.isShowLoading.value) {
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: 40,
                    width: 40,
                    margin: const EdgeInsets.only(top: 30),
                    child: const CircularProgressIndicator(),
                  ),
                )
              ],
            ),
          );
        } else {
          return Stack(
            children: [
              if (controller?.works?.obs?.value?.isEmpty == true &&
                  controller.isFirstLoad)
                const Center(
                  child: Text(
                    HighElectricStrings.emptyList,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              _renderList()
            ],
          );
        }
      }),
    );
  }

  Widget _renderList() {
    return Column(
      children: [
        _buildSearch(),
        _buildInfoHeader(),
        Expanded(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: controller.isHasLoadMore.value ?? false,
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
              separatorBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                );
              },
              itemBuilder: (context, index) {
                final model = controller.works[index];
                return _buildFeedBackItem(model);
              },
              itemCount: controller.works.length,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onRefresh() async {
    await controller.loadData(ListTypeLoad.refresh);
  }

  Future<void> _onLoadMore() async {
    await controller.loadData(ListTypeLoad.loadMore);
  }

  @override
  void onLoadMoreSuccess() {
    _refreshController.loadComplete();
  }

  @override
  void onRefreshSuccess() {
    _refreshController.refreshCompleted();
  }

  Widget _buildFeedBackItem(FeedBack model) {
    return GestureDetector(
      onTap: () async {
        await Get.to(() => FeedbackDetailScreen(
              id: model.id,
            ));
      },
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(model.getCreateDate()),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  SvgPicture.asset(model.getIconType())
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      model.description,
                      style: Styles.textTitleContent,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  )
                ],
              ),
            ),
            Container(
              height: 4,
              color: model.isSend
                  ? HighElectricAppColor.greenColor
                  : HighElectricAppColor.orange2,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: HighElectricAppColor.nature01,
      child: Row(children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: Colors.grey.shade300)),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black87),
                    cursorHeight: 0,
                    cursorWidth: 0,
                    focusNode: _focusNode,
                    controller: controller.searchController,
                    // autofocus: false,
                    onChanged: (value) {
                      controller.searchTerm.value = value;
                    },
                    onEditingComplete: () async {
                      _focusNode.unfocus();
                      await controller.loadData(ListTypeLoad.refresh);
                    },
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(10, 12, 20, 10),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintStyle: TextStyle(
                          color: HighElectricAppColor.nature04,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      hintText: 'Nhập từ khóa tìm kiếm',
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    controller.searchController.text = '';
                    controller.searchTerm.value = '';
                    await controller.loadData(ListTypeLoad.refresh);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right:8.0),
                    child: Icon(Icons.close, color: HighElectricAppColor.nature04,),
                  ),
                )
              ],
            ),
          ),
        ),

        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            _showFilter();
          },
          child: Button40(
              child: Container(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              HighElectricAppIcon.filter,
              color: controller.hasFilter()?HighElectricAppColor.orange:Colors.white,
            ),
          )),
        )
      ]),
    );
  }

  void _showFilter() {
    if (controller.fromDateTime != null && controller.toDateTime != null) {
      controller.timeController.value.text =
      '${controller.fromDateTime.toStringFormat(HighElectricStrings.ddMMyyyy)} - ${controller.toDateTime.toStringFormat(HighElectricStrings.ddMMyyyy)}';
    } else {
      controller.timeController.value.text = '';
    }
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
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1, color: Colors.grey.shade300)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Obx(()=>TextField(
                                    controller: controller.timeController.value,
                                    decoration: const InputDecoration(
                                      enabled: false,
                                      border: InputBorder.none,
                                      hintText: 'Chọn khoảng thời gian',
                                      isDense: true,
                                    ),
                                  ),)
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: HighElectricAppColor.nature05,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ))),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                            controller.toDateTime=null;
                            controller.fromDateTime=null;
                            controller.toDate='';
                            controller.fromDate='';

                            controller.isFilter.value = false;
                            controller.loadData(ListTypeLoad.load);
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
                              controller.isFilter.value = true;
                              controller.loadData(ListTypeLoad.load);
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
              ));
        });
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final arrDateSearch = await showTimePickerSearch(
        context, controller.fromDateTime ?? DateTime(DateTime.now().year, DateTime.now().month, 1), controller.toDateTime??DateTime(DateTime.now().year, DateTime.now().month + 1, 0));
    if (arrDateSearch != null) {

      controller.fromDateTime = arrDateSearch.start;
      controller.toDateTime = arrDateSearch.end;
      controller.fromDate = arrDateSearch.start.formatFirstDate();
      controller.toDate = arrDateSearch.end.formatSecondDate();
      controller.timeController.value.text =
        '${arrDateSearch.start.toStringFormat(HighElectricStrings.ddMMyyyy)} - ${arrDateSearch.end.toStringFormat(HighElectricStrings.ddMMyyyy)}';
      controller.timeController.refresh();
      if (Get.context.isTablet) {
        // await _controller.getListViolate();
      }
    }
  }

  Widget _buildInfoHeader() {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 5),
      color: HighElectricAppColor.nature01,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tổng số: ${controller.paging.value.totalCount}',
            style: Styles.textNormalContent,
          ),
          Text(
            'Đã gửi: ${controller.paging.value.completeCount}',
            style: const TextStyle(
              color: HighElectricAppColor.greenColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            'Đã nhận: ${controller.paging.value.processingCount}',
            style: const TextStyle(
              color: HighElectricAppColor.orange2,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

