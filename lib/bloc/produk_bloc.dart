import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toko_kita/helpers/api_url.dart';
import 'package:toko_kita/model/produk.dart';

class ProdukBloc {
  static const _baseUrl = 'http://10.0.2.2/toko_api/public/index.php/produk';

  // Mendapatkan daftar produk
  static Future<List<Produk>> getProduk() async {
    final response = await http.get(Uri.parse(_baseUrl));
    // ignore: avoid_print
    print("Response Body: ${response.body}"); // Debug respons backend

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      // ignore: avoid_print
      print("Decoded Data: $decodedData"); // Debug data setelah decode

      if (decodedData['status'] == true) {
        // Debug tipe data harga
        for (var item in decodedData['data']) {
          // ignore: avoid_print
          print("Harga: ${item['harga']} (Type: ${item['harga'].runtimeType})");
        }

        return (decodedData['data'] as List)
            .map((item) => Produk.fromJson(item))
            .toList();
      } else {
        throw Exception('Data tidak valid');
      }
    } else {
      throw Exception('Gagal mengambil data produk');
    }
  }

  // Menambahkan produk baru
  static Future<void> addProduk({required Produk produk}) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produk.toJson()), // Harga dikirim sebagai String
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menambahkan produk');
    }
  }

  static Future<void> updateProduk({required Produk produk}) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/${produk.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produk.toJson()), // Harga dikirim sebagai String
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memperbarui produk');
    }
  }

  // Menghapus produk
  static Future<void> deleteProduk(int id) async {
    final url = ApiUrl.deleteProduk(id); // Endpoint delete dari ApiUrl

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      // Debug respons backend
      // ignore: avoid_print
      print("Delete Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        if (decodedData['status'] != true) {
          throw Exception('Gagal menghapus produk: ${decodedData['data']}');
        }
      } else {
        throw Exception(
            'Gagal menghapus produk. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat menghapus produk: $e');
    }
  }
}
