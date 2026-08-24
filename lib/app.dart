// @dart=2.9
import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/src/htdct/common/enum/ticket_enum.dart';
import 'package:evnmobile/src/htdct/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htdct/models/equipment_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/content/equipment_list/equipment_list_controller.dart'
    as night_equipment_list_controller;
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/tunnel_cable_content/tunnel_cable_controller.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/transformer/transformer_ticket_controller.dart';
import 'package:evnmobile/src/htdct/services/responsitory/notify_respository.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/utils/connection.dart';
import 'package:evnmobile/src/qltnkd/common/utils/report_location_utils.dart';
import 'package:evnmobile/src/qltnkd/offline_service/sync_manager.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/list_request/list_request_controller.dart';
import 'package:evnmobile/src/qltnkd/services/qr_deep_link_handler.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'routes.dart';
import 'src/app_common/shared/app_shared.dart';

import 'src/htdct/screens/grid_management/not_pmis/test_plan/test_plan_screen.dart';
import 'src/htdct/models/day_night/ticket.dart' as htdct;
import 'src/htdct/screens/grid_management/transformer/equipment_list/equipment_list_controller.dart';
import 'src/htdct/screens/notify/detail_screen/detail_screen.dart';
import 'src/htld/common/themes/colorx.dart';
import 'src/htld/common/utils/global_app.dart';
import 'src/htld/models/day_night/ticket.dart';
import 'src/htld/screens/grid_management/periodic_inspection_plan/periodic_inspection_plan.dart';
import 'src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'src/htld/services/location_background_service.dart';
import 'src/qltnkd/common/constance/r_user_role_type.dart';

