import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wallpapers_hd/app_widget/button_widget.dart';
import 'package:wallpapers_hd/app_widget/customwidget.dart';
import 'package:wallpapers_hd/constant.dart';
import 'package:wallpapers_hd/controller/auth/logincontroller.dart';

class ForgotScreen extends GetView {
  ForgotScreen({Key? key}) : super(key: key);
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leadingWidth: 60.w,
          leading: BackButtonWidget(
            iconColor: themeColor,
            backGroundColor: whiteColor,
            onTap: () {
              Get.back();
              loginController.isLoading.value = false;
            },
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextModel(
              'Forgot Password',
              fontSize: 30.h,
              fontFamily: 'SB',
            ),
            SizedBox(height: 40.h),
            TextFieldModel(
              hint: 'Enter your Email',
              label: 'Email',
              controller: loginController.forgotController,
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 40.h),
            Obx(() {
              return ButtonWidget(
                title: 'Submit',
                isLoad: loginController.isLoading.value,
                titleColor: whiteColor,
                onTap: () {
                  loginController.userForgotApi();
                },
              );
            }),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child:
                  TextModel('Back to Login', color: greyColor, fontSize: 14.sp),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
