import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../dashboard/dashboard_page.dart';
import 'auth_actions.dart';
import 'auth_scaffold.dart';
import 'auth_text_field.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onEmailChanged(String email) {
    context.read<AuthBloc>().add(AuthEmailChanged(email));
  }

  void _onPasswordChanged(String password) {
    context.read<AuthBloc>().add(AuthPasswordChanged(password));
  }

  void _onConfirmPasswordChanged(String confirmPassword) {
    context.read<AuthBloc>().add(AuthConfirmPasswordChanged(confirmPassword));
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() != true) return;
    context.read<AuthBloc>().add(const AuthRegisterSubmitted());
  }

  void _onGoogleSignIn() {
    context.read<AuthBloc>().add(const AuthGoogleSignInRequested());
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _handleStateChange(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.success && state.userName != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DashboardPage(
            userName: state.userName!,
            userEmail: state.userEmail ?? 'google@saku.app',
          ),
        ),
      );
    }

    if (state.status == AuthStatus.failure && state.errorMessage != null) {
      _showMessage(state.errorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(mode: AuthMode.register),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: _handleStateChange,
        builder: (context, state) {
          return AuthScaffold(
            title: 'Daftar',
            subtitle:
                'Satu langkah buat keuangan kamu yang\nlebih terkontrol - daftar sekarang!',
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AuthTextField(
                      label: 'Email',
                      hint: 'Masukkan email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: _validateEmail,
                      onChanged: _onEmailChanged,
                    ),
                    const SizedBox(height: 22),
                    AuthTextField(
                      label: 'Password',
                      hint: 'Masukkan password',
                      controller: _passwordController,
                      obscureText: state.isPasswordHidden,
                      textInputAction: TextInputAction.next,
                      validator: _validatePassword,
                      onChanged: _onPasswordChanged,
                      suffixIcon: IconButton(
                        onPressed: () {
                          context
                              .read<AuthBloc>()
                              .add(const AuthPasswordVisibilityToggled());
                        },
                        icon: Icon(
                          state.isPasswordHidden
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: SakuColors.neutral600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    AuthTextField(
                      label: 'Konfirmasi Password',
                      hint: 'Masukkan ulang password',
                      controller: _confirmPasswordController,
                      obscureText: state.isConfirmPasswordHidden,
                      textInputAction: TextInputAction.done,
                      validator: _validateConfirmPassword,
                      onChanged: _onConfirmPasswordChanged,
                      suffixIcon: IconButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                              const AuthConfirmPasswordVisibilityToggled());
                        },
                        icon: Icon(
                          state.isConfirmPasswordHidden
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: SakuColors.neutral600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              AuthPrimaryButton(
                label: state.isSubmitting ? 'Memproses...' : 'Daftar',
                enabled: state.canSubmit,
                onPressed: _onSubmit,
              ),
              const AuthDividerLabel(),
              GoogleAuthButton(
                label: 'Daftar dengan Google',
                onPressed: _onGoogleSignIn,
              ),
              const SizedBox(height: 28),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    'Sudah punya akun? ',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                        LoginPage.routeName,
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: SakuColors.blue700,
                    ),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email wajib diisi';
    if (!email.contains('@') || !email.contains('.')) {
      return 'Masukkan email yang valid';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if ((value ?? '').isEmpty) return 'Password wajib diisi';
    if ((value ?? '').length < 6) return 'Minimal 6 karakter';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if ((value ?? '').isEmpty) return 'Konfirmasi password wajib diisi';
    if (value != _passwordController.text) return 'Password belum sama';
    return null;
  }
}
