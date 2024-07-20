import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wallpapers_hd/app_widget/customwidget.dart';
import 'package:wallpapers_hd/modal/user_model.dart';
import 'package:wallpapers_hd/screens/auth/login.dart';

final Uri mainApi = Uri.parse("https://vocsyinfotech.in/vocsy/app_store/flutter_hdwallpaper/api.php?");

GetStorage storage = GetStorage();
String? userId;
String? type;
RxBool isAndroidVersionUp13 = false.obs;
RxList<HdWallpaper> userProfile = <HdWallpaper>[].obs;
Color baseColor = themeColor.withOpacity(0.2);
Color highlightColor = greyColor.withOpacity(0.05);

Future<void> getUserId() async {
  userId = storage.read('userId');
  type = storage.read('type');
  print("USERID $userId");
}

Future<void> userLogout() async {
  storage.remove('userId');
  storage.remove('type');
  userProfile.clear();
  await storage.erase();
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
  Get.offAll(() => LoginScreen());
}

/// ANDROID VERSION
Future<void> fetchAndroidVersion() async {
  final String? version = await getAndroidVersion();
  if (version != null) {
    String? firstPart;
    if (version.toString().contains(".")) {
      int indexOfFirstDot = version.indexOf(".");
      firstPart = version.substring(0, indexOfFirstDot);
    } else {
      firstPart = version;
    }
    int intValue = int.parse(firstPart);
    if (intValue >= 13) {
      isAndroidVersionUp13.value = true;
    } else {
      isAndroidVersionUp13.value = false;
    }
    print("ANDROID VERSION: $intValue");
  }
}

final platform = MethodChannel('my_channel');

Future<String?> getAndroidVersion() async {
  try {
    final String version = await platform.invokeMethod('getAndroidVersion');
    return version;
  } on PlatformException catch (e) {
    print("FAILED TO GET ANDROID VERSION: ${e.message}");
    return null;
  }
}

void showSnackBar(BuildContext context, {required String msg}) {
  final snackBar = SnackBar(
    content: TextModel(msg, color: themeColor, fontSize: 15.sp),
    backgroundColor: whiteColor.withOpacity(0.7),
    behavior: SnackBarBehavior.floating,
    padding: EdgeInsets.all(10.h),
    margin: EdgeInsets.only(bottom: 100.h, left: 60.w, right: 60.w),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.r)),
    duration: Duration(milliseconds: 800),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

showToast({required String message}) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: whiteColor.withOpacity(0.9),
    textColor: themeColor,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    fontSize: 16.sp,
  );
}

///COLOR
const themeColor = Color(0xff000000);
const pinkColor = Color(0xffDF1F5A);
const redColor = Color(0xffff0000);
const whiteColor = Color(0xffFFFFFF);
const greyColor = Color(0xffB7B7B7);
const goldenColor = Color(0xffFFD700);
