import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallpapers_hd/api_services/auth_services.dart';
import 'package:wallpapers_hd/constant.dart';

class SignupController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  RxBool isVisible = true.obs;

  Future<void> userRegisterApi() async {
    if (globalKey.currentState!.validate()) {
      isLoading.value = true;
      Map user = await ApiServices.userRegister(email: emailController.text, password: passwordController.text, name: nameController.text, number: numberController.text, type: 'Normal');
      if (user['error'] == null) {
        if (user['success'] == '1') {
          showToast(message: user['MSG']);
          await storage.write('isRegister', true);
          isLoading.value = false;
          Get.back();
        } else {
          showToast(message: user['MSG']);
          isLoading.value = false;
        }
      } else {
        showToast(message: "Register ${user['error']}");
        isLoading.value = false;
      }
    }
  }
}
