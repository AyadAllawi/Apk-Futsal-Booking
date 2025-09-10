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

    

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body);
      return ProfileModel.fromJson(json);
    } else {
      throw Exception(
        "Gagal Mengambil Data (${response.statusCode}): ${response.body}",
      );
    }
  }


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


    if (response.statusCode >= 200 && response.statusCode < 300) {
    
      if (response.body.isNotEmpty) {
        try {
          final json = jsonDecode(response.body);
          return ProfileModel.fromJson(json);
         
        } catch (_) {
         
          return await getProfile();
        }
      } else {
       
        return await getProfile();
      }
    } else {
      throw Exception(
        "Gagal Update Data (${response.statusCode}): ${response.body}",
      );
    }
  }
}
