// @dart=2.9
import 'package:evnmobile/src/htdct/common/utils/common.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../app_common/utils/utils.dart';
import '../../../../htld/common/themes/colorx.dart';
import '../../../common/constance/app_color.dart';
import '../../../common/constance/app_icon.dart';
import '../../../common/constance/content_option.dart';
import '../../../common/constance/option_type.dart';
import '../../../common/themes/styles.dart';
import '../../../models/dashboard/abnormal_dashboard_model.dart';
import '../../../models/option_model.dart';
import '../../grid_management/containers/e_button.dart';
import '../../grid_management/containers/e_single_drop_down.dart';
import '../common/badge_circle.dart';
import '../dashboard_controller.dart';
import '../common/custom_expansion_title.dart' as custom;
import 'package:get/get.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart'
    as DateTimePickerSpec;

class BuildWorkChart extends StatelessWidget {
  final DashboardController controller;

  const BuildWorkChart({Key key, this.controller}) : super(key: key);

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
            onExpansionChanged: (value) async {
              if(value == true) {
               await controller.getAbnormal(electricalGrid: true, isBackground: false);
              }
            },
            headerBackgroundColor: HighElectricAppColor.highlightColorDashboard,
            iconColor: HighElectricAppColor.nature01,
            initiallyExpanded: false,
            title: Obx(() => RichText(
                text: TextSpan(children: [
                  const TextSpan(
                      text: 'Công tác trên lưới',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: HighElectricAppColor.nature01,
                      )),
                  if(controller.numberPerformOnGrid.isNotEmpty)
                    TextSpan(
                        text: ' (${controller.numberPerformOnGrid})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: HighElectricAppColor.orange,
                        ))
                ]))),
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [BuildWorkCircle(controller: controller)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildWorkCircle extends StatelessWidget {
  final DashboardController controller;

  int touchedIndex = -1;

  BuildWorkCircle({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: buildFilterInfo(context),
        ),
        Column(
          children: [
            if (controller.electricalGridModel.value?.countSum!=null)
              Container(
                width: double.infinity,
                height: 300,
                child: BuildCircleChart(
                  controller: controller,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      color: const Color(0xff649CD8),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Đã công tác'),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      color: const Color(0xffE47D1C),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Đang công tác'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void _showCalendarPicker(context, {bool startTime = true}) async {
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
                          ? controller.endSearchDateElectricalGridTemp
                          : controller.toEndSearchDateElectricalGridTemp,
                      startDate: startTime
                          ? controller.startSearchDateElectricalGridTemp
                          : controller.toStartSearchDateElectricalGridTemp,
                      typeCalendar:
                          controller.calendarTypeElectricalGridTemp.value,
                      startTime: startTime,
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
      bool startTime = true}) {
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
          selectedDate: startDate ?? DateTime.now(),
          onChanged: (values) => {
                Get.back(),
                if (startTime)
                  {
                    controller.startSearchDateElectricalGridTemp = values,
                    controller.endSearchDateElectricalGridTemp = values,
                    controller.dateElectricalGridTextController.value.text =
                        '${controller.getCalendarType(typeCalendar)} ${controller.ddMMyyyy(datetime: controller.startSearchDateElectricalGridTemp)}',
                    controller.dateElectricalGridTextController.refresh(),
                    controller.toDateElectricalGridTextController.refresh(),
                  }
                else
                  {
                    controller.toStartSearchDateElectricalGridTemp = values,
                    controller.toEndSearchDateElectricalGridTemp = values,
                    controller.toDateElectricalGridTextController.value.text =
                        '${controller.getCalendarType(typeCalendar)} ${controller.ddMMyyyy(datetime: controller.toStartSearchDateElectricalGridTemp)}',
                    controller.toDateElectricalGridTextController.refresh(),
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
                    controller.startSearchDateElectricalGridTemp = values.start,
                    controller.endSearchDateElectricalGridTemp = values.end,
                    controller.dateElectricalGridTextController.value.text =
                        '${controller.getCalendarType(typeCalendar)} ${getWeekOfYear(controller.startSearchDateElectricalGridTemp.toString())}',
                    controller.dateElectricalGridTextController.refresh(),
                    controller.toDateElectricalGridTextController.refresh(),
                  }
                else
                  {
                    controller.toStartSearchDateElectricalGridTemp =
                        values.start,
                    controller.toEndSearchDateElectricalGridTemp = values.end,
                    controller.toDateElectricalGridTextController.value.text =
                        '${controller.getCalendarType(typeCalendar)} ${getWeekOfYear(controller.toStartSearchDateElectricalGridTemp.toString())}',
                    controller.toDateElectricalGridTextController.refresh(),
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
                if (startTime)
                  {
                    controller.startSearchDateElectricalGridTemp = values,
                    controller.endSearchDateElectricalGridTemp = DateTime(
                        values.year,
                        values.month,
                        DateTime(values.year, values.month + 1, 0).day),
                    controller.dateElectricalGridTextController.value.text =
                        '${controller.getCalendarType(typeCalendar)} ${controller.startSearchDateElectricalGridTemp.month}/${controller.startSearchDateElectricalGridTemp.year}',
                    controller.dateElectricalGridTextController.refresh(),
                    controller.toDateElectricalGridTextController.refresh(),
                  }
                else
                  {
                    controller.toStartSearchDateElectricalGridTemp = values,
                    controller.toEndSearchDateElectricalGridTemp = DateTime(
                        values.year,
                        values.month,
                        DateTime(values.year, values.month + 1, 0).day),
                    controller.toDateElectricalGridTextController.value.text =
                        '${controller.getCalendarType(typeCalendar)} ${controller.toEndSearchDateElectricalGridTemp.month}/${controller.toEndSearchDateElectricalGridTemp.year}',
                    controller.toDateElectricalGridTextController.refresh(),
                  },
                Get.back(),
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
                    controller.startSearchDateElectricalGridTemp = values,
                    controller.endSearchDateElectricalGridTemp =
                        DateTime(values.year, 12, 31),
                    controller.dateElectricalGridTextController.value.text =
                        '${controller.getCalendarType(typeCalendar)} ${controller.startSearchDateElectricalGridTemp.year}',
                    controller.dateElectricalGridTextController.refresh(),
                    controller.toDateElectricalGridTextController.refresh(),
                  }
                else
                  {
                    controller.toStartSearchDateElectricalGridTemp = values,
                    controller.toEndSearchDateElectricalGridTemp =
                        DateTime(values.year, 12, 31),
                    controller.toDateElectricalGridTextController.value.text =
                        '${controller.getCalendarType(typeCalendar)} ${controller.toEndSearchDateElectricalGridTemp.year}',
                    controller.toDateElectricalGridTextController.refresh(),
                  },
              },
          firstDate: DateTime(1990, 1, 1),
          lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month,
              DateTime.now().day));
    } else {
      return Container();
    }
  }

  Widget buildFilter(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          ESingleDropDown(
            [OptionModel('Trạm biến áp', 0), OptionModel('Đường dây', 1)],
            padding: 0,
            value: controller.typeInspectGridTemp,
            hint: 'Chọn loại',
            contentHorizontalPadding: 10,
            onSelected: (option) async {
              controller.typeInspectGridTemp = int.parse(option);
              // await controller.getAbnormal();
            },
          ),
          const SizedBox(
            height: 8,
          ),
          ESingleDropDown(
            OptionsType.calendar_type.getOptions,
            padding: 0,
            value: controller.calendarTypeElectricalGridTemp.value,
            hint: 'Chọn loại thời gian',
            contentHorizontalPadding: 10,
            onSelected: (option) async {
              controller.calendarTypeElectricalGridTemp.value =
                  int.parse(option);
              controller.calendarTypeElectricalGridTemp.refresh();
              updateTextFilter();
            },
          ),
          Obx(
            () => Visibility(
              visible: controller.calendarTypeElectricalGridTemp.value !=
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
                                controller: controller
                                    .dateElectricalGridTextController.value,
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
                              color:  (controller
                              .startOrEndDay(
                          dateTime: controller
                              .startSearchDateElectricalGridTemp,
                              startDay: true)
                              .isBefore(controller.startOrEndDay(
                              dateTime: controller
                                  .toStartSearchDateElectricalGridTemp,
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
                                    .toDateElectricalGridTextController.value,
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

  void _showFilter(context) async {
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
                          controller.calendarTypeElectricalGridTemp =
                              controller.calendarTypeElectricalGrid;
                          controller.startSearchDateElectricalGridTemp =
                              controller.startSearchDateElectricalGrid;
                          controller.endSearchDateElectricalGridTemp =
                              controller.endSearchDateElectricalGrid;
                          controller.toStartSearchDateElectricalGridTemp =
                              controller.toStartSearchDateElectricalGrid;
                          controller.toEndSearchDateElectricalGridTemp =
                              controller.toEndSearchDateElectricalGrid;
                          controller.typeInspectGridTemp =
                              controller.typeInspectGrid;
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
                                  dateTime: controller
                                      .startSearchDateElectricalGridTemp,
                                  startDay: true)
                              .isBefore(controller.startOrEndDay(
                                  dateTime: controller
                                      .toStartSearchDateElectricalGridTemp,
                                  startDay: false))) {
                            controller.calendarTypeElectricalGrid =
                                controller.calendarTypeElectricalGridTemp;
                            controller.startSearchDateElectricalGrid =
                                controller.startSearchDateElectricalGridTemp;
                            controller.endSearchDateElectricalGrid =
                                controller.endSearchDateElectricalGridTemp;
                            controller.toStartSearchDateElectricalGrid =
                                controller.toStartSearchDateElectricalGridTemp;
                            controller.toEndSearchDateElectricalGrid =
                                controller.toEndSearchDateElectricalGridTemp;
                            controller.typeInspectGrid =
                                controller.typeInspectGridTemp;

                            if(controller.calendarTypeElectricalGrid.value == ContentOptions.calendarWeek.value)
                              {
                                controller.startSearchDateElectricalGrid = controller.startSearchDateElectricalGrid.subtract(Duration(days: controller.startSearchDateElectricalGrid.weekday));
                                controller.toStartSearchDateElectricalGrid = controller.toStartSearchDateElectricalGrid.subtract(Duration(days: controller.toStartSearchDateElectricalGrid.weekday));
                                controller.endSearchDateElectricalGrid = controller.endSearchDateElectricalGrid.subtract(Duration(days: controller.endSearchDateElectricalGrid.weekday - 6));
                                controller.toEndSearchDateElectricalGrid = controller.toEndSearchDateElectricalGrid.subtract(Duration(days: controller.toEndSearchDateElectricalGrid.weekday - 6));
                              }
                            if(controller.calendarTypeElectricalGrid.value == ContentOptions.calendarMonth.value)
                              {
                                controller.startSearchDateElectricalGrid = DateTime(controller.startSearchDateElectricalGrid.year, controller.startSearchDateElectricalGrid.month, 1);
                                controller.toStartSearchDateElectricalGrid = DateTime(controller.toStartSearchDateElectricalGrid.year, controller.toStartSearchDateElectricalGrid.month, 1);
                                controller.endSearchDateElectricalGrid = DateTime(controller.endSearchDateElectricalGrid.year, controller.endSearchDateElectricalGrid.month + 1, 0);
                                controller.toEndSearchDateElectricalGrid = DateTime(controller.toEndSearchDateElectricalGrid.year, controller.toEndSearchDateElectricalGrid.month + 1, 0);
                              }
                            if(controller.calendarTypeElectricalGrid.value == ContentOptions.calendarYear.value)
                              {
                                controller.startSearchDateElectricalGrid = DateTime(controller.startSearchDateElectricalGrid .year, 1, 31);
                                controller.toStartSearchDateElectricalGrid = DateTime(controller.toStartSearchDateElectricalGrid.year, 12, 31);
                                controller.endSearchDateElectricalGrid = DateTime(controller.endSearchDateElectricalGrid.year, 12, 31);
                                controller.toEndSearchDateElectricalGrid = DateTime(controller.toEndSearchDateElectricalGrid.year, 12, 31);
                              }

                            Get.back();
                            await controller.getAbnormal(electricalGrid: true);
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

  Widget buildFilterInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '${controller.typeInspectGrid == 0 ? 'Trạm biến áp - ' : 'Đường dây - '} Theo ${OptionsType.calendar_type.getOptions.firstWhereOrNull((item) => item.value == controller.calendarTypeElectricalGrid.value)?.title?.toLowerCase()}'),
            Text(
                '${controller.dateElectricalGridTextController.value.text.toString().split(' ').last} - ${controller.toDateElectricalGridTextController.value.text.toString().split(' ').last}')
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

 void updateTextFilter() {
    if (controller.calendarTypeElectricalGridTemp.value ==
        ContentOptions.calendarDay.value) {
      controller.dateElectricalGridTextController.value.text =
          '${controller.getCalendarType(ContentOptions.calendarDay.value)} ${controller.ddMMyyyy(datetime: controller.startSearchDateElectricalGridTemp)}';
      controller.dateElectricalGridTextController.refresh();
      controller.toDateElectricalGridTextController.value.text =
          '${controller.getCalendarType(ContentOptions.calendarDay.value)} ${controller.ddMMyyyy(datetime: controller.toStartSearchDateElectricalGridTemp)}';
      controller.toDateElectricalGridTextController.refresh();
    } else if (controller.calendarTypeElectricalGridTemp.value ==
        ContentOptions.calendarWeek.value) {
      controller.dateElectricalGridTextController.value.text =
          '${controller.getCalendarType(ContentOptions.calendarWeek.value)} ${getWeekOfYear(controller.startSearchDateElectricalGridTemp.toString())}';
      controller.dateElectricalGridTextController.refresh();
      controller.toDateElectricalGridTextController.value.text =
          '${controller.getCalendarType(ContentOptions.calendarWeek.value)} ${getWeekOfYear(controller.toStartSearchDateElectricalGridTemp.toString())}';
      controller.toDateElectricalGridTextController.refresh();
    }
    if (controller.calendarTypeElectricalGridTemp.value ==
        ContentOptions.calendarMonth.value) {
      controller.dateElectricalGridTextController.value.text =
          '${controller.getCalendarType(ContentOptions.calendarMonth.value)} ${controller.startSearchDateElectricalGridTemp.month}/${controller.startSearchDateElectricalGridTemp.year}';
      controller.dateElectricalGridTextController.refresh();
      controller.toDateElectricalGridTextController.value.text =
          '${controller.getCalendarType(ContentOptions.calendarMonth.value)} ${controller.toEndSearchDateElectricalGridTemp.month}/${controller.toEndSearchDateElectricalGridTemp.year}';
      controller.toDateElectricalGridTextController.refresh();
    } else if (controller.calendarTypeElectricalGridTemp.value ==
        ContentOptions.calendarYear.value) {
      controller.dateElectricalGridTextController.value.text =
          '${controller.getCalendarType(ContentOptions.calendarYear.value)} ${controller.startSearchDateElectricalGridTemp.year}';
      controller.dateElectricalGridTextController.refresh();
      controller.toDateElectricalGridTextController.value.text =
          '${controller.getCalendarType(ContentOptions.calendarYear.value)} ${controller.toEndSearchDateElectricalGridTemp.year}';
      controller.toDateElectricalGridTextController.refresh();
    }
  }
}

class BuildCircleChart extends StatefulWidget {
  final DashboardController controller;

  const BuildCircleChart({Key key, this.controller}) : super(key: key);

  @override
  BuildCircleChartState createState() => BuildCircleChartState();
}

class BuildCircleChartState extends State<BuildCircleChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return PieChart(
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
            });
          }),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 0,
          sections: showingSections()),
    );
  }

  List<PieChartSectionData> showingSections() {
    var model =
        widget.controller.electricalGridModel.value as AbnormalDashboardModel;
    const color0 = Color(0xff649CD8);
    const color1 = Color(0xffE47D1C);

    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? Get.size.width / 3 : (Get.size.width / 3) - 10;
      final widgetSize = isTouched ? 55.0 : 40.0;

      switch (i) {
        case 0:
          final value = model.countSum == 0
              ? 0
              : roundDouble(
                  ((model.countComplete ?? 0.0) / model.countSum) * 100, 0);
          return PieChartSectionData(
            color: color0,
            value: value.toDouble(),
            title: '${value.toString().replaceAll('.0', '')}%',
            radius: radius,
            titleStyle: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            badgeWidget: Visibility(
              visible: isTouched,
              child: BadgeApp(
                title: '${model.countComplete}/${model.countSum}',
                size: widgetSize,
                borderColor: color0,
              ),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          final value = model.countSum == 0
              ? 0
              : 100 -
                  roundDouble(
                      ((model.countComplete ?? 0.0) / model.countSum) * 100, 0);
          return PieChartSectionData(
            color: color1,
            value: value.toDouble(),
            title: '${value.toString().replaceAll('.0', '')}%',
            radius: radius,
            titleStyle: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            badgeWidget: Visibility(
              visible: isTouched,
              child: BadgeApp(
                title: '${model.countInprogress}/${model.countSum}',
                size: widgetSize,
                borderColor: color1,
              ),
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw 'Oh no';
      }
    });
  }
}

