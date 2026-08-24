// @dart=2.9
import 'package:evnmobile/routes.dart';
import 'package:evnmobile/src/htdct/models/day_night/ticket.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/night_content/night_content.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/transformer/transformer_ticket_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/constance/app_color.dart';
import '../line/tab_check/content/check_content.dart';
import '../line/tab_check/general_info/line_general_information.dart';
import '../line/tab_check/tunnel_cable_content/tunnel_cable_screen.dart';
import 'check_by_daytime/content/check_content.dart';
import 'tab_common/conclude/conclude.dart';
import 'tab_common/general_info/general_information.dart';
import 'tab_common/group_check/group_check_list.dart';

class TransformerTicket extends StatefulWidget {
  const TransformerTicket();

  @override
  State<TransformerTicket> createState() => _TransformerTicketState();
}

class _TransformerTicketState extends State<TransformerTicket>
    with TickerProviderStateMixin {
  final TransformerTicketController _controller = Get.find();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _controller.triggerCompleteTicket=false;
  }

  @override
  Widget build(BuildContext context) {
    final _views = <Widget>[
      _getGeneralView(),
      const GroupCheckListView(),
      _getContentView(),
      const ConcludeScreen(),
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
      const Tab(text: 'Nhóm kiểm tra'),
      const Tab(text: 'Nội dung kiểm tra'),
      const Tab(text: 'Kết luận'),
    ];
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: HighElectricAppColor.primary10,
      leading: BackButton(
        color: Colors.white,
        onPressed: handleBack,
      ),
      title: Text(
        _controller.ticketType.tabbarTitle(_controller.testType),
        style: const TextStyle(
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
    if (_controller.testType == TestType.subStation) {
      //tram bien ap
      return const GeneralInformationView();
    } else {
      // duong day
      return const LineGeneralInformationView();
    }
  }

  Widget _getContentView() {
    if (_controller.testType == TestType.subStation) {
      // tram bien ap
      switch (_controller.ticketType) {
        case TicketType.periodicNight:
          return const TBACheckContentView();
        case TicketType.periodicDay:
          return const TBACheckContentView();
        default:
          return Container();
      }
    } else {
      switch (_controller.ticketType) {
        case TicketType.periodicNight:
          return const NightContent();
        case TicketType.tunnelCable:
          return const TunnelCableContentView();
        case TicketType.periodicMonth:
          return const LineCheckContentView();
        default:
          return Container();
      }
    }
  }

  Future<bool> handleBack() async {
    Get.until((route) => [Routes.testPlan].contains(route.settings.name));
    return true;
  }
}

