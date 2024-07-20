import 'dart:convert';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:wallpapers_hd/constant.dart';
import 'package:wallpapers_hd/controller/Gif/gif_controller.dart';
import 'package:wallpapers_hd/controller/search/searchcontroller.dart';
import 'package:wallpapers_hd/modal/get_category.dart';
import 'package:wallpapers_hd/modal/popular_section_model.dart';
import 'package:wallpapers_hd/modal/premium_wall_model.dart';
import 'package:wallpapers_hd/modal/search_gif_model.dart';

import '../controller/home/homecontroller.dart';
import '../firebase_options.dart';
import '../modal/get_home_model.dart';
import '../modal/get_wallpaper_list.dart';
import '../modal/popular_section_wallpaper_list_model.dart';

class Apis {
  Future<void> initOneSignalNotification() async {
    bool _requireConsent = false;

    final String oneSignalAppId = "8d8a2804-5e50-4704-81de-d59762f3dea5";
    OneSignal.initialize(oneSignalAppId);
    OneSignal.Debug.setLogLevel(OSLogLevel.debug);

    OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.consentRequired(_requireConsent);
    OneSignal.Notifications.clearAll();

    OneSignal.User.pushSubscription.addObserver((state) {
      print(OneSignal.User.pushSubscription.optedIn);
      print(OneSignal.User.pushSubscription.id);
      print(OneSignal.User.pushSubscription.token);
      print(state.current.jsonRepresentation());
    });

    OneSignal.User.addObserver((state) {
      var userState = state.jsonRepresentation();
      print('OneSignal user changed: $userState');
    });

    OneSignal.Notifications.addPermissionObserver((state) {
      print("Has permission " + state.toString());
    });
  }

