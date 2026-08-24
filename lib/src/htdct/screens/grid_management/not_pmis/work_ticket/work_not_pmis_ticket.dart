// @dart=2.9
import 'package:evnmobile/routes.dart';
import 'package:evnmobile/src/htdct/models/day_night/ticket.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/transformer/transformer_ticket_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../common/constance/app_color.dart';
import '../../line/tab_check/general_info/line_general_information.dart';
import 'tab_common/content_check/content_check.dart';
import 'tab_common/general_info/general_information.dart';
import 'tab_common/group_check/group_check_list.dart';

class WorkNotPmisTicket extends StatefulWidget {
  const WorkNotPmisTicket();

  @override
  State<WorkNotPmisTicket> createState() => _WorkNotPmisTicketState();
}

class _WorkNotPmisTicketState extends State<WorkNotPmisTicket>
    with TickerProviderStateMixin {
  final TransformerTicketController _controller = Get.find();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final _views = <Widget>[
      _getGeneralView(),
      const GroupCheckListView(),
      const ContentCheckView(),
    ];
    return Scaffold(
      appBar: _renderAppbar(),
      body: Container(
        color: HighElectricAppColor.bgColor,
        child: TabBarView(
          controller: _tabController,
          children: _views,
        ),
      ),
    );
  }

  AppBar _renderAppbar() {
    final _tabs = <Tab>[
      const Tab(child: Text('Thông tin chung')),
      const Tab(text: 'Nhóm phân công'),
      const Tab(text: 'Nội dung'),
    ];
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: HighElectricAppColor.primary10,
      leading: BackButton(
        color: Colors.white,
        onPressed: handleBack,
      ),
      title: const Text(
        'Thông tin công việc',
        style: TextStyle(
            fontSize: 20,
            color: HighElectricAppColor.nature01,
            fontWeight: FontWeight.w600),
      ),
      bottom: TabBar(
        isScrollable: true,
        controller: _tabController,
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelColor: HighElectricAppColor.nature04,
        labelColor: HighElectricAppColor.orange,
        indicatorColor: HighElectricAppColor.orange,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: _tabs,
      ),
      titleSpacing: 0,
      centerTitle: false,
    );
  }

  Widget _getGeneralView() {
    if (_controller.testType != TestType.line ) {
      //tram bien ap
      return const GeneralInformationView();
    } else {
      // duong day
      return const LineGeneralInformationView();
    }
  }


  Future<bool> handleBack() async {
    //Get.until((route) => [Routes.testPlanNotPmis].contains(route.settings.name));
    Get.back();
    return true;
  }
}

