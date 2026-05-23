import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/onboarding/onboarding_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const SakuApp());
}

class SakuApp extends StatelessWidget {
  const SakuApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routeFromUrl = Uri.base.fragment.split('?').first;
    final initialRoute = routeFromUrl.startsWith('/') && routeFromUrl.length > 1
        ? routeFromUrl
        : OnboardingPage.routeName;

    return MaterialApp(
      title: 'Saku',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: initialRoute,
      routes: {
        OnboardingPage.routeName: (_) => const OnboardingPage(),
        LoginPage.routeName: (_) => const LoginPage(),
        RegisterPage.routeName: (_) => const RegisterPage(),
        DashboardPage.routeName: (_) => const DashboardPage(),
      },
    );
  }
}
