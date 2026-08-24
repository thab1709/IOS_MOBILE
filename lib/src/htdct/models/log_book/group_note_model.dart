// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:g_json/g_json.dart';

class GroupCheckNoteModel {
  int userCheckCount;
  int userCheckedCount;

  String id;
  String dateCheck; //Ngày kiểm tra
  int teamCheck; //Đoàn kiểm tra
  String nameTeamCheck; //Đoàn kiểm tra khác
  String contentCheck; //Nội dung kiểm tra
  String componentTeamCheck; //Thành phần đoàn kiểm tra
  String userCheck1; //Người dùng đoàn kiểm ra
  String roleUserCheck1;
  String userCheck2;
  String roleUserCheck2;
  String userCheck3;
  String roleUserCheck3;
  String userCheck4;
  String roleUserCheck4;
  String userCheck5;
  String roleUserCheck5;
  String userCheck6;
  String roleUserCheck6;
  String userCheck7;
  String roleUserCheck7;
  String userCheck8;
  String roleUserCheck8;
  String userCheck9;
  String roleUserCheck9;
  String userCheck10;
  String roleUserCheck10;
  String commponentTeamChecked; //Thành phần team được kiểm tra
  String user1;
  String roleUser1;
  String user2;
  String roleUser2;
  String user3;
  String roleUser3;
  String user4;
  String roleUser4;
  String user5;
  String roleUser5;
  String user6;
  String roleUser6;
  String user7;
  String roleUser7;
  String user8;
  String roleUser8;
  String user9;
  String roleUser9;
  String user10;
  String roleUser10;
  String commentTeamCheck; //Nhận xét đoàn kiểm tra
  String userLeadChecked;
  String userLeadCheck;
  String assetManage; // Đơn vị quản lý tài sản
  String userGroupCodeId; // Mã đội
  String userGroupId;
  String substationCodeId; // Mã tổ
  String substationId; // Tổ

  GroupCheckNoteModel(
      {this.id,
      this.dateCheck,
      this.teamCheck,
      this.nameTeamCheck,
      this.contentCheck,
      this.componentTeamCheck,
      this.userCheck1,
      this.roleUserCheck1,
      this.userCheck2,
      this.roleUserCheck2,
      this.userCheck3,
      this.roleUserCheck3,
      this.userCheck4,
      this.roleUserCheck4,
      this.userCheck5,
      this.roleUserCheck5,
      this.userCheck6,
      this.roleUserCheck6,
      this.userCheck7,
      this.roleUserCheck7,
      this.userCheck8,
      this.roleUserCheck8,
      this.userCheck9,
      this.roleUserCheck9,
      this.userCheck10,
      this.roleUserCheck10,
      this.commponentTeamChecked,
      this.user1,
      this.roleUser1,
      this.user2,
      this.roleUser2,
      this.user3,
      this.roleUser3,
      this.user4,
      this.roleUser4,
      this.user5,
      this.roleUser5,
      this.user6,
      this.roleUser6,
      this.user7,
      this.roleUser7,
      this.user8,
      this.roleUser8,
      this.user9,
      this.roleUser9,
      this.user10,
      this.roleUser10,
      this.commentTeamCheck,
      this.userLeadChecked,
      this.userLeadCheck,
      this.assetManage,
      this.userGroupCodeId,
      this.userGroupId,
      this.substationCodeId,
      this.substationId,
      this.userCheckCount = 0,
      this.userCheckedCount = 0});

