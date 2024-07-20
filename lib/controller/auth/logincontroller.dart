import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wallpapers_hd/api_services/auth_services.dart';
import 'package:wallpapers_hd/constant.dart';
import 'package:wallpapers_hd/screens/bottomscreen/bottomscreen.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController forgotController = TextEditingController();
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  RxBool isGoogleLoad = false.obs;
  RxBool isAppleLoad = false.obs;
  RxBool isVisible = true.obs;
  final _auth = FirebaseAuth.instance;

  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> userLoginApi() async {
    if (globalKey.currentState!.validate()) {
      isLoading.value = true;
      Map user = await ApiServices.userLogin(email: emailController.text, password: passwordController.text);
      if (user['error'] == null) {
        if (user['success'] == '1') {
          await storage.write('userId', user['user_id']);
          await storage.write('type', 'Normal');
          await getUserId();
          if (Platform.isIOS) {
            await Purchases.logIn(userId.toString());
          }
          showToast(message: user['MSG']);
          await ApiServices.getUserProfile();
          Get.offAll(() => BottomScreen());
          isLoading.value = false;
        } else {
          showToast(message: user['MSG']);
          isLoading.value = false;
        }
      } else {
        showToast(message: "Login ${user['error']}");
        isLoading.value = false;
      }
    }
  }

  Future<void> userForgotApi() async {
    if (forgotController.text.isNotEmpty) {
      isLoading.value = true;
      Map user = await ApiServices.userForgotPassword(email: forgotController.text);
      if (user['error'] == null) {
        if (user['success'] == '1') {
          showToast(message: user['msg']);
          isLoading.value = false;
          forgotController.clear();
          Get.back();
        } else {
          showToast(message: user['msg']);
          isLoading.value = false;
        }
      } else {
        showToast(message: "Forgot ${user['error']}");
        isLoading.value = false;
      }
    }
  }

  Future<void> userGoogleLoginApi() async {
    try {
      isGoogleLoad.value = true;
      final res = await googleSignIn.signIn();
      if (res != null) {
        var googleSignInAuthentication = await res.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(accessToken: googleSignInAuthentication.accessToken, idToken: googleSignInAuthentication.idToken);
        final UserCredential authResult = await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          Map register = await ApiServices.userRegister(
              email: user.email ?? '', type: 'Google', name: user.displayName ?? '', number: user.phoneNumber ?? '', image: user.photoURL ?? '', authId: googleSignInAuthentication.accessToken);
          if (register['error'] == null) {
            if (register['success'] == '1') {
              await storage.write('userId', register['user_id']);
              await storage.write('isRegister', true);

              await getUserId();
              showToast(message: register['MSG']);
              await ApiServices.getUserProfile();
              if (Platform.isIOS) {
                await Purchases.logIn(userId.toString());
              }

              Get.offAll(() => BottomScreen());
              isGoogleLoad.value = false;
            } else {
              showToast(message: register['MSG']);
              isGoogleLoad.value = false;
              googleSignIn.signOut();
            }
          } else {
            showToast(message: "Google ${register['error']}");
            isGoogleLoad.value = false;
          }
        }
      } else {
        isGoogleLoad.value = false;
        googleSignIn.signOut();
      }
    } on FirebaseAuthException catch (e) {
      isGoogleLoad.value = false;
      print('FirebaseAuthException ==== error $e');
      showToast(message: e.message.toString());
    }
  }

  Future<void> userAppleLoginApi() async {
    try {
      isAppleLoad.value = true;
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );

      final oAuthProvider = OAuthProvider('apple.com');
      final firebaseauth = oAuthProvider.credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );
      UserCredential authResult = await _auth.signInWithCredential(firebaseauth);
      final firebaseUser = authResult.user;

      String? appleEmail = firebaseUser!.email;
      String appleName = firebaseUser.displayName ?? appleEmail!.split('@').first;
      String? appleImage = firebaseUser.photoURL;

      Map register = await ApiServices.userRegister(email: appleEmail ?? '', type: 'Apple', name: appleName, authId: credential.identityToken, image: appleImage);
      if (register['error'] == null) {
        if (register['success'] == '1') {
          await storage.write('userId', register['user_id']);
          await storage.write('isRegister', true);
          await getUserId();
          await Purchases.logIn(userId.toString());
          showToast(message: register['MSG']);
          await ApiServices.getUserProfile();
          Get.offAll(() => BottomScreen());
          isAppleLoad.value = false;
        } else {
          showToast(message: register['MSG']);
          isAppleLoad.value = false;
        }
      } else {
        showToast(message: "Apple ${register['error']}");
        isAppleLoad.value = false;
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      isAppleLoad.value = false;
      print('FirebaseAuthException ==== error $e');
      showToast(message: e.message.toString());
    }
  }
}
