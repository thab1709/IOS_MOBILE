// @dart=2.9
import 'package:evnmobile/src/htdct/common/utils/common.dart';
import 'package:evnmobile/src/htdct/common/utils/progress_h_u_d.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart'
    as DateTimePickerSpec;
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../app_common/utils/utils.dart';
import '../../../common/constance/app_color.dart';
import '../../../common/constance/app_icon.dart';
import '../../../common/constance/content_option.dart';
import '../../../common/constance/option_type.dart';
import '../../../common/themes/colorx.dart';
import '../../../common/themes/styles.dart';
import '../../../models/dashboard/inspect_dashboard_model.dart';
import '../../grid_management/containers/e_button.dart';
import '../../grid_management/containers/e_single_drop_down.dart';
import '../common/badge_circle.dart';
import '../common/custom_expansion_title.dart' as custom;
import '../dashboard_controller.dart';

class BuildSubstaionChart extends StatelessWidget {
  final DashboardController controller;

   BuildSubstaionChart({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      // padding: const EdgeInsets.only(left: 16, right: 16),
      color: HighElectricAppColor.nature01,
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        tileColor: Colors.transparent,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: custom.ExpansionTile(
            backgroundColor: Colors.transparent,
            headerBackgroundColor: HighElectricAppColor.highlightColorDashboard,
            iconColor: HighElectricAppColor.nature01,
            initiallyExpanded: false,
            title: const Text(
              'Check list kiểm tra',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: HighElectricAppColor.nature01,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    buildSustationInspect(context, true),
                    buildSustationInspect(context, false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSustationInspect(BuildContext context, bool isSubstation) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      // padding: const EdgeInsets.only(left: 16, right: 16),
      color: HighElectricAppColor.nature01,
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        tileColor: Colors.transparent,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: custom.ExpansionTile(
            backgroundColor: Colors.transparent,
            headerBackgroundColor: Colors.transparent,
            iconColor: HighElectricAppColor.nature06,
            onExpansionChanged: (value) async {
              if(value == true && isSubstation == true) {
                ProgressHUD.show();
                final futures = <Future>[];
                futures.add(controller.getInspect(isSubstaion: true, isDateTime: true, isBackground: true));
                futures.add(controller.getInspect(isSubstaion: true, isDateTime: false, isBackground: true));

               await Future.wait(futures);
                ProgressHUD.dismiss();
              }
            },
            initiallyExpanded: false,
            title: Text(
              '${isSubstation == true ? '1.Trạm biến áp' : '2.Đường dây'}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: HighElectricAppColor.nature06,
              ),
            ),
            children: [
              Column(
                children: [
                  if (isSubstation)
                    BuildSubstationCircle(
                        controller: controller, isSubstaion: isSubstation),
                  if (!isSubstation) buildLineCircle(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLineCircle(context) {
    var model = controller.lineInspectModel.value as InspectDashboardModel;
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8),
          // padding: const EdgeInsets.only(left: 16, right: 16),
          color: HighElectricAppColor.nature01,
          child: ListTileTheme(
            contentPadding: const EdgeInsets.all(0),
            tileColor: Colors.transparent,
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: custom.ExpansionTile(
                backgroundColor: Colors.transparent,
                headerBackgroundColor: Colors.transparent,
                onExpansionChanged: (value) async {
                  if(value == true) {
                    ProgressHUD.show();
                    final futures = <Future>[];
                    futures.add(controller.getInspect(isSubstaion: false, isDateTime: true, isBackground: true));
                    futures.add(controller.getInspect(isSubstaion: false, isDateTime: false, isBackground: true));

                    await Future.wait(futures);
                    ProgressHUD.dismiss();
                  }
                },
                iconColor: HighElectricAppColor.nature06,
                initiallyExpanded: false,
                title: const Text(
                  '2.1 Đối với loại Tháng/Đêm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff696973),
                  ),
                ),
                children: [
                  BuildSubstationCircle(
                      controller: controller, isSubstaion: false)
                ],
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8),
          // padding: const EdgeInsets.only(left: 16, right: 16),
          color: HighElectricAppColor.nature01,
          child: ListTileTheme(
            contentPadding: const EdgeInsets.all(0),
            tileColor: Colors.transparent,
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: custom.ExpansionTile(
                backgroundColor: Colors.transparent,
                headerBackgroundColor: Colors.transparent,
                iconColor: HighElectricAppColor.nature06,
                initiallyExpanded: false,
                onExpansionChanged: (value) async {
                  if(value == true) {
                    ProgressHUD.show();
                    final futures = <Future>[];
                    futures.add(controller.getInspect(isSubstaion: false, isDateTime: false, isCable: true, isBackground: true));

                    await Future.wait(futures);
                    ProgressHUD.dismiss();
                  }
                },
                title: const Text(
                  '2.2 Đối với hầm nối cáp ngầm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff696973),
                  ),
                ),
                children: [
                  BuildSubstationCircle(
                    controller: controller,
                    isCable: true,
                    isSubstaion: false,
                  ),
                ],
                // children: [
                //   Padding(
                //     padding: const EdgeInsets.only(left: 10),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         const SizedBox(
                //           height: 10,
                //         ),
                //         Text(
                //           'Tổng số hầm nối cáp ngầm: ${model.lineUnderSumCount}',
                //           style: const TextStyle(
                //             fontSize: 16,
                //             fontWeight: FontWeight.w500,
                //             color: Color(0xffFF9700),
                //           ),
                //         ),
                //         const SizedBox(
                //           height: 10,
                //         ),
                //         const Text(
                //           'ĐZ_Hầm nối cáp ngầm',
                //           style: TextStyle(
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //         const SizedBox(
                //           height: 10,
                //         ),
                //         if (model.underGroundDetails != null &&
                //             model.underGroundDetails.details != null)
                //           for (var i = 0;
                //               i < model.underGroundDetails.details.length;
                //               i++)
                //             Padding(
                //               padding: const EdgeInsets.only(left: 10),
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     '${model.underGroundDetails.details[i].lineName}',
                //                   ),
                //                   const SizedBox(
                //                     height: 10,
                //                   ),
                //                   Padding(
                //                     padding: const EdgeInsets.only(left: 8.0),
                //                     child: Text(
                //                       '${model.underGroundDetails.details[i].underName}',
                //                       style: const TextStyle(
                //                         fontWeight: FontWeight.w500,
                //                       ),
                //                       softWrap: true,
                //                     ),
                //                   ),
                //                   const SizedBox(
                //                     height: 10,
                //                   ),
                //                 ],
                //               ),
                //             )
                //       ],
                //     ),
                //   )
                // ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BuildSubstationCircle extends StatelessWidget {
  final DashboardController controller;
  final bool isSubstaion;
  int touchedIndex = -1;
  bool isCable;

  BuildSubstationCircle(
      {Key key, this.controller, this.isSubstaion, this.isCable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCable
        ? buildCableInfo(context)
        : Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: buildFilterInfo(context, isDateTime: true),
                      ),
                      Stack(
                        children: [
                          Column(
                            children: [
                              // Container(
                              //   width: double.infinity,
                              //   height: 300,
                              //   child: BuildCircleChart(
                              //       isSubstaion: isSubstaion, controller: controller, isDateTime: true),
                              // ),
                              AspectRatio(
                                aspectRatio: 1.4,
                                child: BuildCircleChart(
                                    isSubstaion: isSubstaion,
                                    controller: controller,
                                    isDateTime: true),
                              ),
                              const SizedBox(
                                height: 80,
                              ),
                            ],
                          ),
                          Positioned(
                              top: Get.size.width * 0.25,
                              right: 0,
                              child: Container(
                                width: Get.size.width - 20,
                                child: Column(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1.7,
                                      child: BuildCircleChart(
                                          isSubstaion: isSubstaion,
                                          controller: controller,
                                          isDateTime: false),
                                    ),
                                    // Container(
                                    //   width: double.infinity,
                                    //   height: 200,
                                    //   child: BuildCircleChart(
                                    //       isSubstaion: isSubstaion, controller: controller, isDateTime: false),
                                    // ),
                                  ],
                                ),
                              )),
                          Positioned(
                            top: Get.size.width * 0.36,
                            right: 0,
                            child: Container(
                              width: Get.size.width - 20,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: buildFilterInfo(context,
                                        isDateTime: false),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: const Color(0xff456779),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text('Hoàn thành'),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: const Color(0xffE9B9A8),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text('Đang thực hiện'),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: const Color(0xffD1D9DA),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text('Chưa thực hiện'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  Widget buildCableInfo(BuildContext context) {
    final model = controller.cableInspectModel.value as InspectDashboardModel;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          buildFilterInfo(context, isDateTime: true, isCable: true),
          if (model.lineUnderSumCount != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Tổng số hầm nối cáp ngầm: ${model.lineUnderSumCount}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xffFF9700),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'ĐZ_Hầm nối cáp ngầm',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (model.underGroundDetails != null &&
                    model.underGroundDetails.details != null)
                  for (var i = 0;
                      i < model.underGroundDetails.details.length;
                      i++)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${model.underGroundDetails.details[i].lineName}',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '${model.underGroundDetails.details[i].underName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              softWrap: true,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
              ],
            )
        ],
      ),
    );
  }

  void _showCalendarPicker(context,
      {bool startTime = true, isDateTime = true, isCable = false}) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)), //this right here
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.close))
                    ],
                  ),
                  Localizations.override(
                    context: context,
                    locale: const Locale('vi', 'VN'),
                    child: buildWeekDatePicker(
                      endDate: isCable
                          ? controller.endSearchDateCableInspectTemp
                          : isSubstaion
                              ? isDateTime
                                  ? controller.endSearchDateInspectTemp
                                  : controller.toEndSearchDateNightInspectTemp
                              : isDateTime
                                  ? controller.endSearchDateLineInspectTemp
                                  : controller
                                      .endSearchDateNightLineInspectTemp,
                      startDate: isCable
                          ? controller.startSearchDateCableInspectTemp
                          : isSubstaion
                              ? isDateTime
                                  ? controller.startSearchDateInspectTemp
                                  : controller.startSearchDateNightInspectTemp
                              : isDateTime
                                  ? controller.startSearchDateLineInspectTemp
                                  : controller
                                      .startSearchDateNightLineInspectTemp,
                      typeCalendar: isCable
                          ? controller.calendarTypeCableInspectTemp.value
                          : isSubstaion
                              ? isDateTime
                                  ? controller.calendarTypeInspectTemp.value
                                  : controller
                                      .calendarTypeNightInspectTemp.value
                              : isDateTime
                                  ? controller.calendarTypeLineInspectTemp.value
                                  : controller
                                      .calendarTypeNightLineInspectTemp.value,
                      startTime: startTime,
                      isDateTime: isDateTime,
                      isCable: isCable,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildWeekDatePicker(
      {DateTime startDate,
      DateTime endDate,
      Function onChange,
      int typeCalendar,
      bool startTime = true,
      bool isDateTime = true,
      bool isCable = false}) {
    // add some colors to default settings
    final styles = DateTimePickerSpec.DatePickerRangeStyles(
      selectedPeriodLastDecoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(10.0), bottomEnd: Radius.circular(10.0))),
      selectedPeriodStartDecoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(10.0),
            bottomStart: Radius.circular(10.0)),
      ),
      selectedPeriodMiddleDecoration:
          const BoxDecoration(color: Colors.yellow, shape: BoxShape.rectangle),
    );

    if (typeCalendar == ContentOptions.calendarDay.value) {
      return DateTimePickerSpec.DayPicker.single(
          datePickerStyles: styles,
          selectedDate: startTime
              ? startDate ?? DateTime.now()
              : endDate ?? DateTime.now(),
          onChanged: (values) => {
                if (isCable)
                  {
                    if (startTime)
                      {
                        controller.startSearchDateCableInspectTemp = values,
                        controller.endSearchDateCableInspectTemp = values,
                        controller.dateCableInspectTextController.value.text =
                            '${controller.getCalendarType(typeCalendar)} ${controller.ddMMyyyy(datetime: controller.startSearchDateCableInspectTemp)}',
                        controller.dateCableInspectTextController.refresh(),
                        controller.toDateCableInspectTextController.refresh(),
                      }
                    else
                      {
                        controller.toStartSearchDateCableInspectTemp = values,
                        controller.toEndSearchDateCableInspectTemp = values,
                        controller.toDateCableInspectTextController.value.text =
                            '${controller.getCalendarType(typeCalendar)} ${controller.ddMMyyyy(datetime: controller.toStartSearchDateCableInspectTemp)}',
                        controller.toDateCableInspectTextController.refresh(),
                      },
                  }
                else if (isSubstaion)
                  {
                    if (isDateTime)
                      {
                        if (startTime)
                          {
                            controller.startSearchDateInspectTemp = values,
                            controller.endSearchDateInspectTemp = values,
                            controller.dateInspectTextController.value.text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.ddMMyyyy(datetime: controller.startSearchDateInspectTemp)}',
                            controller.dateInspectTextController.refresh(),
                            controller.toDateInspectTextController.refresh(),
                          }
                        else
                          {
                            controller.toStartSearchDateInspectTemp = values,
                            controller.toEndSearchDateInspectTemp = values,
                            controller.toDateInspectTextController.value.text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.ddMMyyyy(datetime: controller.toStartSearchDateInspectTemp)}',
                            controller.toDateInspectTextController.refresh(),
                          },
                      }
                    else
                      {
                        if (startTime)
                          {
                            controller.startSearchDateNightInspectTemp = values,
                            controller.endSearchDateNightInspectTemp = values,
                            controller
                                    .dateNightInspectTextController.value.text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.ddMMyyyy(datetime: controller.startSearchDateNightInspectTemp)}',
                            controller.dateNightInspectTextController.refresh(),
                            controller.toDateNightInspectTextController
                                .refresh(),
                          }
                        else
                          {
                            controller.toStartSearchDateNightInspectTemp =
                                values,
                            controller.toEndSearchDateNightInspectTemp = values,
                            controller.toDateNightInspectTextController.value
                                    .text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.ddMMyyyy(datetime: controller.toStartSearchDateNightInspectTemp)}',
                            controller.toDateNightInspectTextController
                                .refresh(),
                          },
                      }
                  }
                else
                  {
                    if (isDateTime)
                      {
                        if (startTime)
                          {
                            controller.startSearchDateLineInspectTemp = values,
                            controller.endSearchDateLineInspectTemp = values,
                            controller
                                    .dateLineInspectTextController.value.text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.ddMMyyyy(datetime: controller.startSearchDateLineInspectTemp)}',
                            controller.dateLineInspectTextController.refresh(),
                            controller.toDateLineInspectTextController
                                .refresh(),
                          }
                        else
                          {
                            controller.toStartSearchDateLineInspectTemp =
                                values,
                            controller.toEndSearchDateLineInspectTemp = values,
                            controller.toDateLineInspectTextController.value
                                    .text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.ddMMyyyy(datetime: controller.toStartSearchDateLineInspectTemp)}',
                            controller.toDateLineInspectTextController
                                .refresh(),
                          },
                      }
                    else
                      {
                        if (startTime)
                          {
                            controller.startSearchDateNightLineInspectTemp =
                                values,
                            controller.endSearchDateNightLineInspectTemp =
                                values,
                            controller.dateNightLineInspectTextController.value
                                    .text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.ddMMyyyy(datetime: controller.startSearchDateNightLineInspectTemp)}',
                            controller.dateNightLineInspectTextController
                                .refresh(),
                            controller.toDateNightLineInspectTextController
                                .refresh(),
                          }
                        else
                          {
                            controller.toStartSearchDateNightLineInspectTemp =
                                values,
                            controller.toEndSearchDateNightLineInspectTemp =
                                values,
                            controller.toDateNightLineInspectTextController
                                    .value.text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.ddMMyyyy(datetime: controller.toStartSearchDateNightLineInspectTemp)}',
                            controller.toDateNightLineInspectTextController
                                .refresh(),
                          },
                      }
                  },
                Get.back(),
              },
          firstDate: DateTime(1990, 1, 1),
          lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month,
              DateTime.now().day));
    } else if (typeCalendar == ContentOptions.calendarWeek.value) {
      return WeekPicker(
          selectedDate: startTime
              ? startDate ?? DateTime.now()
              : endDate ?? DateTime.now(),
          onChanged: (values) => {
                if (isCable)
                  {
                    if (startTime)
                      {
                        controller.startSearchDateCableInspectTemp =
                            values.start,
                        controller.endSearchDateCableInspectTemp = values.end,
                        controller.dateCableInspectTextController.value.text =
                            '${controller.getCalendarType(typeCalendar)} ${getWeekOfYear(controller.startSearchDateCableInspectTemp.toString())}',
                        controller.dateCableInspectTextController.refresh(),
                        controller.toDateCableInspectTextController.refresh(),
                      }
                    else
                      {
                        controller.toStartSearchDateCableInspectTemp =
                            values.start,
                        controller.toEndSearchDateCableInspectTemp = values.end,
                        controller.toDateCableInspectTextController.value.text =
                            '${controller.getCalendarType(typeCalendar)} ${getWeekOfYear(controller.toStartSearchDateCableInspectTemp.toString())}',
                        controller.toDateCableInspectTextController.refresh(),
                      },
                  }
                else if (isSubstaion)
                  {
                    if (isDateTime)
                      {
                        if (startTime)
                          {
                            controller.startSearchDateInspectTemp =
                                values.start,
                            controller.endSearchDateInspectTemp = values.end,
                            controller.dateInspectTextController.value.text =
                                '${controller.getCalendarType(typeCalendar)} ${getWeekOfYear(controller.startSearchDateInspectTemp.toString())}',
                            controller.dateInspectTextController.refresh(),
                            controller.toDateInspectTextController.refresh(),
                          }
                        else
                          {
                            controller.toStartSearchDateInspectTemp =
                                values.start,
                            controller.toEndSearchDateInspectTemp = values.end,
                            controller.toDateInspectTextController.value.text =
                                '${controller.getCalendarType(typeCalendar)} ${getWeekOfYear(controller.toStartSearchDateInspectTemp.toString())}',
                            controller.toDateInspectTextController.refresh(),
                          },
                      }
                    else
                      {
                        if (startTime)
                          {
                            controller.startSearchDateNightInspectTemp =
                                values.start,
                            controller.endSearchDateNightInspectTemp =
                                values.end,
                            controller
                                    .dateNightInspectTextController.value.text =
                                '${controller.getCalendarType(typeCalendar)} ${getWeekOfYear(controller.startSearchDateNightInspectTemp.toString())}',
                            controller.dateNightInspectTextController.refresh(),
                            controller.toDateNightInspectTextController
                                .refresh(),
                          }
                        else
                          {
                            controller.toStartSearchDateNightInspectTemp =
                                values.start,
                            controller.toEndSearchDateNightInspectTemp =
                                values.end,
                            controller.toDateNightInspectTextController.value
                                    .text =
                                '${controller.getCalendarType(typeCalendar)} ${getWeekOfYear(controller.toStartSearchDateNightInspectTemp.toString())}',
                            controller.toDateNightInspectTextController
                                .refresh(),
                          },
                      }
                  }
                else
                  {
                    if (isDateTime)
                      {
                        if (startTime)
                          {
                            controller.startSearchDateLineInspectTemp =
                                values.start,
                            controller.endSearchDateLineInspectTemp =
                                values.end,
                            controller
                                    .dateLineInspectTextController.value.text =
                                '${controller.getCalendarType(typeCalendar)} ${getWeekOfYear(controller.startSearchDateLineInspectTemp.toString())}',
                            controller.dateLineInspectTextController.refresh(),
                            controller.toDateLineInspectTextController
                                .refresh(),
                          }
                        else
                          {
                            controller.toStartSearchDateLineInspectTemp =
                                values.start,
                            controller.toEndSearchDateLineInspectTemp =
                                values.end,
                            controller.toDateLineInspectTextController.value
                                    .text =
                                '${controller.getCalendarType(typeCalendar)} ${getWeekOfYear(controller.toStartSearchDateLineInspectTemp.toString())}',
                            controller.toDateLineInspectTextController
                                .refresh(),
                          },
                      }
                    else
                      {
                        if (startTime)
                          {
                            controller.startSearchDateNightLineInspectTemp =
                                values.start,
                            controller.endSearchDateNightLineInspectTemp =
                                values.end,
                            controller.dateNightLineInspectTextController.value
                                    .text =
                                '${controller.getCalendarType(typeCalendar)} ${getWeekOfYear(controller.startSearchDateNightLineInspectTemp.toString())}',
                            controller.dateNightLineInspectTextController
                                .refresh(),
                            controller.toDateNightLineInspectTextController
                                .refresh(),
                          }
                        else
                          {
                            controller.toStartSearchDateNightLineInspectTemp =
                                values.start,
                            controller.toEndSearchDateNightLineInspectTemp =
                                values.end,
                            controller.toDateNightLineInspectTextController
                                    .value.text =
                                '${controller.getCalendarType(typeCalendar)} ${getWeekOfYear(controller.toStartSearchDateNightLineInspectTemp.toString())}',
                            controller.toDateNightLineInspectTextController
                                .refresh(),
                          },
                      }
                  },
                Get.back(),
              },
          firstDate: DateTime(1990, 1, 1),
          lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month,
              DateTime.now().day),
          datePickerStyles: styles);
    } else if (typeCalendar == ContentOptions.calendarMonth.value) {
      return DateTimePickerSpec.MonthPicker.single(
          datePickerStyles: styles,
          selectedDate: startTime
              ? startDate ?? DateTime.now()
              : endDate ?? DateTime.now(),
          onChanged: (values) => {
                if (isCable)
                  {
                    if (startTime)
                      {
                        controller.startSearchDateCableInspectTemp = values,
                        controller.endSearchDateCableInspectTemp = DateTime(
                            values.year,
                            values.month,
                            DateTime(values.year, values.month + 1, 0).day),
                        controller.dateCableInspectTextController.value.text =
                            '${controller.getCalendarType(typeCalendar)} ${controller.startSearchDateCableInspectTemp.month}/${controller.startSearchDateCableInspectTemp.year}',
                        controller.dateCableInspectTextController.refresh(),
                        controller.toDateCableInspectTextController.refresh(),
                      }
                    else
                      {
                        controller.toStartSearchDateCableInspectTemp = values,
                        controller.toEndSearchDateCableInspectTemp = DateTime(
                            values.year,
                            values.month,
                            DateTime(values.year, values.month + 1, 0).day),
                        controller.toDateCableInspectTextController.value.text =
                            '${controller.getCalendarType(typeCalendar)} ${controller.toEndSearchDateCableInspectTemp.month}/${controller.toEndSearchDateCableInspectTemp.year}',
                        controller.toDateCableInspectTextController.refresh(),
                      },
                  }
                else if (isSubstaion)
                  {
                    if (isDateTime)
                      {
                        if (startTime)
                          {
                            controller.startSearchDateInspectTemp = values,
                            controller.endSearchDateInspectTemp = DateTime(
                                values.year,
                                values.month,
                                DateTime(values.year, values.month + 1, 0).day),
                            controller.dateInspectTextController.value.text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.startSearchDateInspectTemp.month}/${controller.startSearchDateInspectTemp.year}',
                            controller.dateInspectTextController.refresh(),
                            controller.toDateInspectTextController.refresh(),
                          }
                        else
                          {
                            controller.toStartSearchDateInspectTemp = values,
                            controller.toEndSearchDateInspectTemp = DateTime(
                                values.year,
                                values.month,
                                DateTime(values.year, values.month + 1, 0).day),
                            controller.toDateInspectTextController.value.text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.toEndSearchDateInspectTemp.month}/${controller.toEndSearchDateInspectTemp.year}',
                            controller.toDateInspectTextController.refresh(),
                          },
                      }
                    else
                      {
                        if (startTime)
                          {
                            controller.startSearchDateNightInspectTemp = values,
                            controller.endSearchDateNightInspectTemp = DateTime(
                                values.year,
                                values.month,
                                DateTime(values.year, values.month + 1, 0).day),
                            controller
                                    .dateNightInspectTextController.value.text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.startSearchDateNightInspectTemp.month}/${controller.startSearchDateNightInspectTemp.year}',
                            controller.dateNightInspectTextController.refresh(),
                            controller.toDateNightInspectTextController
                                .refresh(),
                          }
                        else
                          {
                            controller.toStartSearchDateNightInspectTemp =
                                values,
                            controller.toEndSearchDateNightInspectTemp =
                                DateTime(
                                    values.year,
                                    values.month,
                                    DateTime(values.year, values.month + 1, 0)
                                        .day),
                            controller.toDateNightInspectTextController.value
                                    .text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.toEndSearchDateNightInspectTemp.month}/${controller.toEndSearchDateNightInspectTemp.year}',
                            controller.toDateNightInspectTextController
                                .refresh(),
                          },
                      }
                  }
                else
                  {
                    if (isDateTime)
                      {
                        if (startTime)
                          {
                            controller.startSearchDateLineInspectTemp = values,
                            controller.endSearchDateLineInspectTemp = DateTime(
                                values.year,
                                values.month,
                                DateTime(values.year, values.month + 1, 0).day),
                            controller
                                    .dateLineInspectTextController.value.text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.startSearchDateLineInspectTemp.month}/${controller.startSearchDateLineInspectTemp.year}',
                            controller.dateLineInspectTextController.refresh(),
                            controller.toDateLineInspectTextController
                                .refresh(),
                          }
                        else
                          {
                            controller.toStartSearchDateLineInspectTemp =
                                values,
                            controller.toEndSearchDateLineInspectTemp =
                                DateTime(
                                    values.year,
                                    values.month,
                                    DateTime(values.year, values.month + 1, 0)
                                        .day),
                            controller.toDateLineInspectTextController.value
                                    .text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.toEndSearchDateLineInspectTemp.month}/${controller.toEndSearchDateLineInspectTemp.year}',
                            controller.toDateLineInspectTextController
                                .refresh(),
                          },
                      }
                    else
                      {
                        if (startTime)
                          {
                            controller.startSearchDateNightLineInspectTemp =
                                values,
                            controller.endSearchDateNightLineInspectTemp =
                                DateTime(
                                    values.year,
                                    values.month,
                                    DateTime(values.year, values.month + 1, 0)
                                        .day),
                            controller.dateNightLineInspectTextController.value
                                    .text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.startSearchDateNightLineInspectTemp.month}/${controller.startSearchDateNightLineInspectTemp.year}',
                            controller.dateNightLineInspectTextController
                                .refresh(),
                            controller.toDateNightLineInspectTextController
                                .refresh(),
                          }
                        else
                          {
                            controller.toStartSearchDateNightLineInspectTemp =
                                values,
                            controller.toEndSearchDateNightLineInspectTemp =
                                DateTime(
                                    values.year,
                                    values.month,
                                    DateTime(values.year, values.month + 1, 0)
                                        .day),
                            controller.toDateNightLineInspectTextController
                                    .value.text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.toEndSearchDateNightLineInspectTemp.month}/${controller.toEndSearchDateNightLineInspectTemp.year}',
                            controller.toDateNightLineInspectTextController
                                .refresh(),
                          },
                      }
                  },
                Get.back(),
              },
          firstDate: DateTime(1990, 1, 1),
          lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month,
              DateTime.now().day));
    } else if (typeCalendar == ContentOptions.calendarYear.value) {
      return DateTimePickerSpec.YearPicker.single(
          datePickerStyles: styles,
          selectedDate: startTime
              ? startDate ?? DateTime.now()
              : endDate ?? DateTime.now(),
          onChanged: (values) => {
                if (isCable)
                  {
                    if (startTime)
                      {
                        controller.startSearchDateCableInspectTemp = values,
                        controller.endSearchDateCableInspectTemp =
                            DateTime(values.year, 12, 31),
                        controller.dateCableInspectTextController.value.text =
                            '${controller.getCalendarType(typeCalendar)} ${controller.startSearchDateCableInspectTemp.year}',
                        controller.dateCableInspectTextController.refresh(),
                        controller.toDateCableInspectTextController.refresh(),
                      }
                    else
                      {
                        controller.toStartSearchDateCableInspectTemp = values,
                        controller.toEndSearchDateCableInspectTemp =
                            DateTime(values.year, 12, 31),
                        controller.toDateCableInspectTextController.value.text =
                            '${controller.getCalendarType(typeCalendar)} ${controller.toEndSearchDateCableInspectTemp.year}',
                        controller.toDateCableInspectTextController.refresh(),
                      },
                  }
                else if (isSubstaion)
                  {
                    if (isDateTime)
                      {
                        if (startTime)
                          {
                            controller.startSearchDateInspectTemp = values,
                            controller.endSearchDateInspectTemp =
                                DateTime(values.year, 12, 31),
                            controller.dateInspectTextController.value.text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.startSearchDateInspectTemp.year}',
                            controller.dateInspectTextController.refresh(),
                            controller.toDateInspectTextController.refresh(),
                          }
                        else
                          {
                            controller.toStartSearchDateInspectTemp = values,
                            controller.toEndSearchDateInspectTemp =
                                DateTime(values.year, 12, 31),
                            controller.toDateInspectTextController.value.text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.toEndSearchDateInspectTemp.year}',
                            controller.toDateInspectTextController.refresh(),
                          },
                      }
                    else
                      {
                        if (startTime)
                          {
                            controller.startSearchDateNightInspectTemp = values,
                            controller.endSearchDateNightInspectTemp =
                                DateTime(values.year, 12, 31),
                            controller
                                    .dateNightInspectTextController.value.text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.startSearchDateNightInspectTemp.year}',
                            controller.dateNightInspectTextController.refresh(),
                            controller.toDateNightInspectTextController
                                .refresh(),
                          }
                        else
                          {
                            controller.toStartSearchDateNightInspectTemp =
                                values,
                            controller.toEndSearchDateNightInspectTemp =
                                DateTime(values.year, 12, 31),
                            controller.toDateNightInspectTextController.value
                                    .text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.toEndSearchDateNightInspectTemp.year}',
                            controller.toDateNightInspectTextController
                                .refresh(),
                          },
                      }
                  }
                else
                  {
                    if (isDateTime)
                      {
                        if (startTime)
                          {
                            controller.startSearchDateLineInspectTemp = values,
                            controller.endSearchDateLineInspectTemp =
                                DateTime(values.year, 12, 31),
                            controller
                                    .dateLineInspectTextController.value.text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.startSearchDateLineInspectTemp.year}',
                            controller.dateLineInspectTextController.refresh(),
                            controller.toDateLineInspectTextController
                                .refresh(),
                          }
                        else
                          {
                            controller.toStartSearchDateLineInspectTemp =
                                values,
                            controller.toEndSearchDateLineInspectTemp =
                                DateTime(values.year, 12, 31),
                            controller.toDateLineInspectTextController.value
                                    .text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.toEndSearchDateLineInspectTemp.year}',
                            controller.toDateLineInspectTextController
                                .refresh(),
                          },
                      }
                    else
                      {
                        if (startTime)
                          {
                            controller.startSearchDateNightLineInspectTemp =
                                values,
                            controller.endSearchDateNightLineInspectTemp =
                                DateTime(values.year, 12, 31),
                            controller.dateNightLineInspectTextController.value
                                    .text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.startSearchDateNightLineInspectTemp.year}',
                            controller.dateNightLineInspectTextController
                                .refresh(),
                            controller.toDateNightLineInspectTextController
                                .refresh(),
                          }
                        else
                          {
                            controller.toStartSearchDateNightLineInspectTemp =
                                values,
                            controller.toEndSearchDateNightLineInspectTemp =
                                DateTime(values.year, 12, 31),
                            controller.toDateNightLineInspectTextController
                                    .value.text =
                                '${controller.getCalendarType(typeCalendar)} ${controller.toEndSearchDateNightLineInspectTemp.year}',
                            controller.toDateNightLineInspectTextController
                                .refresh(),
                          },
                      }
                  },
                Get.back(),
              },
          firstDate: DateTime(1990, 1, 1),
          lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month,
              DateTime.now().day));
    } else {
      return Container();
    }
  }

  Widget buildFilter(BuildContext context,
      {bool isDateTime = true, bool isCable = false}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          ESingleDropDown(
            OptionsType.calendar_type.getOptions,
            padding: 0,
            isInTicket: false,
            value: isCable
                ? controller.calendarTypeCableInspectTemp.value
                : isSubstaion
                    ? isDateTime
                        ? controller.calendarTypeInspectTemp.value
                        : controller.calendarTypeNightInspectTemp.value
                    : isDateTime
                        ? controller.calendarTypeLineInspectTemp.value
                        : controller.calendarTypeNightLineInspectTemp.value,
            hint: 'Chọn loại thời gian',
            contentHorizontalPadding: 10,
            onSelected: (option) async {
              if (isCable) {
                controller.calendarTypeCableInspectTemp.value =
                    int.parse(option);
                controller.calendarTypeCableInspectTemp.refresh();
              } else if (isSubstaion) {
                if (isDateTime) {
                  controller.calendarTypeInspectTemp.value = int.parse(option);
                  controller.calendarTypeInspectTemp.refresh();
                } else {
                  controller.calendarTypeNightInspectTemp.value =
                      int.parse(option);
                  controller.calendarTypeNightInspectTemp.refresh();
                }
              } else {
                if (isDateTime) {
                  controller.calendarTypeLineInspectTemp.value =
                      int.parse(option);
                  controller.calendarTypeLineInspectTemp.refresh();
                } else {
                  controller.calendarTypeNightLineInspectTemp.value =
                      int.parse(option);
                  controller.calendarTypeNightLineInspectTemp.refresh();
                }
              }
              updateTextFilter(
                substaion: isSubstaion,
                isDateTime: isDateTime,
                isCable: isCable,
              );
            },
          ),
          Obx(
            () => Visibility(
              visible: controller.calendarTypeAbnormalTemp.value !=
                  ContentOptions.calendarAll.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  buildTitle('Thời gian bắt đầu'),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border:
                            Border.all(width: 1, color: Colors.grey.shade300)),
                    child: GestureDetector(
                      onTap: () {
                        _showCalendarPicker(context,
                            isDateTime: isDateTime, isCable: isCable);
                      },
                      child: Obx(
                        () => Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: isCable
                                    ? controller
                                        .dateCableInspectTextController.value
                                    : isSubstaion
                                        ? isDateTime
                                            ? controller
                                                .dateInspectTextController.value
                                            : controller
                                                .dateNightInspectTextController
                                                .value
                                        : isDateTime
                                            ? controller
                                                .dateLineInspectTextController
                                                .value
                                            : controller
                                                .dateNightLineInspectTextController
                                                .value,
                                decoration: const InputDecoration(
                                  enabled: false,
                                  border: InputBorder.none,
                                  hintText: 'Chọn khoảng thời gian',
                                  isDense: true,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today_rounded,
                              color: AppColor.highlightColor70,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  buildTitle('Thời gian kết thúc'),
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              width: 1,
                              color: (isCable
                                      ? (controller
                                          .startOrEndDay(
                                              dateTime: controller
                                                  .startSearchDateCableInspectTemp,
                                              startDay: true)
                                          .isBefore(controller.startOrEndDay(
                                              dateTime: controller
                                                  .toStartSearchDateCableInspectTemp,
                                              startDay: false)))
                                      : isSubstaion
                                          ? isDateTime
                                              ? (controller.startOrEndDay(dateTime: controller.startSearchDateInspectTemp, startDay: true).isBefore(
                                                  controller.startOrEndDay(
                                                      dateTime: controller
                                                          .toStartSearchDateInspectTemp,
                                                      startDay: false)))
                                              : (controller
                                                  .startOrEndDay(
                                                      dateTime: controller
                                                          .startSearchDateNightInspectTemp,
                                                      startDay: true)
                                                  .isBefore(
                                                      controller.startOrEndDay(
                                                          dateTime: controller
                                                              .endSearchDateNightInspectTemp,
                                                          startDay: false)))
                                          : isDateTime
                                              ? (controller
                                                  .startOrEndDay(
                                                      dateTime: controller.startSearchDateLineInspectTemp,
                                                      startDay: true)
                                                  .isBefore(controller.startOrEndDay(dateTime: controller.toStartSearchDateLineInspectTemp, startDay: false)))
                                              : (controller.startOrEndDay(dateTime: controller.startSearchDateNightLineInspectTemp, startDay: true).isBefore(controller.startOrEndDay(dateTime: controller.toStartSearchDateNightLineInspectTemp, startDay: false))))
                                  ? Colors.grey.shade300
                                  : Colors.red)),
                      child: GestureDetector(
                        onTap: () {
                          _showCalendarPicker(context,
                              startTime: false,
                              isDateTime: isDateTime,
                              isCable: isCable);
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: isCable
                                    ? controller
                                        .toDateCableInspectTextController.value
                                    : isSubstaion
                                        ? isDateTime
                                            ? controller
                                                .toDateInspectTextController
                                                .value
                                            : controller
                                                .toDateNightInspectTextController
                                                .value
                                        : isDateTime
                                            ? controller
                                                .toDateLineInspectTextController
                                                .value
                                            : controller
                                                .toDateNightLineInspectTextController
                                                .value,
                                decoration: const InputDecoration(
                                  enabled: false,
                                  border: InputBorder.none,
                                  hintText: 'Chọn khoảng thời gian',
                                  isDense: true,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today_rounded,
                              color: AppColor.highlightColor70,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget buildTitle(String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Text(
                title,
                style: Styles.titleTextField,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFilter(context,
      {bool isDateTime = true, bool isCable = false}) async {
    void closeFilter() {
      if (isCable) {
        controller.calendarTypeCableInspectTemp.value =
            controller.calendarTypeCableInspect.value;
        controller.startSearchDateCableInspectTemp =
            controller.startSearchDateCableInspect;
        controller.endSearchDateCableInspectTemp =
            controller.endSearchDateCableInspect;
        controller.toStartSearchDateCableInspectTemp =
            controller.toStartSearchDateCableInspect;
        controller.toEndSearchDateCableInspectTemp =
            controller.toEndSearchDateCableInspect;
        updateTextFilter(
          substaion: false,
          isDateTime: true,
          isCable: true,
        );
      } else if (isSubstaion) {
        if (isDateTime) {
          controller.calendarTypeInspectTemp.value =
              controller.calendarTypeInspect.value;
          controller.startSearchDateInspectTemp =
              controller.startSearchDateInspect;
          controller.endSearchDateInspectTemp = controller.endSearchDateInspect;
          controller.toStartSearchDateInspectTemp =
              controller.toStartSearchDateInspect;
          controller.toEndSearchDateInspectTemp =
              controller.toEndSearchDateInspect;
          updateTextFilter(substaion: true);
        } else {
          controller.calendarTypeNightInspectTemp.value =
              controller.calendarTypeNightInspect.value;
          controller.startSearchDateNightInspectTemp =
              controller.startSearchDateNightInspect;
          controller.endSearchDateNightInspectTemp =
              controller.endSearchDateNightInspect;
          controller.toStartSearchDateNightInspectTemp =
              controller.toStartSearchDateNightInspect;
          controller.toEndSearchDateNightInspectTemp =
              controller.toEndSearchDateNightInspect;
          updateTextFilter(
            substaion: true,
            isDateTime: false,
          );
        }
      } else {
        if (isDateTime) {
          controller.calendarTypeLineInspectTemp.value =
              controller.calendarTypeLineInspect.value;
          controller.startSearchDateLineInspectTemp =
              controller.startSearchDateLineInspect;
          controller.endSearchDateLineInspectTemp =
              controller.endSearchDateLineInspect;
          controller.toStartSearchDateLineInspectTemp =
              controller.toStartSearchDateLineInspect;
          controller.toEndSearchDateLineInspectTemp =
              controller.toEndSearchDateLineInspect;
          updateTextFilter(
            substaion: false,
            isDateTime: true,
          );
        } else {
          controller.calendarTypeNightLineInspectTemp.value =
              controller.calendarTypeNightLineInspect.value;
          controller.startSearchDateNightLineInspectTemp =
              controller.startSearchDateNightLineInspect;
          controller.endSearchDateNightLineInspectTemp =
              controller.endSearchDateNightLineInspect;
          controller.toStartSearchDateNightLineInspectTemp =
              controller.toStartSearchDateNightLineInspect;
          controller.toEndSearchDateNightLineInspectTemp =
              controller.toEndSearchDateNightLineInspect;
          updateTextFilter(
            substaion: false,
            isDateTime: false,
          );
        }
      }

      Get.back();
    }

    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)), //this right here
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Bộ lọc',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                          onTap: closeFilter,
                          child: const Icon(Icons.close))
                    ],
                  ),
                  buildFilter(context,
                      isDateTime: isDateTime, isCable: isCable),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: closeFilter ,
                        child: EButtonWidget(
                          width: MediaQuery.of(context).size.width / 3.2,
                          text: 'Thoát',
                          bgColor: Colors.white,
                          textColor: HighElectricAppColor.primary10,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (isCable) {
                            if (controller
                                .startOrEndDay(
                                    dateTime: controller
                                        .startSearchDateCableInspectTemp,
                                    startDay: true)
                                .isBefore(controller.startOrEndDay(
                                    dateTime: controller
                                        .toStartSearchDateCableInspectTemp,
                                    startDay: false))) {
                              controller.calendarTypeCableInspect =
                                  controller.calendarTypeCableInspectTemp;
                              controller.startSearchDateCableInspect =
                                  controller.startSearchDateCableInspectTemp;
                              controller.endSearchDateCableInspect =
                                  controller.endSearchDateCableInspectTemp;
                              controller.toStartSearchDateCableInspect =
                                  controller.toStartSearchDateCableInspectTemp;
                              controller.toEndSearchDateCableInspect =
                                  controller.toEndSearchDateCableInspectTemp;

                              if (controller
                                      .calendarTypeCableInspectTemp.value ==
                                  ContentOptions.calendarWeek.value) {
                                controller.startSearchDateCableInspect =
                                    controller.startSearchDateCableInspect
                                        .subtract(Duration(
                                            days: controller
                                                .startSearchDateCableInspect
                                                .weekday));
                                controller.toStartSearchDateCableInspect =
                                    controller.toStartSearchDateCableInspect
                                        .subtract(Duration(
                                            days: controller
                                                .toStartSearchDateCableInspect
                                                .weekday));
                                controller.endSearchDateCableInspect =
                                    controller.endSearchDateCableInspect
                                        .subtract(Duration(
                                            days: controller
                                                    .endSearchDateCableInspect
                                                    .weekday -
                                                6));
                                controller.toEndSearchDateCableInspect =
                                    controller.toEndSearchDateCableInspect
                                        .subtract(Duration(
                                            days: controller
                                                    .toEndSearchDateCableInspect
                                                    .weekday -
                                                6));
                              }
                              if (controller
                                      .calendarTypeCableInspectTemp.value ==
                                  ContentOptions.calendarMonth.value) {
                                controller.startSearchDateCableInspect =
                                    DateTime(
                                        controller
                                            .startSearchDateCableInspect.year,
                                        controller
                                            .startSearchDateCableInspect.month,
                                        1);
                                controller.toStartSearchDateCableInspect =
                                    DateTime(
                                        controller
                                            .toStartSearchDateCableInspect.year,
                                        controller.toStartSearchDateCableInspect
                                            .month,
                                        1);
                                controller.endSearchDateCableInspect = DateTime(
                                    controller.endSearchDateCableInspect.year,
                                    controller.endSearchDateCableInspect.month +
                                        1,
                                    0);
                                controller.toEndSearchDateCableInspect =
                                    DateTime(
                                        controller
                                            .toEndSearchDateCableInspect.year,
                                        controller.toEndSearchDateCableInspect
                                                .month +
                                            1,
                                        0);
                              }
                              if (controller
                                      .calendarTypeCableInspectTemp.value ==
                                  ContentOptions.calendarYear.value) {
                                controller.startSearchDateCableInspect =
                                    DateTime(
                                        controller
                                            .startSearchDateCableInspect.year,
                                        1,
                                        1);
                                controller.toStartSearchDateCableInspect =
                                    DateTime(
                                        controller
                                            .toStartSearchDateCableInspect.year,
                                        1,
                                        1);
                                controller.endSearchDateCableInspect = DateTime(
                                    controller.endSearchDateCableInspect.year,
                                    12,
                                    31);
                                controller.toEndSearchDateCableInspect =
                                    DateTime(
                                        controller
                                            .toEndSearchDateCableInspect.year,
                                        12,
                                        31);
                              }
                              await controller.getInspect(
                                  isSubstaion: isSubstaion,
                                  isDateTime: isDateTime,
                                  isCable: isCable);
                              Get.back();
                            }
                          } else if (isSubstaion) {
                            if (isDateTime) {
                              if (controller
                                  .startOrEndDay(
                                      dateTime:
                                          controller.startSearchDateInspectTemp,
                                      startDay: true)
                                  .isBefore(controller.startOrEndDay(
                                      dateTime: controller
                                          .toStartSearchDateInspectTemp,
                                      startDay: false))) {
                                controller.calendarTypeInspect =
                                    controller.calendarTypeInspectTemp;
                                controller.startSearchDateInspect =
                                    controller.startSearchDateInspectTemp;
                                controller.endSearchDateInspect =
                                    controller.endSearchDateInspectTemp;
                                controller.toStartSearchDateInspect =
                                    controller.toStartSearchDateInspectTemp;
                                controller.toEndSearchDateInspect =
                                    controller.toEndSearchDateInspectTemp;
                                if (controller.calendarTypeInspect.value ==
                                    ContentOptions.calendarWeek.value) {
                                  controller.toStartSearchDateInspect =
                                      controller.startSearchDateInspect;
                                  controller.endSearchDateInspect =
                                      controller.toEndSearchDateInspect;
                                }
                                if (controller.calendarTypeInspect.value ==
                                    ContentOptions.calendarWeek.value) {
                                  controller.startSearchDateInspect = controller
                                      .startSearchDateInspect
                                      .subtract(Duration(
                                          days: controller
                                              .startSearchDateInspect.weekday));
                                  controller.toStartSearchDateInspect =
                                      controller.toStartSearchDateInspect
                                          .subtract(Duration(
                                              days: controller
                                                  .toStartSearchDateInspect
                                                  .weekday));
                                  controller.endSearchDateInspect = controller
                                      .endSearchDateInspect
                                      .subtract(Duration(
                                          days: controller.endSearchDateInspect
                                                  .weekday -
                                              6));
                                  controller.toEndSearchDateInspect = controller
                                      .toEndSearchDateInspect
                                      .subtract(Duration(
                                          days: controller
                                                  .toEndSearchDateInspect
                                                  .weekday -
                                              6));
                                }
                                if (controller.calendarTypeInspect.value ==
                                    ContentOptions.calendarMonth.value) {
                                  controller.startSearchDateInspect = DateTime(
                                      controller.startSearchDateInspect.year,
                                      controller.startSearchDateInspect.month,
                                      1);
                                  controller.toStartSearchDateInspect =
                                      DateTime(
                                          controller
                                              .toStartSearchDateInspect.year,
                                          controller
                                              .toStartSearchDateInspect.month,
                                          1);
                                  controller.endSearchDateInspect = DateTime(
                                      controller.endSearchDateInspect.year,
                                      controller.endSearchDateInspect.month + 1,
                                      0);
                                  controller.toEndSearchDateInspect = DateTime(
                                      controller.toEndSearchDateInspect.year,
                                      controller.toEndSearchDateInspect.month +
                                          1,
                                      0);
                                }
                                if (controller.calendarTypeInspect.value ==
                                    ContentOptions.calendarYear.value) {
                                  controller.startSearchDateInspect = DateTime(
                                      controller.startSearchDateInspect.year,
                                      1,
                                      1);
                                  controller.toStartSearchDateInspect =
                                      DateTime(
                                          controller
                                              .toStartSearchDateInspect.year,
                                          1,
                                          1);
                                  controller.endSearchDateInspect = DateTime(
                                      controller.endSearchDateInspect.year,
                                      12,
                                      31);
                                  controller.toEndSearchDateInspect = DateTime(
                                      controller.toEndSearchDateInspect.year,
                                      12,
                                      31);
                                }

                                await controller.getInspect(
                                    isSubstaion: isSubstaion,
                                    isDateTime: isDateTime);
                                Get.back();
                              }
                            } else {
                              if (controller
                                  .startOrEndDay(
                                      dateTime: controller
                                          .startSearchDateNightInspectTemp,
                                      startDay: true)
                                  .isBefore(controller.startOrEndDay(
                                      dateTime: controller
                                          .toEndSearchDateNightInspectTemp,
                                      startDay: false))) {
                                controller.calendarTypeNightInspect =
                                    controller.calendarTypeNightInspectTemp;
                                controller.startSearchDateNightInspect =
                                    controller.startSearchDateNightInspectTemp;
                                controller.endSearchDateNightInspect =
                                    controller.endSearchDateNightInspectTemp;
                                controller.toStartSearchDateNightInspect =
                                    controller
                                        .toStartSearchDateNightInspectTemp;
                                controller.toEndSearchDateNightInspect =
                                    controller.toEndSearchDateNightInspectTemp;
                                if (controller.calendarTypeNightInspect.value ==
                                    ContentOptions.calendarWeek.value) {
                                  controller.toStartSearchDateNightInspect =
                                      controller.startSearchDateNightInspect;
                                  controller.endSearchDateNightInspect =
                                      controller.toEndSearchDateNightInspect;
                                }
                                if (controller.calendarTypeNightInspect.value ==
                                    ContentOptions.calendarWeek.value) {
                                  controller.startSearchDateNightInspect =
                                      controller.startSearchDateNightInspect
                                          .subtract(Duration(
                                              days: controller
                                                  .startSearchDateNightInspect
                                                  .weekday));
                                  controller.toStartSearchDateNightInspect =
                                      controller.toStartSearchDateNightInspect
                                          .subtract(Duration(
                                              days: controller
                                                  .toStartSearchDateNightInspect
                                                  .weekday));
                                  controller.endSearchDateNightInspect =
                                      controller.endSearchDateNightInspect
                                          .subtract(Duration(
                                              days: controller
                                                      .endSearchDateNightInspect
                                                      .weekday -
                                                  6));
                                  controller.toEndSearchDateNightInspect =
                                      controller.toEndSearchDateNightInspect
                                          .subtract(Duration(
                                              days: controller
                                                      .toEndSearchDateNightInspect
                                                      .weekday -
                                                  6));
                                }
                                if (controller.calendarTypeNightInspect.value ==
                                    ContentOptions.calendarMonth.value) {
                                  controller.startSearchDateNightInspect =
                                      DateTime(
                                          controller
                                              .startSearchDateNightInspect.year,
                                          controller.startSearchDateNightInspect
                                              .month,
                                          1);
                                  controller.toStartSearchDateNightInspect =
                                      DateTime(
                                          controller
                                              .toStartSearchDateNightInspect
                                              .year,
                                          controller
                                              .toStartSearchDateNightInspect
                                              .month,
                                          1);
                                  controller.endSearchDateNightInspect =
                                      DateTime(
                                          controller
                                              .endSearchDateNightInspect.year,
                                          controller.endSearchDateNightInspect
                                                  .month +
                                              1,
                                          0);
                                  controller.toEndSearchDateNightInspect =
                                      DateTime(
                                          controller
                                              .toEndSearchDateNightInspect.year,
                                          controller.toEndSearchDateNightInspect
                                                  .month +
                                              1,
                                          0);
                                }
                                if (controller.calendarTypeNightInspect.value ==
                                    ContentOptions.calendarYear.value) {
                                  controller.startSearchDateNightInspect =
                                      DateTime(
                                          controller
                                              .startSearchDateNightInspect.year,
                                          1,
                                          1);
                                  controller.toStartSearchDateNightInspect =
                                      DateTime(
                                          controller
                                              .toStartSearchDateNightInspect
                                              .year,
                                          1,
                                          1);
                                  controller.endSearchDateNightInspect =
                                      DateTime(
                                          controller
                                              .endSearchDateNightInspect.year,
                                          12,
                                          31);
                                  controller.toEndSearchDateNightInspect =
                                      DateTime(
                                          controller
                                              .toEndSearchDateNightInspect.year,
                                          12,
                                          31);
                                }

                                await controller.getInspect(
                                    isSubstaion: isSubstaion,
                                    isDateTime: isDateTime);
                                Get.back();
                              }
                            }
                          } else {
                            if (isDateTime) {
                              if (controller
                                  .startOrEndDay(
                                      dateTime: controller
                                          .startSearchDateLineInspectTemp,
                                      startDay: true)
                                  .isBefore(controller.startOrEndDay(
                                      dateTime: controller
                                          .toStartSearchDateLineInspectTemp,
                                      startDay: false))) {
                                controller.calendarTypeLineInspect =
                                    controller.calendarTypeLineInspectTemp;
                                controller.startSearchDateLineInspect =
                                    controller.startSearchDateLineInspectTemp;
                                controller.endSearchDateLineInspect =
                                    controller.endSearchDateLineInspectTemp;
                                controller.toStartSearchDateLineInspect =
                                    controller.toStartSearchDateLineInspectTemp;
                                controller.toEndSearchDateLineInspect =
                                    controller.toEndSearchDateLineInspectTemp;

                                if (controller
                                        .calendarTypeLineInspectTemp.value ==
                                    ContentOptions.calendarWeek.value) {
                                  controller.startSearchDateLineInspect =
                                      controller
                                          .startSearchDateLineInspect
                                          .subtract(Duration(
                                              days: controller
                                                  .startSearchDateLineInspect
                                                  .weekday));
                                  controller.toStartSearchDateLineInspect =
                                      controller.toStartSearchDateLineInspect
                                          .subtract(Duration(
                                              days: controller
                                                  .toStartSearchDateLineInspect
                                                  .weekday));
                                  controller.endSearchDateLineInspect =
                                      controller.endSearchDateLineInspect
                                          .subtract(Duration(
                                              days: controller
                                                      .endSearchDateLineInspect
                                                      .weekday -
                                                  6));
                                  controller.toEndSearchDateLineInspect =
                                      controller
                                          .toEndSearchDateLineInspect
                                          .subtract(Duration(
                                              days: controller
                                                      .toEndSearchDateLineInspect
                                                      .weekday -
                                                  6));
                                }
                                if (controller
                                        .calendarTypeLineInspectTemp.value ==
                                    ContentOptions.calendarMonth.value) {
                                  controller.startSearchDateLineInspect =
                                      DateTime(
                                          controller
                                              .startSearchDateLineInspect.year,
                                          controller
                                              .startSearchDateLineInspect.month,
                                          1);
                                  controller.toStartSearchDateLineInspect =
                                      DateTime(
                                          controller
                                              .toStartSearchDateLineInspect
                                              .year,
                                          controller
                                              .toStartSearchDateLineInspect
                                              .month,
                                          1);
                                  controller.endSearchDateLineInspect =
                                      DateTime(
                                          controller
                                              .endSearchDateLineInspect.year,
                                          controller.endSearchDateLineInspect
                                                  .month +
                                              1,
                                          0);
                                  controller.toEndSearchDateLineInspect =
                                      DateTime(
                                          controller
                                              .toEndSearchDateLineInspect.year,
                                          controller.toEndSearchDateLineInspect
                                                  .month +
                                              1,
                                          0);
                                }
                                if (controller
                                        .calendarTypeLineInspectTemp.value ==
                                    ContentOptions.calendarYear.value) {
                                  controller.startSearchDateLineInspect =
                                      DateTime(
                                          controller
                                              .startSearchDateLineInspect.year,
                                          1,
                                          1);
                                  controller.toStartSearchDateLineInspect =
                                      DateTime(
                                          controller
                                              .toStartSearchDateLineInspect
                                              .year,
                                          1,
                                          1);
                                  controller.endSearchDateLineInspect =
                                      DateTime(
                                          controller
                                              .endSearchDateLineInspect.year,
                                          12,
                                          31);
                                  controller.toEndSearchDateLineInspect =
                                      DateTime(
                                          controller
                                              .toEndSearchDateLineInspect.year,
                                          12,
                                          31);
                                }
                                await controller.getInspect(
                                    isSubstaion: isSubstaion,
                                    isDateTime: isDateTime);
                                Get.back();
                              }
                            } else {
                              if (controller
                                  .startOrEndDay(
                                      dateTime: controller
                                          .startSearchDateNightLineInspectTemp,
                                      startDay: true)
                                  .isBefore(controller.startOrEndDay(
                                      dateTime: controller
                                          .toStartSearchDateNightLineInspectTemp,
                                      startDay: false))) {
                                controller.calendarTypeNightLineInspect =
                                    controller.calendarTypeNightLineInspectTemp;
                                controller.startSearchDateNightLineInspect =
                                    controller
                                        .startSearchDateNightLineInspectTemp;
                                controller.endSearchDateNightLineInspect =
                                    controller
                                        .endSearchDateNightLineInspectTemp;
                                controller.toStartSearchDateNightLineInspect =
                                    controller
                                        .toStartSearchDateNightLineInspectTemp;
                                controller.toEndSearchDateNightLineInspect =
                                    controller
                                        .toEndSearchDateNightLineInspectTemp;

                                if (controller.calendarTypeNightLineInspectTemp
                                        .value ==
                                    ContentOptions.calendarWeek.value) {
                                  controller.startSearchDateNightLineInspect =
                                      controller.startSearchDateNightLineInspect
                                          .subtract(Duration(
                                              days: controller
                                                  .startSearchDateNightLineInspect
                                                  .weekday));
                                  controller.toStartSearchDateNightLineInspect =
                                      controller
                                          .toStartSearchDateNightLineInspect
                                          .subtract(Duration(
                                              days: controller
                                                  .toStartSearchDateNightLineInspect
                                                  .weekday));
                                  controller.endSearchDateNightLineInspect =
                                      controller.endSearchDateNightLineInspect
                                          .subtract(Duration(
                                              days: controller
                                                      .endSearchDateNightLineInspect
                                                      .weekday -
                                                  6));
                                  controller.toEndSearchDateNightLineInspect =
                                      controller.toEndSearchDateNightLineInspect
                                          .subtract(Duration(
                                              days: controller
                                                      .toEndSearchDateNightLineInspect
                                                      .weekday -
                                                  6));
                                }
                                if (controller.calendarTypeNightLineInspectTemp
                                        .value ==
                                    ContentOptions.calendarMonth.value) {
                                  controller.startSearchDateNightLineInspect =
                                      DateTime(
                                          controller
                                              .startSearchDateNightLineInspect
                                              .year,
                                          controller
                                              .startSearchDateNightLineInspect
                                              .month,
                                          1);
                                  controller.toStartSearchDateNightLineInspect =
                                      DateTime(
                                          controller
                                              .toStartSearchDateNightLineInspect
                                              .year,
                                          controller
                                              .toStartSearchDateNightLineInspect
                                              .month,
                                          1);
                                  controller.endSearchDateNightLineInspect =
                                      DateTime(
                                          controller
                                              .endSearchDateNightLineInspect
                                              .year,
                                          controller
                                                  .endSearchDateNightLineInspect
                                                  .month +
                                              1,
                                          0);
                                  controller.toEndSearchDateNightLineInspect =
                                      DateTime(
                                          controller
                                              .toEndSearchDateNightLineInspect
                                              .year,
                                          controller
                                                  .toEndSearchDateNightLineInspect
                                                  .month +
                                              1,
                                          0);
                                }
                                if (controller.calendarTypeNightLineInspectTemp
                                        .value ==
                                    ContentOptions.calendarYear.value) {
                                  controller.startSearchDateNightLineInspect =
                                      DateTime(
                                          controller
                                              .startSearchDateNightLineInspect
                                              .year,
                                          1,
                                          1);
                                  controller.toStartSearchDateNightLineInspect =
                                      DateTime(
                                          controller
                                              .toStartSearchDateNightLineInspect
                                              .year,
                                          1,
                                          1);
                                  controller.endSearchDateNightLineInspect =
                                      DateTime(
                                          controller
                                              .endSearchDateNightLineInspect
                                              .year,
                                          12,
                                          31);
                                  controller.toEndSearchDateNightLineInspect =
                                      DateTime(
                                          controller
                                              .toEndSearchDateNightLineInspect
                                              .year,
                                          12,
                                          31);
                                }
                                await controller.getInspect(
                                    isSubstaion: isSubstaion,
                                    isDateTime: isDateTime);
                                Get.back();
                              }
                            }
                          }
                        },
                        child: EButtonWidget(
                          width: MediaQuery.of(context).size.width / 3.2,
                          text: 'Lọc',
                          bgColor: HighElectricAppColor.primary10,
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  updateTextFilter({substaion = true, isDateTime = true, isCable = false}) {
    if (isCable) {
      if (controller.calendarTypeCableInspectTemp.value ==
          ContentOptions.calendarDay.value) {
        controller.dateCableInspectTextController.value.text =
            '${controller.getCalendarType(ContentOptions.calendarDay.value)} ${controller.ddMMyyyy(datetime: controller.startSearchDateCableInspectTemp)}';
        controller.dateCableInspectTextController.refresh();

        controller.toDateCableInspectTextController.value.text =
            '${controller.getCalendarType(ContentOptions.calendarDay.value)} ${controller.ddMMyyyy(datetime: controller.endSearchDateCableInspectTemp)}';
        controller.toDateCableInspectTextController.refresh();
      } else if (controller.calendarTypeCableInspectTemp.value ==
          ContentOptions.calendarWeek.value) {
        controller.dateCableInspectTextController.value.text =
            '${controller.getCalendarType(ContentOptions.calendarWeek.value)} ${getWeekOfYear(controller.startSearchDateCableInspectTemp.toString())}';
        controller.dateCableInspectTextController.refresh();
        controller.toDateCableInspectTextController.value.text =
            '${controller.getCalendarType(ContentOptions.calendarWeek.value)} ${getWeekOfYear(controller.endSearchDateCableInspectTemp.toString())}';
        controller.toDateCableInspectTextController.refresh();
      }
      if (controller.calendarTypeCableInspectTemp.value ==
          ContentOptions.calendarMonth.value) {
        controller.dateCableInspectTextController.value.text =
            '${controller.getCalendarType(ContentOptions.calendarMonth.value)} ${controller.startSearchDateCableInspectTemp.month}/${controller.startSearchDateCableInspectTemp.year}';
        controller.dateCableInspectTextController.refresh();
        controller.toDateCableInspectTextController.value.text =
            '${controller.getCalendarType(ContentOptions.calendarMonth.value)} ${controller.toEndSearchDateCableInspectTemp.month}/${controller.toEndSearchDateCableInspectTemp.year}';
        controller.toDateCableInspectTextController.refresh();
      } else if (controller.calendarTypeCableInspectTemp.value ==
          ContentOptions.calendarYear.value) {
        controller.dateCableInspectTextController.value.text =
            '${controller.getCalendarType(ContentOptions.calendarYear.value)} ${controller.startSearchDateCableInspectTemp.year}';
        controller.dateCableInspectTextController.refresh();
        controller.toDateCableInspectTextController.value.text =
            '${controller.getCalendarType(ContentOptions.calendarYear.value)} ${controller.toEndSearchDateCableInspectTemp.year}';
        controller.toDateCableInspectTextController.refresh();
      }
    } else if (substaion) {
      if (isDateTime) {
        if (controller.calendarTypeInspectTemp.value ==
            ContentOptions.calendarDay.value) {
          controller.dateInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarDay.value)} ${controller.ddMMyyyy(datetime: controller.startSearchDateInspectTemp)}';
          controller.dateInspectTextController.refresh();
          controller.toDateInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarDay.value)} ${controller.ddMMyyyy(datetime: controller.toStartSearchDateInspectTemp)}';
          controller.toDateInspectTextController.refresh();
        } else if (controller.calendarTypeInspectTemp.value ==
            ContentOptions.calendarWeek.value) {
          controller.dateInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarWeek.value)} ${getWeekOfYear(controller.startSearchDateInspectTemp.toString())}';
          controller.dateInspectTextController.refresh();

          controller.toDateInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarWeek.value)} ${getWeekOfYear(controller.toStartSearchDateInspectTemp.toString())}';
          controller.toDateInspectTextController.refresh();
        }
        if (controller.calendarTypeInspectTemp.value ==
            ContentOptions.calendarMonth.value) {
          controller.dateInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarMonth.value)} ${controller.startSearchDateInspectTemp.month}/${controller.startSearchDateInspectTemp.year}';
          controller.dateInspectTextController.refresh();

          controller.toDateInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarMonth.value)} ${controller.toEndSearchDateInspectTemp.month}/${controller.toEndSearchDateInspectTemp.year}';
          controller.toDateInspectTextController.refresh();
        } else if (controller.calendarTypeInspectTemp.value ==
            ContentOptions.calendarYear.value) {
          controller.dateInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarYear.value)} ${controller.startSearchDateInspectTemp.year}';
          controller.dateInspectTextController.refresh();

          controller.toDateInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarYear.value)} ${controller.toEndSearchDateInspectTemp.year}';
          controller.toDateInspectTextController.refresh();
        }
      } else {
        if (controller.calendarTypeNightInspectTemp.value ==
            ContentOptions.calendarDay.value) {
          controller.dateNightInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarDay.value)} ${controller.ddMMyyyy(datetime: controller.startSearchDateNightInspectTemp)}';
          controller.dateNightInspectTextController.refresh();
          controller.toDateNightInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarDay.value)} ${controller.ddMMyyyy(datetime: controller.toEndSearchDateNightInspectTemp)}';
          controller.toDateNightInspectTextController.refresh();
        } else if (controller.calendarTypeNightInspectTemp.value ==
            ContentOptions.calendarWeek.value) {
          controller.dateNightInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarWeek.value)} ${getWeekOfYear(controller.startSearchDateNightInspectTemp.toString())}';
          controller.dateNightInspectTextController.refresh();

          controller.toDateNightInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarWeek.value)} ${getWeekOfYear(controller.toEndSearchDateNightInspectTemp.toString())}';
          controller.toDateNightInspectTextController.refresh();
        }
        if (controller.calendarTypeNightInspectTemp.value ==
            ContentOptions.calendarMonth.value) {
          controller.dateNightInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarMonth.value)} ${controller.startSearchDateNightInspectTemp.month}/${controller.startSearchDateNightInspectTemp.year}';
          controller.dateNightInspectTextController.refresh();

          controller.toDateNightInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarMonth.value)} ${controller.toEndSearchDateNightInspectTemp.month}/${controller.toEndSearchDateNightInspectTemp.year}';
          controller.toDateNightInspectTextController.refresh();
        } else if (controller.calendarTypeNightInspectTemp.value ==
            ContentOptions.calendarYear.value) {
          controller.dateNightInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarYear.value)} ${controller.startSearchDateNightInspectTemp.year}';
          controller.dateNightInspectTextController.refresh();

          controller.toDateNightInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarYear.value)} ${controller.toEndSearchDateNightInspectTemp.year}';
          controller.toDateNightInspectTextController.refresh();
        }
      }
    } else {
      if (isDateTime) {
        if (controller.calendarTypeLineInspectTemp.value ==
            ContentOptions.calendarDay.value) {
          controller.dateLineInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarDay.value)} ${controller.ddMMyyyy(datetime: controller.startSearchDateLineInspectTemp)}';
          controller.dateLineInspectTextController.refresh();

          controller.toDateLineInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarDay.value)} ${controller.ddMMyyyy(datetime: controller.toStartSearchDateLineInspectTemp)}';
          controller.toDateLineInspectTextController.refresh();
        } else if (controller.calendarTypeLineInspectTemp.value ==
            ContentOptions.calendarWeek.value) {
          controller.dateLineInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarWeek.value)} ${getWeekOfYear(controller.startSearchDateLineInspectTemp.toString())}';
          controller.dateLineInspectTextController.refresh();
          controller.toDateLineInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarWeek.value)} ${getWeekOfYear(controller.toStartSearchDateLineInspectTemp.toString())}';
          controller.toDateLineInspectTextController.refresh();
        }
        if (controller.calendarTypeLineInspectTemp.value ==
            ContentOptions.calendarMonth.value) {
          controller.dateLineInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarMonth.value)} ${controller.startSearchDateLineInspectTemp.month}/${controller.startSearchDateLineInspectTemp.year}';
          controller.dateLineInspectTextController.refresh();
          controller.toDateLineInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarMonth.value)} ${controller.toEndSearchDateLineInspectTemp.month}/${controller.toEndSearchDateLineInspectTemp.year}';
          controller.toDateLineInspectTextController.refresh();
        } else if (controller.calendarTypeLineInspectTemp.value ==
            ContentOptions.calendarYear.value) {
          controller.dateLineInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarYear.value)} ${controller.startSearchDateLineInspectTemp.year}';
          controller.dateLineInspectTextController.refresh();
          controller.toDateLineInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarYear.value)} ${controller.toEndSearchDateLineInspectTemp.year}';
          controller.toDateLineInspectTextController.refresh();
        }
      } else {
        if (controller.calendarTypeNightLineInspectTemp.value ==
            ContentOptions.calendarDay.value) {
          controller.dateNightLineInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarDay.value)} ${controller.ddMMyyyy(datetime: controller.startSearchDateNightLineInspectTemp)}';
          controller.dateNightLineInspectTextController.refresh();

          controller.toDateNightLineInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarDay.value)} ${controller.ddMMyyyy(datetime: controller.toStartSearchDateNightLineInspectTemp)}';
          controller.toDateNightLineInspectTextController.refresh();
        } else if (controller.calendarTypeNightLineInspectTemp.value ==
            ContentOptions.calendarWeek.value) {
          controller.dateNightLineInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarWeek.value)} ${getWeekOfYear(controller.startSearchDateNightLineInspectTemp.toString())}';
          controller.dateNightLineInspectTextController.refresh();
          controller.toDateNightLineInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarWeek.value)} ${getWeekOfYear(controller.toStartSearchDateNightLineInspectTemp.toString())}';
          controller.toDateNightLineInspectTextController.refresh();
        }
        if (controller.calendarTypeNightLineInspectTemp.value ==
            ContentOptions.calendarMonth.value) {
          controller.dateNightLineInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarMonth.value)} ${controller.startSearchDateNightLineInspectTemp.month}/${controller.startSearchDateNightLineInspectTemp.year}';
          controller.dateNightLineInspectTextController.refresh();
          controller.toDateNightLineInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarMonth.value)} ${controller.toEndSearchDateNightLineInspectTemp.month}/${controller.toEndSearchDateNightLineInspectTemp.year}';
          controller.toDateNightLineInspectTextController.refresh();
        } else if (controller.calendarTypeNightLineInspectTemp.value ==
            ContentOptions.calendarYear.value) {
          controller.dateNightLineInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarYear.value)} ${controller.startSearchDateNightLineInspectTemp.year}';
          controller.dateNightLineInspectTextController.refresh();
          controller.toDateNightLineInspectTextController.value.text =
              '${controller.getCalendarType(ContentOptions.calendarYear.value)} ${controller.toEndSearchDateNightLineInspectTemp.year}';
          controller.toDateNightLineInspectTextController.refresh();
        }
      }
    }
  }

  Widget buildFilterInfo(BuildContext context,
      {bool isDateTime = true, bool isCable = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isCable
              ? [
                  Text(
                      'Theo ${OptionsType.calendar_type.getOptions.firstWhereOrNull((item) => item.value == controller.calendarTypeCableInspect.value)?.title?.toLowerCase()} ${controller.dateCableInspectTextController.value.text.toString().split(' ').last} - ${controller.toDateCableInspectTextController.value.text.toString().split(' ').last}')
                ]
              : isSubstaion
                  ? [
                      if (isDateTime)
                        Text(
                            'Ngày - Theo ${OptionsType.calendar_type.getOptions.firstWhereOrNull((item) => item.value == controller.calendarTypeInspect.value)?.title?.toLowerCase()} ${controller.dateInspectTextController.value.text.toString().split(' ').last} - ${controller.toDateInspectTextController.value.text.toString().split(' ').last}')
                      else
                        Text(
                            'Đêm - Theo ${OptionsType.calendar_type.getOptions.firstWhereOrNull((item) => item.value == controller.calendarTypeNightInspect.value)?.title?.toLowerCase()} ${controller.dateNightInspectTextController.value.text.toString().split(' ').last} - ${controller.toDateNightInspectTextController.value.text.toString().split(' ').last}')
                    ]
                  : [
                      if (isDateTime)
                        Text(
                            'Ngày - Theo ${OptionsType.calendar_type.getOptions.firstWhereOrNull((item) => item.value == controller.calendarTypeLineInspect.value)?.title?.toLowerCase()} ${controller.dateLineInspectTextController.value.text.toString().split(' ').last} - ${controller.toDateLineInspectTextController.value.text.toString().split(' ').last}')
                      else
                        Text(
                            'Đêm - Theo ${OptionsType.calendar_type.getOptions.firstWhereOrNull((item) => item.value == controller.calendarTypeNightLineInspect.value)?.title?.toLowerCase()} ${controller.dateNightLineInspectTextController.value.text.toString().split(' ').last} - ${controller.toDateNightLineInspectTextController.value.text.toString().split(' ').last}')
                    ],
        ),
        GestureDetector(
          onTap: () {
            _showFilter(context, isDateTime: isDateTime, isCable: isCable);
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            color: HighElectricAppColor.highlightColorDashboard,
            child: Row(
              children: [
                const Text(
                  'Lọc',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(
                  HighElectricAppIcon.filter,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class BuildCircleChart extends StatefulWidget {
  final DashboardController controller;
  final bool isSubstaion;
  final bool isDateTime;

  const BuildCircleChart(
      {Key key, this.controller, this.isSubstaion, this.isDateTime = true})
      : super(key: key);

  @override
  BuildCircleChartState createState() => BuildCircleChartState();
}

class BuildCircleChartState extends State<BuildCircleChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    InspectDashboardModel model;
    if (widget.isSubstaion) {
      model = (widget.isDateTime
          ? widget.controller.inspectModel.value
          : widget.controller.nightInspectModel.value) as InspectDashboardModel;
    } else {
      model = (widget.isDateTime
              ? widget.controller.lineInspectModel.value
              : widget.controller.nightLineInspectModel.value)
          as InspectDashboardModel;
    }
    return model.substationDayTimeSumCount != null
        ? PieChart(
            PieChartData(
                pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection.touchedSectionIndex;
                    debugPrint('index: $touchedIndex');
                  });
                }),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 0,
                sections: showingSections()),
          )
        : Container();
  }

  List<PieChartSectionData> showingSections() {
    InspectDashboardModel model;
    if (widget.isSubstaion) {
      model = (widget.isDateTime
          ? widget.controller.inspectModel.value
          : widget.controller.nightInspectModel.value) as InspectDashboardModel;
    } else {
      model = (widget.isDateTime
              ? widget.controller.lineInspectModel.value
              : widget.controller.nightLineInspectModel.value)
          as InspectDashboardModel;
    }
    return List.generate(
      4,
      (i) {
        final isTouched = i == touchedIndex;
        final radius =
            isTouched ? Get.size.width / 3 : (Get.size.width / 3) - 10;
        final widgetSize = isTouched ? 55.0 : 40.0;

        const color0 = Color(0xff456779);
        const color1 = Color(0xffE9B9A8);
        const color2 = Color(0xffD1D9DA);
        const color3 = Colors.transparent;
        if (widget.isSubstaion) {
          if (!widget.isDateTime) {
            double valueFinished =  model.substationNightTimeSumCount == 0
                ? 0
                : ((model.substaionNightTimeCompleteCount ?? 0.0) /
                model.substationNightTimeSumCount) *
                50.0;

            double valueInImplement =  model.substationNightTimeSumCount == 0
                ? 0
                : ((model.substaionNightTimeInprogressCount ?? 0.0) /
                model.substationNightTimeSumCount) *
                50.0;

            double valueNotImplement =  model.substationNightTimeSumCount == 0
                ? 0
                : 50 - valueFinished - valueInImplement;

            switch (i) {
              case 0:
                valueFinished = valueFinished == 0 ? 0.001 : valueFinished;
                final disable = valueFinished == 0.001;
                return PieChartSectionData(
                  color: color0,
                  value: valueFinished.toDouble(),
                  title: disable
                      ? ''
                      : valueFinished < 5
                          ? ''
                          : '${roundDouble(valueFinished * 2, 2)}%',
                  radius: radius,
                  titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  badgeWidget: Visibility(
                    visible: isTouched,
                    child: BadgeApp(
                      title:
                          '${model.substaionNightTimeCompleteCount}/${model.substationNightTimeSumCount}',
                      size: widgetSize,
                      borderColor: color0,
                    ),
                  ),
                  titlePositionPercentageOffset: 0.8,
                  badgePositionPercentageOffset: 0.98,
                );
              case 1:
                valueInImplement = valueInImplement == 0 ? 0.001 : valueInImplement;
                final disable = valueInImplement == 0.001;
                return PieChartSectionData(
                  color: color1,
                  value: valueInImplement.toDouble(),
                  title: disable
                      ? ''
                      : valueInImplement < 5
                          ? ''
                          : '${roundDouble(valueInImplement * 2, 2)}%',
                  radius: radius,
                  titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  badgeWidget: Visibility(
                    visible: isTouched,
                    child: BadgeApp(
                      title:
                          '${model.substaionNightTimeInprogressCount}/${model.substationNightTimeSumCount}',
                      size: widgetSize,
                      borderColor: color1,
                    ),
                  ),
                  titlePositionPercentageOffset: 0.8,
                  badgePositionPercentageOffset: 0.98,
                );
              case 2:

                valueNotImplement = valueNotImplement == 0 ? 0.001 : valueNotImplement;
                final disable = valueNotImplement == 0.001;
                return PieChartSectionData(
                  color: color2,
                  value: valueNotImplement.toDouble(),
                  title: disable
                      ? ''
                      : valueNotImplement < 5
                          ? ''
                          : '${roundDouble(valueNotImplement * 2, 2)}%',
                  radius: radius,
                  titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  badgeWidget: Visibility(
                    visible: isTouched,
                    child: BadgeApp(
                      title:
                          '${model.substaionNightTimeNotHandleCount}/${model.substationNightTimeSumCount}',
                      size: widgetSize,
                      borderColor: color2,
                    ),
                  ),
                  titlePositionPercentageOffset: 0.8,
                  badgePositionPercentageOffset: 0.98,
                );
              case 3:
                const value = 50;
                return PieChartSectionData(
                  color: color3,
                  value: value.toDouble(),
                  title: '',
                );

              default:
                throw Error();
            }
          } else {

            var valueComplete = model.substationDayTimeSumCount == 0
                ? 0
                : ((model.substaionDayTimeCompleteCount ?? 0.0) / model.substationDayTimeSumCount) * 50.0;

            var valueInprogress = model.substationDayTimeSumCount == 0
                ? 0
                : ((model.substaionDayTimeInprogressCount ?? 0.0) / model.substationDayTimeSumCount) * 50.0;

            var valueNoImplementYet = 50 - valueComplete - valueInprogress;

            switch (i) {
              case 3:

                valueComplete = valueComplete == 0 ? 0.001 : valueComplete;
                final disable = valueComplete == 0.001;
                return PieChartSectionData(
                  color: color0,
                  value: valueComplete.toDouble(),
                  title: disable
                      ? ''
                      : valueComplete < 5
                          ? ''
                          : '${roundDouble(valueComplete * 2, 2)}%',
                  radius: radius,
                  titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  badgeWidget: Visibility(
                    visible: isTouched,
                    child: BadgeApp(
                      title:
                          '${model.substaionDayTimeCompleteCount}/${model.substationDayTimeSumCount}',
                      size: widgetSize,
                      borderColor: color0,
                    ),
                  ),
                  titlePositionPercentageOffset: 0.8,
                  badgePositionPercentageOffset: 0.98,
                );
              case 1:

                valueInprogress = valueInprogress == 0 ? 0.001 : valueInprogress;
                final disable = valueInprogress == 0.001;
                return PieChartSectionData(
                  color: color1,
                  value: valueInprogress.toDouble(),
                  title: disable
                      ? ''
                      : valueInprogress < 5
                          ? ''
                          : '${roundDouble(valueInprogress * 2, 2)}%',
                  radius: radius,
                  titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  badgeWidget: Visibility(
                    visible: isTouched,
                    child: BadgeApp(
                      title:
                          '${model.substaionDayTimeInprogressCount}/${model.substationDayTimeSumCount}',
                      size: widgetSize,
                      borderColor: color1,
                    ),
                  ),
                  titlePositionPercentageOffset: 0.8,
                  badgePositionPercentageOffset: 0.98,
                );
              case 2:

                valueNoImplementYet = valueNoImplementYet == 0 ? 0.001 : valueNoImplementYet;
                final disable = valueNoImplementYet == 0.001;
                return PieChartSectionData(
                  color: color2,
                  value: valueNoImplementYet.toDouble(),
                  title: disable
                      ? ''
                      : valueNoImplementYet < 5
                          ? ''
                          : '${roundDouble(valueNoImplementYet * 2, 2)}%',
                  radius: radius,
                  titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  badgeWidget: Visibility(
                    visible: isTouched,
                    child: BadgeApp(
                      title:
                          '${model.substaionDayTimeNotHandleCount}/${model.substationDayTimeSumCount}',
                      size: widgetSize,
                      borderColor: color2,
                    ),
                  ),
                  titlePositionPercentageOffset: 0.8,
                  badgePositionPercentageOffset: 0.98,
                );
              case 0:
                const value = 50;
                return PieChartSectionData(
                  color: color3,
                  value: value.toDouble(),
                  title: '',
                );
              default:
                throw Error();
            }
          }
        } else {
          if (!widget.isDateTime) {

            var complete = model.lineNightTimeSumCount == 0
                ? 0
                : ((model.lineNightTimeCompleteCount ?? 0.0) /
                model.lineNightTimeSumCount) *
                50.0;

            var valueInprogress = model.lineNightTimeSumCount == 0
                ? 0
                : ((model.lineNightTimeInprogressCount ?? 0.0) /
                model.lineNightTimeSumCount) *
                50.0;

            var valueNoInplementYet = 50 - complete - valueInprogress;
            switch (i) {
              case 0:

                complete = complete == 0 ? 0.001 : complete;
                final disable = complete == 0.001;
                return PieChartSectionData(
                  color: color0,
                  value: complete.toDouble(),
                  title: disable
                      ? ''
                      : complete < 5
                          ? ''
                          : '${roundDouble(complete * 2, 2)}%',
                  radius: radius,
                  titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  badgeWidget: Visibility(
                    visible: isTouched,
                    child: BadgeApp(
                      title:
                          '${model.lineNightTimeCompleteCount}/${model.lineNightTimeSumCount}',
                      size: widgetSize,
                      borderColor: color0,
                    ),
                  ),
                  titlePositionPercentageOffset: 0.8,
                  badgePositionPercentageOffset: 0.98,
                );
              case 1:

                valueInprogress = valueInprogress == 0 ? 0.001 : valueInprogress;
                final disable = valueInprogress == 0.001;
                return PieChartSectionData(
                  color: color1,
                  value: valueInprogress.toDouble(),
                  title: disable
                      ? ''
                      : valueInprogress < 5
                          ? ''
                          : '${roundDouble(valueInprogress * 2, 2)}%',
                  radius: radius,
                  titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  badgeWidget: Visibility(
                    visible: isTouched,
                    child: BadgeApp(
                      title:
                          '${model.lineNightTimeInprogressCount}/${model.lineNightTimeSumCount}',
                      size: widgetSize,
                      borderColor: color1,
                    ),
                  ),
                  titlePositionPercentageOffset: 0.8,
                  badgePositionPercentageOffset: 0.98,
                );
              case 2:

                valueNoInplementYet = valueNoInplementYet == 0 ? 0.001 : valueNoInplementYet;
                final disable = valueNoInplementYet == 0.001;
                return PieChartSectionData(
                  color: color2,
                  value: valueNoInplementYet.toDouble(),
                  title: disable
                      ? ''
                      : valueNoInplementYet < 5
                          ? ''
                          : '${roundDouble(valueNoInplementYet * 2, 2)}%',
                  radius: radius,
                  titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  badgeWidget: Visibility(
                    visible: isTouched,
                    child: BadgeApp(
                      title:
                          '${model.lineNightTimeNotHandleCount}/${model.lineNightTimeSumCount}',
                      size: widgetSize,
                      borderColor: color2,
                    ),
                  ),
                  titlePositionPercentageOffset: 0.8,
                  badgePositionPercentageOffset: 0.98,
                );
              case 3:
                const value = 50;
                return PieChartSectionData(
                  color: color3,
                  value: value.toDouble(),
                  title: '',
                );
              default:
                throw Error();
            }
          } else {

            var valueComplete = model.lineDayTimeSumCount == 0
                ? 0
                : ((model.lineDayTimeCompleteCount ?? 0.0) /
                model.lineDayTimeSumCount) *
                50.0;

            var valueInProgress = model.lineDayTimeSumCount == 0
                ? 0
                : ((model.lineDayTimeInprogressCount ?? 0.0) /
                model.lineDayTimeSumCount) *
                50.0;

            var valueNoImplementYet = 50 - valueComplete - valueInProgress;

            switch (i) {
              case 3:

                valueComplete = valueComplete == 0 ? 0.001 : valueComplete;
                final disable = valueComplete == 0.001;
                return PieChartSectionData(
                  color: color0,
                  value: valueComplete.toDouble(),
                  title: disable
                      ? ''
                      : valueComplete < 5
                          ? ''
                          : '${roundDouble(valueComplete * 2, 2)}%',
                  radius: radius,
                  titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  badgeWidget: Visibility(
                    visible: isTouched,
                    child: BadgeApp(
                      title:
                          '${model.lineDayTimeCompleteCount}/${model.lineDayTimeSumCount}',
                      size: widgetSize,
                      borderColor: color0,
                    ),
                  ),
                  titlePositionPercentageOffset: 0.8,
                  badgePositionPercentageOffset: 0.98,
                );
              case 1:

                valueInProgress = valueInProgress == 0 ? 0.001 : valueInProgress;
                final disable = valueInProgress == 0.001;
                return PieChartSectionData(
                  color: color1,
                  value: valueInProgress.toDouble(),
                  title: disable
                      ? ''
                      : valueInProgress < 5
                          ? ''
                          : '${roundDouble(valueInProgress * 2, 2)}%',
                  radius: radius,
                  titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  badgeWidget: Visibility(
                    visible: isTouched,
                    child: BadgeApp(
                      title:
                          '${model.lineDayTimeInprogressCount}/${model.lineDayTimeSumCount}',
                      size: widgetSize,
                      borderColor: color1,
                    ),
                  ),
                  titlePositionPercentageOffset: 0.8,
                  badgePositionPercentageOffset: 0.98,
                );
              case 2:

                valueNoImplementYet = valueNoImplementYet == 0 ? 0.001 : valueNoImplementYet;
                final disable = valueNoImplementYet == 0.001;
                return PieChartSectionData(
                  color: color2,
                  value: valueNoImplementYet.toDouble(),
                  title: disable
                      ? ''
                      : valueNoImplementYet < 5
                          ? ''
                          : '${roundDouble(valueNoImplementYet * 2, 2)}%',
                  radius: radius,
                  titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  badgeWidget: Visibility(
                    visible: isTouched,
                    child: BadgeApp(
                      title:
                          '${model.lineDayTimeNotHandleCount}/${model.lineDayTimeSumCount}',
                      size: widgetSize,
                      borderColor: color2,
                    ),
                  ),
                  titlePositionPercentageOffset: 0.8,
                  badgePositionPercentageOffset: 0.98,
                );
              case 0:
                const value = 50;
                return PieChartSectionData(
                  color: color3,
                  value: value.toDouble(),
                  title: '',
                );
              default:
                throw Error();
            }
          }
        }
      },
    );
  }
}

