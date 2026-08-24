// @dart=2.9
import 'package:g_json/g_json.dart';

/// imageStorageId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// url : "string"
/// problems : 0

class TImages {
  String imageStorageId;
  String url;
  String path;
  String name;
  int problems;

  TImages({this.imageStorageId, this.url, this.path,this.name,  this.problems});

  TImages.fromJson(JSON json) {
    imageStorageId = json['imageStorageId'].string;
    url = json['url'].string;
    path = json['path'].string;
    name = json['name'].string;
    problems = json['problems'].integer;
  }

  Map<String, dynamic> toJsonWithoutURL() {
    final map = <String, dynamic>{};
    map['imageStorageId'] = imageStorageId;
    map['problems'] = problems;
    return map;
  }

  TImages.fromJsonNotMap(JSON json) {
    imageStorageId = json['imageStorageId'].string;
    url = json['url'].string;
    path = json['path'].string;
    name = json['name'].string;
    problems = json['problems'].integer??0;
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
