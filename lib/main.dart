import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CidadaoAtivoApp());
}

class CidadaoAtivoApp extends StatelessWidget {
  const CidadaoAtivoApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Cidadão Ativo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashScreen(),
      );
}
