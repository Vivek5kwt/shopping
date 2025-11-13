import 'package:flutter/foundation.dart';

/// Centralised runtime configuration for the application.
///
/// Google Sign-In requires the server client id (the OAuth 2.0 client id
/// generated for your backend) to be supplied on Android when using the
/// `google_sign_in` package v7.x. We read the credentials from compile-time
/// environment variables so they can be injected securely at build time.
class AppConfig {
  /// OAuth 2.0 client id that represents the backend/server application.
  ///
  /// Provide this via `--dart-define=GOOGLE_SERVER_CLIENT_ID=xxxx` when
  /// building or running the Flutter application. Leaving it empty will cause
  /// Google Sign-In to be unavailable on Android because the native SDK will
  /// reject the sign-in attempt.
  static const String googleServerClientId =
      String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID', defaultValue: '');

  /// Optional: OAuth 2.0 client id that represents the Android application.
  ///
  /// This is not strictly required for most flows but can be supplied when a
  /// specific Android client id is preferred. It is also read from a
  /// compile-time define so secrets are not committed to source control.
  static const String googleAndroidClientId =
      String.fromEnvironment('GOOGLE_ANDROID_CLIENT_ID', defaultValue: '');

  /// Returns `true` when the Google server client id is missing on Android.
  /// This allows the UI layer to warn the developer instead of attempting a
  /// sign-in that is guaranteed to fail with a configuration error.
  static bool get isMissingAndroidServerClientId =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android &&
      googleServerClientId.trim().isEmpty;
}
