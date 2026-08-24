// @dart=2.9
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';

import '../../../common/constance/content_option.dart';
import '../../day_night/popups/abnormal_model.dart';
import '../../day_night/popups/images_model.dart';

class UndergroundCablesLineModel extends BaseHighElectricPopupModel {
  UndergroundCablesLineModel({
    this.headStatus,
    this.headStatusAbnormal,
    this.systemStatus,
    this.systemStatusAbnormal,
    this.constructionStatus,
    this.constructionStatusAbnormal,
    this.lobbyStatus,
    this.lobbyStatusAbnormal,
    this.mustyStatus,
    this.mustyStatusAbnormal,
    this.cablesStatus,
    this.cablesStatusAbnormal,
    this.lineUndergroundCablesAbnormal,
  }) : super(images: [], abnormals: []);

  int headStatus;
  String headStatusAbnormal;
  int systemStatus;
  String systemStatusAbnormal;
  int constructionStatus;
  String constructionStatusAbnormal;
  int lobbyStatus;
  String lobbyStatusAbnormal;
  int mustyStatus;
  String mustyStatusAbnormal;
  int cablesStatus;
  String cablesStatusAbnormal;
  int lineUndergroundCablesAbnormal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['headStatus'] = headStatus;
    map['headStatusAbnormal'] = headStatusAbnormal;
    map['systemStatus'] = systemStatus;
    map['systemStatusAbnormal'] = systemStatusAbnormal;
    map['constructionStatus'] = constructionStatus;
    map['constructionStatusAbnormal'] = constructionStatusAbnormal;
    map['lobbyStatus'] = lobbyStatus;
    map['lobbyStatusAbnormal'] = lobbyStatusAbnormal;
    map['mustyStatus'] = mustyStatus;
    map['mustyStatusAbnormal'] = mustyStatusAbnormal;
    map['cablesStatus'] = cablesStatus;
    map['cablesStatusAbnormal'] = cablesStatusAbnormal;
    map['lineUndergroundCablesAbnormal'] = lineUndergroundCablesAbnormal;
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
    return ![
      systemStatus,
      systemStatusAbnormal,
      lobbyStatus,
      headStatus,
      mustyStatus,
      cablesStatus,
      constructionStatus
    ].contains(null);
  }

  @override
  void fromJson(Map json) {
    if(json == null) return;
    headStatus = json['headStatus'];
    headStatusAbnormal = json['headStatusAbnormal'];
    systemStatus = json['systemStatus'];
    systemStatusAbnormal = json['systemStatusAbnormal'];
    constructionStatus = json['constructionStatus'];
    constructionStatusAbnormal = json['constructionStatusAbnormal'];
    lobbyStatus = json['lobbyStatus'];
    lobbyStatusAbnormal = json['lobbyStatusAbnormal'];
    mustyStatus = json['mustyStatus'];
    mustyStatusAbnormal = json['mustyStatusAbnormal'];
    cablesStatus = json['cablesStatus'];
    cablesStatusAbnormal = json['cablesStatusAbnormal'];
    lineUndergroundCablesAbnormal = json['lineUndergroundCablesAbnormal'];
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