Future handleNotifyOpen(RemoteMessage notificationResponse) async {
  if (notificationResponse.data == null) {
    return;
  }

  ProgressHUD.show();
  Map data;
  try {
    data = jsonDecode(notificationResponse.data['response']);
  } catch (e) {
    await FirebaseCrashlytics.instance.recordError(
        Exception('Check lỗi notification'),
        StackTrace.fromString('fromString'),
        information: ['Notification'],
        reason:
            '${notificationResponse?.notification}}\n${notificationResponse?.data}}',
        fatal: false);
    data = null;
  }

  if (data == null) return;

  if (AppShared.instance.getAppType() == AppType.HTDCT) {
    final service = NotifyRepository();
    await service.seenNotify(
      notifyId: data['IdNoti'],
      isBackground: true,
    );
    await Routes?.homeDCTKey?.currentState?.updateNotifyQuantity();
    if (data['TypeEvent'] != null && data['TypeEvent'] == 'report') {
      Get.until((route) => route.settings.name == Routes.homeDCT);
      await Get.deleteAll(force: true);
      await Get.to(DetailScreen(id: data['IdNoti']));
    } else if (data['TypeEvent'] != null && data['TypeEvent'] == 'feed_back') {
      Get.until((route) => route.settings.name == Routes.homeDCT);
      await Get.deleteAll(force: true);
      if (data['IsPMIS'] == false) {
        Get.put(data['Id'].toString(), tag: 'ticketIdNotify');
        Get.put(data['Id'].toString(), tag: 'workIdNotify');
        await Get.to(() =>
            TestPlanView(ticketIdNotify: data['Id'], workIdNotify: data['Id']));
      } else {
        await Get.deleteAll(force: true);
        if (data['TypeWork'] == 1) {
          Get.put(htdct.TestType.subStation, tag: 'testType');
          Get.put(htdct.TicketType.periodicDay, tag: 'ticketType');
          Get.put(data['Id'].toString(), tag: 'ticketIdNotify');
          Get.put(data['Id'].toString(), tag: 'workIdNotify');
        } else if (data['TypeWork'] == 2) {
          Get.put(htdct.TestType.subStation, tag: 'testType');
          Get.put(htdct.TicketType.periodicNight, tag: 'ticketType');
          Get.put(data['Id'].toString(), tag: 'ticketIdNotify');
          Get.put(data['Id'].toString(), tag: 'workIdNotify');
        } else if (data['TypeWork'] == 3) {
          Get.put(htdct.TestType.line, tag: 'testType');
          Get.put(htdct.TicketType.periodicMonth, tag: 'ticketType');
          Get.put(data['Id'].toString(), tag: 'ticketIdNotify');
          Get.put(data['Id'].toString(), tag: 'workIdNotify');
        } else if (data['TypeWork'] == 4) {
          Get.put(htdct.TestType.line, tag: 'testType');
          Get.put(htdct.TicketType.periodicNight, tag: 'ticketType');
          Get.put(data['Id'].toString(), tag: 'ticketIdNotify');
          Get.put(data['Id'].toString(), tag: 'workIdNotify');
        } else if (data['TypeWork'] == 5) {
          Get.put(htdct.TestType.line, tag: 'testType');
          Get.put(htdct.TicketType.tunnelCable, tag: 'ticketType');
          Get.put(data['Id'].toString(), tag: 'ticketIdNotify');
          Get.put(data['Id'].toString(), tag: 'workIdNotify');
        }
        await Get.toNamed(Routes.testPlan);
      }
    } else {
      Get.until((route) => route.settings.name == Routes.homeDCT);
      await Get.deleteAll(force: true);
      final transformerTicketController = TransformerTicketController(
          abnormalNotify: true, titleAbnormalNotify: data['Title']);
      transformerTicketController.ticketId = data['TicketId'];
      transformerTicketController.testType =
          (data['TypeWork'] == 1 || data['TypeWork'] == 2)
              ? htdct.TestType.subStation
              : htdct.TestType.line;

      transformerTicketController.ticketType = data['TypeWork'] == 1
          ? htdct.TicketType.periodicDay
          : (data['TypeWork'] == 2 || data['TypeWork'] == 4)
              ? htdct.TicketType.periodicNight
              : data['TypeWork'] == 3
                  ? htdct.TicketType.periodicMonth
                  : htdct.TicketType.tunnelCable;
      transformerTicketController.actionTicketType = ActionTicketType.view;
      transformerTicketController.actionPopupType = ActionTicketType.view;
      transformerTicketController.equipmentNameNotify = data['EquipmentName'];
      transformerTicketController.nodeNameNotify = data['SubstationName'];
      Get.put(transformerTicketController);

      final model = EquipmentModel();
      model.id = data['EquipmentId'];
      model.equipmentCategory = data['CategoryId'];

      if (data['TypeWork'] == 1 || data['TypeWork'] == 2) {
        final equipmentController = EquipmentController();
        equipmentController.fromNotify = true;
        equipmentController.categoryId = data['CategoryId'];
        unawaited(equipmentController.onRouter(model));
      } else if (data['TypeWork'] == 3) {
        final equipmentController =
            night_equipment_list_controller.EquipmentLineController();
        equipmentController.fromNotify = true;
        equipmentController.categoryId = data['CategoryId'];
        unawaited(
            equipmentController.onRouter(model, ticketId: data['TicketId']));
      } else if (data['TypeWork'] == 5) {
        final tunnelCableContentController = TunnelCableContentController();
        tunnelCableContentController.fromNotify = true;
        unawaited(tunnelCableContentController.onRouter(model,
            ticketId: data['TicketId']));
      } else if (data['TypeWork'] == 4) {
        unawaited(Get.toNamed(Routes.nightContentNotify));
      }
    }
    ProgressHUD.dismiss();
  }
  if (AppShared.instance.getAppType() == AppType.HTLDTT) {
    final type = data['notification_type'].string;

    switch (type) {
      case 'NEW_WORK_DISTRIBUTION':

        /// Goto distribution periodicView
        final argument = TicketScreenArgument(
            ticketType: TicketType.periodicDay,
            subStationType: SubStationType.distribution,
            actionType: ActionType.create);
        Get.until((route) => route.settings.name == Routes.home);
        await Get.to(() => PeriodicInspectionPlanView(
              argument: argument,
            ));
        break;
      case 'NEW_WORK_INTERMEDIARY':

        /// Goto distribution periodicView
        final argument = TicketScreenArgument(
            ticketType: TicketType.periodicDay,
            subStationType: SubStationType.intermediate,
            actionType: ActionType.create);
        Get.until((route) => route.settings.name == Routes.home);
        await Get.to(() => PeriodicInspectionPlanView(
              argument: argument,
            ));
        break;
      case 'NEW_WORK_LINE':

        /// Goto distribution periodicView
        final argument = TicketScreenArgument(
            ticketType: TicketType.periodicDay,
            subStationType: SubStationType.mediumVoltage,
            actionType: ActionType.create);
        Get.until((route) => route.settings.name == Routes.home);
        await Get.to(() => PeriodicInspectionPlanView(
              argument: argument,
            ));
        break;
      default:
        break;
    }
  } else {}
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

bool isFlutterLocalNotificationsInitialized = false;
AndroidNotificationChannel channel;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  final notification = message.notification;
  final android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
        ),
        payload: message.data['response'].toString());
    Routes?.homeDCTKey?.currentState?.updateNotifyQuantity();
  }
}

