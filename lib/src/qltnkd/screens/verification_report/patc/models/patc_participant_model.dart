// @dart=2.9
import 'package:g_json/g_json.dart';

class PatcParticipantModel {
  String id;
  String constructionPlanId;
  int groupType;
  int sortOrder;
  String unitId;
  String unitName;
  String userId;
  String fullName;
  String position;
  bool isSigned;
  DateTime signedDate;
  int companyOrder;
  bool hasHsmCert;
  bool isCompanySigner;
  bool isHsmSign;
  int signOrder;
  int signType;
  bool isExternal;
  String signatureImagePath;
  String signatureCapturedByName;

  PatcParticipantModel({
    this.id,
    this.constructionPlanId,
    this.groupType,
    this.sortOrder,
    this.unitId,
    this.unitName,
    this.userId,
    this.fullName,
    this.position,
    this.isSigned,
    this.signedDate,
    this.companyOrder,
    this.hasHsmCert,
    this.isCompanySigner,
    this.isHsmSign,
    this.signOrder,
    this.signType,
    this.isExternal,
    this.signatureImagePath,
    this.signatureCapturedByName,
  });

  static PatcParticipantModel fromJson(JSON json) {
    if (json == null) return null;
    
    final fullName = json['fullName'].string ?? json['userName'].string ?? 'Unknown';
    final rawIsExternal = json['isExternal'].value;
    print('==== PARSING PARTICIPANT: $fullName ====');
    print('Raw isExternal from API: $rawIsExternal (Type: ${rawIsExternal.runtimeType})');
    
    return PatcParticipantModel(
      id: json['id'].string,
      constructionPlanId: json['constructionPlanId'].string,
      groupType: json['groupType'].integer,
      sortOrder: json['sortOrder'].integer,
      unitId: json['unitId'].string,
      unitName: json['unitName'].string,
      userId: json['userId'].string,
      fullName: fullName,
      position: json['position'].string ?? json['userPositionName'].string,
      isSigned: json['isSigned'].boolean ?? false,
      signedDate: DateTime.tryParse(json['signedDate'].stringValue ?? ''),
      companyOrder: json['companyOrder'].integer,
      hasHsmCert: json['hasHsmCert'].boolean ?? false,
      isCompanySigner: json['isCompanySigner'].boolean ?? false,
      isHsmSign: json['isHsmSign'].boolean ?? false,
      signOrder: json['signOrder'].integer,
      signType: json['signType'].integer ?? 1,
      isExternal: json['isExternal'].boolean ?? false,
      signatureImagePath: json['signatureImagePath'].string,
      signatureCapturedByName: json['signatureCapturedByName'].string,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'constructionPlanId': constructionPlanId,
      'groupType': groupType,
      'sortOrder': sortOrder,
      'unitId': unitId,
      'unitName': unitName,
      'userId': userId,
      'fullName': fullName,
      'position': position,
      'isSigned': isSigned,
      'signedDate': signedDate?.toIso8601String(),
      'companyOrder': companyOrder,
      'hasHsmCert': hasHsmCert,
      'isCompanySigner': isCompanySigner,
      'isHsmSign': isHsmSign,
      'signOrder': signOrder,
      'signType': signType,
    };
  }
}
