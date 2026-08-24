// @dart=2.9
import 'dart:async';

import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/components/drawer_app.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/utils/connection.dart';
import 'package:evnmobile/src/qltnkd/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_work/filter/filter_work_screen.dart';

import 'package:evnmobile/src/qltnkd/screens/verification_report/list_work/search/search_work_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_work/tab/list_work_tab_view.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_work/work_report_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../app_common/shared/app_shared.dart';
import '../../../common/themes/colorx.dart';
import '../../../offline_service/sync_manager.dart';

class WorkReportScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListWorkState();
  }
}

class _ListWorkState extends State<WorkReportScreen>
    with SingleTickerProviderStateMixin {
  final GetMaterialController getController = Get.find();

  final _controller = Get.put(WorkReportController());
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    RLocalDataManager.instance.getUserProfile();
    _tabController =
        TabController(length: _controller.optionsStatus.length, vsync: this);
    getController.defaultTransition = Transition.cupertino;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      unawaited(_controller.getDataEquipmentReport());
      final result = await _controller.checkVersionApp();
      if(!result){
        // await showDialogUpdateApp();
      }
      if (await RSyncManager.instance.isHasReportOffline() && await RConnection.shared.checkConnection()) {
        unawaited(RSyncManager.instance.doAutoSync());
      }
    });

  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.filterController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _controller.optionsStatus.length ?? 0,
        child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              centerTitle: false,
              title: const Text(
                'Danh sách công việc',
                style: TextStyle(fontSize: TextSize.normal),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search_rounded, color: Colors.white),
                  onPressed: () {
                    Get.to(() => SearchWorkScreen());
                  },
                ),
                IconButton(
                    onPressed: () async {
                     final result = await Get.to(() => FilterWorkScreen());
                     if(result == true) {
                       _controller.reloadTab(_tabController.index);
                     }
                    },
                    icon: const Icon(
                      Icons.filter_list,
                      color: Colors.white,
                    )),
              ],
              bottom: TabBar(
                controller: _tabController,
                isScrollable: MediaQuery.of(context).size.width < 600,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                tabs: _controller.optionsStatus
                    .map<Tab>((optionModel) => Tab(
                          text: optionModel.title,
                        ))
                    .toList(),
              ),
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
            drawer: AppDrawer(index: CategoryMenu.work,),
            backgroundColor: RAppColor.backgroundColorGray,
            body: SafeArea(
              child: Column(
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
                                _controller.groupTypeController.sink.add(value);
                              }
                            },
                          )),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: buildListTab(),
                    ),
                  ),
                ],
              ),
            )));
  }

  List<Widget> buildListTab() {
    final list = _controller.optionsStatus
        .mapIndexed<Widget>((status, index) => ListWorkTab(
              status: '${status.value}',
              index: index
            ))
        .toList();
    return list;
  }

}

