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
        data: (json["data"] as List? ?? [])
            .map((x) => Booking.fromJson(x))
            .toList(),
      );
}

class Booking {
  final int id;
  final int fieldId;
  final String? fieldName;
  final String date;
  final String startTime;
  final String endTime;
  final String status; 

  Booking({
    required this.id,
    required this.fieldId,
    this.fieldName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status, 
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
  return Booking(
    id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
    fieldId: int.tryParse(json['field_id']?.toString() ?? '') ?? 0,
    fieldName: json['field_name'],
    date: json['date'],
    startTime: json['start_time'],
    endTime: json['end_time'],
    status: json['status'] ?? 'pending',
  );
}
}
