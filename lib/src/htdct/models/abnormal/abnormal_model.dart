// @dart=2.9
import '../day_night/popups/images_model.dart';

class AbnormalModel {
  String id;
  String violateId;
  int status;
  String date;
  String userId;
  String content;
  List<String> images;
  List<Images> imageProblem;

  AbnormalModel(
      {this.id,
      this.violateId,
      this.status,
      this.date,
      this.userId,
      this.content,
      this.images});

  AbnormalModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    violateId = json['violateId'];
    status = json['status'];
    date = json['date'];
    userId = json['userId'];
    content = json['content'];
    images = json['images']?.cast<String>() ?? [];
    imageProblem = [];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['date'] = date;
    data['userId'] = userId;
    data['content'] = content;
    data['images'] = imageProblem?.map((e) => e.imageStorageId)?.toList();
    return data;
  }

  Map<String, dynamic> toJsonViolate() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['violateId'] = violateId;
    data['trackingStatus'] = status;
    data['endViolate'] = date;
    data['userHandleId'] = userId;
    data['content'] = content;
    data['images'] = imageProblem?.map((e) => e.toJson())?.toList();
    return data;
  }
}

