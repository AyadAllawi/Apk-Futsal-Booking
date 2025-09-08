import 'dart:convert';
import 'package:futsal_booking/model/lapangan/booking_model.dart';
import 'package:http/http.dart' as http;
import 'package:futsal_booking/api/endpoint/endpoint.dart';

import 'package:futsal_booking/preference/shared_preference.dart';

class BookingService {
  // Get schedules by fieldId
  static Future<List<Schedule>> getSchedules(int fieldId) async {
    final token = await PreferenceHandler.getToken();
    
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.get(
      Uri.parse(Endpoint.schedulesByField(fieldId)),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print('[GET] Request schedule: ${Endpoint.schedulesByField(fieldId)}');
    print('[GET] Response status: ${response.statusCode}');
    print('[GET] Response body: ${response.body}');

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List data = body["data"] ?? [];
      return data.map((e) => Schedule.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load schedules: ${response.statusCode}");
    }
  }

  // Create new schedule
  static Future<Schedule?> createSchedule({
    required int fieldId,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    final token = await PreferenceHandler.getToken();
    
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    // ✅ Debug request data
    print('[DEBUG] Schedule Request:');
    print('[DEBUG] - fieldId: $fieldId');
    print('[DEBUG] - date: $date');
    print('[DEBUG] - startTime: $startTime');
    print('[DEBUG] - endTime: $endTime');

    final response = await http.post(
      Uri.parse(Endpoint.createSchedule),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode({
        "field_id": fieldId,
        "date": date,
        "start_time": startTime,
        "end_time": endTime,
      }),
    );

    print('[POST] Create schedule: ${Endpoint.createSchedule}');
    print('[POST] Response status: ${response.statusCode}');
    print('[POST] Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = json.decode(response.body);
      return Schedule.fromJson(body["data"]);
    } else {
      // ✅ Tampilkan error detail dari server
      try {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody["message"] ?? "Gagal membuat schedule");
      } catch (e) {
        throw Exception("Gagal membuat schedule: ${response.statusCode}");
      }
    }
  }

  // Create booking
  static Future<Booking?> createBooking({
    required int userId,
    required int scheduleId,
  }) async {
    final token = await PreferenceHandler.getToken();
    
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.post(
      Uri.parse(Endpoint.createBooking),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode({
        "user_id": userId,
        "schedule_id": scheduleId,
      }),
    );

    print('[POST] Create booking: ${Endpoint.createBooking}');
    print('[POST] Response status: ${response.statusCode}');
    print('[POST] Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      // ✅ Success create booking, tapi response tidak punya data relational
      // Jadi kita perlu fetch ulang data bookings untuk mendapatkan data lengkap
      // Atau langsung navigate ke halaman pemesanan yang akan auto-refresh
      return null; // Return null karena data tidak lengkap
    }
    return null;
  }

  // Get my bookings
  static Future<List<Booking>> getMyBookings() async {
    final token = await PreferenceHandler.getToken();
    
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.get(
      Uri.parse(Endpoint.myBookings),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print('[GET] My bookings: ${Endpoint.myBookings}');
    print('[GET] Response status: ${response.statusCode}');
    print('[GET] Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final bookingResponse = bookingResponseFromJson(response.body);
        return bookingResponse.data;
      } catch (e) {
        print('[ERROR] Parsing my-bookings: $e');
        throw Exception("Failed to parse bookings data: $e");
      }
    } else {
      throw Exception("Failed to load bookings: ${response.statusCode}");
    }
  }

  // Cancel booking
  static Future<bool> cancelBooking(int id) async {
    final token = await PreferenceHandler.getToken();
    
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.delete(
      Uri.parse(Endpoint.cancelBooking(id)),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print('[DELETE] Cancel booking: ${Endpoint.cancelBooking(id)}');
    print('[DELETE] Response status: ${response.statusCode}');
    print('[DELETE] Response body: ${response.body}');

    return response.statusCode == 200;
  }
}