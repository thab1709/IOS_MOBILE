// @dart=2.9
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/constance/content_option.dart';
import '../../../models/dashboard/abnormal_dashboard_model.dart';
import '../dashboard_controller.dart';

class BuildAbnormalColumn extends StatefulWidget {
  final DashboardController controller;

  const BuildAbnormalColumn({Key key, this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BuildAbnormalColumnState();
}

class BuildAbnormalColumnState extends State<BuildAbnormalColumn> {
  final Color leftBarColor = const Color(0xff6E96F8);
  final Color centerBarColor = Colors.grey;
  final Color rightBarColor = const Color(0xff53fdd7);
  final double width = 15;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    final model =
        widget.controller.abnormalModel.value as AbnormalDashboardModel;

    final items = <BarChartGroupData>[];
    var allValue = 0.0;
    var notHandleValue = 0.0;

    for (var i = 0; i < model.abnormalData.length; i++) {
      if (widget.controller.abnormalTyleChart.value !=
          ContentOptions.dashboardAbmorder.value) {
        allValue = 0.0;
        notHandleValue = 0.0;
      }
      notHandleValue += model.abnormalData[i].notHandler.toDouble();
      allValue += model.abnormalData[i].sumAbnormal.toDouble();

      items.add(makeGroupData(i, notHandleValue, allValue));
    }

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
    final maxAbnormal = widget.controller.getMaxYAbnormal(model.abnormalData);
    return Column(
      children: [
        if (model.abnormalData != null && model.abnormalData.isNotEmpty)
          Container(
            width: double.infinity,
            height: maxAbnormal < 30
                ? 200.0
                : maxAbnormal < 70
                    ? maxAbnormal * 13.0
                    : maxAbnormal < 100
                        ? maxAbnormal * 5.0
                        : maxAbnormal * 2.3,
            //model.abnormalData.length < 5? 300: model.abnormalData.length * 30.0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: (model.abnormalData?.length ?? 0) < 5
                    ? 400
                    : (model.abnormalData?.length ?? 0) * 95.0,
                child: BarChart(
                  BarChartData(
                    maxY: widget.controller
                        .getMaxYAbnormal(model.abnormalData)
                        .toDouble(),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: bottomTitles,
                          reservedSize: 60,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: 10,
                          getTitlesWidget: leftTitles,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        bottom: BorderSide(color: Color(0xff4e4965), width: 0.5),
                        left: BorderSide(color: Colors.transparent),
                        right: BorderSide(color: Colors.transparent),
                        top: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    barGroups: showingBarGroups,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 5,
                      checkToShowHorizontalLine: (double value) {
                        return true;
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (model.abnormalData != null && model.abnormalData.isNotEmpty)
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

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;

    if (value % 10 == 0) {
      text = value.toString().replaceAll('.0', '');
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>[];
    final model =
        widget.controller.abnormalModel.value as AbnormalDashboardModel;
    if (widget.controller.calendarTypeAbnormal.value ==
        ContentOptions.calendarWeek.value) {
      for (var i = 0; i < model.abnormalData.length; i++) {
        titles.add(model.abnormalData[i].weekOfYear);
      }
    } else if (widget.controller.calendarTypeAbnormal.value ==
        ContentOptions.calendarMonth.value) {
      for (var i = 0; i < model.abnormalData.length; i++) {
        titles.add(model.abnormalData[i].monthOfYear);
      }
    } else if (widget.controller.calendarTypeAbnormal.value ==
        ContentOptions.calendarYear.value) {
      for (var i = 0; i < model.abnormalData.length; i++) {
        titles.add(model.abnormalData[i].year);
      }
    } else {
      for (var i = 0; i < model.abnormalData.length; i++) {
        titles.add(DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(model.abnormalData[i].createdDate)));
      }
    }

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double notHandle, double sum) {
    return BarChartGroupData(barsSpace: 0, x: x, barRods: [
      if (widget.controller.statusAbnormal.value !=
          ContentOptions.workSumHandle.value)
        BarChartRodData(
          borderRadius: BorderRadius.zero,
          toY: notHandle,
          color: leftBarColor,
          width: width,
        ),
      if (widget.controller.statusAbnormal.value !=
          ContentOptions.workNotHandle.value)
        BarChartRodData(
          borderRadius: BorderRadius.zero,
          toY: sum,
          color: rightBarColor,
          width: width,
        ),
    ]);
  }
}

