// To parse this JSON data, do
//
//     final getWallpaperList = getWallpaperListFromJson(jsonString);

import 'dart:convert';

GetWallpaperList getWallpaperListFromJson(String str) => GetWallpaperList.fromJson(json.decode(str));

String getWallpaperListToJson(GetWallpaperList data) => json.encode(data.toJson());

class GetWallpaperList {
  List<HdWallpaper>? hdWallpaper;

  GetWallpaperList({
    this.hdWallpaper,
  });

  factory GetWallpaperList.fromJson(Map<String, dynamic> json) => GetWallpaperList(
        hdWallpaper: json["HD_WALLPAPER"] == null ? [] : List<HdWallpaper>.from(json["HD_WALLPAPER"]!.map((x) => HdWallpaper.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "HD_WALLPAPER": hdWallpaper == null ? [] : List<dynamic>.from(hdWallpaper!.map((x) => x.toJson())),
      };
}

class HdWallpaper {
  String? num;
  String? id;
  String? catId;
  WallpaperType? wallpaperType;
  String? wallpaperImage;
  String? totalViews;
  String? totalRate;
  String? isPaid;
  String? rateAvg;
  bool? isFavorite;
  String? wallTags;
  String? wallColors;
  String? cid;
  String? categoryName;
  String? categoryImage;

  HdWallpaper({
    this.num,
    this.id,
    this.catId,
    this.wallpaperType,
    this.wallpaperImage,
    this.totalViews,
    this.totalRate,
    this.isPaid,
    this.rateAvg,
    this.isFavorite,
    this.wallTags,
    this.wallColors,
    this.cid,
    this.categoryName,
    this.categoryImage,
  });

  factory HdWallpaper.fromJson(Map<String, dynamic> json) => HdWallpaper(
        num: json["num"],
        id: json["id"],
        catId: json["cat_id"],
        wallpaperType: wallpaperTypeValues.map[json["wallpaper_type"]]!,
        wallpaperImage: json["wallpaper_image"],
        totalViews: json["total_views"],
        totalRate: json["total_rate"],
        isPaid: json["is_paid"],
        rateAvg: json["rate_avg"],
        isFavorite: json["is_favorite"],
        wallTags: json["wall_tags"],
        wallColors: json["wall_colors"],
        cid: json["cid"],
        categoryName: json["category_name"],
        categoryImage: json["category_image"],
      );

  Map<String, dynamic> toJson() => {
        "num": num,
        "id": id,
        "cat_id": catId,
        "wallpaper_type": wallpaperTypeValues.reverse[wallpaperType],
        "wallpaper_image": wallpaperImage,
        "total_views": totalViews,
        "total_rate": totalRate,
        "is_paid": isPaid,
        "rate_avg": rateAvg,
        "is_favorite": isFavorite,
        "wall_tags": wallTags,
        "wall_colors": wallColors,
        "cid": cid,
        "category_name": categoryName,
        "category_image": categoryImage,
      };
}

enum WallpaperType { LANDSCAPE, PORTRAIT, SQUARE }

final wallpaperTypeValues = EnumValues({"Landscape": WallpaperType.LANDSCAPE, "Portrait": WallpaperType.PORTRAIT, "Square": WallpaperType.SQUARE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
