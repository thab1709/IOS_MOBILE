// @dart=2.9
import 'package:evnmobile/routes.dart';
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/equipment_model.dart';
import 'package:evnmobile/src/htld/models/inspection_model.dart';
import 'package:evnmobile/src/htld/models/line/line_branch_info.dart';
import 'package:evnmobile/src/htld/models/line/line_general.dart';
import 'package:evnmobile/src/htld/models/line/line_model.dart';
import 'package:evnmobile/src/htld/models/work_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/tabs/group/group_check_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/medium_conclude_ht_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/day/medium_content_day_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/medium_content_incident_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/night/medium_content_night_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../../app_env.dart';
import '../../../../../app_common/shared/app_shared.dart';
import '../day/medium_content_day_ht_screen.dart';
import '../incident/medium_content_incident_ht_screen.dart';
import 'medium_conclude_screen.dart';
import 'medium_general_information_screen.dart';

class LineArgument {
  LineModel line;
  LineModel branch;
  List<EquipmentModel> kinks;
  List<EquipmentModel> equipments;
  bool isNight;

  LineArgument({
    this.line,
    this.branch,
    this.kinks,
    this.equipments,
    this.isNight = false,
  });
}

class LineTicketArgument {
  TicketType ticketType;
  ActionType actionType;
  InspectionModel inspectionModel;
  WorkModel workModel;
  String fre;
  LineTicketArgument(
      {this.ticketType,
      this.actionType,
      this.inspectionModel,
      this.workModel,
      this.fre});

  bool isEdit() {
    return actionType != ActionType.view;
  }
}

class LineTicketController extends GetxController {
  String ticketId;
  LineTicketArgument argument;
  List<LineBranchInfo> listLineBranchInfo;
  List<EquipmentModel> substations;
  LineGeneral line;
  bool isInitInternetStateOnline = true;
  bool isSelectedAllLine = false;

  Future<bool> isHandleDataOnline() async {
    final isCurrentInternetStateOnline =
        await Connection.shared.checkConnection();
    return isInitInternetStateOnline && isCurrentInternetStateOnline;
  }
}

class LineTicketScreen extends StatefulWidget {
  const LineTicketScreen();
  @override
  _LineTicketScreenState createState() => _LineTicketScreenState();
}

class _LineTicketScreenState extends State<LineTicketScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final LineTicketController _ticketController = Get.find();

  Future _getInternetState() async {
    _ticketController.isInitInternetStateOnline =
        await Connection.shared.checkConnection();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _getInternetState();
    Get.put(TicketController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: AppColor.highlightColor70,
        leading: BackButton(
          onPressed: () {
            Get.until((route) =>
                route.settings.name == Routes.historyCheck ||
                route.settings.name == Routes.periodicInspectionPlanView ||
                route.settings.name == Routes.chooseLine ||
                route.settings.name == Routes.chooseSubstation);
          },
        ),
        title: Column(
          children: [
            // const Text('Kiểm tra đường dây trung áp' ),
            Text(
                ' ${AppShared.instance.getAppType() == AppType.HTLDTT ? 'Kiểm tra đường dây trung áp' : 'Kiểm tra công trình hạ áp'}'),
            const SizedBox(
              height: 4,
            ),
            Text(
              'Loại kiểm tra: ${_ticketController.argument.ticketType.title.capitalizeFirst}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            )
          ],
        ),
        bottom: TabBar(
          labelStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          indicatorColor: AppColor.colorOrange,
          controller: _tabController,
          isScrollable: Get.context.isPhone,
          tabs: _renderTabs(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _getGeneralInforScreen(() {
            _next(1);
          }),
          GroupCheckScreen(
            next: () {
              _next(2);
            },
            isLine: true,
          ),
          _getPageContent(() {
            _next(3);
          }),
          if (AppShared().getAppType() == AppType.HTLDHT) MediumConcludeHTScreen() else MediumConcludeScreen()
        ],
      ),
    );
  }

  Widget _getGeneralInforScreen(Function funcNext) {
    return MediumGeneralInformationScreen(next: funcNext);
  }

  Widget _getPageContent(Function funcNext) {
    final htldht = AppShared().getAppType() == AppType.HTLDHT;
    switch (_ticketController.argument.ticketType) {
      case TicketType.periodicNight:
        return MediumContentNightScreen(
          next: funcNext,
        );
        break;

      case TicketType.periodicDay:
        return htldht ? MediumContentDayHTScreen(
          next: funcNext,
        ) : MediumContentDayScreen(
          next: funcNext,
        );
        break;

      case TicketType.fortuityDay:
        return htldht ? MediumContentDayHTScreen(
          next: funcNext,
        ) : MediumContentDayScreen(
          next: funcNext,
        );
        break;

      case TicketType.techDay:
        return htldht ? MediumContentDayHTScreen(
          next: funcNext,
        ) : MediumContentDayScreen(
          next: funcNext,
        );
        break;

      case TicketType.incidentDay:
        return htldht ? MediumContentIncidentHTScreen(
          next: funcNext,
        ) : MediumContentIncidentScreen(
          next: funcNext,
        );
        break;

      default:
        return Container();
    }
  }

  List<Tab> _renderTabs() {
    final tabs = <String>[
      'Thông tin chung',
      'Nhóm kiểm tra',
      'Nội dung kiểm tra',
      'Kết quả'
    ];
    return tabs.map((e) {
      return Tab(text: e);
    }).toList();
  }

  void _next(int index) {
    switch (_tabController.index) {
      case 0:
        _tabController.animateTo(1);
        break;
      case 1:
        _tabController.animateTo(2);
        break;
      case 2:
        _tabController.animateTo(3);
        break;
      default:
        break;
    }
  }
}

