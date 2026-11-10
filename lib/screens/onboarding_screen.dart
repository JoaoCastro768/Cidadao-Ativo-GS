import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../theme/app_theme.dart';
import 'app_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;
  bool _doNotShowAgain = true;
  bool _finishing = false;

  static const _pages = [
    ('Transforme sua cidade', 'Registre problemas urbanos e organize suas observações sobre o bairro.', Icons.location_city_outlined),
    ('Acompanhe seus registros', 'Consulte ocorrências, pesquise por assunto e destaque o que importa para você.', Icons.fact_check_outlined),
    ('Conheça sua região', 'Pesquise endereços por CEP com dados de uma API pública, sem precisar criar uma conta.', Icons.travel_explore_outlined),
  ];

  Future<void> _finish() async {
    if (_finishing) return;
    setState(() => _finishing = true);
    try {
      await PreferencesService().setSkipOnboarding(_doNotShowAgain);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Não foi possível salvar a preferência de introdução.'),
      ));
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
      builder: (_) => const AppShell(),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('CIDADÃO ATIVO',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                color: AppTheme.forest)),
                        Text('${_index + 1} de ${_pages.length}',
                            style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _controller,
                        itemCount: _pages.length,
                        onPageChanged: (value) => setState(() => _index = value),
                        itemBuilder: (context, i) {
                          final page = _pages[i];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 210,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: AppTheme.mint,
                                    borderRadius: BorderRadius.circular(28)),
                                child: i == 0
                                    ? Center(
                                        child: Image.asset('assets/images/cidade.png',
                                            width: 170, height: 170))
                                    : Icon(page.$3,
                                        size: 112, color: AppTheme.forest),
                              ),
                              const SizedBox(height: 35),
                              Text(page.$1,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.ocean)),
                              const SizedBox(height: 14),
                              Text(page.$2,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      height: 1.55, fontSize: 16)),
                            ],
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pages.length, (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _index == i ? 25 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _index == i ? AppTheme.forest : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                    ),
                    const SizedBox(height: 12),
                    if (_index == _pages.length - 1)
                      CheckboxListTile(
                        value: _doNotShowAgain,
                        onChanged: (value) => setState(() => _doNotShowAgain = value ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Não mostrar novamente'),
                      )
                    else
                      const SizedBox(height: 56),
                    Row(children: [
                      Expanded(
                        child: TextButton(
                          onPressed: _index == 0 ? null : () => _controller.previousPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                          ),
                          child: const Text('Voltar'),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _finishing ? null : _index < _pages.length - 1
                              ? () => _controller.nextPage(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOut)
                              : _finish,
                          child: Text(_index == _pages.length - 1
                              ? 'Começar agora' : 'Próximo'),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
