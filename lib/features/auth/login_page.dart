import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../dashboard/dashboard_page.dart';
import 'auth_actions.dart';
import 'auth_scaffold.dart';
import 'auth_text_field.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordHidden = true;
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_syncButtonState);
    _passwordController.addListener(_syncButtonState);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _syncButtonState() {
    final canSubmit = _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty;

    if (_canSubmit != canSubmit) {
      setState(() => _canSubmit = canSubmit);
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    Navigator.of(context).pushReplacementNamed(DashboardPage.routeName);
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login Google akan disambungkan nanti.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Masuk',
      subtitle:
          'Masuk ke akunmu sekarang dan tetap\nstay on track sama keuanganmu',
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
              ),
              const SizedBox(height: 22),
              AuthTextField(
                label: 'Password',
                hint: 'Masukkan password',
                controller: _passwordController,
                obscureText: _passwordHidden,
                textInputAction: TextInputAction.done,
                validator: _validatePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() => _passwordHidden = !_passwordHidden);
                  },
                  icon: Icon(
                    _passwordHidden
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: SakuColors.neutral600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 150),
        AuthPrimaryButton(
          label: 'Masuk',
          enabled: _canSubmit,
          onPressed: _submit,
        ),
        const AuthDividerLabel(),
        GoogleAuthButton(
          label: 'Masuk dengan Google',
          onPressed: _showComingSoon,
        ),
        const SizedBox(height: 28),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'Belum punya akun? ',
              style: TextStyle(fontSize: 16),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                  RegisterPage.routeName,
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: SakuColors.blue700,
              ),
              child: const Text(
                'Daftar Akun',
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
}
