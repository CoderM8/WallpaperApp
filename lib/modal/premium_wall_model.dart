// To parse this JSON data, do
//
//     final premiumWallpaperList = premiumWallpaperListFromJson(jsonString);

import 'dart:convert';

PremiumWallpaperList premiumWallpaperListFromJson(String str) => PremiumWallpaperList.fromJson(json.decode(str));

String premiumWallpaperListToJson(PremiumWallpaperList data) => json.encode(data.toJson());

class PremiumWallpaperList {
  List<HdWallpaper>? hdWallpaper;

  PremiumWallpaperList({
    this.hdWallpaper,
  });

  factory PremiumWallpaperList.fromJson(Map<String, dynamic> json) => PremiumWallpaperList(
        hdWallpaper: json["HD_WALLPAPER"] == null ? [] : List<HdWallpaper>.from(json["HD_WALLPAPER"]!.map((x) => HdWallpaper.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "HD_WALLPAPER": hdWallpaper == null ? [] : List<dynamic>.from(hdWallpaper!.map((x) => x.toJson())),
      };
}

class HdWallpaper {
  String? num;
  String? id;
  String? premiumName;
  String? premiumImage;
  String? isPaid;
  String? premiumImageThumbs;
  String? pStatus;
  String? premiumView;
  String? premiumDownload;

  HdWallpaper({
    this.num,
    this.id,
    this.premiumName,
    this.premiumImage,
    this.isPaid,
    this.premiumImageThumbs,
    this.pStatus,
    this.premiumView,
    this.premiumDownload,
  });

  factory HdWallpaper.fromJson(Map<String, dynamic> json) => HdWallpaper(
        num: json["num"],
        id: json["id"],
        premiumName: json["premium_name"],
        premiumImage: json["premium_image"],
        isPaid: json["is_paid"],
        premiumImageThumbs: json["premium_image_thumbs"],
        pStatus: json["p_status"],
        premiumView: json["premium_view"],
        premiumDownload: json["premium_download"],
      );

  Map<String, dynamic> toJson() => {
        "num": num,
        "id": id,
        "premium_name": premiumName,
        "premium_image": premiumImage,
        "is_paid": isPaid,
        "premium_image_thumbs": premiumImageThumbs,
        "p_status": pStatus,
        "premium_view": premiumView,
        "premium_download": premiumDownload,
      };
}
