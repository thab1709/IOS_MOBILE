// @dart=2.9

class NotificationRequestModel {
  NotificationRequestModel({
    this.content,
    this.userIds,
    this.userTeamIds,
    this.userGroupIds,
    this.isMonitoring,
  });

  String content;
  List<String> userIds;
  List<String> userTeamIds;
  List<String> userGroupIds;
  bool isMonitoring;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['content'] = content;
    map['userIds'] = userIds;
    map['userTeamIds'] = userTeamIds;
    map['userGroupIds'] = userGroupIds;
    map['isMonitoring'] = isMonitoring;
    return map;
  }
}

