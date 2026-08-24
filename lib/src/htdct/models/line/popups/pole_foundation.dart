// @dart=2.9
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';

import '../../../common/constance/content_option.dart';
import '../../day_night/popups/abnormal_model.dart';
import '../../day_night/popups/images_model.dart';

class PoleFoundationModel extends BaseHighElectricPopupModel {
  PoleFoundationModel({
    this.drownStatus,
    this.drownStatusAbnormal,
    this.roadStatus,
    this.roadStatusAbnormal,
    this.lineFoudationAbnormal,
  }) : super(images: [], abnormals: []);

  int drownStatus;
  String drownStatusAbnormal;
  int roadStatus;
  String roadStatusAbnormal;
  int lineFoudationAbnormal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['drownStatus'] = drownStatus;
    map['drownStatusAbnormal'] = drownStatusAbnormal;
    map['roadStatus'] = roadStatus;
    map['roadStatusAbnormal'] = roadStatusAbnormal;
    map['lineFoudationAbnormal'] = lineFoudationAbnormal;
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
    return ![drownStatus, roadStatus, lineFoudationAbnormal]
        .contains(null);
  }

  @override
  void fromJson(Map json) {
    if(json == null) return;
    drownStatus = json['drownStatus'];
    drownStatusAbnormal = json['drownStatusAbnormal'];
    roadStatus = json['roadStatus'];
    roadStatusAbnormal = json['roadStatusAbnormal'];
    lineFoudationAbnormal = json['lineFoudationAbnormal'];
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

