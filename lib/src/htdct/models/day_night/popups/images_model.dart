// @dart=2.9
import 'package:g_json/g_json.dart';

class Images {
  String imageStorageId;
  String url;
  String name;
  int problems;

  Images({this.imageStorageId, this.url, this.problems, this.name = 'IMG_20220610_170636_1'});

  Images.fromJson(Map<String, dynamic> json) {
    imageStorageId = json['imageStorageId'];
    url = json['url'];
    name = json['name'];
    problems = json['problems'];
  }

  Images.fromJsonNotMap(JSON json) {
    imageStorageId = json['imageStorageId'].string;
    url = json['url'].string;
    name = json['name'].string;
    problems = json['problems'].integer??0;
  }

  Images.fromJsonGroup(JSON json) {
    imageStorageId = json['imageStorageId'].string;
    url = json['url'].string;
    name = json['name'].string;
    problems = json['problems'].integer;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['imageStorageId'] = imageStorageId;
    data['url'] = url;
    data['name'] = name;
    data['problems'] = problems;
    return data;
  }
}
