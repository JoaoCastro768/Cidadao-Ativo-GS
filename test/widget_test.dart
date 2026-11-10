import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cidadao_ativo/screens/about_screen.dart';
import 'package:cidadao_ativo/theme/app_theme.dart';

void main() {
  testWidgets('tela Sobre comunica finalidade e autor', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: AppTheme.light,
      home: const AboutScreen()));
    expect(find.text('Sobre o projeto'), findsOneWidget);
    expect(find.text('CIDADÃO ATIVO'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
