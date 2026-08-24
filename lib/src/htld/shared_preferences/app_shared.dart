// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/models/group_in_unit_model.dart';
import 'package:evnmobile/src/htld/models/unit_model.dart';
import 'package:g_json/g_json.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MAppShared {
  static final shared = MAppShared();
  List<UnitModel> units;
  List<ListUserGroup> groups = <ListUserGroup>[ListUserGroup(unitId: '0', groups: <GroupInUnitModel>[GroupInUnitModel(id: '0',name: 'Tất cả')] )];

  Future<void> saveGroups(List<ListUserGroup> groups) async {
    // AppShared.shared.groups = groups;
    final unitJson = groups.map((e) => e.toMap()).toList();
    final pref = await SharedPreferences.getInstance();
    final string = jsonEncode(unitJson);
    await pref.setString('${AppShared.instance.getUserProfile()?.id ?? ''}_groups', string);
  }

  Future<List<ListUserGroup>> getGroups() async {
    final pref = await SharedPreferences.getInstance();
    final string = pref.getString('${AppShared.instance.getUserProfile()?.id ?? ''}_groups');
    if (string == null) {
      return [];
    }
    final json = JSON(jsonDecode(string));

    return json.list.map((e) => ListUserGroup.fromMap(e.mapObject)).toList();
  }

  Future<void> saveUnits(List<UnitModel> units) async {
    MAppShared.shared.units = units;
    final unitJson = units.map((e) => e.toJson()).toList();
    final pref = await SharedPreferences.getInstance();
    await pref.setString('${AppShared.instance.getUserProfile()?.id ?? ''}_units', jsonEncode(unitJson));
  }

  Future<List<UnitModel>> getUnits() async {
    final pref = await SharedPreferences.getInstance();
    if (AppShared.instance.getUserProfile()?.id?.isEmpty ?? true) {
      return [];
    }
    final string = pref.getString('${AppShared.instance.getUserProfile()?.id ?? ''}_units');
    if (string == null) {
      return [];
    }
    final json = JSON(jsonDecode(string));

    return json.list.map((e) => UnitModel.fromJson(e)).toList();
  }
}

class ListUserGroup {
  String unitId;
  List<GroupInUnitModel> groups;

  ListUserGroup({this.unitId, this.groups});

  ListUserGroup.fromMap(Map<String, dynamic> map) {
    final json = JSON(map);
    unitId = json['unitId'].string;
    groups = json['groups'].list.map((e) => GroupInUnitModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['unitId'] = unitId;
    map['groups'] = groups.map((e) => e.toJson());
    return map;
  }
}

