import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'auth_api.dart';

/// Uploads to Laravel → Cloudflare R2 (`POST /api/upload/visa`).
class UploadApi {
  const UploadApi(this._client);

  final http.Client _client;

  Future<GuestVisaUploadResult> uploadVisaGuest(File file) async {
    final Uri url = Uri.parse('${ApiConfig.baseUrl()}/api/upload/visa');
    final http.MultipartRequest request = http.MultipartRequest('POST', url);
    request.headers['Accept'] = 'application/json';
    final String host = ApiConfig.hostHeader();
    if (host.isNotEmpty) {
      request.headers['Host'] = host;
    }

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final http.StreamedResponse streamed = await _client.send(request);
    final String body = await streamed.stream.bytesToString();
    final String trimmed = body.trimLeft();

    if (trimmed.startsWith('<')) {
      throw ApiException(
        'Backend returned HTML instead of JSON. '
        'Check API_BASE_URL and API_HOST_HEADER for your emulator.',
      );
    }

    final dynamic decoded = jsonDecode(body);

    if (streamed.statusCode >= 200 && streamed.statusCode < 300) {
      final Map<String, dynamic> map = decoded as Map<String, dynamic>;
      return GuestVisaUploadResult(
        uploadId: (map['upload_id'] as num).toInt(),
        guestId: (map['guest_id'] ?? '') as String,
        key: map['key'] as String,
        publicUrl: map['public_url'] as String?,
      );
    }

    throw ApiException.fromResponse(streamed.statusCode, decoded);
  }

  /// POST `/api/upload/profile-photo` — requires Bearer token.
  Future<ProfilePhotoUploadResult> uploadProfilePhoto(
    File file, {
    required String token,
  }) async {
    final Uri url = Uri.parse('${ApiConfig.baseUrl()}/api/upload/profile-photo');
    final http.MultipartRequest request = http.MultipartRequest('POST', url);
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    final String host = ApiConfig.hostHeader();
    if (host.isNotEmpty) {
      request.headers['Host'] = host;
    }

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final http.StreamedResponse streamed = await _client.send(request);
    final String body = await streamed.stream.bytesToString();
    final String trimmed = body.trimLeft();

    if (trimmed.startsWith('<')) {
      throw ApiException(
        'Backend returned HTML instead of JSON. '
        'Check API_BASE_URL and API_HOST_HEADER for your emulator.',
      );
    }

    final dynamic decoded = jsonDecode(body);

    if (streamed.statusCode >= 200 && streamed.statusCode < 300) {
      final Map<String, dynamic> map = decoded as Map<String, dynamic>;
      return ProfilePhotoUploadResult(
        key: map['key'] as String,
        publicUrl: map['public_url'] as String?,
        profilePhotoUrl: map['profile_photo_url'] as String?,
      );
    }

    throw ApiException.fromResponse(streamed.statusCode, decoded);
  }
}

class ProfilePhotoUploadResult {
  const ProfilePhotoUploadResult({
    required this.key,
    this.publicUrl,
    this.profilePhotoUrl,
  });

  final String key;
  final String? publicUrl;
  final String? profilePhotoUrl;
}

class GuestVisaUploadResult {
  const GuestVisaUploadResult({
    required this.uploadId,
    required this.guestId,
    required this.key,
    this.publicUrl,
  });

  final int uploadId;
  final String guestId;
  final String key;
  final String? publicUrl;
}
