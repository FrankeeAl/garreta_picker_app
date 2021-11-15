import 'package:flutter/widgets.dart';

class Product with ChangeNotifier {
  final String? id;
  final String? barcode;
  final String? brand;
  final String? category;
  final String? description;
  final int? discountedPrice;
  final String? imageUrl;
  final int? maxQtyStore;
  final int? minQtyStore;
  final int? qtyCeiling;
  final int? qtyOnHand;
  final String? rack;
  final int? rateItem;
  final int? reOrderLevel;
  final String? sellerId;
  final double? sellingPrice;
  final String? shelf;
  final String? smsCode;
  final String? title;
  final String? unit;
  final String? weight;
  bool isSelected = false;

  Product(
      {this.id,
      this.barcode,
      this.brand,
      this.category,
      this.description,
      this.discountedPrice,
      this.imageUrl,
      this.maxQtyStore,
      this.minQtyStore,
      this.qtyCeiling,
      this.qtyOnHand,
      this.rack,
      this.rateItem,
      this.reOrderLevel,
      this.sellerId,
      this.sellingPrice,
      this.shelf,
      this.smsCode,
      this.title,
      this.unit,
      this.weight,
      this.isSelected = false});

  factory Product.fromRTDB(Map<String, dynamic> json) {
    return Product(
      id: json['name'],
      barcode: json['barcode'],
      brand: json['brand'],
      category: json['category'],
      description: json['description'],
      discountedPrice: json['discountedPrice'],
      imageUrl: json['imageUrl'],
      maxQtyStore: json['maxQtyStore'],
      minQtyStore: json['minQtyStore'],
      qtyCeiling: json['qtyCeiling'],
      qtyOnHand: json['qtyOnHand'],
      rack: json['rack'],
      rateItem: json['rateItem'],
      reOrderLevel: json['reOrderLevel'],
      sellerId: json['sellerId'],
      sellingPrice: json['sellingPrice'],
      shelf: json['shelf'],
      smsCode: json['smsCode'],
      title: json['title'],
      unit: json['unit'],
      weight: json['weight'],
    );
  }
}
