// field_service.dart
import 'dart:convert';

import 'package:futsal_booking/api/endpoint/endpoint.dart';
import 'package:futsal_booking/model/lapangan/field_model.dart';
import 'package:futsal_booking/preference/shared_preference.dart';
import 'package:http/http.dart' as http;

class FieldService {
  static Future<List<Field>> getFields() async {
    try {
      final url = Uri.parse(Endpoint.field);
      final token = await PreferenceHandler.getToken();

      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        return data.map((json) => Field.fromJson(json)).toList();
      } else {
        throw Exception(
          'Gagal memuat data: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<void> deleteField(int id) async {
    try {
      final url = Uri.parse('${Endpoint.field}/$id');
      final token = await PreferenceHandler.getToken();

      final response = await http.delete(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Gagal menghapus lapangan: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<void> addField(Field field) async {
    try {
      final url = Uri.parse(Endpoint.field);
      final token = await PreferenceHandler.getToken();

      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode({
          'nama': field.nama,
          'alamat': field.alamat,
          'harga': field.harga,
          'rating': field.rating,
          'jarak': field.jarak,
          'available_slot': field.availableSlot,
          'price_per_hour': field.pricePerHour,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          'Gagal menambah lapangan: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<void> updateField(Field field) async {
    try {
      final url = Uri.parse('${Endpoint.field}/${field.id}');
      final token = await PreferenceHandler.getToken();

      final response = await http.put(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode({
          'nama': field.nama,
          'alamat': field.alamat,
          'harga': field.harga,
          'rating': field.rating,
          'jarak': field.jarak,
          'available_slot': field.availableSlot,
          'price_per_hour': field.pricePerHour,
        }),
      );

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
