// @dart=2.9
import 'package:flutter/material.dart';

class TabBarItem {
  TabBarItem({
    this.title,
    this.icon,
    this.controller,
    this.badgeIcon
  });

  final String title;
  final Icon icon;
  final Widget controller;
  Widget badgeIcon;
}

