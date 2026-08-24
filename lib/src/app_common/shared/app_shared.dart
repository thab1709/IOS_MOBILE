// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/htdct/models/profile_model.dart'
    as profile_model_dct;
import 'package:evnmobile/src/htdct/models/team_model.dart';
import 'package:evnmobile/src/htld/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../htdct/models/group_model.dart';
import '../../htdct/models/station.dart';
import '../../htdct/models/unit_model.dart';
import '../../htdct/models/work_current_user_model.dart';

class AppShared {
  factory AppShared() => _instance;
  static final AppShared _instance = AppShared._internal();
  SharedPreferences _prefs;

  AppShared._internal();

  static AppShared get instance => _instance;

  static const _appUserProfile = 'appUserProfile';
  static const _appUserToken = 'appUserToken';
  static const _ssoTicket = 'ssoTicket';
  static const _ssoAppCode = 'ssoAppCode';
  static const _appUserName = 'appUserName';
  static const _appType = 'appType';
  static const _hAutoFill = 'hAutoFill';
  static const _appUserPassword = 'appUserPassword';
  static const _hAutoFillPassword = 'hAutoFillPassword';
  static const _keyLat = 'cached_latitude';
  static const _keyLng = 'cached_longitude';

  Future getShare() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> persistentUserToken(String token) async {
    try {
      await _prefs.setString(_appUserToken, token);
    } catch (_) {
      debugPrint('AppPrefs: $_');
    }
  }

  String getUserToken() {
    try {
      final data = _prefs.getString(_appUserToken);
      if (data == null) {
        return null;
      }
      return data;
    } catch (_) {
      debugPrint('AppPrefs: $_');
      return null;
    }
  }

  Future<void> persistentSSOTicket(String ticket) async {
    try {
      await _prefs.setString(_ssoTicket, ticket);
    } catch (_) {
      debugPrint('AppPrefs: $_');
    }
  }

  String getSSOTicket() {
    try {
      final data = _prefs.getString(_ssoTicket) ?? '';
      if (data == null) {
        return null;
      }
      return data;
    } catch (_) {
      debugPrint('AppPrefs: $_');
      return null;
    }
  }

  Future<void> persistentSSOAppCode(String appCode) async {
    try {
      await _prefs.setString(_ssoAppCode, appCode);
    } catch (_) {
      debugPrint('AppPrefs: $_');
    }
  }

  String getSSOAppCode() {
    try {
      final data = _prefs.getString(_ssoAppCode) ?? '';
      if (data == null) {
        return null;
      }
      return data;
    } catch (_) {
      debugPrint('AppPrefs: $_');
      return null;
    }
  }

  Future<void> persistentHAutoFill({bool isAutoFill}) async {
    try {
      await _prefs.setBool(_hAutoFill, isAutoFill);
    } catch (_) {
      debugPrint('AppPrefs: $_');
    }
  }

  bool getHAutoFill() {
    try {
      final data = _prefs.getBool(_hAutoFill);
      if (data == null) {
        return true;
      }
      return data;
    } catch (_) {
      debugPrint('AppPrefs: $_');
      return true;
    }
  }

  Future<void> persistentUserProfile(UserProfileModel model) async {
    try {
      await _prefs.remove('access_token');
      await _prefs.setString(_appUserProfile, jsonEncode(model));
    } catch (_) {
      debugPrint('AppPrefs: $_');
    }
  }

  UserProfileModel getUserProfile() {
    try {
      final data = _prefs.getString(_appUserProfile);
      if (data == null) {
        return null;
      }
      return UserProfileModel.fromJson(JSON.parse(data));
    } catch (_) {
      debugPrint('AppPrefs: $_');
      return null;
    }
  }

  Future<void> persistentUserProfileDCT(
      profile_model_dct.UserProfileModel model) async {
    try {
      await _prefs.remove('access_token');
      await _prefs.setString(_appUserProfile, jsonEncode(model));
    } catch (_) {
      debugPrint('AppPrefs: $_');
    }
  }

  profile_model_dct.UserProfileModel getUserProfileDCT() {
    try {
      final data = _prefs.getString(_appUserProfile);
      if (data == null) {
        return null;
      }
      return profile_model_dct.UserProfileModel.fromJson(JSON.parse(data));
    } catch (_) {
      debugPrint('AppPrefs: $_');
      return null;
    }
  }

