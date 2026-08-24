// @dart=2.9
import 'package:g_json/g_json.dart';

import '../base_popup_model.dart';
import '../day_night/popups/abnormal_model.dart';
import '../day_night/popups/images_model.dart';


class ContentNightTimeModel extends BaseHighElectricPopupModel {
  String id;
  int checkNight;
  String checkNightAbnormal;
  int checkSplice; //1.1 Sự phát hiện mối nối
  String checkSpliceAbnormal;
  int checkDischarges; //1.2 Kiểm tra hiện tượng phóng điện
  String checkDischargesAbnormal;
  int other; //1.3 Các hiện tượng bất thường khác
  String otherAbnormal;
  int checkLight; //1.4 Kiểm tra ánh sáng cột vượt
  String checkLightAbnormal;

  ContentNightTimeModel(
      {this.id,
        this.checkNight,
      this.checkNightAbnormal,
      this.checkSplice,
      this.checkSpliceAbnormal,
      this.checkDischarges,
      this.checkDischargesAbnormal,
      this.other,
      this.otherAbnormal,
      this.checkLight,
      this.checkLightAbnormal})
      : super(images: [], abnormals: []);

  ContentNightTimeModel.fromJson(JSON json) {
    id = json['id'].string;
    checkNight = json['checkNight'].integer;
    checkNightAbnormal = json['checkNightAbnormal'].string;
    checkSplice = json['checkSplice'].integer;
    checkSpliceAbnormal = json['checkSpliceAbnormal'].string;
    checkDischarges = json['checkDischarges'].integer;
    checkDischargesAbnormal = json['checkDischargesAbnormal'].string;
    other = json['other'].integer;
    otherAbnormal = json['otherAbnormal'].string;
    checkLight = json['checkLight'].integer;
    checkLightAbnormal = json['checkLightAbnormal'].string;
    if (json['images'] != null) {
      images = json['images']
          ?.listObject
          ?.map((e) => Images.fromJsonNotMap(JSON(e)))
          ?.toList();
    }
    if (json['abnormals'] != null) {
      abnormals = json['abnormals']
          ?.listObject
          ?.map((e) => Abnormals.fromJsonNotMap(JSON(e)))
          ?.toList();
    }
    else
    {
      abnormals=[];
    }
  }

  Map<String, dynamic> toJson() {
    final data =  <String, dynamic>{};
    data['id'] = id;
    data['checkNight'] = checkNight;
    data['checkNightAbnormal'] = checkNightAbnormal;
    data['checkSplice'] = checkSplice;
    data['checkSpliceAbnormal'] = checkSpliceAbnormal;
    data['checkDischarges'] = checkDischarges;
    data['checkDischargesAbnormal'] = checkDischargesAbnormal;
    data['other'] = other;
    data['otherAbnormal'] = otherAbnormal;
    data['checkLight'] = checkLight;
    data['checkLightAbnormal'] = checkLightAbnormal;
    if (images != null) {
      data['images'] = images.map((v) => v.toJson()).toList();
    }
    if (abnormals != null) {
      data['abnormals'] = abnormals.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  bool validateData() {
    return checkNight != null &&
        checkSplice != null &&
        checkDischarges != null &&
        other != null &&
        checkLight != null;
  }
}

