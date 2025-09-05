// field_services.dart
import 'dart:convert';

import 'package:futsal_booking/api/endpoint/endpoint.dart';
import 'package:futsal_booking/model/lapangan/field_model.dart';
import 'package:futsal_booking/preference/shared_preference.dart';
import 'package:http/http.dart' as http;

class FieldService {
  /// ✅ Ambil semua lapangan
  static Future<List<Datum>> getFields() async {
    try {
      final url = Uri.parse(Endpoint.getFields);
      final token = await PreferenceHandler.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      final response = await http
          .get(
            url,
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final fieldResponse = fieldFromJson(response.body);

        // fallback image kalau null
        final safeData = fieldResponse.data?.map((d) {
          return d.copyWith(
            imageUrl:
                d.imageUrl ??
                "https://via.placeholder.com/300x200.png?text=No+Image",
          );
        }).toList();

        return safeData ?? [];
      } else if (response.statusCode == 401) {
        await PreferenceHandler.clearToken();
        throw Exception('Token tidak valid. Silakan login kembali.');
      } else {
        throw Exception(
          'Gagal memuat data: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// ✅ Hapus lapangan by ID
  static Future<void> deleteField(int id) async {
    try {
      final url = Uri.parse("${Endpoint.getFields}/$id");
      final token = await PreferenceHandler.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      final response = await http
          .delete(
            url,
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception(
          'Gagal menghapus lapangan: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// ✅ Tambah lapangan
  static Future<void> addField(String name, String pricePerHour) async {
    try {
      final url = Uri.parse(Endpoint.getFields);
      final token = await PreferenceHandler.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      final requestData = {
        'name': name,
        'price_per_hour': pricePerHour,
        'image_path': 'default_image.jpg',
      };

      final response = await http
          .post(
            url,
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
            body: json.encode(requestData),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          'Gagal menambah lapangan: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// ✅ Update lapangan
  static Future<void> updateField(Datum field) async {
    try {
      final url = Uri.parse("${Endpoint.getFields}/${field.id}");
      final token = await PreferenceHandler.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      final requestData = {
        'name': field.name,
        'price_per_hour': field.pricePerHour?.toString() ?? "0",
        'image_path': field.imagePath ?? "default_image.jpg",
      };

      final response = await http
          .put(
            url,
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
            body: json.encode(requestData),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception(
          'Gagal mengupdate lapangan: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
