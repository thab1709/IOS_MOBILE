// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/image_path.dart';
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/models/r_menu_item.dart';
import 'package:evnmobile/src/qltnkd/screens/profile/profile.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/list_report_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/report_for_director_company/report_director_company.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_work/work_report_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/unscheduled_report/unscheduled_report_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_by_transformer/work_by_transformer_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/list_request/list_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart'
    as get_transition;

import '../../../../app_env.dart';
import '../../screens/verification_report/list_report_meter/list_report_meter_screen.dart';
import '../../screens/verification_report/report_by_transformer/report_by_transformer.dart';
import '../../screens/verification_report/survey_report/list_survey_report/list_survey_report.dart';
import '../../screens/verification_report/workload/list_workload/list_workload.dart';
import '../../screens/verification_report/patc/list_patc/list_patc.dart';
import '../../screens/verification_report/work_registration/list_work_registration/list_work_registration_screen.dart';

class CategoryMenu {
  static const int work = 0;
//  static const int report = 1;
  static const int certificate = 2;
  static const int reportForDirectorCompany = 3;
  static const int unscheduledReport = 4;
  static const int workload = 5;
  static const int request = 6;
  static const int ticketWorkload = 7;
  static const int reportMeter = 8;
  static const int reportBySubstation = 9;
  static const int profile = 10;
  static const int surveyReport = 11;
  static const int patc = 12;
  static const int workRegistration = 13;
}

class AppDrawer extends StatelessWidget {
  AppDrawer({Key key, this.index}) : super(key: key);
  final int index;

