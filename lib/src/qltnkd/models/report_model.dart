// @dart=2.9
import 'package:g_json/g_json.dart';

import 'field_model.dart';

class ReportModel {
  ReportModel({this.name, this.id, this.fieldsModel, this.reportType});

  ReportModel.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
    reportType = json['reportType'].integer;
    fieldsModel = (json['fieldModels'].listObject ?? json['fieldsModel'].listObject)
        ?.map((e) => FieldModel.fromJSON(JSON(e)))
        ?.toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['reportType'] = reportType;
    if (fieldsModel != null) {
      map['fieldModels'] = fieldsModel?.map((v) => v?.toJson())?.toList();
    }
    return map;
  }

  String id;
  String name;
  int reportType;
  List<FieldModel> fieldsModel;
}

class ReportModelResponse {
  ReportModelResponse({this.reportId, this.status, this.reportModel, this.isSync, this.formId, this.scheduleId});

  ReportModelResponse.fromJson(JSON json) {
    reportId = json['id'].string;
    scheduleId = json['scheduleId'].string;
    formId = json['formId'].string;
    status = json['status'].integer;
    isSync = json['isSync']?.boolean;
    isPmis = json['isPmis']?.boolean ?? false;
    isCbm = json['isCbm']?.boolean ?? false;
    final modelJson = json['formModel'].value != null 
        ? json['formModel'] 
        : (json['reportModel'].value != null ? json['reportModel'] : json);
    reportModel = ReportModel.fromJson(modelJson);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = reportId;
    map['status'] = status;
    map['scheduleId'] = scheduleId;
    map['formId'] = formId;
    map['isSync'] = isSync;
    map['isPmis'] = isPmis;
    map['isCbm'] = isCbm;
    map['formModel'] = reportModel.toJson();

    return map;
  }

  String reportId;
  String scheduleId;
  String formId;
  int status;
  ReportModel reportModel;
  bool isSync;
  bool isPmis;
  bool isCbm;
}

