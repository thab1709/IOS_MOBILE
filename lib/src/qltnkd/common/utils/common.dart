// @dart=2.9
import 'package:package_info/package_info.dart';

Future<String> getDeviceInfo() async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

