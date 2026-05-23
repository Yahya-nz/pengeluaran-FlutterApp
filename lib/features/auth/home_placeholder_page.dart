import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_logo.dart';
import 'login_page.dart';

class HomePlaceholderPage extends StatelessWidget {
  const HomePlaceholderPage({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SakuColors.blue50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 36),
              const Center(child: AppLogo(width: 156)),
              const Spacer(),
              Image.asset(
                'assets onboarding 2.png',
                height: 210,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 26),
              const Text(
                'Akun siap dipakai',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: SakuColors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Nanti halaman ini bisa disambungkan ke dashboard utama Saku.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: SakuColors.neutral700,
                  fontSize: 16,
                  height: 1.45,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(LoginPage.routeName);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: SakuColors.blue300,
                    foregroundColor: SakuColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Text(
                    'Kembali ke Login',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
