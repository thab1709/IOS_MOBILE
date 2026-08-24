// @dart=2.9
import 'package:evnmobile/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../htdct/common/themes/colorx.dart';
import '../../../htdct/models/day_night/ticket.dart';
import '../../common/constance/app_color.dart';
import '../../common/utils/alert_dialog_utils.dart';
import '../home/home_controller.dart';
import 'grid_management_controller.dart';
import 'not_pmis/test_plan/test_plan_screen.dart';

class GridManagementScreen extends StatefulWidget {
  @override
  State<GridManagementScreen> createState() => _GridManagementScreenState();
}

class _GridManagementScreenState extends State<GridManagementScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  final HighGridManagementController _controller =
      Get.put(HighGridManagementController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final _views = <Widget>[
      _renderBody(ticketType: TicketType.periodicDay),
      TestPlanView(),
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
      const Tab(text: 'Từ PMIS'),
      const Tab(text: 'Không từ PMIS'),
    ];
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: HighElectricAppColor.primary10,
      title: const Padding(
        padding: EdgeInsets.only(left: 15),
        child: Text(
          'Danh sách loại kiểm tra',
          style: TextStyle(
              fontSize: 20,
              color: HighElectricAppColor.nature01,
              fontWeight: FontWeight.w600),
        ),
      ),
      bottom: TabBar(
        isScrollable: false,
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
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: _tabs,
      ),
      titleSpacing: 0,
      centerTitle: false,
    );
  }

  Widget _renderBody({TicketType ticketType}) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      // padding: EdgeInsets.all(15),
      color: Colors.white,
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                TestType.subStation.title,
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
          ),
          _renderMenu(type:TestType.subStation, ticketType:ticketType),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              height: 5,
              color: AppColor.backgroundColorGray,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                TestType.line.title,
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
          ),
          _renderMenu(type:TestType.line, ticketType:ticketType),
          const SliverToBoxAdapter(
              child: SizedBox(
            height: 15,
          )),
        ],
      ),
    );
  }

  Widget _renderMenu({TestType type, TicketType ticketType}) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.3,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
              padding: index % 2 == 0
                  ? const EdgeInsets.only(left: 15)
                  : const EdgeInsets.only(right: 10),
              child: _renderMenuItem(type, ticketType==TicketType.experiment?type.ticketsNotPMIS[index]:type.tickets[index]));
        },
        childCount: ticketType==TicketType.experiment?type.ticketsNotPMIS.length:type.tickets.length,
      ),
    );
  }

  Widget _renderMenuItem(TestType subStationType, TicketType ticketType) {
    return GestureDetector(
      onTap: () {
        _handleMenuTap(subStationType, ticketType);
      },
      child: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ticketType.bgColor,
        ),
        child: Row(
          children: [
            // Image(image:ticketType.icon),
            ticketType.icon,
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                ticketType.title,
                style: ticketType.textStyle,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                maxLines: 2,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _handleMenuTap(TestType subStationType, TicketType ticketType) async {
    if(ticketType == TicketType.periodicCBM /*|| ticketType == TicketType.experiment || ticketType == TicketType.tunnelCable*/) {
      await hShowDialogOneButton('Hệ thống này đang trong quá trình phát triển');
      return;
    }
    await _controller.setTypeWork(subStationType, ticketType);
    if(ticketType == TicketType.experiment) {
      await Get.toNamed(Routes.testPlanNotPmis);
    }
    else {
      await Get.toNamed(Routes.testPlan);
    }
  }
}

