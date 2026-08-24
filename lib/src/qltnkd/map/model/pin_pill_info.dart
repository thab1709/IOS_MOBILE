// @dart=2.9
import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RPinInformation {
  String pinPath;
  String avatarPath;
  String subtitle;
  String subtitle2;
  LatLng location;
  String title;
  Color labelColor;
  String timeLog;

  RPinInformation(
      {this.pinPath,
      this.avatarPath,
      this.location,
      this.title,
      this.subtitle,
      this.subtitle2,
      this.labelColor,
      this.timeLog});
}

