import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class AuthApi {
  const AuthApi(this._client);

  final http.Client _client;

  Future<RegisterResponse> register({
    required String name,
    required String email,
    required String password,
    int? visaUploadId,
  }) async {
    final Uri url = Uri.parse('${ApiConfig.baseUrl()}/api/register');

    // Herd uses virtual hosts (e.g. eash-backend.test). Android emulator can
    // reach the host machine via 10.0.2.2, but we must send the Host header
    // so Herd routes to the correct site.
    final Map<String, String> headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final String host = ApiConfig.hostHeader();
    if (host.isNotEmpty) headers['Host'] = host;

    final Map<String, Object?> payload = <String, Object?>{
      'name': name,
      'email': email,
      'password': password,
      if (visaUploadId != null) 'visa_upload_id': visaUploadId,
    };

    final http.Response res = await _client.post(
      url,
      headers: headers,
      body: jsonEncode(payload),
    );

    // If we hit a non-API endpoint, Laravel (or a proxy) may return HTML.
    // That would crash jsonDecode with "Unexpected character '<'".
    final String body = res.body;
    final String trimmed = body.trimLeft();
    if (trimmed.startsWith('<')) {
      throw ApiException(
        'Backend returned HTML instead of JSON. '
        'Check your API base URL for emulator.\n'
        'If you are using Herd, set API_BASE_URL=http://10.0.2.2 and '
        'API_HOST_HEADER=eash-backend.test',
      );
    }

    final dynamic decoded = jsonDecode(body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return RegisterResponse.fromJson(decoded as Map<String, dynamic>);
    }

    throw ApiException.fromResponse(res.statusCode, decoded);
  }

  /// GET `/api/visa/me` — current user's visa verification state (requires Bearer token).
  Future<VisaMeResponse> fetchVisaMe({required String token}) async {
    final Uri url = Uri.parse('${ApiConfig.baseUrl()}/api/visa/me');
    final Map<String, String> headers = <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final String host = ApiConfig.hostHeader();
    if (host.isNotEmpty) {
      headers['Host'] = host;
    }

    final http.Response res = await _client.get(url, headers: headers);
    final String body = res.body;
    final String trimmed = body.trimLeft();
    if (trimmed.startsWith('<')) {
      throw ApiException(
        'Backend returned HTML instead of JSON. '
        'Check your API base URL for emulator.',
      );
    }

    final dynamic decoded = jsonDecode(body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return VisaMeResponse.fromJson(decoded as Map<String, dynamic>);
    }

    throw ApiException.fromResponse(res.statusCode, decoded);
  }

  /// POST `/api/login` — returns a Sanctum token when credentials match.
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final Uri url = Uri.parse('${ApiConfig.baseUrl()}/api/login');

    final Map<String, String> headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final String host = ApiConfig.hostHeader();
    if (host.isNotEmpty) {
      headers['Host'] = host;
    }

    final http.Response res = await _client.post(
      url,
      headers: headers,
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    final String body = res.body;
    final String trimmed = body.trimLeft();
    if (trimmed.startsWith('<')) {
      throw ApiException(
        'Backend returned HTML instead of JSON. '
        'Check your API base URL for emulator.\n'
        'If you are using Herd, set API_BASE_URL=http://10.0.2.2 and '
        'API_HOST_HEADER=eash-backend.test',
      );
    }

    final dynamic decoded = jsonDecode(body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return LoginResponse.fromJson(decoded as Map<String, dynamic>);
    }

    if (res.statusCode == 401) {
      throw const ApiException('Incorrect email or password.');
    }

    throw ApiException.fromResponse(res.statusCode, decoded);
  }
}

class LoginResponse {
  const LoginResponse({required this.token});

  final String token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(token: (json['token'] ?? '') as String);
  }
}

class RegisterResponse {
  const RegisterResponse({required this.token});

  final String token;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(token: (json['token'] ?? '') as String);
  }
}

class VisaMeResponse {
  const VisaMeResponse({
    required this.visaStatus,
    required this.uploadStatus,
    required this.verified,
  });

  final String visaStatus;
  final String? uploadStatus;
  final bool verified;

  factory VisaMeResponse.fromJson(Map<String, dynamic> json) {
    return VisaMeResponse(
      visaStatus: (json['visa_status'] ?? 'none') as String,
      uploadStatus: json['upload_status'] as String?,
      verified: json['verified'] as bool? ?? false,
    );
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  static ApiException fromResponse(int status, dynamic decoded) {
    // Laravel validation: { message: "...", errors: { field: [..] } }
    if (decoded is Map<String, dynamic>) {
      final String msg = (decoded['message'] ?? 'Request failed') as String;
      final Object? errors = decoded['errors'];
      if (errors is Map<String, dynamic>) {
        final String details = errors.entries
            .map((e) => '${e.key}: ${(e.value as List).join(", ")}')
            .join(' | ');
        return ApiException('$msg ($status). $details');
      }
      return ApiException('$msg ($status)');
    }
    return ApiException('Request failed ($status)');
  }

  @override
  String toString() => message;
}

