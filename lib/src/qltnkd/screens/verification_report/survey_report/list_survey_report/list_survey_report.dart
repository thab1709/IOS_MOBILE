// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/components/drawer_app.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/common/enum/enum_survey_report.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/list_survey_report/list_survey_report_controller.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/list_survey_report/page/survey_report_page.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/list_survey_report/search/survey_report_search.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/list_survey_report/filter/survey_report_filter.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/survey_report_create/survey_report_create_screen.dart';

class ListSurveyReport extends StatefulWidget {
  const ListSurveyReport({Key key}) : super(key: key);

  @override
  State<ListSurveyReport> createState() => _ListSurveyReportState();
}

class _ListSurveyReportState extends State<ListSurveyReport>
    with SingleTickerProviderStateMixin {
  final _controller = Get.put(ListSurveyReportController());
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: EnumSurveyReport.values.length, vsync: this);
    
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _controller.onTabChanged(_tabController.index);
      }
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
                  Get.to(() => SurveyReportSearch());
                },
              ),
              IconButton(
                  onPressed: () async {
                    final result = await Get.to(() => SurveyReportFilter(controller: _controller));
                    if (result == true) {
                      _controller.refreshData();
                    }
                  },
                  icon: const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  )),
            ],
            title: const Text(
              'Biên bản khảo sát',
              style: TextStyle(fontSize: TextSize.normal),
            ),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              tabs: EnumSurveyReport.values
                  .map((e) => Tab(
                        text: e.getName(),
                      ))
                  .toList(),
            ),
          ),
          drawer: AppDrawer(
            index: CategoryMenu.surveyReport,
          ),
          backgroundColor: RAppColor.backgroundColorGray,
          body: SafeArea(
            child: TabBarView(
              controller: _tabController,
              children: EnumSurveyReport.values
                  .map((e) => SurveyReportPage(controller: _controller))
                  .toList(),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

