// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';

import '../../../common/constance/content_option.dart';
import '../../day_night/popups/abnormal_model.dart';
import '../../day_night/popups/images_model.dart';

class InsulationModel extends BaseHighElectricPopupModel {
  InsulationModel({
      this.statusInsulation, 
      this.statusInsulationAbnormal,
      this.lineInsulationsAbnormal, 
     }) : super(images: [], abnormals: []);

  int statusInsulation;
  String statusInsulationAbnormal;
  int lineInsulationsAbnormal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusInsulation'] = statusInsulation;
    map['statusInsulationAbnormal'] = statusInsulationAbnormal;
    map['lineInsulationsAbnormal'] = lineInsulationsAbnormal;
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
    return ![statusInsulation, lineInsulationsAbnormal].contains(null);
  }

  @override
  void fromJson(Map json) {
    if(json == null) return;
    statusInsulation = json['statusInsulation'];
    statusInsulationAbnormal = json['statusInsulationAbnormal'];
    lineInsulationsAbnormal = json['lineInsulationsAbnormal'];
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
