// ignore: unused_import
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:toko_kita/helpers/api.dart';
import 'package:toko_kita/helpers/api_url.dart';
import 'package:toko_kita/model/registrasi.dart';

class RegistrasiBloc {
  static Future<Registrasi> registrasi({
    required String nama,
    required String email,
    required String password,
  }) async {
    String apiUrl = ApiUrl.registrasi;

    var body = {
      'nama': nama,
      'email': email,
      'password': password,
    };

    try {
      // Kirim POST request
      final response = await Api().post(apiUrl, body);

      // Log response untuk debugging
      if (kDebugMode) {
        print('Response body: $response');
      }

      // Jika response adalah Map (JSON yang sudah didecode)
      if (response != null && response is Map<String, dynamic>) {
        if (response['code'] == 200 && response['status'] == true) {
          // Jika registrasi berhasil, parse data ke model Registrasi
          return Registrasi.fromJson(response);
        } else {
          // Jika registrasi gagal, lempar exception dengan pesan error dari server
          throw Exception(response['data'] ?? 'Registrasi gagal');
        }
      } else {
        // Jika respons bukan Map atau tidak valid
        throw Exception('Format respons tidak valid');
      }
    } catch (error) {
      // Tangani error lainnya, seperti kesalahan jaringan
      throw Exception('Terjadi kesalahan: $error');
    }
  }
}
