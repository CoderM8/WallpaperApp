// To parse this JSON data, do
//
//     final searchGif = searchGifFromJson(jsonString);

import 'dart:convert';

Gif searchGifFromJson(String str) => Gif.fromJson(json.decode(str));

String searchGifToJson(Gif data) => json.encode(data.toJson());

class Gif {
  List<HdWallpaper>? hdWallpaper;

  Gif({
    this.hdWallpaper,
  });

  factory Gif.fromJson(Map<String, dynamic> json) => Gif(
        hdWallpaper: json["HD_WALLPAPER"] == null
            ? []
            : List<HdWallpaper>.from(
                json["HD_WALLPAPER"]!.map((x) => HdWallpaper.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "HD_WALLPAPER": hdWallpaper == null
            ? []
            : List<dynamic>.from(hdWallpaper!.map((x) => x.toJson())),
      };
}

class HdWallpaper {
  String? num;
  String? id;
  String? gifImage;
  String? gifTags;
  String? totalViews;
  String? totalRate;
  String? rateAvg;

  HdWallpaper({
    this.num,
    this.id,
    this.gifImage,
    this.gifTags,
    this.totalViews,
    this.totalRate,
    this.rateAvg,
  });

  factory HdWallpaper.fromJson(Map<String, dynamic> json) => HdWallpaper(
        num: json["num"],
        id: json["id"],
        gifImage: json["gif_image"],
        gifTags: json["gif_tags"],
        totalViews: json["total_views"],
        totalRate: json["total_rate"],
        rateAvg: json["rate_avg"],
      );

  Map<String, dynamic> toJson() => {
        "num": num,
        "id": id,
        "gif_image": gifImage,
        "gif_tags": gifTags,
        "total_views": totalViews,
        "total_rate": totalRate,
        "rate_avg": rateAvg,
      };
}
