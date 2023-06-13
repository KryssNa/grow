// To parse this JSON data, do
//
//     final ItemModel = ItemModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ItemModel? ItemModelFromJson(String str) => ItemModel.fromJson(json.decode(str));

String ItemModelToJson(ItemModel? data) => json.encode(data!.toJson());

class ItemModel {
  ItemModel({
    this.ItemId,
    this.ItemName,
    this.description,
    this.price,
    this.imagepath,
    this.imageUrl,
  });

  String? ItemId;
  String? ItemName;
  String? description;
  String? price;
  String? imagepath;
  String? imageUrl;

  factory ItemModel.fromJson(
      Map<String, dynamic> json) => ItemModel(
    ItemId: json["Item_id"],
    ItemName: json["Item_name"],
    description: json["description"],
    price: json["price"],
    imagepath: json["imagepath"],
    imageUrl: json["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "Item_id": ItemId,
    "Item_name": ItemName,
    "description": description,
    "price": price,
    "imagepath": imagepath,
    "imageUrl": imageUrl,
  };
  factory ItemModel.fromFirebaseSnapshot(
      DocumentSnapshot<Map<String, dynamic>> json) => ItemModel(
  ItemId: json.id,
  ItemName: json["Item_name"],
  description: json["description"],
  price: json["price"],
  imagepath: json["imagepath"],
  imageUrl: json["imageUrl"],
  );
}
