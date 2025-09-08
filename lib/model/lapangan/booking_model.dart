import 'dart:convert';

BookingResponse bookingResponseFromJson(String str) =>
    BookingResponse.fromJson(json.decode(str));

String bookingResponseToJson(BookingResponse data) =>
    json.encode(data.toJson());

class BookingResponse {
  final String message;
  final Booking data;

  BookingResponse({required this.message, required this.data});

  factory BookingResponse.fromJson(Map<String, dynamic> json) =>
      BookingResponse(
        message: json["message"] ?? "",
        data: Booking.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Booking {
  final int id;
  final int userId;
  final int scheduleId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.userId,
    required this.scheduleId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json["id"] ?? 0,
    userId: json["user_id"] ?? 0,
    scheduleId: json["schedule_id"] ?? 0,
    status: json["status"] ?? "pending",
    createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json["updated_at"] ?? "") ?? DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "schedule_id": scheduleId,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
