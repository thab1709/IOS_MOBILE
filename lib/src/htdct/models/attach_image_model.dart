// @dart=2.9
import 'package:g_json/g_json.dart';

/// imageStorageId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// url : "string"
/// problems : 0

class Images {
  String imageStorageId;
  String url;
  String path;
  int problems;

  Images({this.imageStorageId, this.url, this.path, this.problems});

  Images.fromJson(JSON json) {
    imageStorageId = json['imageStorageId'].string;
    url = json['url'].string;
    path = json['path'].string;
    problems = json['problems'].integer;
  }

  Map<String, dynamic> toJsonWithoutURL() {
    final map = <String, dynamic>{};
    map['imageStorageId'] = imageStorageId;
    map['problems'] = problems;
    return map;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imageStorageId'] = imageStorageId;
    map['url'] = url;
    map['path'] = path;
    map['problems'] = problems;
    return map;
  }

  bool isNotSync(){
    return path != null;
  }
}
