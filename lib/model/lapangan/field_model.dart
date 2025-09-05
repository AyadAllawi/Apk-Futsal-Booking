import 'dart:convert';

FieldModel fieldFromJson(String str) => FieldModel.fromJson(json.decode(str));

String fieldToJson(FieldModel data) => json.encode(data.toJson());

class FieldModel {
  final bool? success;
  final String? message;
  final List<Datum>? data;

  FieldModel({this.success, this.message, this.data});

  factory FieldModel.fromJson(Map<String, dynamic> json) => FieldModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  final int? id;
  final String? name;
  final String? pricePerHour;
  final String? imageUrl;
  final String? imagePath;

  Datum({this.id, this.name, this.pricePerHour, this.imageUrl, this.imagePath});

  /// ✅ copyWith supaya bisa update field tanpa bikin object baru
  Datum copyWith({
    int? id,
    String? name,
    String? pricePerHour,
    String? imageUrl,
    String? imagePath,
  }) {
    return Datum(
      id: id ?? this.id,
      name: name ?? this.name,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    pricePerHour: json["price_per_hour"]?.toString(),
    imageUrl: json["image_url"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price_per_hour": pricePerHour,
    "image_url": imageUrl,
    "image_path": imagePath,
  };
}
