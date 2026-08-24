// @dart=2.9
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';

import '../../../common/constance/content_option.dart';
import '../../day_night/popups/abnormal_model.dart';
import '../../day_night/popups/images_model.dart';

class PoleModel extends BaseHighElectricPopupModel {
  int constructionPolesStatus;
  String constructionPolesStatusAbnormal;
  int systemPolesStatus;
  String systemPolesStatusAbnormal;
  int numberPolesStatus;
  String numberPolesStatusAbnormal;
  int lobbyPolesStatus;
  String lobbyPolesStatusAbnormal;
  int linePolesAbnormal;

  PoleModel({
      this.constructionPolesStatus, 
      this.constructionPolesStatusAbnormal, 
      this.systemPolesStatus, 
      this.systemPolesStatusAbnormal, 
      this.numberPolesStatus, 
      this.numberPolesStatusAbnormal, 
      this.lobbyPolesStatus, 
      this.lobbyPolesStatusAbnormal, 
      this.linePolesAbnormal}) : super(images: [], abnormals: []);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['constructionPolesStatus'] = constructionPolesStatus;
    map['constructionPolesStatusAbnormal'] = constructionPolesStatusAbnormal;
    map['systemPolesStatus'] = systemPolesStatus;
    map['systemPolesStatusAbnormal'] = systemPolesStatusAbnormal;
    map['numberPolesStatus'] = numberPolesStatus;
    map['numberPolesStatusAbnormal'] = numberPolesStatusAbnormal;
    map['lobbyPolesStatus'] = lobbyPolesStatus;
    map['lobbyPolesStatusAbnormal'] = lobbyPolesStatusAbnormal;
    map['linePolesAbnormal'] = linePolesAbnormal;
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
    return constructionPolesStatus != null &&
        systemPolesStatus != null &&
        numberPolesStatus != null &&
        lobbyPolesStatus != null &&
        linePolesAbnormal != null;
  }

  @override
  void fromJson(Map json) {
    if(json == null) return;
    constructionPolesStatus = json['constructionPolesStatus'];
    constructionPolesStatusAbnormal = json['constructionPolesStatusAbnormal'];
    systemPolesStatus = json['systemPolesStatus'];
    systemPolesStatusAbnormal = json['systemPolesStatusAbnormal'];
    numberPolesStatus = json['numberPolesStatus'];
    numberPolesStatusAbnormal = json['numberPolesStatusAbnormal'];
    lobbyPolesStatus = json['lobbyPolesStatus'];
    lobbyPolesStatusAbnormal = json['lobbyPolesStatusAbnormal'];
    linePolesAbnormal = json['linePolesAbnormal'];
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
