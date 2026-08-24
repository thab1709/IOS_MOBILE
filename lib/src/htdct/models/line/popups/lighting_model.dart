// @dart=2.9
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';

import '../../../common/constance/content_option.dart';
import '../../day_night/popups/abnormal_model.dart';
import '../../day_night/popups/images_model.dart';

class LightingModel extends BaseHighElectricPopupModel {
  LightingModel({
      this.lineStatus, 
      this.lineStatusAbnormal, 
      this.lineGroundingStatus, 
      this.lineGroundingStatusAbnormal, 
      this.lineLightingAbnormal,}): super(images: [], abnormals: []);

  int lineStatus;
  String lineStatusAbnormal;
  int lineGroundingStatus;
  String lineGroundingStatusAbnormal;
  int lineLightingAbnormal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lineStatus'] = lineStatus;
    map['lineStatusAbnormal'] = lineStatusAbnormal;
    map['lineGroundingStatus'] = lineGroundingStatus;
    map['lineGroundingStatusAbnormal'] = lineGroundingStatusAbnormal;
    map['lineLightingAbnormal'] = lineLightingAbnormal;
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
    return true;
  }

  @override
  void fromJson(Map json) {
    if(json == null) return;
    lineStatus = json['lineStatus'];
    lineStatusAbnormal = json['lineStatusAbnormal'];
    lineGroundingStatus = json['lineGroundingStatus'];
    lineGroundingStatusAbnormal = json['lineGroundingStatusAbnormal'];
    lineLightingAbnormal = json['lineLightingAbnormal'];
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
