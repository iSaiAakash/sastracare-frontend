import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "https://sastracare-backend.onrender.com";

  // ================= TOKEN STORAGE =================

  static Future<void> _saveTokens(
      String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("accessToken", accessToken);
    await prefs.setString("refreshToken", refreshToken);
  }

  static Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("accessToken");
  }

  static Future<String?> _getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("refreshToken");
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final token = await _getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ================= HEADER =================

  static Future<Map<String, String>> _headers({
    bool requiresAuth = false,
  }) async {

    final prefs = await SharedPreferences.getInstance();
    final language = prefs.getString("language") ?? "en";

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept-Language": language,   // ✅ ADD THIS
    };

    if (requiresAuth) {
      final token = await _getAccessToken();
      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      }
    }

    return headers;
  }

  // ================= AUTO AUTH =================

  static Future<http.Response> _authorizedRequest(
      Future<http.Response> Function() requestFn) async {

    http.Response response = await requestFn();

    if (response.statusCode == 401) {
      final refreshed = await _tryRefreshToken();

      if (refreshed) {
        response = await requestFn();
      } else {
        await logout();
        throw Exception("Session expired. Please login again.");
      }
    }

    return response;
  }

  static Future<bool> _tryRefreshToken() async {
    final refreshToken = await _getRefreshToken();
    if (refreshToken == null) return false;

    final response = await http.post(
      Uri.parse("$baseUrl/auth/refresh"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"refreshToken": refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveTokens(data["accessToken"], data["refreshToken"]);
      return true;
    }

    return false;
  }

  static dynamic _handleJsonResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : null;
    }

    try {
      final error = jsonDecode(response.body);
      throw Exception(error["message"] ?? "Unknown error");
    } catch (_) {
      throw Exception("Server error: ${response.statusCode}");
    }
  }

  // ================= AUTH =================

  static Future<String> requestOtp(String mobile) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/request-otp"),
      headers: await _headers(),
      body: jsonEncode({"mobile": mobile}),
    );

    final data = _handleJsonResponse(response);
    return data["message"];
  }

  static Future<void> verifyOtp(String mobile, String otp) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/verify-otp"),
      headers: await _headers(),
      body: jsonEncode({
        "mobile": mobile,
        "otp": otp,
      }),
    );

    final data = _handleJsonResponse(response);
    await _saveTokens(data["accessToken"], data["refreshToken"]);
  }

  // ================= CHILDREN =================

  static Future<List<dynamic>> getMyChildren() async {
    final response = await _authorizedRequest(() async {
      return await http.get(
        Uri.parse("$baseUrl/api/my-children"),
        headers: await _headers(requiresAuth: true),
      );
    });

    return _handleJsonResponse(response);
  }

  // ================= SEMESTERS =================

  static Future<List<int>> getAvailableSemesters(int studentId) async {
    final response = await _authorizedRequest(() async {
      return await http.get(
        Uri.parse('$baseUrl/api/my-children/$studentId/semesters'),
        headers: await _headers(requiresAuth: true),
      );
    });

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => (e as num).toInt()).toList();
  }

  // ================= TEXT APIs =================

  static Future<Map<String, dynamic>> getAttendance({
    required int studentId,
    required int semester,
  }) async {

    final response = await _authorizedRequest(() async {
      return await http.get(
        Uri.parse("$baseUrl/api/my-children/$studentId/attendance?semester=$semester"),
        headers: await _headers(requiresAuth: true),
      );
    });

    return _handleJsonResponse(response);
  }

  static Future<Map<String, dynamic>> getFees({
    required int studentId,
    required int semester,
  }) async {

    final response = await _authorizedRequest(() async {
      return await http.get(
        Uri.parse("$baseUrl/api/my-children/$studentId/fees?semester=$semester"),
        headers: await _headers(requiresAuth: true),
      );
    });

    return _handleJsonResponse(response);
  }

  static Future<Map<String, dynamic>> getSgpa({
    required int studentId,
    required int semester,
  }) async {

    final response = await _authorizedRequest(() async {
      return await http.get(
        Uri.parse("$baseUrl/api/my-children/$studentId/sgpa?semester=$semester"),
        headers: await _headers(requiresAuth: true),
      );
    });

    return _handleJsonResponse(response);
  }

  static Future<Map<String, dynamic>> getCgpa({
    required int studentId,
  }) async {

    final response = await _authorizedRequest(() async {
      return await http.get(
        Uri.parse("$baseUrl/api/my-children/$studentId/cgpa"),
        headers: await _headers(requiresAuth: true),
      );
    });

    return _handleJsonResponse(response);
  }

  static Future<Map<String, dynamic>> getResult({
    required int studentId,
    required int semester,
  }) async {

    final response = await _authorizedRequest(() async {
      return await http.get(
        Uri.parse("$baseUrl/api/my-children/$studentId/result?semester=$semester"),
        headers: await _headers(requiresAuth: true),
      );
    });

    return _handleJsonResponse(response);
  }

  static Future<List<int>> getAttendanceAudio({
    required int studentId,
    required int semester,
  }) async {

    final response = await _authorizedRequest(() async {
      return await http.post(
        Uri.parse("$baseUrl/api/audio/attendance?semester=$semester"),
        headers: await _headers(requiresAuth: true),
        body: jsonEncode({"studentId": studentId}),
      );
    });

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    throw Exception("Audio generation failed");
  }

  static Future<List<int>> getFeesAudio({
    required int studentId,
    required int semester,
  }) async {

    final response = await _authorizedRequest(() async {
      return await http.post(
        Uri.parse("$baseUrl/api/audio/fees?semester=$semester"),
        headers: await _headers(requiresAuth: true),
        body: jsonEncode({"studentId": studentId}),
      );
    });

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    throw Exception("Audio generation failed");
  }

  static Future<List<int>> getSgpaAudio({
    required int studentId,
    required int semester,
  }) async {

    final response = await _authorizedRequest(() async {
      return await http.post(
        Uri.parse("$baseUrl/api/audio/sgpa?semester=$semester"),
        headers: await _headers(requiresAuth: true),
        body: jsonEncode({"studentId": studentId}),
      );
    });

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    throw Exception("Audio generation failed");
  }

  static Future<List<int>> getCgpaAudio({
    required int studentId,
  }) async {

    final response = await _authorizedRequest(() async {
      return await http.post(
        Uri.parse("$baseUrl/api/audio/cgpa"),
        headers: await _headers(requiresAuth: true),
        body: jsonEncode({"studentId": studentId}),
      );
    });

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    throw Exception("Audio generation failed");
  }

  static Future<List<int>> getResultAudio({
    required int studentId,
    required int semester,
  }) async {

    final response = await _authorizedRequest(() async {
      return await http.post(
        Uri.parse("$baseUrl/api/audio/result?semester=$semester"),
        headers: await _headers(requiresAuth: true),
        body: jsonEncode({"studentId": studentId}),
      );
    });

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    throw Exception("Audio generation failed");
  }

  static Future<void> setSelectedStudentId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("selectedStudentId", id);
  }

  static Future<int?> getSelectedStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("selectedStudentId");
  }
}