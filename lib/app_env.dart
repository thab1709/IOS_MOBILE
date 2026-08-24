// @dart=2.9
import 'dart:io' show Platform;

import 'package:evnmobile/src/app_common/shared/app_shared.dart';

enum ENV { dev, stg, prd, local, uat }

class AppType {
  //Trung thế
  static const HTLDTT = 1;

  //Kiểm định thí nghiệm
  static const KDTN = 2;

  //Cao thế
  static const HTDCT = 3;

  //Hạ thế
  static const HTLDHT = 4;
}

class AppEnv {
  static const _devKDTNUrl = 'http://125.212.226.94:5006/tnkd/api';
  static const _uatKDTNUrl = 'https://appqthtuat.evnhanoi.com.vn/tnkd/api';
  static const _devTTUrl = 'http://192.168.1.145:31002/api'; //dev trung thế
  static const _stgHTTTUrl = 'https://evn-mobile-staging.dev.3si.vn/api';
  static const _prdKDTNUrl = 'http://14.238.40.33:31006/api';
  static const _prdHTTTUrl = 'http://42.112.213.225:30002/api';
  // static const _prdHTTTUrl = 'http://10.9.125.117:30005/api';
  static const _localApiHost = String.fromEnvironment('LOCAL_API_HOST');
  static String get _localHost {
    if (_localApiHost.isNotEmpty) {
      return _localApiHost;
    }

    return Platform.isAndroid ? '10.0.2.2' : 'localhost';
  }

  static String get _localUrl => 'http://$_localHost:5006/api';
  static const _devGHDUrl = 'http://125.212.226.94:3000/api';

  // ha the
  // static const _prdHTDHTUrl = 'http://42.112.213.225:30002/api';
  // static const _prdHTDHTUrl = 'https://apicskh1.evnhanoi.com.vn/hathe/api';
  static const _prdHTDHTUrl =
      'https://bounteous-june-overlofty.ngrok-free.dev/api';

  static const _prdHtdctUrl = 'http://14.238.40.52:30009/api'; //prod
  // static const _prdHtdctUrl = 'http://10.9.125.117:30006/api'; //prod nội bộ
  static const _stgHtdctUrl = 'http://14.238.40.52:30009/api'; //stg

  static const _devHtdctUrl = 'http://222.252.22.193:31012/api'; //dev public

  ///SET ENVIRONMENT APPLICATION
  static const ENV _environment = ENV.uat;

  static ENV getAppEnv() {
    return _environment;
  }

  static bool isDev() {
    return _environment == ENV.dev || _environment == ENV.local;
  }

  static int appType = AppShared.instance.getAppType();
  static String appVersion = '';

  static bool firstLoad = true;

  static bool isHTLDTT() {
    return appType == AppType.HTLDTT;
  }

  static String getServerUrl() {
    switch (AppEnv.getAppEnv()) {
      case ENV.dev:
        if (AppShared.instance.getAppType() == AppType.HTLDTT) {
          return _devTTUrl;
        } else if (AppShared.instance.getAppType() == AppType.HTDCT) {
          return _devHtdctUrl;
        } else {
          return _devKDTNUrl;
        }
        break;
      case ENV.stg:
        if (AppShared.instance.getAppType() == AppType.HTLDTT) {
          return _stgHTTTUrl;
        } else if (AppShared.instance.getAppType() == AppType.HTDCT) {
          return _stgHtdctUrl;
        } else {
          return _prdKDTNUrl;
        }
        break;
      case ENV.prd:
        if (AppShared.instance.getAppType() == AppType.HTLDTT) {
          return _prdHTTTUrl;
        } else if (AppShared.instance.getAppType() == AppType.HTDCT) {
          return _prdHtdctUrl;
        } else if (AppShared.instance.getAppType() == AppType.HTLDHT) {
          return _prdHTDHTUrl;
        } else {
          return _prdKDTNUrl;
        }
        break;
      case ENV.uat:
        if (AppShared.instance.getAppType() == AppType.HTLDTT) {
          return _stgHTTTUrl;
        } else if (AppShared.instance.getAppType() == AppType.HTDCT) {
          return _stgHtdctUrl;
        } else {
          return _uatKDTNUrl;
        }
        break;
      case ENV.local:
        return _localUrl;
        break;
      default:
        return '';
    }
  }

  static String getName() {
    switch (_environment) {
      case ENV.dev:
        return 'dev';
        break;
      case ENV.stg:
        return 'stg';
        break;
      case ENV.uat:
        return 'uat';
        break;
      case ENV.local:
        return _localUrl;
        break;
      default:
        return '';
    }
  }
}

