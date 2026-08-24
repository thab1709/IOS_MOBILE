// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:g_json/g_json.dart';

import '../common/constance/app_icon.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';

class FeedBack {
  FeedBack({
      this.id, 
      this.isRead, 
      this.createdDate, 
      this.isSend, 
      this.description, 
      this.date, 
      this.totalRows,});

  FeedBack.fromJson(JSON json) {
    id = json['id'].string;
    isRead = json['isRead'].boolean;
    createdDate = json['createdDate'].string;
    isSend = json['isSend'].boolean;
    description = json['description'].string;
    date = json['date'].string;
    totalRows = json['totalRows'].integer;
  }
  String id;
  bool isRead;
  String createdDate;
  bool isSend;
  String description;
  String date;
  int totalRows;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['isRead'] = isRead;
    map['createdDate'] = createdDate;
    map['isSend'] = isSend;
    map['description'] = description;
    map['date'] = date;
    map['totalRows'] = totalRows;
    return map;
  }

  String getCreateDate() => createdDate.fromFormatUtcToFormatLocal(HighElectricStrings.ddmmyyyyHHmmss);
  String getIconType () => isSend ? HighElectricAppIcon.feedbackSend : HighElectricAppIcon.feedbackReceive;

}
