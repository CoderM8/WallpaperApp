import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wallpapers_hd/app_widget/button_widget.dart';
import 'package:wallpapers_hd/app_widget/customwidget.dart';
import 'package:wallpapers_hd/constant.dart';
import 'package:wallpapers_hd/controller/auth/singupcontroller.dart';

class SignupScreen extends GetView {
  SignupScreen({Key? key}) : super(key: key);
  final SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 60.w,
        leading: BackButtonWidget(
            backGroundColor: whiteColor, iconColor: themeColor),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Form(
            key: signupController.globalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextModel(
                  'Sign up',
                  fontSize: 30.h,
                  fontFamily: 'SB',
                ),
                SizedBox(height: 40.h),
                TextFieldModel(
                  hint: 'Enter your Name',
                  label: 'Name',
                  controller: signupController.nameController,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validation: (value) {
                    if (value!.isEmpty) {
                      return "Name is required !!";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20.h),
                TextFieldModel(
                  hint: 'Enter your Email',
                  label: 'Email',
                  controller: signupController.emailController,
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
                    controller: signupController.passwordController,
                    textInputType: TextInputType.visiblePassword,
                    obscureText: signupController.isVisible.value,
                    textInputAction: TextInputAction.next,
                    maxLine: 1,
                    suffixIcon: InkWell(
                        onTap: () {
                          signupController.isVisible.value =
                              !signupController.isVisible.value;
                        },
                        child: Icon(Icons.visibility,
                            color: signupController.isVisible.value
                                ? greyColor
                                : pinkColor)),
                    validation: (value) {
                      if (value!.isEmpty) {
                        return "Password is required !!";
                      } else {
                        return null;
                      }
                    },
                  );
                }),
                SizedBox(height: 20.h),
                TextFieldModel(
                  hint: 'Enter your Number',
                  label: 'Number',
                  controller: signupController.numberController,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validation: (value) {
                    if (value!.isEmpty) {
                      return "Number is required !!";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 40.h),
                Obx(() {
                  return ButtonWidget(
                    title: 'Register',
                    onTap: () {
                      signupController.userRegisterApi();
                    },
                    isLoad: signupController.isLoading.value,
                    titleColor: whiteColor,
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextModel(
                      'Already have an account ?',
                      fontSize: 14.sp,
                      color: greyColor,
                    ),
                    TextButton(
                      child: TextModel(
                        'Login',
                        fontSize: 15.sp,
                        color: greyColor,
                        fontFamily: 'SB',
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