  String getUserName() {
    try {
      final data = _prefs.getString(_appUserName);
      if (data == null) {
        return null;
      }
      return data;
    } catch (_) {
      debugPrint('AppPrefs: $_');
      return null;
    }
  }

  Future<void> persistentUserName(String userName) async {
    try {
      await _prefs.setString(_appUserName, userName);
    } catch (_) {
      debugPrint('AppPrefs: $_');
    }
  }

  int getAppType() {
    try {
      final data = _prefs.getInt(_appType);
      if (data == null) {
        return -1;
      }
      return data;
    } catch (_) {
      debugPrint('AppPrefs: $_');
      return -1;
    }
  }

  Future<void> persistentAppType(int appType) async {
    try {
      await _prefs.setInt(_appType, appType);
    } catch (_) {
      debugPrint('AppPrefs: $_');
    }
  }

  Future<void> saveGroupsHTDCT(List<GroupModel> groups) async {
    final unitJson = groups.map((e) => e.toJson()).toList();
    final string = jsonEncode(unitJson);
    await _prefs.setString('groups_htdct', string);
  }

  Future<void> clearGroupsHTDCT() async {
    await _prefs.setString('groups_htdct', '');
  }

  List<GroupModel> getGroupsHTDCT() {
    try {
      final string = _prefs.getString('groups_htdct');
      if (string == null) {
        return [];
      }
      final json = JSON(jsonDecode(string));

      return json?.list?.map((e) => GroupModel.fromJson(JSON(e)))?.toList() ??
          [];
    } catch (_) {
      return [];
    }
  }

  Future<void> saveTeamsHTDCT(List<TeamModel> groups) async {
    final oldList = getTeamsHTDCT() ?? [];
    final newList = [...oldList, ...groups];
    final unitJson = newList.map((e) => e.toJson()).toList();
    final string = jsonEncode(unitJson);
    await _prefs.setString('teams_htdct', string);
  }

  Future<void> clearTeamsHTDCT() async {
    await _prefs.setString('teams_htdct', '');
  }

  List<TeamModel> getTeamsHTDCT() {
    final string = _prefs.getString('teams_htdct');
    if (string?.isNotEmpty == true) {
      final json = JSON(jsonDecode(string));

      return json?.list?.map((e) => TeamModel.fromJson(JSON(e)))?.toList();
    } else {
      return [];
    }
  }

  Future<void> saveListSubstationHTDCT(List<StationModel> groups) async {
    final unitJson = groups.map((e) => e.toJson()).toList();
    final string = jsonEncode(unitJson);
    await _prefs.setString('substation_htdct', string);
  }

  Future<void> clearListSubstationHTDCT() async {
    await _prefs.setString('substation_htdct', '');
  }

  List<StationModel> getListSubstationHTDCT() {
    final string = _prefs.getString('substation_htdct');
    if (string == null) {
      return [];
    }
    final json = JSON(jsonDecode(string));

    return json?.list?.map((e) => StationModel.fromJson(JSON(e)))?.toList();
  }

  Future<void> saveListLineHTDCT(List<StationModel> groups) async {
    final unitJson = groups.map((e) => e.toJson()).toList();
    final string = jsonEncode(unitJson);
    await _prefs.setString('line_htdct', string);
  }

  Future<void> clearListLineHTDCT() async {
    await _prefs.setString('line_htdct', '');
  }

  List<StationModel> getListLineHTDCT() {
    final string = _prefs.getString('line_htdct');
    if (string == null) {
      return [];
    }
    final json = JSON(jsonDecode(string));

    return json?.list?.map((e) => StationModel.fromJson(JSON(e)))?.toList();
  }

  String getUserPassword() {
    try {
      final data = _prefs.getString(_appUserPassword);
      if (data == null) {
        return null;
      }
      return data;
    } catch (_) {
      debugPrint('AppPrefs: $_');
      return null;
    }
  }

  Future<void> persistentUserPassword(String userName) async {
    try {
      await _prefs.setString(_appUserPassword, userName);
    } catch (_) {
      debugPrint('AppPrefs: $_');
    }
  }

  Future<void> persistentHAutoFillPassword({bool isAutoFill}) async {
    try {
      await _prefs.setBool(_hAutoFillPassword, isAutoFill);
    } catch (_) {
      debugPrint('AppPrefs: $_');
    }
  }

