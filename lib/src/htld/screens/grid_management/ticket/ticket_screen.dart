// @dart=2.9
import 'package:evnmobile/routes.dart';
import 'package:evnmobile/src/htld/models/line/line_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/distribution_substation/day/distribution_day_content.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/line_ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../app_env.dart';
import '../../../../app_common/shared/app_shared.dart';
import '../../../common/themes/colorx.dart';
import '../../../models/day_night/ticket.dart';
import '../../../models/equipment_model.dart';
import '../../../models/inspection_model.dart';
import '../../../models/substation_model.dart';
import '../containers/tabs/general_information_screen.dart';
import '../containers/tabs/group/group_check_screen.dart';
import '../containers/tabs/result/result_screen.dart';
import '../distribution_substation/night/distribution_night_content.dart';
import '../intermediate_transformer_station/day/inter_content_day_screen.dart';
import '../intermediate_transformer_station/night/inter_content_night.dart';
import '../medium_voltage_line/common/medium_conclude_ht_screen.dart';
import '../medium_voltage_line/common/medium_conclude_screen.dart';
import '../medium_voltage_line/common/medium_general_information_screen.dart';
import '../medium_voltage_line/day/medium_content_day_ht_screen.dart';
import '../medium_voltage_line/day/medium_content_day_screen.dart';
import '../medium_voltage_line/incident/medium_content_incident_ht_screen.dart';
import '../medium_voltage_line/incident/medium_content_incident_screen.dart';
import '../medium_voltage_line/night/medium_content_night_screen.dart';
import 'ticket_controller.dart';

class TicketScreen extends StatefulWidget {
  TicketScreen({this.ticketScreenArgument, this.lineTicketArgument});
  final TicketScreenArgument ticketScreenArgument;
  final LineTicketArgument lineTicketArgument;

  final TicketController _ticketController = Get.put(TicketController());
  @override
  _TicketScreenState createState() => _TicketScreenState();
}

enum ActionType { edit, view, create }

class TicketScreenArgument {
  TicketScreenArgument(
      {this.ticketType,
      this.ticketId,
      this.subStationType,
      this.substationModel,
      this.equipments,
      this.inspectionModel,
      this.actionType,
      this.workId,
      this.lineModel});

  InspectionModel inspectionModel;
  TicketType ticketType;
  SubStationType subStationType;
  List<EquipmentModel> equipments;
  SubstationModel substationModel;
  String workId;
  String fre;
  String ticketId;
  ActionType actionType;
  LineModel lineModel;
}

class _TicketScreenState extends State<TicketScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    widget._ticketController.ticketScreenArgument = widget.ticketScreenArgument;
    widget._ticketController.ticketID =
        widget.ticketScreenArgument.inspectionModel?.id ??
            widget.ticketScreenArgument.ticketId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: AppColor.highlightColor70,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            if (widget._ticketController.ticketID != null) {
              Get.until((route) =>
                  route.settings.name == Routes.periodicInspectionPlanView ||
                  route.settings.name == Routes.historyCheck);
            } else {
              Get.back();
            }
          },
        ),
        title: Column(
          children: [
            Text(
              '${widget.ticketScreenArgument.subStationType.title.toUpperCase()}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Loại kiểm tra: ${widget.ticketScreenArgument.ticketType.title.capitalizeFirst}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            )
          ],
        ),
        bottom: TabBar(
          labelStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          indicatorColor: AppColor.colorOrange,
          controller: _tabController,
          isScrollable: GetPlatform.isMobile,
          tabs: _renderTabs(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _getGeneralInforScreen(widget.ticketScreenArgument, () {
            _next(1);
          }),
          GroupCheckScreen(
            next: () {
              _next(2);
            },
            isLine: false,
          ),
          _getPageContent(widget.ticketScreenArgument, () {
            _next(3);
          }),
          _getConcludeScreen(widget.ticketScreenArgument)
        ],
      ),
    );
  }

  Widget _getGeneralInforScreen(
      TicketScreenArgument argument, Function funcNext) {
    switch (argument.subStationType) {
      case SubStationType.distribution:
        return GeneralInformationScreen(next: funcNext);
      case SubStationType.intermediate:
        return GeneralInformationScreen(next: funcNext);
      case SubStationType.mediumVoltage:
        return MediumGeneralInformationScreen(next: funcNext);
      case SubStationType.lowVoltage:
        return MediumGeneralInformationScreen(next: funcNext);
      default:
        return Container();
    }
  }

  Widget _getPageContent(TicketScreenArgument argument, Function funcNext) {
    switch (argument.subStationType) {
      case SubStationType.distribution:
        switch (argument.ticketType) {
          case TicketType.periodicNight:
            return DistributionNightContent(
              next: funcNext,
            );
            break;
          default:
            return DistributionDayContent(next: funcNext);
            break;
        }
        break;

      case SubStationType.intermediate:
        switch (argument.ticketType) {
          case TicketType.periodicNight:
            return InterContentNightScreen(
              next: funcNext,
            );
            break;

          case TicketType.periodicDay:
            return InterContentDayScreen(
              next: funcNext,
            );
            break;

          case TicketType.techDay:
            return InterContentDayScreen(
              next: funcNext,
            );
            break;

          default:
            return Container();
        }
        break;

      case SubStationType.mediumVoltage:
        final htldht = AppShared().getAppType() == AppType.HTLDHT;
        switch (argument.ticketType) {
          case TicketType.periodicNight:
            return MediumContentNightScreen(
              next: funcNext,
            );
            break;

          case TicketType.periodicDay:
            return htldht
                ? MediumContentDayHTScreen(
                    next: funcNext,
                  )
                : MediumContentDayScreen(
                    next: funcNext,
                  );
            break;

          case TicketType.fortuityDay:
            return htldht
                ? MediumContentDayHTScreen(
                    next: funcNext,
                  )
                : MediumContentDayScreen(
                    next: funcNext,
                  );
            break;

          case TicketType.techDay:
            return htldht
                ? MediumContentDayHTScreen(
                    next: funcNext,
                  )
                : MediumContentDayScreen(
                    next: funcNext,
                  );
            break;

          case TicketType.incidentDay:
            return htldht
                ? MediumContentIncidentHTScreen(
                    next: funcNext,
                  )
                : MediumContentIncidentScreen(
                    next: funcNext,
                  );
            break;

          default:
            return Container();
        }
        break;

      default:
        return Container();
    }
  }

  Widget _getConcludeScreen(TicketScreenArgument argument) {
    switch (argument.subStationType) {
      case SubStationType.distribution:
        return ConcludeScreen();
      case SubStationType.intermediate:
        return ConcludeScreen();
      case SubStationType.mediumVoltage:
        return AppShared().getAppType() == AppType.HTLDHT
            ? MediumConcludeHTScreen()
            : MediumConcludeScreen();
      case SubStationType.lowVoltage:
        return AppShared().getAppType() == AppType.HTLDHT
            ? MediumConcludeHTScreen()
            : MediumConcludeScreen();
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

  void injectController() {
    widget._ticketController.ticketScreenArgument = widget.ticketScreenArgument;
  }
}

