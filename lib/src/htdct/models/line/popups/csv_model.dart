// @dart=2.9

import '../../../common/constance/content_option.dart';
import '../../base_popup_model.dart';
import '../../day_night/popups/abnormal_model.dart';
import '../../day_night/popups/images_model.dart';

class CsvModel extends BaseHighElectricPopupModel {
  CsvModel({
    this.groundingStatus,
    this.groundingStatusAbnormal,
    this.pointStatus,
    this.pointStatusAbNormal,
    this.csStatus,
    this.csStatusAbnormal,
    this.lineCSVAbnormal,
  }) : super(images: [], abnormals: []);

  int groundingStatus;
  String groundingStatusAbnormal;
  int csStatus;
  String csStatusAbnormal;
  int pointStatus;
  String pointStatusAbNormal;
  int lineCSVAbnormal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['groundingStatus'] = groundingStatus;
    map['groundingStatusAbnormal'] = groundingStatusAbnormal;
    map['pointStatus'] = pointStatus;
    map['pointStatusAbNormal'] = pointStatusAbNormal;
    map['csStatus'] = csStatus;
    map['csStatusAbnormal'] = csStatusAbnormal;
    map['lineCSVAbnormal'] = lineCSVAbnormal;
    map['description'] = getDescription();
    if (images != null) {
      map['images'] = images.map((v) => v.toJson()).toList();
    }
    if (abnormals != null) {
      map['abnormals'] = abnormals.map((v) => v.toJson()).toList();
    }
    return map;
  }

  @override
  bool validateData() {
    return ![groundingStatus, pointStatus, csStatus, lineCSVAbnormal].contains(null);
  }

  @override
  void fromJson(Map json) {
    if(json == null) return;
    groundingStatus = json['groundingStatus'];
    groundingStatusAbnormal = json['groundingStatusAbnormal'];
    pointStatus = json['pointStatus'];
    pointStatusAbNormal = json['pointStatusAbNormal'];
    csStatus = json['csStatus'];
    csStatusAbnormal = json['csStatusAbnormal'];
    lineCSVAbnormal = json['lineCSVAbnormal'];
    description = json['description'];
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images.add(Images.fromJson(v));
      });
    }
    if (json['abnormals'] != null) {
      abnormals = <Abnormals>[];
      json['abnormals'].forEach((v) {
        abnormals.add(Abnormals.fromJson(v));
      });
    }
    else
    {
      abnormals=[];
    }
  }

  @override
  void autoGenAbnormalType() {
    abnormals?.forEach((abnormal) {
      abnormal.abnormalType = ContentOptions.lineType.value;
    });
  }
}

