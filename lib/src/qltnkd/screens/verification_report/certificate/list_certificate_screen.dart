// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/drawer_app.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/certificate/search/search_certificate_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/certificate/tab/tab_certificate_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'filter/filter_certificate_screen.dart';
import 'list_certificate_controller.dart';

class ListCertificateScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListReportState();
  }
}

class ListReportState extends State<ListCertificateScreen>
    with SingleTickerProviderStateMixin {
  final _controller = Get.put(ListCertificateController());
  TabController _tabController;
  List<IntOptionModel> listTab;

  @override
  void initState() {
    super.initState();
    listTab = _controller.optionsStatus;
    _tabController =
        TabController(length: listTab.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: listTab.length ?? 0,
        child: Scaffold(
          backgroundColor: RAppColor.backgroundColorGray,
          appBar: AppBar(
            backgroundColor: RAppColor.highlightColor70,
            elevation: 1,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            centerTitle: false,
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: listTab
                  .map<Tab>((optionModel) => Tab(
                        text: optionModel.title,
                      ))
                  .toList(),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.to(() => SearchCertificateScreen());
                },
              ),
              IconButton(
                  onPressed: () {
                    Get.to(() => FilterCertificateScreen());
                  },
                  icon: const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  )),
            ],
            title: const Text(
              'Danh sách giấy chứng nhận',
              style: TextStyle(fontSize: TextSize.normal),
            ),
          ),
          drawer: AppDrawer(index: CategoryMenu.certificate,),
          body: SafeArea(
            child: TabBarView(
              controller: _tabController,
              children: buildListTab(),
            ),
          ),
        ));
  }

  List<Widget> buildListTab() {
    final list = listTab
        .map<Widget>((status) => TabCertificateScreen(
              statusCertificate: '${status.value}',
              isFilter: _controller.isHasValueFilterChange,
            ))
        .toList();
    if (_controller.isHasValueFilterChange) {
      _controller.isHasValueFilterChange = false;
    }
    return list;
  }
}

