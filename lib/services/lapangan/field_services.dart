// field_services.dart
import 'dart:convert';

import 'package:futsal_booking/api/endpoint/endpoint.dart';
import 'package:futsal_booking/model/lapangan/field_model.dart';
import 'package:futsal_booking/preference/shared_preference.dart';
import 'package:http/http.dart' as http;

class FieldService {
  static Future<List<Datum>> getFields() async {
    try {
      final url = Uri.parse(Endpoint.getFields);
      final token = await PreferenceHandler.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      print('Mengambil data dari: $url');
      print('Token: $token');

      final response = await http
          .get(
            url,
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
          )
          .timeout(Duration(seconds: 30));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final fieldResponse = fieldFromJson(response.body);
        return fieldResponse.data ?? [];
      } else if (response.statusCode == 401) {
        throw Exception('Token tidak valid. Silakan login kembali.');
      } else {
        throw Exception(
          'Gagal memuat data: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error dalam getFields: $e');
      throw Exception('Error: $e');
    }
  }

  static Future<void> deleteField(int id) async {
    try {
      final url = Uri.parse(Endpoint.getFields);
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
          .timeout(Duration(seconds: 30));

      print('Delete response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        // Success
      } else if (response.statusCode == 401) {
        throw Exception('Token tidak valid. Silakan login kembali.');
      } else {
        throw Exception(
          'Gagal menghapus lapangan: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error dalam deleteField: $e');
      throw Exception('Error: $e');
    }
  }

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

      print('Mengirim data: ${json.encode(requestData)}');

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
          .timeout(Duration(seconds: 30));

      print('Add response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
      } else if (response.statusCode == 401) {
        throw Exception('Token tidak valid. Silakan login kembali.');
      } else {
        throw Exception(
          'Gagal menambah lapangan: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error dalam addField: $e');
      throw Exception('Error: $e');
    }
  }

  static Future<void> updateField(Datum field) async {
    try {
      final url = Uri.parse(Endpoint.getFields);
      final token = await PreferenceHandler.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      final response = await http
          .put(
            url,
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
            body: json.encode({
              'name': field.name,
              'price_per_hour': field.pricePerHour,
              'image_path': field.imagePath,
            }),
          )
          .timeout(Duration(seconds: 30));

      print('Update response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        // Success
      } else if (response.statusCode == 401) {
        throw Exception('Token tidak valid. Silakan login kembali.');
      } else {
        throw Exception(
          'Gagal mengupdate lapangan: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error dalam updateField: $e');
      throw Exception('Error: $e');
    }
  }
}
