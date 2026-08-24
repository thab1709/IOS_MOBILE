// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/components/drawer_app.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/common/enum/enum_workload.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/list_request/page/request_page.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/list_request/search/search_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../common/constance_workload.dart';
import 'filter/request_filter.dart';
import 'list_request_controller.dart';

class ListRequest extends StatefulWidget {
  const ListRequest({Key key}) : super(key: key);

  @override
  State<ListRequest> createState() => _ListRequestState();
}

class _ListRequestState extends State<ListRequest>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final ListRequestController controller = Get.find();
  int index = 0;

  @override
  void initState() {
    super.initState();
    controller.getUnits();
    _tabController =
        TabController(length: EnumRequestStatus.values.length, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: EnumRequestStatus.values.length,
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            centerTitle: false,
            title: const Text(
              'Danh sách yêu cầu',
              style: TextStyle(fontSize: TextSize.normal),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded, color: Colors.white),
                onPressed: () {
                 Get.to(() => SearchRequestScreen());
                },
              ),
              IconButton(
                  onPressed: () async {
                   final result = await Get.to(() => RequestFilter());
                   if(result is bool) {
                     controller.reloadTab(_tabController.index);
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
              tabs: EnumRequestStatus.values
                  .map((e) => Tab(
                        text: e.getName(),
                      ))
                  .toList(),
            ),
          ),
          drawer: AppDrawer(
            index: CategoryMenu.request,
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
    super.dispose();
    _tabController.dispose();
  }

  List<Widget> _buildTab() {
    final list = RequestStatusCode.listOption
        .mapIndexed((e, i) => RequestPage(
              status: e,
              index: i,
              tabController: _tabController,
            ))
        .toList();
    return list;
  }
}

