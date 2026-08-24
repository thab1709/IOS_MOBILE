// @dart=2.9
import 'package:evnmobile/src/htdct/common/components/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../htdct/common/enum/list.dart';
import '../../../../common/components/field_infor_item.dart';
import '../../../../common/themes/colorx.dart';
import '../../../../delegate/list_delegate.dart';
import '../../../../models/form_report_copy_model.dart';
import '../../../../models/report_work.dart';
import 'copy_report_controller.dart';

class CopyReportScreen extends StatefulWidget {
  const CopyReportScreen(this.reportWorkItem, {this.groupType = 0, Key key}) : super(key: key);
  final ReportWorkItem reportWorkItem;
  final int groupType;

  @override
  State<CopyReportScreen> createState() => _CopyReportScreenState();
}

class _CopyReportScreenState extends State<CopyReportScreen>
    implements ListDelegate {
  final controller = CopyReportController();
  final _refreshController = RefreshController(initialRefresh: true);
  final textController = TextEditingController();
  final textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.delegate = this;
    controller.scheduleId = widget.reportWorkItem.id;
    controller.equipmentDetailId = widget.reportWorkItem.equipmentDetailId;
    controller.equipmentTypeId = widget.reportWorkItem.equipmentTypeId;
    controller.groupType = widget.groupType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Copy biên bản'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: textFieldFocusNode,
                      controller: textController,
                      onSubmitted: (val) {
                        controller.searchTerm.value = val;
                        controller.loadData(ListTypeLoad.refresh);
                      },
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          errorBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                          focusedBorder: InputBorder.none,
                          prefixIcon: Icon(Icons.search_rounded)),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        textController.text = '';
                        controller.searchTerm.value = '';
                        textFieldFocusNode.unfocus();
                        controller.loadData(ListTypeLoad.refresh);
                      },
                      icon: const Icon(Icons.clear))
                ],
              ),
            ),
            Expanded(child: _renderList()),

          ],
        ),
      ),
      bottomNavigationBar:  Obx(() {
        final report = controller.getReportSelected();
        return EButton(
            maxSize: true,
            color:
            report != null ? RAppColor.highlightColor70 : Colors.grey,
            borderRadius: 0,
            title: 'Xác nhận',
            action: () {
              if (report != null) Get.back(result: report);
            });
      }),
    );
  }

  Widget _renderList() {
    return Obx(() => SmartRefresher(
          enablePullDown: true,
          enablePullUp: controller.isHasLoadMore.value ?? false,
          header: WaterDropHeader(
            refresh: Container(),
            complete: const Icon(
              Icons.done,
              color: RAppColor.highlightColor70,
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
              final model = controller.reports[index];
              return renderItem(model, () {
                controller.handleSelectItem(model);
              },
                  isLast: index == controller.reports.length - 1);
            },
            itemCount: controller.reports.length,
          ),
        ));
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

  Widget renderItem(FormReportCopyModel model, Function() onChange,
      {bool isLast}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: model.isChecked == true ? Colors.blue.shade100 : Colors.white,
      ),
      margin: EdgeInsets.only(top: 16, bottom: isLast ? 16 : 0),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  model.reportNumber,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: RAppColor.highlightColor70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Radio(
                  value: model.isChecked,
                  groupValue: true,
                  onChanged: (val) {
                    onChange();
                  })
              //const Icon(Icons.arrow_forward_sharp)
            ],
          ),
          const Divider(
            thickness: 1,
            height: 30,
          ),
          FieldInfoItem(
            titleFirst: 'Vị trí',
            valueFirst: model.location,
            titleSecond: 'Nội dung',
            valueSecond: model.content,
          ),
          FieldInfoItem(
            titleFirst: 'Loại công việc',
            valueFirst: model.formType,
            titleSecond: 'Giám sát',
            valueSecond: model.isMonitor ? 'Có' : 'Không',
          ),
        ],
      ),
    );
  }
}

