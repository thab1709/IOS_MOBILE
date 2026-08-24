// @dart=2.9
import 'package:g_json/g_json.dart';

class ContentCheckModel {
  String id;
  List<Popups> popups;
  String abnormalPhenomenon;
  List<ViolateCounts> violateCounts;
  bool isSuggestAbnormal;

  ContentCheckModel(
      {this.id = '',
      this.popups = const <Popups>[],
      this.abnormalPhenomenon = ''});

  ContentCheckModel.fromJson(JSON json) {
    id = json['id'].stringValue;
    if (json['popups'] != null) {
      popups = <Popups>[];
      json['popups']?.list?.forEach((v) {
        popups.add(Popups.fromJson(v));
      });
    }
    if (json['vioLateCounts'] != null) {
      violateCounts = <ViolateCounts>[];
      json['vioLateCounts']?.list?.forEach((v) {
        violateCounts.add(ViolateCounts.fromJson(v));
      });
    }
    abnormalPhenomenon = json['abnormalPhenomenon'].stringValue;
    isSuggestAbnormal = json['isSuggestAbnormal'].boolean;
  }
}

class Popups {
  String id;
  String categoryName;
  int total;
  int count;
  int inspectionCategory;

  Popups(
      {this.id = '',
      this.categoryName = '',
      this.total = 0,
      this.count = 0,
      this.inspectionCategory = 0});

  Popups.fromJson(JSON json) {
    id = json['id'].stringValue;
    categoryName = json['categoryName'].stringValue == 'TU'
        ? 'Biến điện áp (TU)'
        : json['categoryName'].stringValue == 'TI'
            ? 'Biến dòng điện (TI)'
            : json['categoryName'].stringValue;
    total = json['total'].integer;
    count = json['count'].integer;
    inspectionCategory = json['inspectionCategory'].integer;
    inspectionCategory = json['inspectionCategory'].integer;
  }
}

class ViolateCounts {
  int id;
  int count;
  int typeViolation;
  String vioLateName;

  ViolateCounts({this.id, this.count, this.typeViolation, this.vioLateName});

  ViolateCounts.fromJson(JSON json) {
    id = json['id'].integer;
    count = json['count'].integer;
    typeViolation = json['typeViolation'].integer;
    vioLateName = json['vioLateName'].stringValue;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['count'] = count;
    data['typeViolation'] = typeViolation;
    data['vioLateName'] = vioLateName;
    return data;
  }
}

