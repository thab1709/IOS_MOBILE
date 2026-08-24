// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/models/base_popup_model.dart';

import '../abnormal_model.dart';
import '../images_model.dart';

class CapacitorNightModel extends BaseHighElectricPopupModel {
  CapacitorNightModel() : super(images: [], abnormals: []);

  int checkBonded;
  int soundCondenser;
  String soundCondenserAbnormal;
  int checkAbnormalDischarges;
  String checkAbnormalDischargesAbnormal;

  CapacitorNightModel.fromJson(json) {
    if (json == null) return;
    checkBonded = json['checkBonded'];
    soundCondenser = json['soundCondenser'];
    soundCondenserAbnormal = json['soundCondenserAbnormal'];
    checkAbnormalDischarges = json['checkAbnormalDischarges'];
    checkAbnormalDischargesAbnormal = json['checkAbnormalDischargesAbnormal'];

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
    } else {
      abnormals = [];
    }
  }

  Map toJson() {
    final maps = <String, dynamic>{};
    maps['checkBonded'] = checkBonded;
    maps['soundCondenser'] = soundCondenser;
    maps['soundCondenserAbnormal'] = soundCondenserAbnormal;
    maps['checkAbnormalDischarges'] = checkAbnormalDischarges;
    maps['checkAbnormalDischargesAbnormal'] = checkAbnormalDischargesAbnormal;

    maps['description'] = getDescription();
    if (images != null) {
      maps['images'] = images.map((v) => v.toJson()).toList();
    }
    if (abnormals != null) {
      maps['abnormals'] = abnormals.map((v) => v.toJson()).toList();
    }
    return maps;
  }

  @override
  bool validateData() {
    return ![
      checkBonded,
      soundCondenser,
      checkAbnormalDischarges,
    ].contains(null);
  }

  @override
  void autoGenAbnormalType() {
    abnormals?.forEach((abnormal) {
      switch (abnormal.categoryIndex) {
        case ImageProblems.muc1_1:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
        case ImageProblems.muc1_2:
          abnormal.abnormalType = ContentOptions.first.value;
          break;
      }
    });
  }
}

