import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.emailChanged(String email) = AuthEmailChanged;
  const factory AuthEvent.passwordChanged(String password) =
      AuthPasswordChanged;
  const factory AuthEvent.confirmPasswordChanged(String confirmPassword) =
      AuthConfirmPasswordChanged;
  const factory AuthEvent.passwordVisibilityToggled() =
      AuthPasswordVisibilityToggled;
  const factory AuthEvent.confirmPasswordVisibilityToggled() =
      AuthConfirmPasswordVisibilityToggled;
  const factory AuthEvent.loginSubmitted() = AuthLoginSubmitted;
  const factory AuthEvent.registerSubmitted() = AuthRegisterSubmitted;
  const factory AuthEvent.googleSignInRequested() = AuthGoogleSignInRequested;
}
