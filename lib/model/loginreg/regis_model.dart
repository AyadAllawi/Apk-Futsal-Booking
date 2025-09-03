// To parse this JSON data, do
//
//     final register = registerFromJson(jsonString);

import 'dart:convert';

RegisFutsal registerFutsalFromJson(String str) =>
    RegisFutsal.fromJson(json.decode(str));

String registerFutsalToJson(RegisFutsal data) => json.encode(data.toJson());

class RegisFutsal {
  String? message;
  Data? data;

  RegisFutsal({this.message, this.data});

  factory RegisFutsal.fromJson(Map<String, dynamic> json) => RegisFutsal(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  String? token;
  User? user;

  Data({this.token, this.user});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {"token": token, "user": user?.toJson()};
}

class User {
  String? name;
  String? email;
  String? updatedAt;
  String? createdAt;
  int? id;

  User({this.name, this.email, this.updatedAt, this.createdAt, this.id});

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    email: json["email"],
    updatedAt: json["updated_at"],
    createdAt: json["created_at"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "updated_at": updatedAt,
    "created_at": createdAt,
    "id": id,
  };
}
