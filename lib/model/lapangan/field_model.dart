// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Field {
  final int id;
  final String nama;
  final String alamat;
  final double rating;
  final int jumlahRating;
  final double harga;
  final double jarak;
  final int availableSlot;
  final String? imagePath;

  String pricePerHour;

  Field({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.rating,
    required this.jumlahRating,
    required this.harga,
    required this.jarak,
    required this.availableSlot,
    this.imagePath,
    required this.pricePerHour,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      jumlahRating: json['jumlah_rating'] ?? 0,
      harga: (json['harga'] ?? 0).toDouble(),
      jarak: (json['jarak'] ?? 0).toDouble(),
      availableSlot: json['available_slot'] ?? 0,
      imagePath: json['image_path'],
      pricePerHour: json['price_per_hour'] ?? '',
    );
  }

  Field copyWith({
    int? id,
    String? nama,
    String? alamat,
    double? rating,
    int? jumlahRating,
    double? harga,
    double? jarak,
    int? availableSlot,
    String? imagePath,
    String? pricePerHour,
  }) {
    return Field(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      rating: rating ?? this.rating,
      jumlahRating: jumlahRating ?? this.jumlahRating,
      harga: harga ?? this.harga,
      jarak: jarak ?? this.jarak,
      availableSlot: availableSlot ?? this.availableSlot,
      imagePath: imagePath ?? this.imagePath,
      pricePerHour: pricePerHour ?? this.pricePerHour,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'rating': rating,
      'jumlahRating': jumlahRating,
      'harga': harga,
      'jarak': jarak,
      'availableSlot': availableSlot,
      'imagePath': imagePath,
      'pricePerHour': pricePerHour,
    };
  }

  factory Field.fromMap(Map<String, dynamic> map) {
    return Field(
      id: map['id'] as int,
      nama: map['nama'] as String,
      alamat: map['alamat'] as String,
      rating: map['rating'] as double,
      jumlahRating: map['jumlahRating'] as int,
      harga: map['harga'] as double,
      jarak: map['jarak'] as double,
      availableSlot: map['availableSlot'] as int,
      imagePath: map['imagePath'] != null ? map['imagePath'] as String : null,
      pricePerHour: map['pricePerHour'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Field.fromJsonString(String source) =>
      Field.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Field(id: $id, nama: $nama, alamat: $alamat, rating: $rating, jumlahRating: $jumlahRating, harga: $harga, jarak: $jarak, availableSlot: $availableSlot, imagePath: $imagePath, pricePerHour: $pricePerHour)';
  }

  @override
  bool operator ==(covariant Field other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nama == nama &&
        other.alamat == alamat &&
        other.rating == rating &&
        other.jumlahRating == jumlahRating &&
        other.harga == harga &&
        other.jarak == jarak &&
        other.availableSlot == availableSlot &&
        other.imagePath == imagePath &&
        other.pricePerHour == pricePerHour;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nama.hashCode ^
        alamat.hashCode ^
        rating.hashCode ^
        jumlahRating.hashCode ^
        harga.hashCode ^
        jarak.hashCode ^
        availableSlot.hashCode ^
        imagePath.hashCode ^
        pricePerHour.hashCode;
  }
}
