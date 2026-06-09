import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/laravel_api_service.dart';
import '../google_auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthMode mode}) : super(AuthState(mode: mode)) {
    on<AuthEmailChanged>(_onEmailChanged);
    on<AuthPasswordChanged>(_onPasswordChanged);
    on<AuthConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<AuthPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<AuthConfirmPasswordVisibilityToggled>(
        _onConfirmPasswordVisibilityToggled);
    on<AuthLoginSubmitted>(_onLoginSubmitted);
    on<AuthRegisterSubmitted>(_onRegisterSubmitted);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
  }

  void _onEmailChanged(
    AuthEmailChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
      status: AuthStatus.initial,
      errorMessage: null,
    ));
  }

  void _onPasswordChanged(
    AuthPasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
      status: AuthStatus.initial,
      errorMessage: null,
    ));
  }

  void _onConfirmPasswordChanged(
    AuthConfirmPasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      confirmPassword: event.confirmPassword,
      status: AuthStatus.initial,
      errorMessage: null,
    ));
  }

  void _onPasswordVisibilityToggled(
    AuthPasswordVisibilityToggled event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(isPasswordHidden: !state.isPasswordHidden));
  }

  void _onConfirmPasswordVisibilityToggled(
    AuthConfirmPasswordVisibilityToggled event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      isConfirmPasswordHidden: !state.isConfirmPasswordHidden,
    ));
  }

  Future<void> _onLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (state.mode != AuthMode.login || state.isSubmitting) return;
    if (!state.canSubmit) return;

    emit(state.copyWith(
      status: AuthStatus.submissionInProgress,
      errorMessage: null,
    ));

    try {
      final auth = await LaravelApiService.instance.login(
        email: state.email.trim(),
        password: state.password,
      );

      emit(state.copyWith(
        status: AuthStatus.success,
        userName: auth.user.name,
        userEmail: auth.user.email,
      ));
    } on LaravelApiException catch (error) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: error.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage:
            'API Laravel belum bisa dihubungi. Pastikan backend sudah berjalan.',
      ));
    }
  }

  Future<void> _onRegisterSubmitted(
    AuthRegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (state.mode != AuthMode.register || state.isSubmitting) return;
    if (!state.canSubmit) return;

    emit(state.copyWith(
      status: AuthStatus.submissionInProgress,
      errorMessage: null,
    ));

    try {
      final auth = await LaravelApiService.instance.register(
        name: _displayNameFromUser(null, state.email.trim()),
        email: state.email.trim(),
        password: state.password,
      );

      emit(state.copyWith(
        status: AuthStatus.success,
        userName: auth.user.name,
        userEmail: auth.user.email,
      ));
    } on LaravelApiException catch (error) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: error.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage:
            'API Laravel belum bisa dihubungi. Pastikan backend sudah berjalan.',
      ));
    }
  }

  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.isSubmitting) return;

    emit(state.copyWith(
      status: AuthStatus.submissionInProgress,
      errorMessage: null,
    ));

    try {
      final user = await GoogleAuthService.instance.authenticate();
      if (user.email == null) {
        throw const FormatException('Email Google tidak tersedia.');
      }

      emit(state.copyWith(
        status: AuthStatus.success,
        userName: _displayNameFromUser(user.displayName, user.email),
        userEmail: user.email!,
      ));
    } on GoogleAuthSetupException catch (error) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: error.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: state.mode == AuthMode.register
            ? 'Daftar dengan Google dibatalkan atau belum siap.'
            : 'Login Google dibatalkan atau belum siap.',
      ));
    }
  }

  String _displayNameFromUser(String? displayName, String? email) {
    final name = displayName?.trim();
    if (name != null && name.isNotEmpty) return name;

    final prefix = email?.split('@').first.trim();
    if (prefix != null && prefix.isNotEmpty) return prefix;

    return 'Pengguna';
  }
}
