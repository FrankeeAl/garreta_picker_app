import 'package:flutter/widgets.dart';

class HatsShelf with ChangeNotifier {
  HatsShelf({
    this.hatsShelf,
  });

  final Map<String, HatsShelf>? hatsShelf;

  factory HatsShelf.fromJson(Map<String, dynamic> json) => HatsShelf(
        hatsShelf: Map.from(json["hatsShelf"]).map(
            (k, v) => MapEntry<String, HatsShelf>(k, HatsShelf.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "hatsShelf": Map.from(hatsShelf!)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class HatsShelves with ChangeNotifier {
  final String? code;
  final String? items;
  final int? order;

  HatsShelves({
    this.code,
    this.items,
    this.order,
  });

  factory HatsShelves.fromJson(Map<String, dynamic> json) => HatsShelves(
        code: json["code"],
        items: json["items"],
        order: json["order"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "items": items,
        "order": order,
      };
}

class BottomsShelf with ChangeNotifier {
  BottomsShelf({
    this.bottomsShelf,
  });

  final Map<String, BottomsShelf>? bottomsShelf;

  factory BottomsShelf.fromJson(Map<String, dynamic> json) => BottomsShelf(
        bottomsShelf: Map.from(json["bottomsShelf"]).map((k, v) =>
            MapEntry<String, BottomsShelf>(k, BottomsShelf.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "bottomsShelf": Map.from(bottomsShelf!)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class BottomsShelves with ChangeNotifier {
  final String? code;
  final String? items;
  final int? order;

  BottomsShelves({
    this.code,
    this.items,
    this.order,
  });

  factory BottomsShelves.fromJson(Map<String, dynamic> json) => BottomsShelves(
        code: json["code"],
        items: json["items"],
        order: json["order"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "items": items,
        "order": order,
      };
}

class TopsShelf with ChangeNotifier {
  TopsShelf({
    this.topsShelf,
  });

  final Map<String, TopsShelf>? topsShelf;

  factory TopsShelf.fromJson(Map<String, dynamic> json) => TopsShelf(
        topsShelf: Map.from(json["topsShelf"]).map(
            (k, v) => MapEntry<String, TopsShelf>(k, TopsShelf.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "topsShelf": Map.from(topsShelf!)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class TopsShelves with ChangeNotifier {
  TopsShelves({
    this.code,
    this.items,
    this.order,
  });

  final String? code;
  final String? items;
  final int? order;

  factory TopsShelves.fromRTDB(Map<String, dynamic> json) => TopsShelves(
        code: json["code"],
        items: json["items"],
        order: json["order"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "items": items,
        "order": order,
      };
}
