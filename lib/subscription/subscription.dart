import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:get/get.dart';

import 'package:wallpapers_hd/constant.dart';

const appleApiKey = 'appl_GiGAgQOOEXyhaztOAXwoPsWaBhS';

const googleApiKey = '';

const entitlementKey = 'pro';

RxList<StoreProduct> subscriptionPlanList = <StoreProduct>[].obs;
Rx<StoreProduct> subscriptionPlan = StoreProduct('', '', '', 0, '', '').obs;

/// RETURN [TRUE] IF PLAN ACTIVATED
final RxBool isSubscribe = false.obs;

class Config {
  static final RxBool isPurchasing = false.obs;
  static final RxBool isLoadPlan = false.obs;

  static String get apiKey {
    if (Platform.isAndroid) {
      return googleApiKey;
    } else if (Platform.isIOS) {
      return appleApiKey;
    } else {
      return "Unsupported Platform ${Platform.operatingSystem}";
    }
  }

  static Future<void> configureSDK() async {
    await Purchases.setLogLevel(LogLevel.debug);
    await Purchases.configure(PurchasesConfiguration(Config.apiKey));

    await Purchases.enableAdServicesAttributionTokenCollection();
  }

  /// GET ALL PRODUCT
  static Future<void> getAllProducts() async {
    try {
      subscriptionPlanList.clear();
      isLoadPlan.value = true;
      final response = await http.post(Uri.parse('$mainApi'),
          body: {'data': '{"method_name": "get_active_subscription_plan", "package_name": "com.eng.hdwallpaper", "id": ""}'});
      if (kDebugMode) {
        print('HELLO API RESPONSE get_subscription [${response.statusCode}]');
      }
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List draw = List.from(json['HD_WALLPAPER']);
        if (draw.isNotEmpty) {
          List<String> subIds = [];
          List<String> purIds = [];
          for (final element in draw) {
            /// consumable A Type for subscriptions.
            if (element['plan_type'] != "lifetime") {
              if (Platform.isAndroid) {
                subIds.add(element['playstore_id']);
              } else if (Platform.isIOS) {
                subIds.add(element['appstore_id']);
              }
            }

            /// non-consumable A Type for in-app products.
            else if (element['plan_type'] == "lifetime") {
              if (Platform.isAndroid) {
                purIds.add(element['playstore_id']);
              } else if (Platform.isIOS) {
                purIds.add(element['appstore_id']);
              }
            }
          }
          if (subIds.isNotEmpty) {
            final items = await Purchases.getProducts(subIds, productCategory: ProductCategory.subscription);
            for (final key in items) {
              subscriptionPlanList.add(key);
            }
          }
          if (purIds.isNotEmpty) {
            final items = await Purchases.getProducts(purIds, productCategory: ProductCategory.nonSubscription);
            for (final key in items) {
              subscriptionPlanList.add(key);
            }
          }
          subscriptionPlanList.sort((a, b) => a.price.compareTo(b.price));
        }
      }
      isLoadPlan.value = false;
      if (kDebugMode) {
        print('HELLO PURCHASE INITIALIZE storeProduct ${subscriptionPlanList.length}');
      }
    } on PlatformException catch (e) {
      isLoadPlan.value = false;
      if (kDebugMode) {
        print('HELLO PURCHASE INITIALIZE ERROR [${e.code}] ${e.message}');
      }
    }
  }

  /// GET USER ACTIVE SUBSCRIPTION DATA
  static Future<void> getActiveSubscription() async {
    isPurchasing.value = false;
    isPurchasing.value = true;

    CustomerInfo info = await Purchases.getCustomerInfo();

    final bool isPro = info.entitlements.active.containsKey(entitlementKey);
    final bool isActive = info.activeSubscriptions.isNotEmpty || info.nonSubscriptionTransactions.isNotEmpty;
    if (kDebugMode) {
      print(
          'HELLO PURCHASE GET isActive $isActive isPro $isPro sub ${info.activeSubscriptions} inApp ${info.nonSubscriptionTransactions} entitlements ${info.entitlements.active}');
    }
    isSubscribe.value = (isActive && isPro);
    isPurchasing.value = false;
    if (kDebugMode) {
      print('HELLO PURCHASE GET isSubscribe $isSubscribe');
    }
  }

  /// BUY SUBSCRIPTION PLAN
  static Future<void> buySubscription(context, {required StoreProduct item}) async {
    try {
      isPurchasing.value = false;
      isPurchasing.value = true;
      print('StoreProduct =======> ${item.price}');
      final CustomerInfo information = await Purchases.restorePurchases();
      final bool isProRestore = information.entitlements.active.containsKey(entitlementKey);
      final bool isActiveRestore = information.activeSubscriptions.isNotEmpty || information.nonSubscriptionTransactions.isNotEmpty;
      //
      if (!isProRestore && !isActiveRestore) {
        final CustomerInfo info = await Purchases.purchaseStoreProduct(item);
        final bool isPro = info.entitlements.active.containsKey(entitlementKey);
        final bool isActive = info.activeSubscriptions.isNotEmpty || info.nonSubscriptionTransactions.isNotEmpty;
        if (kDebugMode) {
          print(
              'HELLO PURCHASE BUY isActive $isActive isPro $isPro sub ${info.activeSubscriptions} inApp ${info.nonSubscriptionTransactions} entitlements ${info.entitlements.active} ');
        }
        isSubscribe.value = (isActive && isPro);
        print('hello ======> 0');
        Get.snackbar('Purchase SuccessFully', 'Thank You For Subscribing....', borderRadius: 15, backgroundColor: pinkColor.withOpacity(.5));
      } else {
        isSubscribe.value = (isActiveRestore && isProRestore);
        print('hello ======> 1');
        Get.snackbar('Premium', 'You Have Already Subscribe....', borderRadius: 15, backgroundColor: pinkColor.withOpacity(.5),);
      }


    } on PlatformException catch (e) {
      isPurchasing.value = false;
      // Apis.constSnack(context, e.message.toString());
      if (kDebugMode) {
        print('HELLO PURCHASE BUY ERROR [${e.code}] ${e.message} ${e.details}');
      }
      if (e.code == '5' && e.message == 'Couldn\'t find product.') {
        Get.snackbar('Something Went Wrong!', 'Please select product..', borderRadius: 15, backgroundColor: pinkColor.withOpacity(.5));
      }
      if (e.code == '6' || e.message == 'This product is already active for the user.') {
        await restoreSubscription();
      }
    }
    isPurchasing.value = false;

    if (kDebugMode) {
      print('HELLO PURCHASE BUY isSubscribe $isSubscribe');
    }
  }

  /// RESTORE PURCHASE
  static Future<void> restoreSubscription() async {
    try {
      isPurchasing.value = false;
      isPurchasing.value = true;
      final CustomerInfo info = await Purchases.restorePurchases();
      final bool isPro = info.entitlements.active.containsKey(entitlementKey);
      final bool isActive = info.activeSubscriptions.isNotEmpty || info.nonSubscriptionTransactions.isNotEmpty;
      if (kDebugMode) {
        print(
            'HELLO PURCHASE RESTORE ACTIVE isActive $isActive isPro $isPro sub ${info.activeSubscriptions} inApp ${info.nonSubscriptionTransactions} entitlements ${info.entitlements.active}');
      }
      isSubscribe.value = (isActive && isPro);
    } on PlatformException catch (e) {
      isPurchasing.value = false;
      // if (kDebugMode) {
      print('HELLO PURCHASE RESTORE ERROR [${e.code}] ${e.message}');
      // Get.snackbar('Something Went Wrong', 'You Have No Subscription....', borderRadius: 15, backgroundColor: pinkColor.withOpacity(.5));
      // }
    }
    isPurchasing.value = false;
    isSubscribe.isTrue
        ? Get.snackbar(
            'SuccessFully',
            'Your Subscription Restore SuccessFully....',
            borderRadius: 15,
            backgroundColor: pinkColor.withOpacity(.7),
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
          )
        : Get.snackbar('Something Went Wrong', 'You Have No Subscription....', borderRadius: 15, backgroundColor: pinkColor.withOpacity(.5));
    print('HELLO PURCHASE RESTORE isSubscribe $isSubscribe');
  }
}
