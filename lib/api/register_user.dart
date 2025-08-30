import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:futsal_booking/api/endpoint/endpoint.dart';
import 'package:futsal_booking/model/get_user.dart';
import 'package:futsal_booking/preference/shared_preference.dart';
import 'package:futsal_booking/views/register_futsal.dart';

class AuthenticationAPI {
  static Future<RegisterFutsal> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    final url = Uri.parse(Endpoint.register);
    final response = await http.post(
      url,
      body: {"name": name, "email": email, "password": password},
      headers: {"Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      return RegisterFutsal.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
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
    if (response.statusCode == 200) {
      return RegisterFutsal.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }

  static Future<GetUser> updateUser({required String name}) async {
    final url = Uri.parse(Endpoint.profile);
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      url,
      body: {"name": name},
      headers: {"Accept": "application/json", "Authorization": token},
    );
    if (response.statusCode == 200) {
      return GetUser.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }

  static Future<GetUser> getProfile() async {
    final url = Uri.parse(Endpoint.profile);
    final token = await PreferenceHandler.getToken();
    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": token},
    );
    if (response.statusCode == 200) {
      return GetUser.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }
}
