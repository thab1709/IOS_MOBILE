// @dart=2.9
import 'package:g_json/g_json.dart';
import 'line_branch_info.dart';

class LineGeneral {
  String id;
  String code;
  String ownedId;
  String owned;
  int inspectionType;
  String inspectionTypeName;
  int expireRemainingTime;
  int predicType;
  String weather;
  String temperature;
  String weather2;
  String temperature2;
  String predicTypeName;
  String inspectTime;
  String lastInspection;
  bool isGroupOne;
  bool isAll;
  bool isSingleBranch;
  bool isUpdateOffline;
  String inspectionRequest;
  int structure;
  String structureName;
  String outstandingIssues;
  String lineName;
  String lineId;
  bool isNight;
  List<LineBranchInfo> listLineBranchInfo;

  LineGeneral({
    this.id,
    this.code,
    this.ownedId,
    this.owned,
    this.inspectionType,
    this.inspectionTypeName,
    this.predicType,
    this.predicTypeName,
    this.inspectTime,
    this.lastInspection,
    this.inspectionRequest,
    this.structure,
    this.expireRemainingTime,
    this.structureName,
    this.outstandingIssues,
    this.listLineBranchInfo,
    this.lineName,
    this.lineId,
    this.isAll = false,
    this.isNight = false,
    this.isSingleBranch,
  });

  LineGeneral.fromJson(JSON json) {
    final data = json['data'] ?? json;
    isGroupOne = data['isGroup1']?.boolean;
    weather = data['weather']?.string;
    temperature = data['temperature']?.string;
    weather2 = data['weather2']?.string;
    temperature2 = data['temperature2']?.string;
    id = data['id']?.string;
    isUpdateOffline = data['isUpdateOffline']?.boolean ?? false;
    code = data['code']?.string;
    ownedId = data['ownedId']?.string;
    owned = data['owned']?.string;
    inspectionType = data['inspectionType']?.integer;
    inspectionTypeName = data['inspectionTypeName']?.string;
    predicType = data['predicType']?.integer;
    predicTypeName = data['predicTypeName']?.string;
    inspectTime = data['inspectTime']?.string;
    lastInspection = data['lastInspection']?.string;
    inspectionRequest = data['inspectionRequest']?.string;
    structure = data['structure']?.integer ?? 0;
    structureName = data['structureName']?.string;
    outstandingIssues = data['outstandingIssues']?.string;
    lineName = data['lineName']?.string;
    lineId = data['lineId']?.string;
    isAll = data['isAll']?.boolean ?? false;
    isNight = data['night']?.boolean ?? false;
    isSingleBranch = data['isSingleBranch']?.boolean;

    expireRemainingTime = data['expireRemainingTime']?.integer;
    if (data['lineBranchInfos']?.list != null) {
      final list = JSON(data['lineBranchInfos']);
      listLineBranchInfo = list.listObject
          ?.map((e) => LineBranchInfo.fromJson(JSON(e)))
          ?.toList();
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['code'] = code;
    map['ownedId'] = ownedId;
    map['owned'] = owned;
    map['weather'] = weather;
    map['temperature'] = temperature;
    map['weather2'] = weather2;
    map['temperature2'] = temperature2;
    map['inspectionType'] = inspectionType;
    map['inspectionTypeName'] = inspectionTypeName;
    map['predicType'] = predicType;
    map['predicTypeName'] = predicTypeName;
    map['inspectTime'] = inspectTime;
    map['lastInspection'] = lastInspection;
    map['inspectionRequest'] = inspectionRequest;
    map['structure'] = structure ?? 0;
    map['structureName'] = structureName;
    map['outstandingIssues'] = outstandingIssues;
    map['expireRemainingTime'] = expireRemainingTime;
    map['lineName'] = lineName;
    map['isSingleBranch'] = isSingleBranch;
    map['isUpdateOffline'] = isUpdateOffline ?? false;
    map['isAll'] = isAll ?? false;
    map['night'] = isNight ?? false;
    if (listLineBranchInfo != null) {
      map['problemPositions'] =
          listLineBranchInfo.map((v) => v.toJson()).toList();
    }

    if (listLineBranchInfo != null) {
      map['lineBranchInfos'] =
          listLineBranchInfo.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

