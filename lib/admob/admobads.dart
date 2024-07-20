import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';

import 'ads_manager.dart';

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

Future<void> appTracking() async {
  final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
  if (status == TrackingStatus.notDetermined) {
    await AppTrackingTransparency.requestTrackingAuthorization();
  } else if (status == TrackingStatus.denied) {
    await AppTrackingTransparency.requestTrackingAuthorization();
  }
  if (status == TrackingStatus.authorized) {
    await AppTrackingTransparency.getAdvertisingIdentifier();
  }
}
