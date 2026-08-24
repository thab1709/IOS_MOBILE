// @dart=2.9

import 'attach_image_model.dart';

class TAbnormalModel {
  String id;
  int status;
  String date;
  String userId;
  String content;
  List<String> images;
  List<TImages> imageProblem;

  TAbnormalModel(
      {this.id,
      this.status,
      this.date,
      this.userId,
      this.content,
      this.images});

  TAbnormalModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    date = json['dateHandle'];
    userId = json['userHandleId'];
    content = json['contentHandle'];
    images = json['images']?.cast<String>() ?? [];
    imageProblem = List.empty(growable: true);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['dateHandle'] = date;
    data['userHandleId'] = userId;
    data['contentHandle'] = content;
    data['imageStorageIds'] = imageProblem?.map((e) => e.imageStorageId)?.toList();
    return data;
  }
}