  bool getHAutoFillPassword() {
    try {
      final data = _prefs.getBool(_hAutoFillPassword);
      if (data == null) {
        return true;
      }
      return data;
    } catch (_) {
      debugPrint('AppPrefs: $_');
      return false;
    }
  }

  Future<void> saveUnits(List<WorkCurrentUserModel> units) async {
    final unitJson = units.map((e) => e.toJson()).toList();
    final string = jsonEncode(unitJson);
    await _prefs.setString('unit_htdct', string);
  }

  Future<void> clearUnits() async {
    await _prefs.setString('unit_htdct', '');
  }

  List<WorkCurrentUserModel> getUnits() {
    final string = _prefs.getString('unit_htdct');
    if (string == null) {
      return [];
    }
    final json = JSON(jsonDecode(string));

    return json.list
        .map((e) => WorkCurrentUserModel.fromJson(JSON(e)))
        .toList();
  }

  Future<void> saveUnitsX6(List<UnitModel> units) async {
    final unitJson = units.map((e) => e.toJson()).toList();
    final string = jsonEncode(unitJson);
    await _prefs.setString('unit_htdct_x6', string);
  }

  Future<void> clearUnitsX6() async {
    await _prefs.setString('unit_htdct_x6', '');
  }

  List<WorkCurrentUserModel> getUnitsX6() {
    final string = _prefs.getString('unit_htdct_x6');
    if (string == null) {
      return [];
    }
    final json = JSON(jsonDecode(string));

    return json.list
        .map((e) => WorkCurrentUserModel.fromJson(JSON(e)))
        .toList();
  }

  Future<void> saveListUser(List<WorkCurrentUserModel> units) async {
    final unitJson = units.map((e) => e.toJson()).toList();
    final string = jsonEncode(unitJson);
    await _prefs.setString('users_htdct', string);
  }

  Future<void> clearListUser() async {
    await _prefs.setString('users_htdct', '');
  }

  List<WorkCurrentUserModel> getListUser() {
    final string = _prefs.getString('users_htdct');
    if (string == null) {
      return [];
    }
    final json = JSON(jsonDecode(string));

    return json.list
        .map((e) => WorkCurrentUserModel.fromJson(JSON(e)))
        .toList();
  }

  Future<void> saveListAllSubstationHTDCT(
      List<WorkCurrentUserModel> groups) async {
    final unitJson = groups.map((e) => e.toJson()).toList();
    final string = jsonEncode(unitJson);
    await _prefs.setString('all_substation_htdct', string);
  }

  Future<void> clearListAllSubstationHTDCT() async {
    await _prefs.setString('all_substation_htdct', '');
  }

  List<StationModel> getListAllSubstationHTDCT() {
    final string = _prefs.getString('all_substation_htdct');
    if (string == null) {
      return [];
    }
    final json = JSON(jsonDecode(string));

    return json?.list?.map((e) => StationModel.fromJson(JSON(e)))?.toList();
  }

  Future<void> saveListAllLineHTDCT(List<WorkCurrentUserModel> groups) async {
    final unitJson = groups.map((e) => e.toJson()).toList();
    final string = jsonEncode(unitJson);
    await _prefs.setString('all_line_htdct', string);
  }

  Future<void> clearListAllLineHTDCT() async {
    await _prefs.setString('all_line_htdct', '');
  }

  List<StationModel> getListAllLineHTDCT() {
    final string = _prefs.getString('all_line_htdct');
    if (string == null) {
      return [];
    }
    final json = JSON(jsonDecode(string));

    return json?.list?.map((e) => StationModel.fromJson(JSON(e)))?.toList();
  }

  /// Lưu vị trí vào SharedPreferences
  Future<void> saveLocationToCache(Position position) async {
    await _prefs.setDouble(_keyLat, position.latitude);
    await _prefs.setDouble(_keyLng, position.longitude);
  }

  /// Lưu nhanh từ lat/lng
  Future<void> saveLatLngToCache(double lat, double lng) async {
    await _prefs.setDouble(_keyLat, lat);
    await _prefs.setDouble(_keyLng, lng);
  }

  /// Đọc lat/lng từ cache
  Future<Map<String, double>> getCachedLatLng() async {
    final lat = _prefs.getDouble(_keyLat);
    final lng = _prefs.getDouble(_keyLng);

    if (lat == null || lng == null) {
      return null; // chưa có cache
    }

    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

