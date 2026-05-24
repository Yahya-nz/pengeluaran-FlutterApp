import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  GoogleAuthService._();

  static final GoogleAuthService instance = GoogleAuthService._();

  static const _clientId = String.fromEnvironment('GOOGLE_CLIENT_ID');
  static const _serverClientId =
      String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _initialized = false;

  Future<GoogleSignInAccount> authenticate() async {
    if (kIsWeb) {
      throw const GoogleAuthSetupException(
        'Google Sign-In web memerlukan Client ID dan tombol web resmi. '
        'Uji login asli melalui build Android/iOS setelah OAuth dikonfigurasi.',
      );
    }

    await _initialize();
    if (!_googleSignIn.supportsAuthenticate()) {
      throw const GoogleAuthSetupException(
        'Platform ini belum mendukung proses Google Sign-In langsung.',
      );
    }
    return _googleSignIn.authenticate();
  }

  Future<void> _initialize() async {
    if (_initialized) return;
    await _googleSignIn.initialize(
      clientId: _clientId.isEmpty ? null : _clientId,
      serverClientId: _serverClientId.isEmpty ? null : _serverClientId,
    );
    _initialized = true;
  }
}

class GoogleAuthSetupException implements Exception {
  const GoogleAuthSetupException(this.message);

  final String message;
}
