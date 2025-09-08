// card_user_lapangan.dart
import 'dart:convert';

SportCard sportCardFromJson(String str) => SportCard.fromJson(json.decode(str));
String sportCardToJson(SportCard data) => json.encode(data.toJson());

class SportCard {
  final String message;
  final List<Field> data;

  SportCard({required this.message, required this.data});

  factory SportCard.fromJson(Map<String, dynamic> json) => SportCard(
    message: (json["message"] ?? "").toString(),
    data: (json["data"] as List? ?? [])
        .map((x) => Field.fromJson(x as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class Field {
  final int id;
  final String name;
  final DateTime? createdAt; // <- nullable
  final DateTime? updatedAt; // <- nullable
  final String? imagePath; // <- nullable
  final String?
  pricePerHour; // <- nullable (kadang "200.0", kadang null/number)
  final String? imageUrl; // <- nullable

  Field({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
    this.imagePath,
    this.pricePerHour,
    this.imageUrl,
  });

  factory Field.fromJson(Map<String, dynamic> json) => Field(
    id: (json["id"] ?? 0) as int,
    name: (json["name"] ?? "").toString(),
    createdAt: json["created_at"] != null
        ? DateTime.tryParse(json["created_at"].toString())
        : null,
    updatedAt: json["updated_at"] != null
        ? DateTime.tryParse(json["updated_at"].toString())
        : null,
    imagePath: json["image_path"] as String?, // bisa null
    pricePerHour: json["price_per_hour"]?.toString(), // bisa number/string/null
    imageUrl: json["image_url"] as String?, // bisa null
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
}
