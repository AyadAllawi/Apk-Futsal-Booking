import 'dart:convert';

BookingResponse bookingResponseFromJson(String str) =>
    BookingResponse.fromJson(json.decode(str));

class BookingResponse {
  final String message;
  final List<Booking> data;

  BookingResponse({
    required this.message,
    required this.data,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) =>
      BookingResponse(
        message: json["message"] ?? "",
        data: (json["data"] as List<dynamic>)
            .map((x) => Booking.fromJson(x))
            .toList(),
      );
}

class Booking {
  final int id;
  final int userId;
  final int scheduleId;
  final String createdAt;
  final String updatedAt;
  final Schedule schedule;

  Booking({
    required this.id,
    required this.userId,
    required this.scheduleId,
    required this.createdAt,
    required this.updatedAt,
    required this.schedule,
  });

  // Getter untuk memudahkan access data
  String get date => schedule.date;
  String get startTime => schedule.startTime;
  String get endTime => schedule.endTime;
  String get fieldName => schedule.field.name;
  int get fieldId => schedule.field.id;
  String get status => "confirmed"; // Default status

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      scheduleId: json['schedule_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      schedule: Schedule.fromJson(json['schedule'] ?? {}),
    );
  }
}

class Schedule {
  final int id;
  final int fieldId;
  final String date;
  final String startTime;
  final String endTime;
  final int isBooked;
  final String createdAt;
  final String updatedAt;
  final Field field;

  Schedule({
    required this.id,
    required this.fieldId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isBooked,
    required this.createdAt,
    required this.updatedAt,
    required this.field,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] ?? 0,
      fieldId: json['field_id'] ?? 0,
      date: json['date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      isBooked: json['is_booked'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      field: Field.fromJson(json['field'] ?? {}),
    );
  }
}

class Field {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;
  final String imagePath;
  final String pricePerHour;

  Field({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.imagePath,
    required this.pricePerHour,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      imagePath: json['image_path'] ?? '',
      pricePerHour: json['price_per_hour'] ?? '0',
    );
  }
}