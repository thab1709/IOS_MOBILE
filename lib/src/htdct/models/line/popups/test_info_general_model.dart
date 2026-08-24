// @dart=2.9
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';

import '../../../common/constance/content_option.dart';
import '../../day_night/popups/abnormal_model.dart';
import '../../day_night/popups/images_model.dart';

class TestInfoGeneralModel extends BaseHighElectricPopupModel {
  TestInfoGeneralModel({
      this.generalInformation, 
      this.generalInformationAbnormalDescription, 
      this.generalTestInformationAbnormal,}) : super(images: [], abnormals: []);

  TestInfoGeneralModel.fromJson(json) {
    generalInformation = json['generalInforAbnormal'];
    generalInformationAbnormalDescription = json['generalInformationAbnormalDescription'];
    generalTestInformationAbnormal = json['generalTestInformationAbnormal'];
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
  int generalInformation;
  String generalInformationAbnormalDescription;
  int generalTestInformationAbnormal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['generalInforAbnormal'] = generalInformation;
    map['generalInformationAbnormalDescription'] = generalInformationAbnormalDescription;
    map['generalTestInformationAbnormal'] = generalTestInformationAbnormal;
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
    return ![generalInformation, generalTestInformationAbnormal].contains(null);
  }
}
