# shop

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Google Sign-In configuration

The mobile application now expects the Google OAuth 2.0 client identifiers to
be provided at build time so that the new `google_sign_in` v7.x flow can operate
correctly on Android devices. Supply the server client id and, optionally, the
Android client id via `--dart-define` when running the application:

```bash
flutter run \
  --dart-define=GOOGLE_SERVER_CLIENT_ID=your-server-client-id.apps.googleusercontent.com \
  --dart-define=GOOGLE_ANDROID_CLIENT_ID=your-android-client-id.apps.googleusercontent.com
```

For the backend service, expose the same server client id using the
`GOOGLE_SERVER_CLIENT_ID` environment variable so Google tokens can be
validated:

```bash
export GOOGLE_SERVER_CLIENT_ID=your-server-client-id.apps.googleusercontent.com
npm start
```
