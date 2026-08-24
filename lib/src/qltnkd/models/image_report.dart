// @dart=2.9
import 'package:g_json/g_json.dart';


class ImageReport {

  String imageStorageId;
  String url;
  String path;
  String name;

  ImageReport({this.imageStorageId, this.url, this.path});

  ImageReport.fromJson(JSON json) {
    imageStorageId = json['imageStorageId'].string;
    url = json['url'].string;
    name = json['name'].string;
    path = json['path'].string;
  }

  Map<String, dynamic> toJsonWithoutURL() {
    final map = <String, dynamic>{};
    map['imageStorageId'] = imageStorageId;
    return map;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imageStorageId'] = imageStorageId;
    map['url'] = url;
    map['name'] = name;
    map['path'] = path;
    return map;
  }

  bool isNotSync(){
    return path != null;
  }
}
