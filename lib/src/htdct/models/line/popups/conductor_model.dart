// @dart=2.9
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';

import '../../../common/constance/content_option.dart';
import '../../day_night/popups/abnormal_model.dart';
import '../../day_night/popups/images_model.dart';

class ConductorModel extends BaseHighElectricPopupModel {
  int lineConductorStatus;
  String lineConductorStatusAbnormal;
  int lockStatus;
  String lockStatusAbnormal;
  int lineConductorAbnormal;

  ConductorModel({
      this.lineConductorStatus,
      this.lineConductorStatusAbnormal,
      this.lineConductorAbnormal,}) : super(images: [], abnormals: []);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lineConductorStatus'] = lineConductorStatus;
    map['lineConductorStatusAbnormal'] = lineConductorStatusAbnormal;
    map['lockStatus'] = lockStatus;
    map['lockStatusAbnormal'] = lockStatusAbnormal;
    map['lineConductorAbnormal'] = lineConductorAbnormal;
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
    return ![lineConductorStatus, lineConductorAbnormal, lockStatus].contains(null);
  }

  @override
  void fromJson(Map json) {
    if(json == null) return;
    lineConductorStatus = json['lineConductorStatus'];
    lineConductorStatusAbnormal = json['lineConductorStatusAbnormal'];
    lockStatus = json['lockStatus'];
    lockStatusAbnormal = json['lockStatusAbnormal'];
    lineConductorAbnormal = json['lineConductorAbnormal'];
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
