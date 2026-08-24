// @dart=2.9
import 'dart:async';
import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/src/qltnkd/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/qltnkd/offline_service/sync_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'src/app_common/shared/app_shared.dart';
import 'src/htld/services/offline_service/local_data_manager.dart';
import 'src/htld/shared_preferences/app_shared.dart';
import 'src/qltnkd/common/utils/common.dart';
//em bỏ mục nam_app đi nhé, k là bị mắng đấy, ae code ngoài em dùng AI đồng bộ nam_app với app ở ngoài r commit lên nhé

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await setupFlutterNotifications();
  showFlutterNotification(message);
  debugPrint('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await setupFlutterNotifications();
    // Initialize Firebase.
    RSyncManager.instance;
    await LocalDataManager.shared.initHive();
    await RLocalDataManager.instance.initHive();
    await AppShared.instance.getShare();
    AppEnv.appVersion = await getDeviceInfo();
    MAppShared.shared.units = await MAppShared.shared.getUnits();
    MAppShared.shared.groups = await MAppShared.shared.getGroups();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(MyApp());
  }, (error, stack) =>
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

