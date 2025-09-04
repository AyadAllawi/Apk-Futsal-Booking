// To parse this JSON data, do
//
//     final field = fieldFromJson(jsonString);

import 'dart:convert';

Field fieldFromJson(String str) => Field.fromJson(json.decode(str));

String fieldToJson(Field data) => json.encode(data.toJson());

class Field {
  String? message;
  List<Datum>? data;

  Field({this.message, this.data});

  factory Field.fromJson(Map<String, dynamic> json) => Field(
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? imagePath;
  String? pricePerHour;
  String? imageUrl;
  String get nama => name ?? '';
  String get alamat => "Alamat default"; // Default value
  double get rating => 0.0; // Default value
  int get jumlahRating => 0; // Default value
  double get harga =>
      double.tryParse(pricePerHour ?? '0') ??
      0; // Convert pricePerHour to double
  double get jarak => 0.0; // Default value
  int get availableSlot => 0; // Default value

  Datum({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.imagePath,
    this.pricePerHour,
    this.imageUrl,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    imagePath: json["image_path"],
    pricePerHour: json["price_per_hour"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "image_path": imagePath,
    "price_per_hour": pricePerHour,
    "image_url": imageUrl,
  };
  Datum copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imagePath,
    String? pricePerHour,
    String? imageUrl,
  }) {
    return Datum(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imagePath: imagePath ?? this.imagePath,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
