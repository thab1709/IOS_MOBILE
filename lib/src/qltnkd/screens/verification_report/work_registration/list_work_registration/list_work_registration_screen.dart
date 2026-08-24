// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/qltnkd/common/components/drawer_app.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/list_work_registration/list_work_registration_controller.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/list_work_registration/page/work_registration_page.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/work_registration_create/work_registration_create_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/list_work_registration/filter/work_registration_filter.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/list_work_registration/search/work_registration_search.dart';

class ListWorkRegistrationScreen extends StatefulWidget {
  const ListWorkRegistrationScreen({Key key}) : super(key: key);

  @override
  State<ListWorkRegistrationScreen> createState() => _ListWorkRegistrationScreenState();
}

class _ListWorkRegistrationScreenState extends State<ListWorkRegistrationScreen> with SingleTickerProviderStateMixin {
  final _controller = Get.put(ListWorkRegistrationController());
  TabController _tabController;

  final List<String> _tabs = [
    'Tất cả',
    'Mới',
    'Chờ xác nhận',
    'Đã xác nhận',
    'Từ chối',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    
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
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.search_rounded, color: Colors.white),
              onPressed: () async {
                final result = await Get.to(() => WorkRegistrationSearch(), fullscreenDialog: true);
                if (result == true) {
                  _controller.refreshData();
                }
              },
            ),

            IconButton(
              onPressed: () async {
                final result = await Get.to(() => WorkRegistrationFilter());
                if (result == true) _controller.refreshData();
              },
              icon: const Icon(Icons.filter_list, color: Colors.white)
            ),
            IconButton(
              onPressed: () async {
                final result = await Get.to(() => const WorkRegistrationCreateScreen());
                if (result == true) {
                  _controller.refreshData();
                }
              },
              icon: const Icon(Icons.add_circle_outline_outlined, color: Colors.white)
            ),
          ],
          title: const Text(
            'Đăng ký công tác',
            style: TextStyle(fontSize: TextSize.normal),
          ),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: _tabs.map((e) => Tab(text: e)).toList(),
          ),
        ),
        drawer: AppDrawer(
          index: CategoryMenu.workRegistration, // NEED TO ADD CategoryMenu.workRegistration in common enum
        ),
        backgroundColor: RAppColor.backgroundColorGray,
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: _tabs.map((e) => WorkRegistrationPage()).toList(),
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
