// @dart=2.9
import 'package:evnmobile/src/htdct/models/day_night/popups/images_model.dart';
import 'package:g_json/g_json.dart';

class AbnormalDetailModel {
  String id;
  String violateId;
  String violate;
  String statusViolate;
  String category;
  String name;
  String description;
  String status;
  String date;
  String content;
  String user;
  List<Images> images;
  String userId;
  int statusId;
  int trackingStatus;

  AbnormalDetailModel(
      {this.id,
        this.category,
        this.name,
        this.description,
        this.status,
        this.date,
        this.content,
        this.user,
        this.images,
        this.userId,
        this.statusId,
        this.trackingStatus,
      });

  AbnormalDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    violateId = json['violateId'];
    category = json['category'];
    name = json['name'];
    description = json['description'];
    statusViolate = json['statusViolate'];
    status = json['status'];
    date = json['date'];
    content = json['content'];
    violate = json['violate'];
    user = json['user'];
    trackingStatus = json['trackingStatus'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images.add(Images.fromJsonNotMap(JSON(v)));
      });
    } else {
      images = [];
    }
    userId = json['userId'];
    statusId = json['statusId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['category'] = category;
    data['trackingStatus'] = trackingStatus;
    data['name'] = name;
    data['description'] = description;
    data['violate'] = violate;
    data['status'] = status;
    data['date'] = date;
    data['content'] = content;
    data['statusViolate'] = statusViolate;
    data['user'] = user;
    if (images != null) {
      data['images'] = images.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