  GroupCheckNoteModel.fromJson(JSON json) {
    userCheckedCount = 0;
    userCheckCount = 0;
    for (var i = 1; i <= 10; i++) {
      if (json['userCheck$i'].string != null) {
        userCheckCount++;
      }
      if (json['user$i'].string != null) {
        userCheckedCount++;
      }
    }
    id = json['id'].string;
    dateCheck = json['dateCheck'].string;
    teamCheck = json['teamCheck'].integer;
    nameTeamCheck = json['nameTeamCheck'].string;
    contentCheck = json['contentCheck'].string;
    componentTeamCheck = json['componentTeamCheck'].string;
    userCheck1 = json['userCheck1'].string;
    roleUserCheck1 = json['roleUserCheck1'].string;
    userCheck2 = json['userCheck2'].string;
    roleUserCheck2 = json['roleUserCheck2'].string;
    userCheck3 = json['userCheck3'].string;
    roleUserCheck3 = json['roleUserCheck3'].string;
    userCheck4 = json['userCheck4'].string;
    roleUserCheck4 = json['roleUserCheck4'].string;
    userCheck5 = json['userCheck5'].string;
    roleUserCheck5 = json['roleUserCheck5'].string;
    userCheck6 = json['userCheck6'].string;
    roleUserCheck6 = json['roleUserCheck6'].string;
    userCheck7 = json['userCheck7'].string;
    roleUserCheck7 = json['roleUserCheck7'].string;
    userCheck8 = json['userCheck8'].string;
    roleUserCheck8 = json['roleUserCheck8'].string;
    userCheck9 = json['userCheck9'].string;
    roleUserCheck9 = json['roleUserCheck9'].string;
    userCheck10 = json['userCheck10'].string;
    roleUserCheck10 = json['roleUserCheck10'].string;
    commponentTeamChecked = json['commponentTeamChecked'].string;
    user1 = json['user1'].string;
    roleUser1 = json['roleUser1'].string;
    user2 = json['user2'].string;
    roleUser2 = json['roleUser2'].string;
    user3 = json['user3'].string;
    roleUser3 = json['roleUser3'].string;
    user4 = json['user4'].string;
    roleUser4 = json['roleUser4'].string;
    user5 = json['user5'].string;
    roleUser5 = json['roleUser5'].string;
    user6 = json['user6'].string;
    roleUser6 = json['roleUser6'].string;
    user7 = json['user7'].string;
    roleUser7 = json['roleUser7'].string;
    user8 = json['user8'].string;
    roleUser8 = json['roleUser8'].string;
    user9 = json['user9'].string;
    roleUser9 = json['roleUser9'].string;
    user10 = json['user10'].string;
    roleUser10 = json['roleUser10'].string;
    commentTeamCheck = json['commentTeamCheck'].string;
    userLeadChecked = json['userLeadChecked'].string;
    userLeadCheck = json['userLeadCheck'].string;
    assetManage = json['assetManage'].string;
    userGroupCodeId = json['userGroupCodeId'].string;
    userGroupId = json['userGroupId'].string;
    substationCodeId = json['substationCodeId'].string;
    substationId = json['substationId'].string;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['dateCheck'] = dateCheck;
    data['teamCheck'] = teamCheck;
    data['nameTeamCheck'] = nameTeamCheck;
    data['contentCheck'] = contentCheck;
    data['componentTeamCheck'] = componentTeamCheck;
    data['userCheck1'] = userCheck1;
    data['roleUserCheck1'] = roleUserCheck1;
    data['userCheck2'] = userCheck2;
    data['roleUserCheck2'] = roleUserCheck2;
    data['userCheck3'] = userCheck3;
    data['roleUserCheck3'] = roleUserCheck3;
    data['userCheck4'] = userCheck4;
    data['roleUserCheck4'] = roleUserCheck4;
    data['userCheck5'] = userCheck5;
    data['roleUserCheck5'] = roleUserCheck5;
    data['userCheck6'] = userCheck6;
    data['roleUserCheck6'] = roleUserCheck6;
    data['userCheck7'] = userCheck7;
    data['roleUserCheck7'] = roleUserCheck7;
    data['userCheck8'] = userCheck8;
    data['roleUserCheck8'] = roleUserCheck8;
    data['userCheck9'] = userCheck9;
    data['roleUserCheck9'] = roleUserCheck9;
    data['userCheck10'] = userCheck10;
    data['roleUserCheck10'] = roleUserCheck10;
    data['commponentTeamChecked'] = commponentTeamChecked;
    data['user1'] = user1;
    data['roleUser1'] = roleUser1;
    data['user2'] = user2;
    data['roleUser2'] = roleUser2;
    data['user3'] = user3;
    data['roleUser3'] = roleUser3;
    data['user4'] = user4;
    data['roleUser4'] = roleUser4;
    data['user5'] = user5;
    data['roleUser5'] = roleUser5;
    data['user6'] = user6;
    data['roleUser6'] = roleUser6;
    data['user7'] = user7;
    data['roleUser7'] = roleUser7;
    data['user8'] = user8;
    data['roleUser8'] = roleUser8;
    data['user9'] = user9;
    data['roleUser9'] = roleUser9;
    data['user10'] = user10;
    data['roleUser10'] = roleUser10;
    data['commentTeamCheck'] = commentTeamCheck;
    data['userLeadChecked'] = userLeadChecked;
    data['userLeadCheck'] = userLeadCheck;
    data['assetManage'] = assetManage;
    data['userGroupCodeId'] = userGroupCodeId;
    data['userGroupId'] = userGroupId;
    data['substationCodeId'] = substationCodeId;
    data['substationId'] = substationId;
    return data;
  }

  bool checkValid() {
    if (substationId == null || userGroupId == null) {
      return false;
    }
    return true;
  }

  String get dateCheckLocalTZ =>
      dateCheck?.fromFormatUtcToFormatLocal(HighElectricStrings.utcFormat);
}

