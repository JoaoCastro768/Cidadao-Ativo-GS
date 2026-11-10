import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../theme/app_theme.dart';
import 'app_shell.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future<void>.delayed(const Duration(milliseconds: 950));
    bool skip = false;
    try {
      skip = await PreferencesService().shouldSkipOnboarding();
    } catch (_) {
      skip = false;
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
      builder: (_) => skip ? const AppShell() : const OnboardingScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppTheme.forest,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/cidade.png', width: 130, height: 130),
                const SizedBox(height: 16),
                const Text('CIDADÃO ATIVO',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 27,
                        letterSpacing: 1.1)),
                const SizedBox(height: 8),
                const Text('A sua cidade começa com você.',
                    style: TextStyle(color: Colors.white70, fontSize: 15)),
                const SizedBox(height: 36),
                const CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ),
      );
}
