import 'dart:developer';
import 'dart:io';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_id/flutter_device_id.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpapers_hd/Notification/local_notification_services.dart';
import 'package:wallpapers_hd/admob/admobid.dart';
import 'package:wallpapers_hd/api_services/auth_services.dart';
import 'package:wallpapers_hd/api_services/home_services.dart';
import 'package:wallpapers_hd/app_extension/appextension.dart';
import 'package:wallpapers_hd/constant.dart';
import 'package:wallpapers_hd/screens/splashscreen.dart';
import 'package:wallpapers_hd/subscription/subscription.dart';
import 'admob/admobads.dart';
import 'controller/home/homecontroller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Apis().initFirebase();
  await GetStorage.init();

  if (Platform.isAndroid) {
    isSubscribe.value = true;
  }

  var status = await Permission.notification.status;
  log('status : ${status.isGranted}');
  if (status.isGranted == false) {
    await Permission.notification.request();
  }

  ///REVENUE-CAT PURCHASES CONFIGURATION
  if (Platform.isIOS) {
    await Config.configureSDK();
    await Config.getActiveSubscription();
    await Config.getAllProducts();
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: themeColor,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark));
  // await AdManager.getIds();
  IAdIdManager adIdManager = AdsTestAdIdManager();
  final flutterDeviceIdPlugin = FlutterDeviceId();

  String? deviceId = await flutterDeviceIdPlugin.getDeviceId() ?? '';

  print("DEVICE ID$deviceId");
  EasyAds.instance.initialize(
    isShowAppOpenOnAppStateChange: false,
    adIdManager,
    adMobAdRequest: const AdRequest(),
    admobConfiguration: RequestConfiguration(testDeviceIds: [deviceId]),
    fbTestMode: true,
    showAdBadge: Platform.isIOS,
    fbiOSAdvertiserTrackingEnabled: true,
  );

  /// INITIALIZE LOCAL NOTIFICATION FOR [IOS]
  if (Platform.isIOS) {
    await NotificationService.init();
    await NotificationService.cancelAllNotifications();
  }

  Apis().initOneSignalNotification();
  await AdManager.getIds();
  await getUserId();

  ApiServices.getUserProfile();

  runApp(MyApp());
}

class MyApp extends GetView {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: isTab(context) ? Size(585, 812) : const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, widget) {
          return GetMaterialApp(
            title: "Wallplix 4K Ultra HD Wallpaper",
            scrollBehavior: ScrollConfiguration.of(context).copyWith(multitouchDragStrategy: MultitouchDragStrategy.latestPointer),
            debugShowCheckedModeBanner: false,
            initialBinding: ControllerBinding(),
            navigatorObservers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
            theme: ThemeData(
              fontFamily: 'M',
              scaffoldBackgroundColor: themeColor,
              colorScheme: ColorScheme.fromSwatch().copyWith(primary: whiteColor, secondary: pinkColor, brightness: Brightness.dark),
              appBarTheme: AppBarTheme(backgroundColor: themeColor, elevation: 0),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: SplashScreen(),
          );
        });
  }
}
