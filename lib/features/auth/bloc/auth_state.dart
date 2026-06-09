import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

enum AuthMode { login, register }

enum AuthStatus { initial, submissionInProgress, success, failure }

@freezed
class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    required AuthMode mode,
    @Default('') String email,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default(true) bool isPasswordHidden,
    @Default(true) bool isConfirmPasswordHidden,
    @Default(AuthStatus.initial) AuthStatus status,
    String? userName,
    String? userEmail,
    String? errorMessage,
  }) = _AuthState;

  bool get canSubmit {
    final hasRequiredFields = email.trim().isNotEmpty && password.isNotEmpty;
    return hasRequiredFields &&
        status != AuthStatus.submissionInProgress &&
        (mode == AuthMode.login || confirmPassword.isNotEmpty);
  }

  bool get isSubmitting => status == AuthStatus.submissionInProgress;
}
