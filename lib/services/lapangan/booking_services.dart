import 'dart:convert';

import 'package:futsal_booking/api/endpoint/endpoint.dart';
import 'package:futsal_booking/model/lapangan/booking_model.dart';
import 'package:futsal_booking/model/lapangan/schedule.dart';
import 'package:http/http.dart' as http;

class BookingService {
  /// 🔹 1. Create Schedule
  static Future<Schedule?> createSchedule({
    required int fieldId,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.createSchedule),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "field_id": fieldId,
        "date": date,
        "start_time": startTime,
        "end_time": endTime,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = json.decode(response.body);
      final scheduleResponse = ScheduleResponse.fromJson(body);
      return scheduleResponse.data; // ✅ ambil jadwal
    } else {
      print("❌ Gagal create schedule: ${response.body}");
      return null;
    }
  }

  /// 🔹 2. Create Booking
  static Future<Booking?> createBooking({
    required int userId,
    required int scheduleId,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.createBooking),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId, "schedule_id": scheduleId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = json.decode(response.body);
      return Booking.fromJson(body["data"]);
    } else {
      print("❌ Gagal create booking: ${response.body}");
      return null;
    }
  }
}
