import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop/util/Cookies.dart';

class ApiProvider {
  late Dio _dio;

  final BaseOptions options = BaseOptions(
    baseUrl: "${dotenv.env['API_URL']}",
    // You can enable these if needed
    connectTimeout: Duration(milliseconds: 15000),
    receiveTimeout: Duration(milliseconds: 13000),
    responseType: ResponseType.json,
    contentType: "application/json",
  );

  static final ApiProvider _instance = ApiProvider._internal();

  factory ApiProvider() => _instance;

  ApiProvider._internal() {
    _dio = Dio(options);
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, handler) async {
          // Set headers for every request
          options.headers['Content-Type'] = 'application/json';
        options.headers['Accept'] = 'application/json';          
          final String? token = await getAuthTokenFromCookies(); // token is now String?
          // Updated token check
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token"; // Use string interpolation
          }
          return handler.next(options); // continue with request
        },
      ),
    );
  }

  Dio get client => _dio;

  Future<String?> getAuthTokenFromCookies() async {
    // The key 'authToken' should match what you use in saveUserAndToken
    final String? token = await getSpecificCookie('authToken');
    return token;
 }
}
