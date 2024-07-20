// To parse this JSON data, do
//
//     final getHome = getHomeFromJson(jsonString);

import 'dart:convert';

GetHome getHomeFromJson(String str) => GetHome.fromJson(json.decode(str));

String getHomeToJson(GetHome data) => json.encode(data.toJson());

class GetHome {
  HdWallpaper? hdWallpaper;

  GetHome({
    this.hdWallpaper,
  });

  factory GetHome.fromJson(Map<String, dynamic> json) => GetHome(
        hdWallpaper: json["HD_WALLPAPER"] == null ? null : HdWallpaper.fromJson(json["HD_WALLPAPER"]),
      );

  Map<String, dynamic> toJson() => {
        "HD_WALLPAPER": hdWallpaper?.toJson(),
      };
}

class HdWallpaper {
  List<WallpaperColor>? wallpaperColors;
  List<Wallpaper>? featuredWallpaper;
  List<Wallpaper>? latestWallpaper;
  List<Wallpaper>? popularWallpaper;

  HdWallpaper({
    this.wallpaperColors,
    this.featuredWallpaper,
    this.latestWallpaper,
    this.popularWallpaper,
  });

  factory HdWallpaper.fromJson(Map<String, dynamic> json) => HdWallpaper(
        wallpaperColors: json["wallpaper_colors"] == null ? [] : List<WallpaperColor>.from(json["wallpaper_colors"]!.map((x) => WallpaperColor.fromJson(x))),
        featuredWallpaper: json["featured_wallpaper"] == null ? [] : List<Wallpaper>.from(json["featured_wallpaper"]!.map((x) => Wallpaper.fromJson(x))),
        latestWallpaper: json["latest_wallpaper"] == null ? [] : List<Wallpaper>.from(json["latest_wallpaper"]!.map((x) => Wallpaper.fromJson(x))),
        popularWallpaper: json["popular_wallpaper"] == null ? [] : List<Wallpaper>.from(json["popular_wallpaper"]!.map((x) => Wallpaper.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "wallpaper_colors": wallpaperColors == null ? [] : List<dynamic>.from(wallpaperColors!.map((x) => x.toJson())),
        "featured_wallpaper": featuredWallpaper == null ? [] : List<dynamic>.from(featuredWallpaper!.map((x) => x.toJson())),
        "latest_wallpaper": latestWallpaper == null ? [] : List<dynamic>.from(latestWallpaper!.map((x) => x.toJson())),
        "popular_wallpaper": popularWallpaper == null ? [] : List<dynamic>.from(popularWallpaper!.map((x) => x.toJson())),
      };
}

class Wallpaper {
  String? id;
  String? catId;
  WallpaperType? wallpaperType;
  String? wallpaperImage;
  String? totalViews;
  String? totalRate;
  String? rateAvg;
  bool? isFavorite;
  String? wallTags;
  String? isPaid;
  String? wallColors;
  String? cid;
  String? categoryName;
  String? categoryImage;

  Wallpaper({
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

  factory Wallpaper.fromJson(Map<String, dynamic> json) => Wallpaper(
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
        "id": id,
        "cat_id": catId,
        "wallpaper_type": wallpaperTypeValues.reverse[wallpaperType],
        "wallpaper_image": wallpaperImage,
        "total_views": totalViews,
        "total_rate": totalRate,
        "rate_avg": rateAvg,
        "is_paid": isPaid,
        "is_favorite": isFavorite,
        "wall_tags": wallTags,
        "wall_colors": wallColors,
        "cid": cid,
        "category_name": categoryName,
        "category_image": categoryImage,
      };
}

enum WallpaperType {
  PORTRAIT,
  Landscape,
  Square,
}

final wallpaperTypeValues = EnumValues({
  "Portrait": WallpaperType.PORTRAIT,
  "Landscape": WallpaperType.Landscape,
  "Square": WallpaperType.Square,
});

class WallpaperColor {
  String? colorId;
  String? colorName;
  String? colorCode;

  WallpaperColor({
    this.colorId,
    this.colorName,
    this.colorCode,
  });

  factory WallpaperColor.fromJson(Map<String, dynamic> json) => WallpaperColor(
        colorId: json["color_id"],
        colorName: json["color_name"],
        colorCode: json["color_code"],
      );

  Map<String, dynamic> toJson() => {
        "color_id": colorId,
        "color_name": colorName,
        "color_code": colorCode,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