  final listItemDrawer = <RMenuItem>[
    RMenuItem(title: 'Danh sách công việc', id: CategoryMenu.work),
  //  RMenuItem(title: 'Danh sách biên bản', id: CategoryMenu.report),
    RMenuItem(title: 'DS giấy chứng nhận', id: CategoryMenu.certificate),
    RMenuItem(
        title: 'Danh sách biên bản', id: CategoryMenu.reportForDirectorCompany),
    RMenuItem(title: 'Biên bản phát sinh', id: CategoryMenu.unscheduledReport),
    RMenuItem(title: 'Khối lượng công việc', id: CategoryMenu.
    workload),
    RMenuItem(title: 'Danh sách yêu cầu', id: CategoryMenu.request),
    RMenuItem(title: 'DS phiếu xác nhận KLCV', id: CategoryMenu.ticketWorkload),
    RMenuItem(title: 'DS biên bản công tơ', id: CategoryMenu.reportMeter),
    RMenuItem(
        title: 'Danh sách biên bản',
        id: CategoryMenu.reportBySubstation),
    RMenuItem(title: 'Hồ sơ cá nhân', id: CategoryMenu.profile),
    RMenuItem(title: 'Quản lý biên bản khảo sát', id: CategoryMenu.surveyReport),
    RMenuItem(title: 'Quản lý phương án thi công', id: CategoryMenu.patc),
    RMenuItem(title: 'Đăng ký công tác', id: CategoryMenu.workRegistration),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                DrawerHeader(
                    child: Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: Image.asset(
                          ImagePath.fullLogoEvn,
                        )),
                    Expanded(flex: 1, child: Container())
                  ],
                )),

                if (RUserRole.isExpertElectric)
                  _buildItemDrawer(
                      Icons.library_books_sharp,
                      listItemDrawer.firstWhere((element) =>
                      element.id == CategoryMenu.ticketWorkload),
                      context,
                      isSecond: false),
                if (!RUserRole.isPresidentCompany &&
                    !RUserRole.isPresidentCenter)
                  _buildItemDrawer(
                      Icons.library_books_sharp,
                      listItemDrawer.firstWhere(
                          (element) => element.id == CategoryMenu.work),
                      context),
                if (!RUserRole.isDriver && !RUserRole.isPresidentCompany)
                  _buildItemDrawer(
                      Icons.library_books_sharp,
                      listItemDrawer.firstWhere((element) =>
                      element.id == CategoryMenu.reportBySubstation),
                      context),
                if (RUserRole.isPresidentCompany)
                  _buildItemDrawer(
                      Icons.library_books_sharp,
                      listItemDrawer.firstWhere((element) =>
                          element.id == CategoryMenu.reportForDirectorCompany),
                      context),
                if (!RUserRole.isDriver && !RUserRole.isPresidentCompany)
                  _buildItemDrawer(
                      Icons.library_books_sharp,
                      listItemDrawer.firstWhere((element) =>
                          element.id == CategoryMenu.unscheduledReport),
                      context),
                if (!RUserRole.isDriver)
                  _buildItemDrawer(
                      Icons.library_books_sharp,
                      listItemDrawer.firstWhere(
                          (element) => element.id == CategoryMenu.reportMeter),
                      context),

                if (!RUserRole.isPresidentCompany &&
                    !RUserRole.isPresidentCenter && !RUserRole.isExpertElectric)
                  _buildItemDrawer(
                      Icons.group_work,
                      listItemDrawer.firstWhere(
                          (element) => element.id == CategoryMenu.workload),
                      context),
                if (!RUserRole.isPresidentCompany &&
                    !RUserRole.isPresidentCenter && !RUserRole.isExpertElectric)
                  _buildItemDrawer(
                      Icons.library_books_sharp,
                      listItemDrawer.firstWhere(
                          (element) => element.id == CategoryMenu.request),
                      context,
                      isSecond: true),
                if (!RUserRole.isPresidentCompany &&
                    !RUserRole.isPresidentCenter && !RUserRole.isExpertElectric)
                  _buildItemDrawer(
                      Icons.library_books_sharp,
                      listItemDrawer.firstWhere((element) =>
                          element.id == CategoryMenu.ticketWorkload),
                      context,
                      isSecond: true),
                if (!RUserRole.isPresidentCompany &&
                    !RUserRole.isPresidentCenter)
                  _buildItemDrawer(
                      Icons.content_paste_search,
                      listItemDrawer.firstWhere((element) =>
                          element.id == CategoryMenu.surveyReport),
                      context,
                      isSecond: true),
                if (!RUserRole.isPresidentCompany &&
                    !RUserRole.isPresidentCenter)
                  _buildItemDrawer(
                      Icons.assignment,
                      listItemDrawer.firstWhere((element) =>
                          element.id == CategoryMenu.patc),
                      context,
                      isSecond: true),
                if (!RUserRole.isPresidentCompany &&
                    !RUserRole.isPresidentCenter && !RUserRole.isExpertElectric)
                  _buildItemDrawer(
                      Icons.app_registration,
                      listItemDrawer.firstWhere((element) =>
                          element.id == CategoryMenu.workRegistration),
                      context,
                      isSecond: true),
                if (!RUserRole.isDriver)
                  _buildItemDrawer(
                      Icons.perm_identity_outlined,
                      listItemDrawer.firstWhere(
                          (element) => element.id == CategoryMenu.profile),
                      context),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: RAppColor.backgroundColorGray,
            child: Center(
              child:
                  Text('Phiên bản: ${AppEnv.appVersion} ${AppEnv.getName()}'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemDrawer(
      IconData icon, RMenuItem menuItem, BuildContext context,
      {bool isSecond = false}) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        //indexSelected = menuItem.index;
        switch (menuItem.id) {
          case CategoryMenu.work:
            await Get.offAll(() => const WorkByTransformerScreen(),
                transition: get_transition.Transition.noTransition);
            break;
          // case CategoryMenu.report:
          //   await Get.offAll(() => ListReportScreen(),
          //       transition: get_transition.Transition.noTransition);
          //   break;
          // case CategoryMenu.certificate:
          //   await Get.to(() => ListCertificateScreen(),
          //       transition: get_transition.Transition.noTransition);
          //   break;
          case CategoryMenu.reportMeter:
            await Get.offAll(() => ListReportMeterScreen(),
                transition: get_transition.Transition.noTransition);
            break;
          case CategoryMenu.reportBySubstation:
            await Get.offAll(() => const ReportByTransformer(),
                transition: get_transition.Transition.noTransition);
            break;
          case CategoryMenu.profile:
            await Get.offAll(() => RProfileScreen(),
                transition: get_transition.Transition.noTransition);
            break;
          case CategoryMenu.unscheduledReport:
            await Get.offAll(() => UnscheduledReportScreen(),
                transition: get_transition.Transition.noTransition);
            break;
          case CategoryMenu.reportForDirectorCompany:
            await Get.offAll(() => ReportDirectorCompany(),
                transition: get_transition.Transition.noTransition);
            break;

          case CategoryMenu.request:
            await Get.offAll(() => const ListRequest(),
                transition: get_transition.Transition.noTransition);
            break;
          case CategoryMenu.ticketWorkload:
            await Get.offAll(() => const ListWorkload(),
                transition: get_transition.Transition.noTransition);
            break;
          case CategoryMenu.surveyReport:
            await Get.offAll(() => const ListSurveyReport(),
                transition: get_transition.Transition.noTransition);
            break;
          case CategoryMenu.patc:
            await Get.offAll(() => const ListPatcScreen(),
                transition: get_transition.Transition.noTransition);
            break;
          case CategoryMenu.workRegistration:
            await Get.offAll(() => const ListWorkRegistrationScreen(),
                transition: get_transition.Transition.noTransition);
            break;
          default:
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Row(
          children: [
            if (!isSecond)
              Icon(
                icon,
                color: Colors.black,
              ),
            if (!isSecond)
              const SizedBox(
                width: 10,
              ),
            if (isSecond)
              const SizedBox(
                width: 30,
              ),
            Text(
              menuItem.title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: index == menuItem.id
                      ? RAppColor.highlightColor70
                      : Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}