  Future<void> initFirebase() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    /// automatically get breadcrumb logs to understand user actions leading up to a crash, non-fatal, or ANR event
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    /// This data can help you understand basic interactions, such as how many times your app was opened, and how many users were active in a chosen time period.
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  }

  void getUserSearch({required String text}) async {
    try {
      final response = await http.post(mainApi, body: {'data': '{"method_name":"search_wallpaper","package_name":"com.example.wallpapers_hd","search_text":"$text"}'});
      print('SEARCH [${response.statusCode}]');
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["HD_WALLPAPER"];
      }
    } catch (e) {
      print('SEARCH EXCEPTION $e');
    }
  }

  void getSingleWallPaper(String id) async {
    try {
      final response = await http.post(mainApi, body: {'data': '{"method_name":"get_single_wallpaper","package_name":"com.eng.hdwallpaper","wallpaper_id":"$id","user_id":"$userId"}'});
      print('SEARCH [${response.statusCode}]');
      if (response.statusCode == 200) {
        homeController.getSingleWallpaper.value = GetWallpaperList.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('SEARCH EXCEPTION $e');
    }
  }

  void getSingleGif(String id) async {
    try {
      final response = await http.post(mainApi, body: {'data': '{"method_name":"get_single_gif","package_name":"com.eng.hdwallpaper","gif_id":"$id","user_id":"$userId"}'});
      print('SEARCH [${response.statusCode}]');
      if (response.statusCode == 200) {
        gifController.getSingleGif.value = Gif.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('SEARCH EXCEPTION $e');
    }
  }

  void rate({required String id, required String rate, required bool isGif}) async {
    try {
      final response = await http
          .post(mainApi, body: {'data': '{"method_name":"${isGif == true ? "gif_rate" : "wallpaper_rate"}","package_name":"com.eng.hdwallpaper","user_id":"$userId","post_id":"$id","rate":"$rate"}'});
      if (response.statusCode == 200) {
        print('MSG ratting ===> ${jsonDecode(response.body)['HD_WALLPAPER'][0]['MSG']}');
        showToast(message: jsonDecode(response.body)['HD_WALLPAPER'][0]['MSG']);
      }
    } catch (e) {
      print('SEARCH EXCEPTION $e');
    }
  }

  void download({required String id, required bool isGif}) async {
    try {
      final response = await http.post(mainApi,
          body: {'data': '{"method_name":"${isGif == true ? "download_gif" : "download_wallpaper"}","package_name":"com.eng.hdwallpaper","${isGif == true ? "gif_id" : "wallpaper_id"}":"$id"}'});
      if (response.statusCode == 200) {
        print('MSG ratting ===> ${jsonDecode(response.body)['HD_WALLPAPER'][0]['MSG']}');
      }
    } catch (e) {
      print('SEARCH EXCEPTION $e');
    }
  }

  void getCategoryById({
    required String cid,
    required String Page,
    required ImageOrientation type,
  }) async {
    try {
      final response = await http.post(mainApi,
          body: {'data': '{"method_name":"get_wallpaper_by_cat_id","package_name":"com.eng.hdwallpaper","page":"$Page","cat_id":"$cid","type":"${orientationStringMap[type]}","user_id":"$userId"}'});
      print('CATEGORY BY ID [${response.statusCode}]');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        homeController.getColorWallPapers.value = GetWallpaperList.fromJson(data);
        homeController.getColorWallPapers.value.hdWallpaper?.forEach((element) {
          homeController.getColorWallPapersList.add(element);
        });
        homeController.getColorWallPapers.refresh();

        print('catList  ==============> ${homeController.getColorWallPapersList}');
      } else {}
    } catch (e) {
      print('CATEGORY BY ID EXCEPTION $e');
    }
    isLoadingGetWallpapers.value = false;
  }

  void getCategory() async {
    try {
      final response = await http.post(mainApi, body: {'data': '{"method_name":"get_category","package_name":"com.eng.hdwallpaper"}'});
      print('get CATEGORY[${response.statusCode}]');
      if (response.statusCode == 200) {
        homeController.getCatGory.value = GetCategory.fromJson(jsonDecode(response.body));
        homeController.getCatGory.value.hdWallpaper?.forEach((element) {
          homeController.getCatGoryList.add(element);
        });
      }
    } catch (e) {
      print('CATEGORY BY ID EXCEPTION $e');
    }
  }

  //
  // /// GIF
  void getUserSearchGif({required String text, required String Page}) async {
    try {
      final response = await http.post(mainApi, body: {'data': '{"method_name":"search_gif","package_name":"com.eng.hdwallpaper","page":"$Page","gif_search_text":"$text","user_id":"$userId"}'});
      print('SEARCH GIF [${response.statusCode}]');
      if (response.statusCode == 200) {
        searchController.searchGif.value = Gif.fromJson(jsonDecode(response.body));

        searchController.searchGif.value.hdWallpaper?.forEach((element) {
          searchController.searchGifList.add(element);
        });
      }
      searchController.searchGif.refresh();
    } catch (e) {
      print('SEARCH GIF EXCEPTION $e');
    }
  }

  void getUserSearchWallpaper({
    required String text,
    required String Page,
    required ImageOrientation type,
  }) async {
    try {
      Map<String, dynamic> body = {
        'data': '{"method_name":"search_wallpaper","package_name":"com.eng.hdwallpaper","page":"$Page","search_text":"$text","type":"${orientationStringMap[type]}","user_id":"$userId"}'
      };
      final response = await http.post(mainApi, body: body);
      print('this is search wallpaper data body ====> $body');
      print('SEARCH Wallpaper [${response.statusCode}]');
      if (response.statusCode == 200) {
        searchController.searchWallPaper.value = GetWallpaperList.fromJson(jsonDecode(response.body));

        searchController.searchWallPaper.value.hdWallpaper?.forEach((element) {
          searchController.searchWallpaperList.add(element);
        });
      }
      searchController.searchWallPaper.refresh();
    } catch (e) {
      print('SEARCH GIF EXCEPTION $e');
    }
  }

  void getLatestGif({required String Page}) async {
    try {
      final response = await http.post(mainApi, body: {'data': '{"method_name":"get_latest_gif","package_name":"com.eng.hdwallpaper","page":"$Page","user_id":"$userId"}'});
      print('LATEST GIF [${response.statusCode}]');
      if (response.statusCode == 200) {
        gifController.latestGif.value = Gif.fromJson(jsonDecode(response.body));
        gifController.latestGif.value.hdWallpaper?.forEach((element) {
          gifController.latestGifList.add(element);
        });
      }
    } catch (e) {
      print('LATEST GIF EXCEPTION $e');
    }
  }

  void getAllGif({required String Page}) async {
    try {
      final response = await http.post(mainApi, body: {'data': '{"method_name":"get_gif_list","package_name":"com.eng.hdwallpaper","page":"$Page","user_id":"$userId"}'});
      print('LATEST GIF [${response.statusCode}]');
      if (response.statusCode == 200) {
        gifController.allGif.value = Gif.fromJson(jsonDecode(response.body));
        gifController.allGif.value.hdWallpaper?.forEach((element) {
          gifController.allGifList.add(element);
        });
      }
    } catch (e) {
      print('LATEST GIF EXCEPTION $e');
    }
  }

  Future<String> getHomeApi({
    required String Page,
    required ImageOrientation type,
  }) async {
    try {
      var body = {'data': '{"method_name":"get_home","package_name":"com.eng.hdwallpaper","page":"$Page","type":"${orientationStringMap[type]}","user_id":$userId}'};

      final response = await http.post(mainApi, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        homeController.getHome.value = GetHome.fromJson(data);

        homeController.getHome.value.hdWallpaper!.wallpaperColors?.forEach((element) {
          homeController.wallpaperColors.add(element);
        });

        homeController.getHome.value.hdWallpaper!.featuredWallpaper?.forEach((element) {
          homeController.featuredWallpaper.add(element);
        });

        homeController.getHome.value.hdWallpaper!.latestWallpaper?.forEach((element) {
          homeController.latestWallpaper.add(element);
        });

        homeController.getHome.value.hdWallpaper!.popularWallpaper?.forEach((element) {
          homeController.popularWallpaper.add(element);
        });
        homeController.getHome.refresh();
      }
      return response.body;
    } catch (e) {}
    return '';
  }

  void getWallpaper({
    required String Page,
  }) async {
    try {
      var body = {'data': '{"method_name":"get_wallpaper","package_name":"com.eng.hdwallpaper","page":"$Page","user_id":"$userId"}'};
      final response = await http.post(mainApi, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        homeController.getWallPaper.value = GetWallpaperList.fromJson(data);
        homeController.getWallPaper.value.hdWallpaper?.forEach((element) {
          homeController.getWallPaperList.add(element);
        });
        homeController.getWallPaper.refresh();
      }
    } catch (e) {
      print('error =========> $e');
    }
  }

  void get_wallpaper_by_color_id({
    required String Page,
    required ImageOrientation type,
    required String colorId,
  }) async {
    try {
      var body = {
        'data': '{"method_name":"get_wallpaper_by_color_id","package_name":"com.eng.hdwallpaper","page":"$Page","color_id":"${colorId}","type":"${orientationStringMap[type]}","user_id":"$userId"}'
      };
      final response = await http.post(mainApi, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        homeController.getColorWallPapers.value = GetWallpaperList.fromJson(data);
        homeController.getColorWallPapers.value.hdWallpaper?.forEach((element) {
          homeController.getColorWallPapersList.add(element);
        });
        homeController.getColorWallPapers.refresh();
        print('colorList ==============> ${homeController.getColorWallPapersList}');
      }
    } catch (e) {
      print('error =========> $e');
    }
    isLoadingGetWallpapers.value = false;
  }

  void getPopularSection({
    required String Page,
    String? id,
  }) async {
    try {
      var body = {'data': '{"method_name":"get_sections_list","package_name":"com.eng.hdwallpaper","page":"$Page","popular_id":$id}'};
      final response = await http.post(mainApi, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        PopularSectionModel.fromJson(data).hdWallpaper?.forEach((element) {
          homeController.getPopularSectionList.add(element);
        });
      }
    } catch (e) {
      print('error =========> $e');
    }
  }

  void get_popular_wallpaper_list({
    required String Page,
    String? id,
  }) async {
    homeController.getPopularSingleWallpaper.value.hdWallpaper?.clear();
    try {
      var body = {'data': '{"method_name":"get_popular_wallpaper_list","package_name":"com.eng.hdwallpaper","page":"$Page","wall_id":$id}'};
      final response = await http.post(mainApi, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        homeController.getPopularSingleWallpaper.value = PopularWallPaperListModel.fromJson(data);
      }
    } catch (e) {
      print('error =========> $e');
    }
  }

  void getPopularSectionWallpaperList({
    required String Page,
    required String id,
  }) async {
    try {
      var body = {'data': '{"method_name":"section_wallpaper_list","package_name":"com.eng.hdwallpaper","page":"$Page","section_id":"$id"}'};
      final response = await http.post(mainApi, body: body);
      if (response.statusCode == 200) {
        print('helo 00 ===> ${isLoadingGetWallpapers.value}');
        var data = jsonDecode(response.body);
        PopularWallPaperListModel.fromJson(data).hdWallpaper?.forEach((element) {
          homeController.getPopularSectionWallpaperList.add(element);
        });
      }
      isLoadingGetWallpapers.value = false;
    } catch (e) {
      print('error =========> $e');
    }
  }

  void get_premium_list({
    required String Page,
    required String id,
  }) async {
    try {
      var body = {'data': '{"method_name":"get_premium_list","package_name":"com.eng.hdwallpaper","page":"$Page","premium_id":"$id"}'};
      final response = await http.post(mainApi, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        homeController.getPremiumWallpaper.value = PremiumWallpaperList.fromJson(data);
        if (id == '') {
          homeController.getPremiumWallpaper.value.hdWallpaper?.forEach((element) {
            homeController.getPremiumWallpaperList.add(element);
          });
        }
        isLoadingGetWallpapers.value = false;
        print('isLoadingGetWallpapers.value ======> ${isLoadingGetWallpapers.value}');
      }
    } catch (e) {
      print('error =========> $e');
    }
  }
}
