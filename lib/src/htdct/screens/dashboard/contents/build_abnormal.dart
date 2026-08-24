// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart'
    as DateTimePickerSpec;
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../app_common/utils/utils.dart';
import '../../../../htld/common/themes/colorx.dart';
import '../../../../htld/common/utils/progress_h_u_d.dart';
import '../../../common/constance/app_color.dart';
import '../../../common/constance/app_icon.dart';
import '../../../common/constance/content_option.dart';
import '../../../common/constance/option_type.dart';
import '../../../common/themes/styles.dart';
import '../../../models/option_model.dart';
import '../../grid_management/containers/e_button.dart';
import '../../grid_management/containers/e_single_drop_down.dart';
import '../dashboard_controller.dart';
import 'build_abnormal_circle.dart';
import '../common/custom_expansion_title.dart' as custom;
import 'build_abnormal_column.dart';
import 'build_abnormal_line.dart';

class AbnormalLineChart extends StatelessWidget {
  final DashboardController controller;

  const AbnormalLineChart({Key key, this.controller}) : super(key: key);

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
            onExpansionChanged: (value) async {

              if(value == true) {
                ProgressHUD.show();
                final futures = <Future>[];
                futures.add(controller.getAbnormal(electricalGrid: false, isBackground: true));

                await Future.wait(futures);
                ProgressHUD.dismiss();
              }
            },
            iconColor: HighElectricAppColor.nature01,
            initiallyExpanded: false,
            title: Obx(() => RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: 'Bất thường trong ngày',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: HighElectricAppColor.nature01,
                      )),
                  if(controller.numberAbnormalInDay.isNotEmpty)
                  TextSpan(
                      text: ' (${controller.numberAbnormalInDay})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: HighElectricAppColor.orange,
                      ))
                ]))),
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: buildContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text('Danh sách biểu đồ:',
                style: TextStyle(color: Color(0xff696973), fontSize: 16)),
            const SizedBox(
              height: 10,
            ),
            ESingleDropDown(
              OptionsType.abnormal_chart.getOptions,
              hasTransformerTicketController: false,
              padding: 0,
              isInTicket: false,
              value: controller.abnormalTyleChart.value == 0
                  ? null
                  : controller.abnormalTyleChart.value,
              hint: 'Chọn biểu đồ',
              contentHorizontalPadding: 10,
              onSelected: (option) async {
                controller.abnormalTyleChart.value = int.parse(option);
                controller.abnormalTyleChart.refresh();
              },
            ),
            if (controller.abnormalTyleChart.value !=
                    ContentOptions.dashboardAbmorderLog.value &&
                controller.abnormalTyleChart.value != 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Trạng thái công việc:',
                      style: TextStyle(color: Color(0xff696973), fontSize: 16)),
                  const SizedBox(
                    height: 10,
                  ),
                  ESingleDropDown(
                    OptionsType.work_status.getOptions,
                    padding: 0,
                    isInTicket: false,
                    value: controller.statusAbnormal.value,
                    hint: 'Chọn loại',
                    contentHorizontalPadding: 10,
                    onSelected: (option) async {
                      controller.statusAbnormal.value = int.parse(option);
                      controller.statusAbnormal.refresh();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Dạng biểu đồ:',
                      style: TextStyle(color: Color(0xff696973), fontSize: 16)),
                  const SizedBox(
                    height: 10,
                  ),
                  ESingleDropDown(
                    [
                      OptionModel('Dạng cột', 0),
                      OptionModel('Dạng đường', 1)
                    ],
                    padding: 0,
                    isInTicket: false,
                    value: controller.typeChartAbnormal.value,
                    hint: 'Chọn loại',
                    contentHorizontalPadding: 10,
                    onSelected: (option) async {
                      controller.typeChartAbnormal.value = int.parse(option);
                      controller.typeChartAbnormal.refresh();
                    },
                  ),
                ],
              ),
            const SizedBox(
              height: 10,
            ),
            buildFilterInfo(context),
            const SizedBox(
              height: 10,
            ),
            Obx(buildChart)
          ],
        ));
  }

  Widget buildChart() {
    if (controller.abnormalTyleChart.value != 0 &&
        controller.abnormalTyleChart.value !=
            ContentOptions.dashboardAbmorderLog.value) {
      if (controller.typeChartAbnormal.value == 1) {
        return BuildAbnormalLine(
          controller: controller,
        );
      } else {
        return Obx(() => Column(
              children: [
                Visibility(
                  visible: false,
                  child: Text('${controller.statusAbnormal.value}'),
                ),
                BuildAbnormalColumn(
                  controller: controller,
                ),
              ],
            ));
      }
      // return buildLineChart();
    } else if (controller.abnormalTyleChart.value ==
        ContentOptions.dashboardAbmorderLog.value) {
      return Obx(() => Column(
            children: [
              Visibility(
                visible: false,
                child: Text('${controller.statusAbnormal.value}'),
              ),
              BuildAbnormalCircle(controller: controller)
            ],
          ));
    }
    return Container();
  }

  Widget buildFilterInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '${controller.abnormalTyleChart.value == ContentOptions.dashboardAbmorderSynthetic ? 'Cột -' : controller.abnormalTyleChart.value == ContentOptions.dashboardAbmorder ? 'Đường -' : ''}${controller.typeInspect == 0 ? 'Trạm biến áp - ' : 'Đường dây - '} Theo ${OptionsType.calendar_type.getOptions.firstWhereOrNull((item) => item.value == controller.calendarTypeAbnormal.value)?.title?.toLowerCase()}'),
            Text(
                '${controller.dateAbnormalTextController.value.text.toString().split(' ').last} - ${controller.toDateAbnormalTextController.value.text.toString().split(' ').last}')
          ],
        ),
        GestureDetector(
          onTap: () {
            _showFilter(context);
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

  Widget buildFilter(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          // buildTitle('Trạm biến áp/ đường dây'),
          ESingleDropDown(
            [OptionModel('Trạm biến áp', 0), OptionModel('Đường dây', 1)],
            padding: 0,
            isInTicket: false,
            value: controller.typeInspectTemp,
            hint: 'Chọn loại',
            contentHorizontalPadding: 10,
            onSelected: (option) async {
              controller.typeInspectTemp = int.parse(option);
              // await controller.getAbnormal();
            },
          ),
          const SizedBox(
            height: 8,
          ),
          // buildTitle('Loại thời gian'),
          ESingleDropDown(
            OptionsType.calendar_type.getOptions,
            padding: 0,
            value: controller.calendarTypeAbnormalTemp.value,
            hint: 'Chọn loại thời gian',
            contentHorizontalPadding: 10,
            onSelected: (option) async {
              controller.calendarTypeAbnormalTemp.value = int.parse(option);
              controller.calendarTypeAbnormalTemp.refresh();
              updateTextFilter();
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
                        _showCalendarPicker(context);
                      },
                      child: Obx(
                        () => Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller:
                                    controller.dateAbnormalTextController.value,
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
                              color: (controller
                                      .startOrEndDay(
                                          dateTime: controller
                                              .startSearchDateAbnormalTemp,
                                          startDay: true)
                                      .isBefore(controller.startOrEndDay(
                                          dateTime: controller
                                              .toStartSearchDateAbnormalTemp,
                                          startDay: false)))
                                  ? Colors.grey.shade300
                                  : Colors.red)),
                      child: GestureDetector(
                        onTap: () {
                          _showCalendarPicker(context, startTime: false);
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller
                                    .toDateAbnormalTextController.value,
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

  Widget buildWeekDatePicker(
      {DateTime startDate,
      DateTime endDate,
      Function onChange,
      int typeCalendar,
      bool startTime = true}) {
    // add some colors to default settings
    final styles = DateTimePickerSpec.DatePickerRangeStyles(
      selectedPeriodLastDecoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(10), bottomEnd: Radius.circular(10))),
      selectedPeriodStartDecoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(10),
            bottomStart: Radius.circular(10)),
      ),
      selectedPeriodMiddleDecoration:
          const BoxDecoration(color: Colors.yellow, shape: BoxShape.rectangle),
    );

    if (typeCalendar == ContentOptions.calendarDay.value) {
      return DateTimePickerSpec.DayPicker.single(
          datePickerStyles: styles,
          selectedDate: startDate ?? DateTime.now(),
          // selectedPeriod: DatePeriod(startDate, endDate),
          onChanged: (values) => {
                Get.back(),
                if (startTime)
                  {
                    controller.startSearchDateAbnormalTemp = values,
                    controller.endSearchDateAbnormalTemp = values,
                    controller.dateAbnormalTextController.value.text =
                        '${controller.getCalendarType(typeCalendar)} ${controller.ddMMyyyy(datetime: controller.startSearchDateAbnormalTemp)}',
                    controller.dateAbnormalTextController.refresh(),
                    controller.toDateAbnormalTextController.refresh(),
                  }
                else
                  {
                    controller.toStartSearchDateAbnormalTemp = values,
                    controller.toEndSearchDateAbnormalTemp = values,
                    controller.toDateAbnormalTextController.value.text =
                        '${controller.getCalendarType(typeCalendar)} ${controller.ddMMyyyy(datetime: controller.toStartSearchDateAbnormalTemp)}',
                    controller.toDateAbnormalTextController.refresh(),
                  },
              },
          firstDate: DateTime(1990, 1, 1),
          lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month,
              DateTime.now().day));
    } else if (typeCalendar == ContentOptions.calendarWeek.value) {
      return WeekPicker(
          selectedDate: endDate,
          onChanged: (values) => {
                Get.back(),
                if (startTime)
                  {
                    controller.startSearchDateAbnormalTemp = values.start,
                    controller.endSearchDateAbnormalTemp = values.end,
                    controller.dateAbnormalTextController.value.text =
                        '${controller.getCalendarType(typeCalendar)} ${getWeekOfYear(controller.startSearchDateAbnormalTemp.toString())}',
                    controller.dateAbnormalTextController.refresh(),
                    controller.toDateAbnormalTextController.refresh(),
                  }
                else
                  {
                    controller.toStartSearchDateAbnormalTemp = values.start,
                    controller.toEndSearchDateAbnormalTemp = values.end,
                    controller.toDateAbnormalTextController.value.text =
                        '${controller.getCalendarType(typeCalendar)} ${getWeekOfYear(controller.toStartSearchDateAbnormalTemp.toString())}',
                    controller.toDateAbnormalTextController.refresh(),
                  },
              },
          firstDate: DateTime(1990, 1, 1),
          lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month,
              DateTime.now().day),
          datePickerStyles: styles);
    } else if (typeCalendar == ContentOptions.calendarMonth.value) {
      return DateTimePickerSpec.MonthPicker.single(
          datePickerStyles: styles,
          selectedDate: endDate,
          onChanged: (values) => {
                Get.back(),
                if (startTime)
                  {
                    controller.startSearchDateAbnormalTemp = values,
                    controller.endSearchDateAbnormalTemp = DateTime(
                        values.year,
                        values.month,
                        DateTime(values.year, values.month + 1, 0).day),
                    controller.dateAbnormalTextController.value.text =
                        '${controller.getCalendarType(typeCalendar)} ${controller.startSearchDateAbnormalTemp.month}/${controller.startSearchDateAbnormalTemp.year}',
                    controller.dateAbnormalTextController.refresh(),
                    controller.toDateAbnormalTextController.refresh(),
                  }
                else
                  {
                    controller.toStartSearchDateAbnormalTemp = values,
                    controller.toEndSearchDateAbnormalTemp = DateTime(
                        values.year,
                        values.month,
                        DateTime(values.year, values.month + 1, 0).day),
                    controller.toDateAbnormalTextController.value.text =
                        '${controller.getCalendarType(typeCalendar)} ${controller.toEndSearchDateAbnormalTemp.month}/${controller.toEndSearchDateAbnormalTemp.year}',
                    controller.toDateAbnormalTextController.refresh(),
                  },
              },
          firstDate: DateTime(1990, 1, 1),
          lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month,
              DateTime.now().day));
    } else if (typeCalendar == ContentOptions.calendarYear.value) {
      return DateTimePickerSpec.YearPicker.single(
          datePickerStyles: styles,
          selectedDate: endDate,
          onChanged: (values) => {
                Get.back(),
                if (startTime)
                  {
                    controller.startSearchDateAbnormalTemp = values,
                    controller.endSearchDateAbnormalTemp =
                        DateTime(values.year, 12, 31),
                    controller.dateAbnormalTextController.value.text =
                        '${controller.getCalendarType(typeCalendar)} ${controller.startSearchDateAbnormalTemp.year}',
                    controller.dateAbnormalTextController.refresh(),
                    controller.toDateAbnormalTextController.refresh(),
                  }
                else
                  {
                    controller.toStartSearchDateAbnormalTemp = values,
                    controller.toEndSearchDateAbnormalTemp =
                        DateTime(values.year, 12, 31),
                    controller.toDateAbnormalTextController.value.text =
                        '${controller.getCalendarType(typeCalendar)} ${controller.toEndSearchDateAbnormalTemp.year}',
                    controller.toDateAbnormalTextController.refresh(),
                  },
              },
          firstDate: DateTime(1990, 1, 1),
          lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month,
              DateTime.now().day));
    } else {
      return Container();
    }
  }

  Future _showFilter(context) async {
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
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.close))
                    ],
                  ),
                  buildFilter(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.typeInspectTemp = controller.typeInspect;
                          controller.calendarTypeAbnormalTemp.value =
                              controller.calendarTypeAbnormal.value;
                          controller.startSearchDateAbnormalTemp =
                              controller.startSearchDateAbnormal;
                          controller.endSearchDateAbnormalTemp =
                              controller.endSearchDateAbnormal;
                          controller.toStartSearchDateAbnormalTemp =
                              controller.toStartSearchDateAbnormal;
                          controller.toEndSearchDateAbnormalTemp =
                              controller.toEndSearchDateAbnormal;

                          updateTextFilter();
                          Get.back();
                        },
                        child: EButtonWidget(
                          width: MediaQuery.of(context).size.width / 3.2,
                          text: 'Thoát',
                          bgColor: Colors.white,
                          textColor: HighElectricAppColor.primary10,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (controller
                              .startOrEndDay(
                                  dateTime:
                                      controller.startSearchDateAbnormalTemp,
                                  startDay: true)
                              .isBefore(controller.startOrEndDay(
                                  dateTime:
                                      controller.toStartSearchDateAbnormalTemp,
                                  startDay: false))) {
                            controller.typeInspect = controller.typeInspectTemp;
                            controller.calendarTypeAbnormal.value =
                                controller.calendarTypeAbnormalTemp.value;
                            controller.startSearchDateAbnormal =
                                controller.startSearchDateAbnormalTemp;
                            controller.endSearchDateAbnormal =
                                controller.endSearchDateAbnormalTemp;
                            controller.toStartSearchDateAbnormal =
                                controller.toStartSearchDateAbnormalTemp;
                            controller.toEndSearchDateAbnormal =
                                controller.toEndSearchDateAbnormalTemp;
                            if(controller.calendarTypeAbnormal.value == ContentOptions.calendarWeek.value)
                            {
                              controller.startSearchDateAbnormal = controller.startSearchDateAbnormal.subtract(Duration(days: controller.startSearchDateAbnormal.weekday));
                              controller.toStartSearchDateAbnormal = controller.toStartSearchDateAbnormal.subtract(Duration(days: controller.toStartSearchDateAbnormal.weekday));
                              controller.endSearchDateAbnormal = controller.endSearchDateAbnormal.subtract(Duration(days: controller.endSearchDateAbnormal.weekday - 6));
                              controller.toEndSearchDateAbnormal = controller.toEndSearchDateAbnormal.subtract(Duration(days: controller.toEndSearchDateAbnormal.weekday - 6));
                            }
                            else if(controller.calendarTypeAbnormal.value == ContentOptions.calendarMonth.value)
                            {
                              controller.startSearchDateAbnormal = DateTime(controller.startSearchDateAbnormal.year, controller.startSearchDateAbnormal.month, 1);
                              controller.toStartSearchDateAbnormal = DateTime(controller.toStartSearchDateAbnormal.year, controller.toStartSearchDateAbnormal.month, 1);
                              controller.endSearchDateAbnormal = DateTime(controller.endSearchDateAbnormal.year, controller.endSearchDateAbnormal.month + 1, 0);
                              controller.toEndSearchDateAbnormal = DateTime(controller.toEndSearchDateAbnormal.year, controller.toEndSearchDateAbnormal.month + 1, 0);
                            }
                            else if(controller.calendarTypeAbnormal.value == ContentOptions.calendarYear.value)
                            {
                              controller.startSearchDateAbnormal = DateTime(controller.startSearchDateAbnormal .year, 1, 31);
                              controller.toStartSearchDateAbnormal = DateTime(controller.toStartSearchDateAbnormal.year, 12, 31);
                              controller.endSearchDateAbnormal = DateTime(controller.endSearchDateAbnormal.year, 1, 31);
                              controller.toEndSearchDateAbnormal = DateTime(controller.toEndSearchDateAbnormal.year, 12, 31);
                            }

                            Get.back();
                            await controller.getAbnormal();
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

 void updateTextFilter() {
    if (controller.calendarTypeAbnormalTemp.value ==
        ContentOptions.calendarDay.value) {
      controller.dateAbnormalTextController.value.text =
          '${controller.getCalendarType(ContentOptions.calendarDay.value)} ${controller.ddMMyyyy(datetime: controller.startSearchDateAbnormalTemp)}';
      controller.dateAbnormalTextController.refresh();
      controller.toDateAbnormalTextController.value.text =
          '${controller.getCalendarType(ContentOptions.calendarDay.value)} ${controller.ddMMyyyy(datetime: controller.toStartSearchDateAbnormalTemp)}';
      controller.toDateAbnormalTextController.refresh();
    } else if (controller.calendarTypeAbnormalTemp.value ==
        ContentOptions.calendarWeek.value) {
      controller.dateAbnormalTextController.value.text =
          '${controller.getCalendarType(ContentOptions.calendarWeek.value)} ${getWeekOfYear(controller.startSearchDateAbnormalTemp.toString())}';
      controller.toDateAbnormalTextController.value.text =
          '${controller.getCalendarType(ContentOptions.calendarWeek.value)} ${getWeekOfYear(controller.toStartSearchDateAbnormalTemp.toString())}';
      controller.toDateAbnormalTextController.refresh();
    }
    if (controller.calendarTypeAbnormalTemp.value ==
        ContentOptions.calendarMonth.value) {
      controller.dateAbnormalTextController.value.text =
          '${controller.getCalendarType(ContentOptions.calendarMonth.value)} ${controller.startSearchDateAbnormalTemp.month}/${controller.startSearchDateAbnormalTemp.year}';
      controller.dateAbnormalTextController.refresh();
      controller.toDateAbnormalTextController.value.text =
          '${controller.getCalendarType(ContentOptions.calendarMonth.value)} ${controller.toEndSearchDateAbnormalTemp.month}/${controller.toEndSearchDateAbnormalTemp.year}';
      controller.toDateAbnormalTextController.refresh();
    } else if (controller.calendarTypeAbnormalTemp.value ==
        ContentOptions.calendarYear.value) {
      controller.dateAbnormalTextController.value.text =
          '${controller.getCalendarType(ContentOptions.calendarYear.value)} ${controller.startSearchDateAbnormalTemp.year}';
      controller.dateAbnormalTextController.refresh();
      controller.toDateAbnormalTextController.value.text =
          '${controller.getCalendarType(ContentOptions.calendarYear.value)} ${controller.toEndSearchDateAbnormalTemp.year}';
      controller.toDateAbnormalTextController.refresh();
    }
  }

  Future _showCalendarPicker(context, {bool startTime = true}) async {
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
                      endDate: startTime
                          ? controller.endSearchDateAbnormalTemp
                          : controller.toEndSearchDateAbnormalTemp,
                      startDate: startTime
                          ? controller.startSearchDateAbnormalTemp
                          : controller.toStartSearchDateAbnormalTemp,
                      typeCalendar: controller.calendarTypeAbnormalTemp.value,
                      startTime: startTime,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

