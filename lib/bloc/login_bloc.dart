import 'package:toko_kita/helpers/api.dart';
import 'package:toko_kita/helpers/api_url.dart';
import 'package:toko_kita/model/login.dart';

class LoginBloc {
  static Future<Login> login({String? email, String? password}) async {
    String apiUrl = ApiUrl.login;
    var body = {"email": email, "password": password};

    try {
      // `Api().post` mengembalikan Map<String, dynamic>
      final response = await Api().post(apiUrl, body);

      // Debugging: Tampilkan data respons
      // ignore: avoid_print
      print('Response JSON: $response');

      // Konversi Map ke model Login
      return Login.fromJson(response);
    } catch (error) {
      // ignore: avoid_print
      print('Error during login: $error');
      rethrow;
    }
  }
}
