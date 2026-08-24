// @dart=2.9
import 'package:evnmobile/src/htld/models/line/selected_branch_model.dart';
import 'package:g_json/g_json.dart';

class LineBranchInfo {
  String id;
  String lineBranchId;
  String lineBranchName;
  String lineChildId;
  String lineChildName;
  String startNode;
  String startNodeId;
  String endNode;
  String endNodeId;
  String outOfLineId;
  String outOfLine;
  bool isSaved;
  int abnormalCount;
  List<SelectedBranchModel> selectedBranchModel;

  LineBranchInfo({
    this.id,
    this.lineBranchId,
    this.lineBranchName,
    this.lineChildId,
    this.lineChildName,
    this.startNode,
    this.startNodeId,
    this.endNode,
    this.outOfLineId,
    this.outOfLine,
    this.selectedBranchModel,
    this.isSaved,
    this.abnormalCount,
  });

  LineBranchInfo.fromJson(JSON json) {
    id = json['id']?.string;
    lineBranchId = json['lineBranchId']?.string;
    lineBranchName = json['lineBranchName']?.string;
    lineChildId = json['lineChildId']?.string;
    lineChildName = json['lineChildName']?.string;
    startNode = json['startNode']?.string;
    startNodeId = json['startNodeId']?.string;
    endNode = json['endNode']?.string;
    endNodeId = json['endNodeId']?.string;
    outOfLineId = json['outOfLineId']?.string;
    outOfLine = json['outOfLine']?.string;
    isSaved = json['isSaved']?.boolean ?? false;
    abnormalCount = json['abnormalCount']?.integer ?? 0;
    if (json['selectedBranch'].list != null) {
          
          
          
      selectedBranchModel = json['selectedBranch']?.list?.map((e) => SelectedBranchModel.fromJson(e))?.toList();
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['lineBranchId'] = lineBranchId;
    map['lineBranchName'] = lineBranchName;
    map['lineChildId'] = lineChildId;
    map['lineChildName'] = lineChildName;
    map['startNode'] = startNode;
    map['startNodeId'] = startNodeId;
    map['endNode'] = endNode;
    map['endNodeId'] = endNodeId;
    map['outOfLineId'] = outOfLineId;
    map['outOfLine'] = outOfLine;
    map['isSaved'] = isSaved;
    map['abnormalCount'] = abnormalCount;
    map['selectedBranch'] = selectedBranchModel.map((e) => e.toJson()).toList();
    return map;
  }
   String getParentsName(){

    return selectedBranchModel?.map((e) => e.name)?.join(' => ') ?? '';
 
 }
}