class MyAppState extends State<MyApp> {
  String token;
  String initRouter = '';
  StreamSubscription<ConnectivityResult> subscription;
  bool isHasInternet;

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    final RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      await handleNotifyOpen(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen(handleNotifyOpen);
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.ripple
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.white
      ..backgroundColor = AppColor.highlightColor70
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.grey.withOpacity(0.4)
      ..userInteractions = false
      ..dismissOnTap = false;

    token = AppShared.instance.getUserToken();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await QrDeepLinkHandler.init();
    });
    if (AppShared.instance.getAppType() == AppType.KDTN) {
      if (!Get.isRegistered<ListRequestController>()) {
        Get.put(ListRequestController(), permanent: true);
      }
      final userProfile = AppShared.instance.getUserProfile();
      if (userProfile == null) {
        return;
      }
      RUserRole.checkPermission(userProfile);
      if (RUserRole.isPresidentCompany) {
        initRouter = Routes.listReportForDirectorCompanyScreen;
      } else if (RUserRole.isPresidentCenter) {
        initRouter = Routes.listReportScreen;
      } else if (RUserRole.isExpertElectric) {
        initRouter = Routes.workloadHome;
      } else {
        initRouter = Routes.reportHome;
      }
      listenNetwork();
    } else if (AppShared.instance.getAppType() == AppType.HTDCT) {
      initRouter = Routes.homeDCT;
    } else {
      initRouter = Routes.home;
    }
    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (AppShared.instance.getAppType() == AppType.KDTN) {
        await ReportLocationUtils.requestPermissionOnAppStart();
      } else {
        await LocationServiceBackground.shared.requestPermission();
      }
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: App.globalKey,
      debugShowCheckedModeBanner: false,
      getPages: Routes.getPages(),
      navigatorObservers: <NavigatorObserver>[observer],
      initialRoute:
          (token == null || token.isEmpty) ? Routes.selectModule : initRouter,
      builder: (context, widget) {
        return EasyLoading.init()(
            context,
            MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                child: widget));
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('vi', 'VN'),
      ],
      theme: ThemeData(
        primarySwatch: AppColor.colorPrimary,
        primaryColor: AppColor.highlightColor70,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }

  Future listenNetwork() async {
    isHasInternet = await RConnection.shared.checkConnection();
    if (token != null && token.isNotEmpty) {
      subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) async {
        if (isHasInternet == false &&
            (await RConnection.shared.checkConnection()) &&
            result != ConnectivityResult.none) {
          if (await RSyncManager.instance.isHasReportOffline()) {
            await RSyncManager.instance.doAutoSync();
          }
          isHasInternet = true;
        } else {
          isHasInternet = await RConnection.shared.checkConnection();
        }
      });
    }
  }
}

