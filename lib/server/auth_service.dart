import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio();

  Future<dynamic> login(String email, String password) async {
    try {
      final userLogin = await _dio.post(
        'http://localhost:7100/api/user/login',
        data: {'email': email, 'password': password},
      );
      return userLogin.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<dynamic> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String gender,
  ) async {
    try {
      final userRegister = await _dio.post(
        'http://localhost:7100/api/user/register',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'gender': gender,
        },
      );
      return userRegister.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<dynamic> logout() async {
    try {
      final response = await _dio.post('https://yourapi.com/logout');
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<dynamic> getAuthTokenFromCookies() async {
    // Implement logic to get auth token from cookies
  }

  dynamic _handleError(dynamic error) {
    if (error is DioException) {
      return {
        "success": false,
        "error": true,
        "statusCode": error.response?.statusCode,
        "message": error.response?.data['message'] ?? "Something went wrong",
      };
    }
    return {"success": false, "message": "Unexpected error"};
  }
}
