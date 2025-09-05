import 'dart:convert';

import 'package:futsal_booking/api/endpoint/endpoint.dart';
import 'package:futsal_booking/model/auth/loginreg/regis_model.dart';
import 'package:futsal_booking/model/lapangan/card_user_lapangan.dart';
import 'package:futsal_booking/preference/shared_preference.dart';
import 'package:http/http.dart' as http;

class AuthenticationAPI {
  static Future<RegisterFutsal> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    final url = Uri.parse(Endpoint.register);
    final response = await http.post(
      url,
      body: {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": password,
      },
      headers: {"Accept": "application/json"},
    );

    print('Register response: ${response.statusCode}');
    print('Register body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final registerUserModel = RegisterFutsal.fromJson(
        json.decode(response.body),
      );

      final token = registerUserModel.data.token;
      final user = registerUserModel.data.user;

      if (token.isEmpty) {
        throw Exception("Token tidak ditemukan di response register");
      }

      await PreferenceHandler.saveToken(token);
      await PreferenceHandler.saveUserId(user.id);
      await PreferenceHandler.saveUserData(user.name, user.email);
      await PreferenceHandler.saveLogin(true);

      print('✅ Registration successful, token saved');
      return registerUserModel;
    } else {
      final error = json.decode(response.body);
      throw Exception(
        error["message"] ?? "Register gagal: ${response.statusCode}",
      );
    }
  }

  static Future<RegisterFutsal> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(Endpoint.login);
    final response = await http.post(
      url,
      body: {"email": email, "password": password},
      headers: {"Accept": "application/json"},
    );

    print('Login response: ${response.statusCode}');
    print('Login body: ${response.body}');

    if (response.statusCode == 200) {
      final registerUserModel = RegisterFutsal.fromJson(
        json.decode(response.body),
      );

      final token = registerUserModel.data.token;
      final user = registerUserModel.data.user;

      if (token.isEmpty) {
        throw Exception("Token tidak ditemukan di response login");
      }

      await PreferenceHandler.saveToken(token);
      await PreferenceHandler.saveUserId(user.id);
      await PreferenceHandler.saveUserData(user.name, user.email);
      await PreferenceHandler.saveLogin(true);

      print('✅ Login successful, token saved');
      return registerUserModel;
    } else {
      final error = json.decode(response.body);
      throw Exception(
        error["message"] ?? "Login gagal: ${response.statusCode}",
      );
    }
  }

  static Future<SportCard> getFields() async {
    try {
      final url = Uri.parse(Endpoint.getFields);
      final token = await PreferenceHandler.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      print('Mengambil data dari: $url');
      print('Token dipakai: $token');

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
        return sportCardFromJson(response.body);
      } else if (response.statusCode == 401) {
        await PreferenceHandler.clearToken();
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

  static Future<Datum> getFieldById(int fieldId) async {
    final url = Uri.parse('${Endpoint.getFields}/$fieldId');
    final token = await PreferenceHandler.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Silakan login kembali.");
    }

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return Datum.fromJson(responseData['data']);
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal ambil detail lapangan");
    }
  }
}
