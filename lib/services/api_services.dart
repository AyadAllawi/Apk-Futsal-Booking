import 'dart:convert';

import 'package:futsal_booking/api/endpoint/endpoint.dart';
import 'package:futsal_booking/preference/shared_preference.dart';
import 'package:futsal_booking/services/services_user.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  static Future<ProfileModel> getProfile() async {
    final url = Uri.parse(Endpoint.profile);
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    // Debug
    // print("GET ${url.toString()}");
    // print("GET status: ${response.statusCode}");
    // print("GET body: ${response.body}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body);
      return ProfileModel.fromJson(json);
    } else {
      throw Exception(
        "Gagal Mengambil Data (${response.statusCode}): ${response.body}",
      );
    }
  }

  /// Update profil. Banyak backend hanya menerima field yang diubah (mis. name & email).
  /// Jika server membalas 204/empty body, kita re-fetch profile agar state terbaru terbaca.
  static Future<ProfileModel> updateData({
    required String name,
    required String email,
  }) async {
    final url = Uri.parse(Endpoint.profile);
    final token = await PreferenceHandler.getToken();

    final bodyMap = {"name": name, "email": email};

    final response = await http.put(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(bodyMap),
    );

    // Debug
    // print("PUT ${url.toString()}");
    // print("PUT body: ${jsonEncode(bodyMap)}");
    // print("PUT status: ${response.statusCode}");
    // print("PUT body: ${response.body}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Kalau server memberi body JSON profile, parse langsung.
      if (response.body.isNotEmpty) {
        try {
          final json = jsonDecode(response.body);
          return ProfileModel.fromJson(json);
          // ignore: avoid_catches_without_on_clauses
        } catch (_) {
          // Jika struktur tidak sesuai ProfileModel, fallback re-fetch.
          return await getProfile();
        }
      } else {
        // 204 No Content atau body kosong -> ambil ulang profil
        return await getProfile();
      }
    } else {
      throw Exception(
        "Gagal Update Data (${response.statusCode}): ${response.body}",
      );
    }
  }
}
