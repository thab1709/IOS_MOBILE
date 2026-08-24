// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/qltnkd/common/components/drawer_app.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/common/enum/enum_survey_report.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/list_patc/list_patc_controller.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/list_patc/page/patc_page.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/patc_create/patc_create_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/list_patc/filter/patc_filter.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/list_patc/search/patc_search.dart';

class ListPatcScreen extends StatefulWidget {
  const ListPatcScreen({Key key}) : super(key: key);

  @override
  State<ListPatcScreen> createState() => _ListPatcScreenState();
}

class _ListPatcScreenState extends State<ListPatcScreen> with SingleTickerProviderStateMixin {
  final _controller = Get.put(ListPatcController());
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: EnumSurveyReport.values.length, vsync: this);
    
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _controller.onTabChanged(_tabController.index);
      }
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: EnumSurveyReport.values.length,
      child: Scaffold(

        appBar: AppBar(
          elevation: 1,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.search_rounded, color: Colors.white),
              onPressed: () {
                Get.to(() => PatcSearch());
              },
            ),

            IconButton(
              onPressed: () async {
                final result = await Get.to(() => PatcFilter());
                if (result == true) _controller.refreshData();
              },
              icon: const Icon(Icons.filter_list, color: Colors.white)
            ),
          ],
          title: const Text(
            'Phương án thi công',
            style: TextStyle(fontSize: TextSize.normal),
          ),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: EnumSurveyReport.values
                .map((e) => Tab(text: e.getName()))
                .toList(),
          ),
        ),
        drawer: AppDrawer(
          index: CategoryMenu.patc,
        ),
        backgroundColor: RAppColor.backgroundColorGray,
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: EnumSurveyReport.values
                .map((e) => PatcPage())
                .toList(),
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
