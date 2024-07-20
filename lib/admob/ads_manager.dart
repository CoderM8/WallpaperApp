import 'dart:io';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';

String googleAppId = '';
String facebookAppId = '';

String? googleBannerAndroid;
String googleBannerIOS = '';
String? facebookBannerAndroid;
String facebookBannerIOS = '';

String? googleInterstitialAndroid;
String googleInterstitialIOS = '';
String? facebookInterstitialAndroid;
String facebookInterstitialIOS = '';

String? googleRewardedAndroid;
String googleRewardedIOS = '';
String? facebookRewardedAndroid;
String facebookRewardedIOS = '';

class AdsTestAdIdManager extends IAdIdManager {
  AdsTestAdIdManager();

  @override
  AppAdIds? get fbAdIds => AppAdIds(
        appId: facebookAppId,
        bannerId: Platform.isIOS ? facebookBannerIOS : facebookBannerAndroid,
        interstitialId: Platform.isIOS ? facebookInterstitialIOS : facebookInterstitialAndroid,
        rewardedId: Platform.isIOS ? facebookRewardedIOS : facebookRewardedAndroid,
      );

  @override
  AppAdIds? get admobAdIds => AppAdIds(
        appId: googleAppId,
        bannerId: Platform.isIOS ? googleBannerIOS : googleBannerAndroid,
        interstitialId: Platform.isIOS ? googleInterstitialIOS : googleInterstitialAndroid,
        rewardedId: Platform.isIOS ? googleRewardedIOS : googleRewardedAndroid,
      );

  @override
  AppAdIds? get unityAdIds => null;

  @override
  AppAdIds? get appLovinAdIds => null;
}

/// Banner Ads
Widget bannerAds() {
  return EasySmartBannerAd(
    priorityAdNetworks: [AdNetwork.facebook, AdNetwork.admob],
    adSize: AdSize.banner,
  );
}

/// Interstitial & Rewarded Ads
void showAd(AdUnitType adUnitType) {
  if (adUnitType == AdUnitType.interstitial) {
    if (EasyAds.instance.showAd(adUnitType, adNetwork: AdNetwork.facebook))
      ;
    else
      EasyAds.instance.showAd(adUnitType, adNetwork: AdNetwork.admob);
  } else if (adUnitType == AdUnitType.rewarded) {
    if (EasyAds.instance.showAd(adUnitType, adNetwork: AdNetwork.facebook))
      ;
    else
      EasyAds.instance.showAd(adUnitType, adNetwork: AdNetwork.admob);
  }
}
