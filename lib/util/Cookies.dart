import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserAndToken(String user, String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user', user);
  await prefs.setString('authToken', token);
  // Expiration is not handled by shared_preferences directly.
  // Data persists until removed or app is uninstalled.
}

Future<String?> getUser() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('user');
}

Future<void> deleteStoredValue(String key) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}

Future<void> deleteUserAndToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');
  await prefs.remove('authToken');
}

Future<void> deleteUserCookiesKey(String key) async {
  await deleteStoredValue(key);
}

Future<bool> saveEmail(String email) async {
  if (email.isEmpty) return false; // Or handle as you see fit
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
  return true; // Indicate success
}


Future<dynamic> getEmail() async { // Returning dynamic to match original logic
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email');
  if (email == null || email.isEmpty) {
    return false;
  }
  return email;
}


Future<String?> getSpecificCookie(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<void> setSpecificCookie(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}