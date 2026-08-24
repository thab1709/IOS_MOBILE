// @dart=2.9
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_work/scan_qr/scan_qr_report_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_by_transformer/widgets/item_work_by_transfomer.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_by_transformer/work_by_transformer_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../app_common/shared/app_shared.dart';
import '../../../../htdct/common/constance/app_color.dart';
import '../../../common/components/drawer_app.dart';
import '../../../common/themes/colorx.dart';
import '../../../offline_service/sync_manager.dart';
import 'filter/filter_work_screen.dart';

class WorkByTransformerScreen extends StatefulWidget {
  const WorkByTransformerScreen({Key key}) : super(key: key);

  @override
  State<WorkByTransformerScreen> createState() => _WorkByTransformerState();
}

class _WorkByTransformerState extends State<WorkByTransformerScreen>
    with SingleTickerProviderStateMixin {
  final _controller = Get.put(WorkByTransformerController());
  final _refreshController = RefreshController(initialRefresh: false);
  AnimationController controller;
  Animation<double> animation;
  final searchFocus = FocusNode();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(controller);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // Bước 1: getUnits trước để có unit ID, loadData mới đúng bộ lọc
      await _controller.getUnits();
      // Bước 2: Chạy song song 2 tác vụ không phụ thuộc nhau
      await Future.wait([
        _controller.getDataEquipmentReport(),
        _controller.loadData(),
      ]);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: AnimatedIcon(
            color: Colors.white,
            icon: AnimatedIcons.menu_close,
            progress: controller,
          ),
          onPressed: () {
            if (_controller.isSearching.value) {
              controller.reverse();
              textEditingController.text = '';
              _controller.searchTerm.value = textEditingController.text;
              if (_controller.isSearched) {
                _controller.isSearched = false;
                _controller.loadData();
              }
              _controller.isSearching.value = !_controller.isSearching.value;
            } else {
              scaffoldKey.currentState.openDrawer();
            }
          },
        ),
        title: LayoutBuilder(builder: (context, constrains) {
          return Obx(() => Row(
            children: [
              if (!_controller.isSearching.value)
                const Expanded(child: Text('Danh sách công việc')),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width:
                _controller.isSearching.value ? constrains.maxWidth : 0,
                child: _controller.isSearching.value
                    ? TextFormField(
                  style: const TextStyle(color: Colors.black87),
                  focusNode: searchFocus,
                  controller: textEditingController,
                  onFieldSubmitted: (value) {
                    _controller.searchTerm.value = value;
                    searchFocus.unfocus();
                    _controller.isSearched = true;
                    _controller.loadData();
                  },
                  decoration: const InputDecoration(
                    isDense: true,
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding:
                    EdgeInsets.fromLTRB(12, 12, 50, 12),
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        color: HighElectricAppColor.nature03,
                      ),
                    ),
                    hintStyle: TextStyle(
                        color: HighElectricAppColor.nature04,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                    hintText: 'Nhập từ khóa',
                  ),
                )
                    : const SizedBox(),
              )
            ],
          ));
        }),
        actions: [
          Obx(() {
            if (_controller.isSearching.value) {
              return const SizedBox();
            }
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Tìm kiếm',
                  icon: const Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _controller.isSearching.value = !_controller.isSearching.value;
                    searchFocus.requestFocus();
                    controller.forward();
                  },
                ),
              ],
            );
          }),
          IconButton(
              tooltip: 'Bộ lọc',
              onPressed: () async {
                final result = await Get.to(() => FilterWorkByTransformerScreen());
                if (result == true) {
                  await _controller.loadData();
                }
              },
              icon: Obx(() => Icon(
                Icons.filter_list,
                color: _controller.isFilter.value ? Colors.orange : Colors.white,
              ))),
        ],
      ),
      drawer: AppDrawer(
        index: CategoryMenu.work,
      ),
      floatingActionButton: (AppShared.instance.getUserProfile().isHasCreateFormReport())
          ? FloatingActionButton(
        backgroundColor: RAppColor.colorOrange,
        onPressed: () async {
          await RSyncManager.instance.doSync();
        },
        child: const Icon(Icons.sync),
      )
      : Container(),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Obx(() => CupertinoSlidingSegmentedControl<int>(
                    groupValue: _controller.workGroupType.value,
                    children: const {
                      0: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('Đơn vị'),
                      ),
                      1: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('Cho các X'),
                      ),
                    },
                    onValueChanged: (value) {
                      if (value != null) {
                        _controller.workGroupType.value = value;
                        _controller.loadData();
                      }
                    },
                  )),
            ),
          ),
          Expanded(
            child: Obx(() {
        if (_controller.works.isEmpty ??
            true && _controller.isFirstLoad) {
          return const Center(
            child: Text('Danh sách trống'),
          );
        }
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(
            refresh: Container(),
            complete: const Icon(
              Icons.done,
              color: RAppColor.highlightColor70,
            ),
          ),
          footer: const ClassicFooter(
            loadStyle: LoadStyle.ShowWhenLoading,
            loadingText: 'Đang tải...',
            noDataText: 'Không còn dữ liệu',
            canLoadingText: 'Vuốt lên để tải thêm',
            failedText: 'Tải thất bại',
            idleText: 'Vuốt lên để tải thêm',
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: () async {
             await _controller.loadMore();
             if (_controller.canLoadMore.value) {
               _refreshController.loadComplete();
             } else {
               _refreshController.loadNoData();
             }
          },
          child: ListView.builder(
              itemCount: _controller.works.length,
              itemBuilder: (context, index) => ItemWorkByTransformer(
                model: _controller.works[index],
                index: index,
                onReloadData: () {
                  _controller.loadData();
                },
                callbackChangePaperReport: (work) {
                  _controller.handleChangePaperReport(work);
                },
                onCreateReport: (work) {
                  _controller.handleCreateFormReport(work);
                },
              )),
        );
      })),
        ],
      ),
    );
  }

  void _onRefresh() async {
    await _controller.loadData();
    _refreshController.refreshCompleted();
    _refreshController.resetNoData();
  }
}

