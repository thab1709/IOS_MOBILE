// @dart=2.9
class InspectDashboardModel {
  int substationDayTimeSumCount;
  int substaionDayTimeInprogressCount;
  int substaionDayTimeCompleteCount;
  int substaionDayTimeNotHandleCount;
  int substationNightTimeSumCount;
  int substaionNightTimeInprogressCount;
  int substaionNightTimeCompleteCount;
  int substaionNightTimeNotHandleCount;
  int lineDayTimeSumCount;
  int lineDayTimeInprogressCount;
  int lineDayTimeCompleteCount;
  int lineDayTimeNotHandleCount;
  int lineNightTimeSumCount;
  int lineNightTimeInprogressCount;
  int lineNightTimeCompleteCount;
  int lineNightTimeNotHandleCount;
  int lineUnderSumCount;
  UnderGroundDetails underGroundDetails;

  InspectDashboardModel(
      {this.substationDayTimeSumCount,
        this.substaionDayTimeInprogressCount,
        this.substaionDayTimeCompleteCount,
        this.substaionDayTimeNotHandleCount,
        this.substationNightTimeSumCount,
        this.substaionNightTimeInprogressCount,
        this.substaionNightTimeCompleteCount,
        this.substaionNightTimeNotHandleCount,
        this.lineDayTimeSumCount,
        this.lineDayTimeInprogressCount,
        this.lineDayTimeCompleteCount,
        this.lineDayTimeNotHandleCount,
        this.lineNightTimeSumCount,
        this.lineNightTimeInprogressCount,
        this.lineNightTimeCompleteCount,
        this.lineNightTimeNotHandleCount,
        this.lineUnderSumCount,
        this.underGroundDetails});

  InspectDashboardModel.fromJson(Map<dynamic, dynamic> json) {
    // substationDayTimeSumCount = json['substationDayTimeSumCount'];
    substaionDayTimeInprogressCount = json['substaionDayTimeInprogressCount'];
    substaionDayTimeCompleteCount = json['substaionDayTimeCompleteCount'];
    substaionDayTimeNotHandleCount = json['substaionDayTimeNotHandleCount'];
    substationNightTimeSumCount = json['substationNightTimeSumCount'];
    substaionNightTimeInprogressCount =
    json['substaionNightTimeInprogressCount'];
    substaionNightTimeCompleteCount = json['substaionNightTimeCompleteCount'];
    substaionNightTimeNotHandleCount = json['substaionNightTimeNotHandleCount'];
    lineDayTimeSumCount = json['lineDayTimeSumCount'];
    lineDayTimeInprogressCount = json['lineDayTimeInprogressCount'];
    lineDayTimeCompleteCount = json['lineDayTimeCompleteCount'];
    lineDayTimeNotHandleCount = json['lineDayTimeNotHandleCount'];
    lineNightTimeSumCount = json['lineNightTimeSumCount'];
    lineNightTimeInprogressCount = json['lineNightTimeInprogressCount'];
    lineNightTimeCompleteCount = json['lineNightTimeCompleteCount'];
    lineNightTimeNotHandleCount = json['lineNightTimeNotHandleCount'];
    lineUnderSumCount = json['lineUnderSumCount'];
    substationDayTimeSumCount = substaionDayTimeInprogressCount + substaionDayTimeCompleteCount + substaionDayTimeNotHandleCount;

    underGroundDetails = json['underGroundDetails'] != null?
    UnderGroundDetails.fromJson(json['underGroundDetails'])
    : null;
  }

}

class UnderGroundDetails {
  int sumCount;
  List<Details> details;

  UnderGroundDetails({this.sumCount, this.details});

  UnderGroundDetails.fromJson(Map<dynamic, dynamic> json) {
    sumCount = json['sumCount'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details.add(Details.fromJson(v));
      });
    }
  }


}

class Details {
  String lineName;
  String underName;

  Details({this.lineName, this.underName});

  Details.fromJson(Map<dynamic, dynamic> json) {
    lineName = json['lineName'];
    underName = json['underName'];
  }

}

