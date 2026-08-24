// @dart=2.9
import 'package:intl/intl.dart';

import '../../../app_common/utils/utils.dart';

class AbnormalDashboardModel {
  int countSum;
  int countInprogress;
  int countComplete;
  List<AbnormalData> abnormalData;
  List<GraphData> graphData;

  AbnormalDashboardModel(
      {this.countSum,
      this.countInprogress,
      this.countComplete,
      this.abnormalData,
      this.graphData});

  AbnormalDashboardModel.fromJson(Map<dynamic, dynamic> json) {
    countSum = json['countSum'];
    countInprogress = json['countInprogress'];
    countComplete = json['countComplete'];
    if (json['abnormalData'] != null) {
      abnormalData = <AbnormalData>[];
      json['abnormalData'].forEach((v) {
        abnormalData.add(AbnormalData.fromJson(v));
      });
    }
    if (json['graphData'] != null) {
      graphData = <GraphData>[];
      json['graphData'].forEach((v) {
        graphData.add(GraphData.fromJson(v));
      });
    }
  }

  double getMaxHandelValue() {
    var max = 0;
    if (abnormalData != null) {
      abnormalData.forEach((element) {
        // if(element.handler>max)
        //   {
        //     max = element.handler;
        //   }
        if (element.notHandler > max) {
          max = element.notHandler;
        }
      });
    }
    return max.toDouble();
  }

  double getMaxGrossHandelValue() {
    var max = 0;
    if (abnormalData != null) {
      abnormalData.forEach((element) {
        max += element.handler;
      });
    }
    return max.toDouble();
  }

  double getMinHandelValue() {
    var min = 9999;
    if (abnormalData != null) {
      abnormalData.forEach((element) {
        if (element.handler < min) {
          min = element.handler;
        }
        if (element.notHandler < min) {
          min = element.notHandler;
        }
      });
    }
    return min.toDouble();
  }
}

class AbnormalData {
  String createdDate;
  int sumAbnormal;
  int notHandler;
  int handler;
  String weekOfYear;
  String monthOfYear;
  String year;

  AbnormalData({this.createdDate,
    this.sumAbnormal,
    this.notHandler,
    this.handler,
    this.monthOfYear,
    this.weekOfYear,
    this.year});

  AbnormalData.fromJson(Map<dynamic, dynamic> json) {
    createdDate = json['createdDate'];
    sumAbnormal = json['sumAbnormal'];
    notHandler = json['notHandler'];
    handler = json['handler'];
    final datetime = DateTime.parse(createdDate);
    weekOfYear = getWeekOfYear(createdDate);
    createdDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(createdDate)).toString();
    monthOfYear = '${datetime.month}/${datetime.year}';
    year = '${datetime.year}';
  }
}

class GraphData {
  int typeAbnormal;
  String typeAbnormalName;
  int total;
  int count;

  GraphData({this.typeAbnormal, this.typeAbnormalName, this.total, this.count});

  GraphData.fromJson(Map<dynamic, dynamic> json) {
    typeAbnormal = json['typeAbnormal'];
    typeAbnormalName = json['typeAbnormalName'];
    total = json['total'];
    count = json['count'];
  }
}

