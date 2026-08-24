// @dart=2.9
import 'package:evnmobile/src/htdct/common/utils/common.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../models/dashboard/abnormal_dashboard_model.dart';
import '../common/badge_circle.dart';
import '../dashboard_controller.dart';

class BuildAbnormalCircle extends StatefulWidget {
  final DashboardController controller;

  const BuildAbnormalCircle({Key key, this.controller}) : super(key: key);

  @override
  PieChart2State createState() => PieChart2State();
}

class PieChart2State extends State<BuildAbnormalCircle> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return widget.controller.abnormalModel.value != null
        ? Column(
            children: [
              if(widget.controller.abnormalModel.value.graphData.length > 0)
              AspectRatio(
                aspectRatio: 1.3,
                child: Card(
                  // color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        height: 18,
                      ),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: PieChart(
                            PieChartData(
                                pieTouchData: PieTouchData(touchCallback:
                                    (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection ==
                                            null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = pieTouchResponse
                                        .touchedSection.touchedSectionIndex;
                                  });
                                }),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 0,
                                centerSpaceRadius: 70,
                                sections: showingSections()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if(widget.controller.abnormalModel.value.graphData.length > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                          Indicator(
                            color: Color(0xff74b44a),
                            text: 'Đường dây',
                            isSquare: true,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Indicator(
                            color: Color(0xff5096d6),
                            text: 'Kênh truyền',
                            isSquare: true,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Indicator(
                            color: Color(0xfff28646),
                            text: 'Nhị thứ',
                            isSquare: true,
                          ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Indicator(
                        color: Color(0xffa9a9a9),
                        text: 'HT SCADA + HMI',
                        isSquare: true,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Indicator(
                        color: Color(0xfff1bd00),
                        text: 'HT 1 chiều',
                        isSquare: true,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Indicator(
                        color: Color(0xff3568c1),
                        text: 'Nhất thứ',
                        isSquare: true,
                      ),
                    ],
                  )
                ],
              )
            ],
          )
        : Container();
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(6, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final widgetSize = isTouched ? 55.0 : 40.0;

      switch (i) {
        // Nhất thứ
        case 0:
          return PieChartSectionData(
            color: const Color(0xff3568c1),
            value: getValueItem(typeEvent: 0),
            title: '${getValueItem(typeEvent: 0)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: Visibility(
              visible: isTouched,
              child: BadgeApp(
                title:
                '${getValueItemString(typeEvent: 0)}',
                size: widgetSize,
                borderColor: const Color(0xff3568c1),
              ),
            ),
            badgePositionPercentageOffset: 0.98,
          );
        // Nhị thứ
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff28646),
            value: getValueItem(typeEvent: 1),
            title: '${getValueItem(typeEvent: 1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: Visibility(
              visible: isTouched,
              child: BadgeApp(
                title:
                '${getValueItemString(typeEvent: 1)}',
                size: widgetSize,
                borderColor: const Color(0xfff28646),
              ),
            ),
            badgePositionPercentageOffset: 0.98,
          );
        // HT SCADA + HMI
        case 2:
          return PieChartSectionData(
            color: const Color(0xffa9a9a9),
            value: getValueItem(typeEvent: 2),
            title: '${getValueItem(typeEvent: 2)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: Visibility(
              visible: isTouched,
              child: BadgeApp(
                title:
                '${getValueItemString(typeEvent: 2)}',
                size: widgetSize,
                borderColor: const Color(0xffa9a9a9),
              ),
            ),
            badgePositionPercentageOffset: 0.98,
          );
        // HT 1 chiều
        case 3:
          return PieChartSectionData(
            color: const Color(0xfff1bd00),
            value: getValueItem(typeEvent: 3),
            title: '${getValueItem(typeEvent: 3)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: Visibility(
              visible: isTouched,
              child: BadgeApp(
                title:
                '${getValueItemString(typeEvent: 3)}',
                size: widgetSize,
                borderColor: const Color(0xfff1bd00),
              ),
            ),
            badgePositionPercentageOffset: 0.98,
          );
        // Kênh truyền
        case 4:
          return PieChartSectionData(
            color: const Color(0xff5096d6),
            value: getValueItem(typeEvent: 4),
            title: '${getValueItem(typeEvent: 4)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: Visibility(
              visible: isTouched,
              child: BadgeApp(
                title:
                '${getValueItemString(typeEvent: 4)}',
                size: widgetSize,
                borderColor: const Color(0xff5096d6),
              ),
            ),
            badgePositionPercentageOffset: 0.98,
          );
        // Đường dây
        case 5:
          return PieChartSectionData(
            color: const Color(0xff74b44a),
            value: getValueItem(typeEvent: 5),
            title: '${getValueItem(typeEvent: 5)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: Visibility(
              visible: isTouched,
              child: BadgeApp(
                title:
                '${getValueItemString(typeEvent: 5)}',
                size: widgetSize,
                borderColor: const Color(0xff74b44a),
              ),
            ),
            badgePositionPercentageOffset: 0.98,
          );
        default:
          throw Error();
      }
    });
  }

  double getValueItem({int typeEvent}) {
    final abnormalDashboardModel =
        widget.controller.abnormalModel.value as AbnormalDashboardModel;
    if (abnormalDashboardModel.graphData == null) {
      return 0;
    }
    var total = 0;
    for(final e in abnormalDashboardModel.graphData) {
      total += e.total;
    }
    for (var i = 0; i < abnormalDashboardModel.graphData.length; i++) {
      final item = abnormalDashboardModel.graphData[i];
      if (item.typeAbnormal == (typeEvent + 1)) {
        return roundDouble((item.count / total) * 100, 0);
      }
    }
    return 0;
  }

  String getValueItemString({int typeEvent}) {
    final abnormalDashboardModel =
    widget.controller.abnormalModel.value as AbnormalDashboardModel;
    if (abnormalDashboardModel.graphData == null) {
      return '0';
    }
    for (var i = 0; i < abnormalDashboardModel.graphData.length; i++) {
      final item = abnormalDashboardModel.graphData[i];
      if (item.typeAbnormal == (typeEvent + 1)) {
        return '${item.count}/${item.total}';
      }
    }
    return '0';
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key key,
    this.color,
    this.text,
    this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}

