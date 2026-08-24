// @dart=2.9
import 'package:g_json/g_json.dart';

class LocationOffline {
  String workId;
  String lat;
  String long;

  LocationOffline({this.workId, this.lat, this.long});

  LocationOffline.fromJson(JSON json) {
    workId = json['reportId'].string;
    lat = json['lat'].string;
    long = json['long'].string;
  }

  Map<String, dynamic> toJson() {
    final maps = <String, dynamic>{};

    maps['reportId'] = workId;
    maps['lat'] = lat;
    maps['long'] = long;
    return maps;
  }
}

