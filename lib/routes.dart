// @dart=2.9
import 'package:evnmobile/src/app_common/login/login.dart';
import 'package:evnmobile/src/app_common/login/select_module.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/content/violate_inspection_list/violate_inspection_list_screen.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/ticket/create_line_ticket.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/not_pmis/test_plan/test_plan_screen.dart'
    as test_plan_not_pmis;
import 'package:evnmobile/src/htdct/screens/grid_management/periodic_inspection_plan/periodic_inspection_plan.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/scan_qr/scan_qr_screen.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/transformer/transformer_ticket.dart';
import 'package:evnmobile/src/htdct/screens/log_book/test_plan/test_plan_screen.dart'
    as test_plan_log_book;
import 'package:evnmobile/src/htdct/screens/notify/notify_screen.dart';
import 'package:evnmobile/src/htld/screens/scan_qr/scan_qr_code_page.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/report_for_director_company/report_director_company.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_work/work_report_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_by_transformer/work_by_transformer_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/detail_request/detail_workload.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_env.dart';
import 'src/htdct/screens/grid_management/line/tab_check/night_content/night_content.dart';
import 'src/htdct/screens/grid_management/not_pmis/work_ticket/work_not_pmis_ticket.dart';
import 'src/htdct/screens/home/home.dart' as home_dct_screen;
import 'src/htld/screens/change_password/change_password_expire.dart';
import 'src/htld/screens/grid_management/choose_line/choose_line_binding.dart';
import 'src/htld/screens/grid_management/choose_line/choose_line_screen.dart';
import 'src/htld/screens/grid_management/choose_substation/choose_substation.dart';
import 'src/htld/screens/grid_management/choose_substation/choose_substation_binding.dart';
import 'src/htld/screens/grid_management/grid_management_screen.dart';
import 'src/htld/screens/grid_management/history_check/binding/history_check_binding.dart';
import 'src/htld/screens/grid_management/history_check/history_check.dart';
import 'src/htld/screens/grid_management/periodic_inspection_plan/periodic_inspection_plan.dart';
import 'src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'src/htld/screens/home/home.dart';
import 'src/qltnkd/screens/verification_report/report_by_transformer/report_by_transformer.dart';
import 'src/qltnkd/screens/verification_report/workload/list_workload/list_workload.dart';

class Routes {
  //htld
  static const home = '/';
  static const splash = '/splash';
  static const login = '/login';
  static const selectModule = '/selectModule';
  static const register = '/register';
  static const forgotPassword = '/forgotPassword';
  static const changePassword = '/changePasswordExpire';
  static const interHomeScreen = '/interHomeScreen';
  static const interScanQRScreen = '/interScanQRScreen';
  static const intersSelectCheckListScreen = '/intersSelectCheckListScreen';
  static const ticketScreen = '/ticketScreen';
  static const distributionDayCheckScreen = '/distributionDayCheckScreen';
  static const historyCheck = '/historyCheck';
  static const chooseSubstation = '/chooseSubstation';
  static const chooseLine = '/chooseLine';

  static const viewPhotoScreen = '/ViewPhotoScreen';
  static const periodicInspectionPlanView = '/periodicInspectionPlanView';

  //qltnkd
  static const reportHome = '/reportMain';
  static const workloadHome = '/workloadHome';
  static const listReportScreen = '/listReportScreen';
  static const listReportForDirectorCompanyScreen =
      '/listReportForDirectorCompanyScreen';
  static const detailWorkScreen = '/detailWorkScreen';
  static const detailWorkloadRequest = '/detailWorkloadRequest';
  static const listWorkSchedule = '/listWorkSchedule';

  //qldct
  static const homeDCT = '/homeDCT';
  static const checkSheet = '/checkSheet';
  static const testPlan = '/testPlan';
  static const testPlanNotPmis = '/testPlanNotPmis';
  static const testPlanLogBook = '/testPlanLogBook';
  static const transformerTicket = '/transformerTicket';
  static const workNotPmisTicket = '/workNotPmisTicket';
  static const createLineTicket = '/createLineTicket';
  static const listViolate = '/listViolate';
  static const nightContentNotify = '/nightContentNotify';

  static final homeDCTKey = GlobalKey<home_dct_screen.MainState>();
  static final notifyScreenKey = GlobalKey<NotifyState>();

  static List<GetPage> getPages() {
    return [
      //common
      GetPage(name: Routes.login, page: () => AppLoginScreen()),
      GetPage(
          name: Routes.selectModule, page: () => const SelectModuleScreen()),
      //qlhtld
      GetPage(name: Routes.home, page: () => MainScreen()),
      GetPage(
          name: Routes.intersSelectCheckListScreen,
          page: () => GridManagementScreen()),
      GetPage(name: Routes.ticketScreen, page: () => TicketScreen()),
      GetPage(
          name: Routes.historyCheck,
          page: () => HistoryCheckScreen(),
          binding: HistoryCheckBinding()),
      GetPage(
          name: Routes.chooseSubstation,
          page: () => ChooseSubStation(),
          binding: ChooseSubStationBinding()),
      GetPage(
          name: Routes.chooseLine,
          page: () => ChooseLineScreen(),
          binding: ChooseLineBinding()),
      GetPage(
          name: Routes.periodicInspectionPlanView,
          page: () => const PeriodicInspectionPlanView()),
      GetPage(
          name: Routes.interScanQRScreen, page: () => const ScanQrCodeScreen()),
      GetPage(
          name: Routes.changePassword,
          page: () => const ChangePasswordExpireScreen()),

      //qltnkd
      GetPage(
          name: Routes.reportHome, page: () => const WorkByTransformerScreen()),
      GetPage(name: Routes.workloadHome, page: () => const ListWorkload()),
      GetPage(
          name: Routes.listReportScreen,
          page: () => const ReportByTransformer()),
      GetPage(
          name: Routes.detailWorkloadRequest,
          page: () => const DetailWorkLoad()),
      GetPage(
          name: Routes.listReportForDirectorCompanyScreen,
          page: () => ReportDirectorCompany()),

      //qldct
      GetPage(
          name: Routes.homeDCT,
          page: () => home_dct_screen.MainScreen(key: homeDCTKey)),
      GetPage(name: Routes.testPlan, page: () => const TestPlanView()),
      GetPage(
          name: Routes.testPlanNotPmis,
          page: () => const test_plan_not_pmis.TestPlanView()),
      GetPage(
          name: Routes.testPlanLogBook,
          page: () => const test_plan_log_book.TestPlanView()),
      GetPage(
          name: Routes.transformerTicket,
          page: () => const TransformerTicket()),
      GetPage(
          name: Routes.workNotPmisTicket,
          page: () => const WorkNotPmisTicket()),
      GetPage(
          name: Routes.createLineTicket,
          page: () => const CreateLineTicketView()),
      GetPage(
          name: Routes.listViolate, page: () => ViolateInspectionListScreen()),
      GetPage(
          name: Routes.nightContentNotify, page: () => NightContentNotify()),
    ];
  }
}

