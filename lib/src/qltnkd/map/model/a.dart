// @dart=2.9
import 'package:evnmobile/src/qltnkd/map/model/substaton_location.dart';
import 'package:evnmobile/src/qltnkd/map/model/user_location.dart';
import 'package:g_json/g_json.dart';

class DataReportLocation {
  DataReportLocation({
    this.substation,
    this.users,
  });

  DataReportLocation.fromJson(JSON json) {
    substation = json['substation'] != null
        ? ReportSubstationLocation.fromJson(json['substation'])
        : null;
    users = json['users']?.list?.map((e) => ReportUserLocation.fromJson(JSON(e)))?.toList();
  }

  ReportSubstationLocation substation;
  List<ReportUserLocation> users;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (substation != null) {
      map['substation'] = substation.toJson();
    }
    if (users != null) {
      map['users'] = users?.map((e) => e.toJson());
    }
    return map;
  }
}

