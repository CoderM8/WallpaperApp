import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wallpapers_hd/app_widget/button_widget.dart';
import 'package:wallpapers_hd/app_widget/customwidget.dart';
import 'package:wallpapers_hd/constant.dart';
import 'package:wallpapers_hd/controller/auth/logincontroller.dart';
import 'package:wallpapers_hd/res.dart';
import 'package:wallpapers_hd/screens/auth/forgot.dart';
import 'package:wallpapers_hd/screens/auth/signup.dart';
import 'package:wallpapers_hd/screens/bottomscreen/bottomscreen.dart';


class LoginScreen extends GetView {
  LoginScreen({Key? key}) : super(key: key);
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 10.h),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Form(
            key: loginController.globalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        storage.remove('userId');
                        storage.remove('type');
                        await storage.erase();
                        userProfile.clear();
                        getUserId();
                        Get.offAll(() => BottomScreen());
                      },
                      child: TextModel('Skip', fontSize: 18.sp, fontFamily: 'SB'),
                    ),
                  ],
                ),
                TextModel(
                  'Login',
                  fontSize: 30.h,
                  fontFamily: 'SB',
                ),
                SizedBox(height: 40.h),
                TextFieldModel(
                  hint: 'Enter your Email',
                  label: 'Email',
                  controller: loginController.emailController,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validation: (value) {
                    if (value!.isEmpty) {
                      return "Email is required !!";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20.h),
                Obx(() {
                  return TextFieldModel(
                    hint: 'Enter password',
                    label: 'Password',
                    controller: loginController.passwordController,
                    textInputType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: loginController.isVisible.value,
                    maxLine: 1,
                    suffixIcon: InkWell(
                        onTap: () {
                          loginController.isVisible.value = !loginController.isVisible.value;
                        },
                        child: Icon(Icons.visibility, color: loginController.isVisible.value ? greyColor : pinkColor)),
                    validation: (value) {
                      if (value!.isEmpty) {
                        return "Password is required !!";
                      } else {
                        return null;
                      }
                    },
                  );
                }),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.to(() => ForgotScreen());
                      },
                      child: TextModel('Forgot Password ?', color: greyColor, fontSize: 14.sp),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Obx(() {
                  return ButtonWidget(
                    title: 'Log in',
                    onTap: () {
                      loginController.userLoginApi();
                    },
                    isLoad: loginController.isLoading.value,
                    titleColor: whiteColor,
                  );
                }),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextModel(
                      'Don\'t have an account ?',
                      fontSize: 14.sp,
                      color: greyColor,
                    ),
                    TextButton(
                      child: TextModel(
                        'Sign up',
                        fontSize: 15.sp,
                        color: greyColor,
                        fontFamily: 'SB',
                      ),
                      onPressed: () {
                        Get.to(() => SignupScreen());
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(child: Divider(color: greyColor)),
                    TextModel('    Or login with    ', color: greyColor, fontSize: 14.sp),
                    Expanded(child: Divider(color: greyColor)),
                  ],
                ),
                SizedBox(height: 16.h),
                Obx(() {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          FloatingActionButton(
                            heroTag: '1',
                            backgroundColor: whiteColor,
                            onPressed: () {
                              loginController.userGoogleLoginApi();
                            },
                            child: SvgPicture.asset(Res.google),
                          ),
                          if (loginController.isGoogleLoad.value)
                            CircleAvatar(
                              radius: 33.r,
                              backgroundColor: pinkColor,
                              child: CircularProgressIndicator(color: whiteColor, strokeWidth: 4.w),
                            ),
                        ],
                      ),
                      if (Platform.isIOS)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            FloatingActionButton(
                              heroTag: '2',
                              backgroundColor: whiteColor,
                              onPressed: () {
                                loginController.userAppleLoginApi();
                              },
                              child: SvgPicture.asset(Res.apple),
                            ),
                            if (loginController.isAppleLoad.value)
                              CircleAvatar(
                                radius: 33.r,
                                backgroundColor: pinkColor,
                                child: CircularProgressIndicator(color: whiteColor, strokeWidth: 4.w),
                              ),
                          ],
                        ),
                    ],
                  );
                }),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
