// @dart=2.9
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/constance/content_option.dart';
import '../../../models/dashboard/abnormal_dashboard_model.dart';
import '../dashboard_controller.dart';

class _LineChart extends StatelessWidget {
  final DashboardController controller;

  const _LineChart({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      lineChartData(),
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        if (controller.statusAbnormal.value ==
                ContentOptions.workAllStatus.value ||
            controller.statusAbnormal.value ==
                ContentOptions.workSumHandle.value)
          grossSumAbnormalChart(),
        if (controller.statusAbnormal.value !=
            ContentOptions.workSumHandle.value)
          notHandlerLineChart(),
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    if (value % 10 == 0) {
      return Text((value.toStringAsFixed(0)).toString(),
          style: style, textAlign: TextAlign.center);
    } else {
      return Container();
    }
  }

  LineChartData lineChartData() {
    final abnormalDashboardModel =
        controller.abnormalModel.value as AbnormalDashboardModel;

    return LineChartData(
      backgroundColor: Colors.transparent,
      lineTouchData: lineTouchData,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 5,
        checkToShowHorizontalLine: (double value) {
          return true;
        },
      ),
      titlesData: titlesData,
      borderData: borderData,
      lineBarsData: lineBarsData1,
      minX: 0,
      maxX: abnormalDashboardModel.abnormalData.length * 8.0,
      maxY: controller
          .getMaxYAbnormal(
            abnormalDashboardModel.abnormalData,
          )
          .toDouble(),
      minY: 0,
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;

    final abnormalDashboardModel =
        controller.abnormalModel.value as AbnormalDashboardModel;

    for (var i = 0; i < abnormalDashboardModel.abnormalData.length; i++) {
      if (i * 10 == value) {
        var title = '';
        if (controller.calendarTypeAbnormal.value ==
            ContentOptions.calendarWeek.value) {
          title = abnormalDashboardModel.abnormalData[i].weekOfYear;
        } else if (controller.calendarTypeAbnormal.value ==
            ContentOptions.calendarMonth.value) {
          title = abnormalDashboardModel.abnormalData[i].monthOfYear;
        } else if (controller.calendarTypeAbnormal.value ==
            ContentOptions.calendarYear.value) {
          title = abnormalDashboardModel.abnormalData[i].year;
        } else {
          title = DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(
                  abnormalDashboardModel.abnormalData[i].createdDate))
              .toString();
        }
        text = Text(title, style: style);
      }
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 2),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData grossSumAbnormalChart() {
    final abnormalDashboardModel =
        controller.abnormalModel.value as AbnormalDashboardModel;

    var spots = <FlSpot>[];
    var value = 0.0;
    for (var i = 0; i < abnormalDashboardModel.abnormalData.length; i++) {
      if (controller.abnormalTyleChart.value !=
          ContentOptions.dashboardAbmorder.value) {
        value = 0.0;
      }
      value += abnormalDashboardModel.abnormalData[i].sumAbnormal.toDouble();
      spots.add(FlSpot(i * 10.0, value));
    }

    return LineChartBarData(
      curveSmoothness: 0,
      isCurved: true,
      color: const Color(0xff7DD9AD),
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: spots,
    );
  }

  LineChartBarData notHandlerLineChart() {
    final abnormalDashboardModel =
        controller.abnormalModel.value as AbnormalDashboardModel;

    final spots = <FlSpot>[];
    var value = 0.0;
    for (var i = 0; i < abnormalDashboardModel.abnormalData.length; i++) {
      if (controller.abnormalTyleChart.value !=
          ContentOptions.dashboardAbmorder.value) {
        value = 0.0;
      }
      value += abnormalDashboardModel.abnormalData[i].notHandler.toDouble();
      spots.add(FlSpot(i * 10.0, value));
    }

    return LineChartBarData(
      curveSmoothness: 0,
      isCurved: true,
      color: const Color(0xff6E96F8),
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(
        show: false,
        color: const Color(0x00aa4cfc),
      ),
      spots: spots,
    );
  }
}

class BuildAbnormalLine extends StatefulWidget {
  final DashboardController controller;

  const BuildAbnormalLine({Key key, this.controller}) : super(key: key);

  @override
  BuildAbnormalLineState createState() => BuildAbnormalLineState();
}

class BuildAbnormalLineState extends State<BuildAbnormalLine> {
  bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 400,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            color: Colors.transparent,
          ),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 16, left: 6),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            padding: const EdgeInsets.only(top: 10),
                            width: (widget.controller.abnormalModel.value
                                            ?.abnormalData?.length ??
                                        0) <
                                    5
                                ? 400
                                : (widget.controller.abnormalModel.value
                                            ?.abnormalData?.length ??
                                        0) *
                                    95.0,
                            child: _LineChart(controller: widget.controller),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
          // ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              color: const Color(0xff6E96F8),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text('Chưa xử lý'),
            const SizedBox(
              width: 30,
            ),
            Container(
              width: 20,
              height: 20,
              color: const Color(0xff7DD9AD),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text('Tổng số'),
          ],
        )
      ],
    );
  }
}

