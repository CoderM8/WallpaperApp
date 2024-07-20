import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'package:wallpapers_hd/constant.dart';
import 'ads_manager.dart';

String interstitialIdIosClick = '';
bool isBannerAds = false;
bool isRewardedAds = false;
bool isInterstitialAds = false;

String appShare = Platform.isAndroid ? 'https://play.google.com/store/apps/details?id=com.example.wallpapers_hd' : 'https://apps.apple.com/in/app/wallplix-4k-ultra-hd-wallpaper/id1571443972';
String appRate = Platform.isAndroid ? 'https://play.google.com/store/apps/details?id=com.example.wallpapers_hd' : 'https://itunes.apple.com/app/id1571443972?action=write-review';
String? appPolicy;
String? appAbout;
String? appTerms;
RxInt clickCount = 0.obs;
RxBool isLoopActive = false.obs;

void showInterstitialAdOnClickEvent() {
  if (clickCount.value == int.parse(Platform.isIOS ? interstitialIdIosClick : '0')) {
    Random r = new Random();

    if (r.nextBool() == true) {
      print('hello how are show ad ====> 0');
      showAd(AdUnitType.interstitial);
    } else {
      print('hello how are show ad ====> 1');

      showAd(AdUnitType.rewarded);
    }

    isLoopActive.value = true;
    clickCount.value = 0;
  } else {
    clickCount.value++;
  }
} // Update UI after state changes

class AdManager {
  static Future<void> getIds() async {
    final response = await http.post(mainApi, body: {"data": '{"method_name": "get_app_details", "package_name": "com.example.wallpapers_hd"}'});
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = json['HD_WALLPAPER'][0];
      appPolicy = data['app_privacy_policy'] ?? '';
      appAbout = data['app_description'] ?? '';
      appTerms = data['app_terms_and_conditions'] ?? '';
      if (data['showAds'] == '1') {
        interstitialIdIosClick = data['interstital_click'];
        isBannerAds = data['ios_banner_ad_id_status'] == '0' ? false : true;
        isRewardedAds = data['rewarded_ios_status'] == '0' ? false : true;
        isInterstitialAds = data['ios_interstital_ad_id_status'] == '0' ? false : true;
        googleAppId = data['publisher_id'];
        facebookAppId = data['f_publisher_id'];
        if (isBannerAds == true) {
          googleBannerIOS = data['banner_ad_id_ios'];
          facebookBannerIOS = data['f_banner_ad_id_ios'];
        }
        if (isInterstitialAds == true) {
          googleInterstitialIOS = data['interstital_ad_id_ios'];
          facebookInterstitialIOS = data['f_interstital_ad_id_ios'];
        }
        if (isRewardedAds == true) {
          googleRewardedIOS = data['rewarded_ios'];
          facebookRewardedIOS = data['f_rewarded_ios'];
        }
      }
    }
  }
}
