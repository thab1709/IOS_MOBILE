// @dart=2.9
import 'package:g_json/g_json.dart';

import '../equipment_model.dart';

class LineModel {
  String id;
  String code;
  String name;
  String nameUnsigned;
  String parentId;
  String selectedBranch;
  String owned;
  List<LineModel> lineChilds;
  List<LineModel> parentBranchs;
  List<EquipmentModel> substations;
  List<EquipmentModel> selectedSubstations;
  bool isChecked = false;

  LineModel(
      {this.id,
      this.code,
      this.name,
      this.nameUnsigned,
      this.parentId,
      this.lineChilds,
      this.substations});

  LineModel.fromJson(JSON json) {
    owned = json['owned'].string;
    id = json['id'].string;
    code = json['code'].string;
    name = json['name'].string;
    selectedBranch = json['selectedBranch'].string;
    if (json['nameUnsigned'].string != null) {
      nameUnsigned = json['nameUnsigned'].string;
    }
    if (json['parentId'].string != null) {
      parentId = json['parentId'].string;
    }
    if (json['lineChilds'].list != null) {
      lineChilds = [];
      json['lineChilds'].list.forEach((v) {
        // checked vào line nếu mà đã được chọn
        final model = LineModel.fromJson(v);
        model.isChecked = model.id == selectedBranch;
        lineChilds.add(model);
      });
    }
    if (json['substations'].list != null) {
      substations = [];
      json['substations'].list.forEach((v) {
        substations.add(EquipmentModel.fromJson(v));
      });
    }

    if (json['parentBranches'].list != null) {
      parentBranchs = [];
      json['parentBranches']?.list?.forEach((v) {
        parentBranchs.add(LineModel.fromJson(v));
      });
    }

    if (json['listSubstation'].list != null) {
      selectedSubstations = [];
      json['listSubstation']?.list?.forEach((v) {
        selectedSubstations.add(EquipmentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': id,
      'code': code,
      'name': name,
      'nameUnsigned': nameUnsigned,
      'parentId': parentId,
      'selectedBranch': selectedBranch,
      'owned': owned,
      'lineChilds': lineChilds?.map((e) => e.toMap())?.toList(),
      'parentBranchs': parentBranchs?.map((e) => e.toMap())?.toList(),
      'substations': substations?.map((e) => e.toMap())?.toList(),
      'selectedSubstations':
          selectedSubstations?.map((e) => e.toMap())?.toList(),
      'isChecked': isChecked,
      // ignore: avoid_as
    } as Map<String, dynamic>;
  }
}

