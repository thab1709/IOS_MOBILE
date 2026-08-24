// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/components/drawer_app.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/common/enum/enum_workload.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/list_workload/page/workload_page.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/list_workload/search/search_workload_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../common/constance_workload.dart';
import 'filter/workload_filter.dart';
import 'list_workload_controller.dart';

class ListWorkload extends StatefulWidget {
  const ListWorkload({Key key}) : super(key: key);

  @override
  State<ListWorkload> createState() => _ListWorkloadState();
}

class _ListWorkloadState extends State<ListWorkload>
    with SingleTickerProviderStateMixin {
  final _controller = Get.put(ListWorkloadController());
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller.getUnits();
    _tabController =
        TabController(length: EnumWorkload.values.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: EnumWorkload.values.length,
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            centerTitle: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded, color: Colors.white),
                onPressed: () {
                  Get.to(() => SearchWorkloadScreen());
                },
              ),
              IconButton(
                  onPressed: () async {
                    final result = await Get.to(() => WorkloadFilter());
                    if(result is bool) {
                      _controller.reloadTab(_tabController.index);
                    }
                  },
                  icon: const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  )),
            ],
            title: const Text('Danh sách phiếu',
              style: TextStyle(fontSize: TextSize.normal),
            ),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: MediaQuery.of(context).size.width < 600,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              tabs: EnumWorkload.values
                  .map((e) => Tab(
                        text: e.getName(),
                      ))
                  .toList(),
            ),
          ),
          drawer: AppDrawer(
            index: CategoryMenu.ticketWorkload,
          ),
          backgroundColor: RAppColor.backgroundColorGray,
          body: SafeArea(
            child: TabBarView(
              controller: _tabController,
              children: _buildTab(),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _controller.filterController.close();
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> _buildTab() {
    return WorkloadStatusCode.listOption
        .mapIndexed((e, i) => WorkloadPage(
              status: e,
              index: i,
            ))
        .toList();
  }
}

