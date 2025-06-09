import 'package:dio/dio.dart';
import 'package:shop/server/server.dart';

class AuthStore {
  // user login use email and password
  Future<dynamic> login(dynamic body) async {
    try {
      final response = await useServer.post("/login", data: body);
      final data = response.data;
      return data;
    } catch (e) {
      return await handlerError(e);
    }
  }

  // user id
  Future<dynamic> logout() async {
    try {
      final response = await useServer.patch("/logout");
      final data = response.data;
      return data;
    } catch (e) {
      return await handlerError(e);
    }
  }

  // user register use firstName, lastName, email, password, gender
  Future<dynamic> register(dynamic body) async {
    try {
      final response = await useServer.post("/register", data: body);
      final data = response.data;
      return data;
    } catch (e) {
      return await handlerError(e);
    }
  }

  // user send email
  Future<dynamic> forgotPassword(dynamic body) async {
    try {
      final response = await useServer.post("/send-otp-to-email", data: body);
      final data = response.data;
      return data;
    } catch (e) {
      return await handlerError(e);
    }
  }

  // user receive otp code from your email or phone number
  // user send otp code and your email
  Future<dynamic> verify(dynamic body) async {
    try {
      final response = await useServer.post("/verify-otp", data: body);
      final data = response.data;
      return data;
    } catch (e) {
      return await handlerError(e);
    }
  }

  // user send email, password and confirm password
  Future<dynamic> updatePassword(dynamic body) async {
    try {
      final response = await useServer.post("/reset-password", data: body);
      final data = response.data;
      return data;
    } catch (e) {
      return await handlerError(e);
    }
  }

  Future<dynamic> handlerError(dynamic e) async {
    if (e is DioException) {
      String message = e.response?.data['message'];
      return throw {
        "success": false,
        "error": true,
        "statusCode": e.response?.statusCode,
        "message": message.isNotEmpty
            ? message.toString()
            : "Something went worng",
      };
    }
  }
}
