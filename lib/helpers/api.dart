import 'dart:convert'; // pastikan mengimpor json
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:toko_kita/helpers/user_info.dart';
import 'app_exception.dart';

class Api {
  // Perform POST request with data
  Future<dynamic> post(String url, dynamic data) async {
    var token = await UserInfo().getToken(); // Get token from storage
    dynamic responseJson;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'Content-Type': 'application/json', // JSON Content Type
        },
        body: json.encode(data), // Convert Map to JSON string
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      throw FetchDataException('An unexpected error occurred: $e');
    }

    return responseJson;
  }

  // Perform GET request
  Future<dynamic> get(String url) async {
    var token = await UserInfo().getToken(); // Get token from storage
    dynamic responseJson;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'Content-Type': 'application/json', // JSON Content Type
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      throw FetchDataException('An unexpected error occurred: $e');
    }

    return responseJson;
  }

  // Perform DELETE request
  Future<dynamic> delete(String url) async {
    var token = await UserInfo().getToken(); // Get token from storage
    dynamic responseJson;

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'Content-Type': 'application/json', // JSON Content Type
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      throw FetchDataException('An unexpected error occurred: $e');
    }

    return responseJson;
  }

  // Handle HTTP response status codes and errors
  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201: // Created
        return json.decode(response.body); // Decode JSON response
      case 400: // Bad Request
        throw BadRequestException(response.body.toString());
      case 401: // Unauthorized
        throw UnauthorizedException(response.body.toString());
      case 403: // Forbidden
        throw UnauthorizedException(response.body.toString());
      case 422: // Unprocessable Entity
        throw InvalidInputException(response.body.toString());
      case 500: // Internal Server Error
        throw FetchDataException(
            'Error occurred while communicating with the server. StatusCode: ${response.statusCode}');
      default:
        throw FetchDataException(
            'Error occurred while communicating with the server. StatusCode: ${response.statusCode}');
    }
  }
}
