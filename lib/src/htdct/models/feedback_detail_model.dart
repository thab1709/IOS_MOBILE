// @dart=2.9
class FeedbackDetailModel {
  String id;
  List<Recipients> recipients;
  Recipients sender;
  String description;
  String date;

  FeedbackDetailModel(
      {this.id, this.recipients, this.sender, this.description, this.date});

  FeedbackDetailModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    if (json['recipients'] != null) {
      recipients = <Recipients>[];
      json['recipients'].forEach((v) {
        recipients.add(Recipients.fromJson(v));
      });
    }
    if(json['sender']!=null)
    {
      sender = Recipients.fromJson(json['sender']);
    }
    description = json['description'];
    date = json['date'];
  }

  Map<dynamic, dynamic> toJson() {
    final data = Map<dynamic, dynamic>();
    data['id'] = this.id;
    if (this.recipients != null) {
      data['recipients'] = this.recipients.map((v) => v.toJson()).toList();
    }
    data['sender'] = this.sender;
    data['description'] = this.description;
    data['date'] = this.date;
    return data;
  }
}

class Recipients {
  String name;
  String position;

  Recipients({this.name, this.position});

  Recipients.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    position = json['position'];
  }

  Map<dynamic, dynamic> toJson() {
    final data = <dynamic, dynamic>{};
    data['name'] = this.name;
    data['position'] = this.position;
    return data;
  }
}

