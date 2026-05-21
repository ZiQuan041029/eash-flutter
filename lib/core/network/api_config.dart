// Keep this file dependency-free; use --dart-define for configuration.

/// Central place to configure backend URLs.
///
/// Notes:
/// - Android emulator cannot reach your PC at `localhost`; use `10.0.2.2`.
/// - iOS simulator can use `127.0.0.1`.
/// - Herd `.test` domains may not resolve inside emulators without extra setup.
class ApiConfig {
  const ApiConfig._();

  static String hostHeader() {
    // Optional override:
    // flutter run --dart-define=API_HOST_HEADER=eash-backend.test
    const String defined =
        String.fromEnvironment('API_HOST_HEADER', defaultValue: '');
    if (defined.isNotEmpty) return defined;

    // Default: no Host header needed for a public base URL.
    return '';
  }

  static String baseUrl() {
    // Allow overriding at build-time:
    // flutter run --dart-define=API_BASE_URL=http://192.168.1.10
    const String defined =
        String.fromEnvironment('API_BASE_URL', defaultValue: '');
    if (defined.isNotEmpty) return defined;

    // Production default (can be overridden with --dart-define).
    return 'https://eash.twiport.com';

    // Note: for local development, override with:
    // - Android: flutter run --dart-define=API_BASE_URL=http://10.0.2.2 --dart-define=API_HOST_HEADER=eash-backend.test
    // - iOS:     flutter run --dart-define=API_BASE_URL=http://127.0.0.1 --dart-define=API_HOST_HEADER=eash-backend.test
  }
}

