import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Sobre o projeto', style: TextStyle(fontWeight: FontWeight.bold))),
    body: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 680),
      child: ListView(padding: const EdgeInsets.fromLTRB(18, 12, 18, 35), children: [
        Center(child: Image.asset('assets/images/cidade.png', height: 100)),
        const SizedBox(height: 8),
        const Center(child: Text('CIDADÃO ATIVO', style: TextStyle(
          fontSize: 23, fontWeight: FontWeight.w800, color: AppTheme.forest))),
        const SizedBox(height: 6),
        const Center(child: Text('Tecnologia para melhorar o cotidiano urbano')),
        const SizedBox(height: 24),
        const _InfoCard(icon: Icons.lightbulb_outline, title: 'O problema',
          description: 'Muitos problemas do bairro passam despercebidos e as observações ficam dispersas. Este protótipo ajuda o cidadão a organizar e acompanhar seus próprios registros.'),
        const _InfoCard(icon: Icons.phone_android_outlined, title: 'A proposta',
          description: 'Aplicativo Flutter com cadastro local de ocorrências, lista pesquisável, filtros, favoritos, conclusão de registros e busca de endereços por CEP.'),
        const _InfoCard(icon: Icons.public_outlined, title: 'Global Solution • CitizenTech',
          description: 'Projeto acadêmico alinhado à ideia de tecnologias centradas no cidadão e aos ODS 11 (cidades sustentáveis) e 16 (instituições eficazes).'),
        const _InfoCard(icon: Icons.lock_outline, title: 'Privacidade e limites',
          description: 'As ocorrências ficam apenas no armazenamento local do aplicativo. Não existe login, envio de denúncias a órgãos públicos nem acompanhamento oficial de protocolos.'),
        const SizedBox(height: 15),
        const Divider(),
        const ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.person_outline),
          title: Text('Desenvolvedor'),
          subtitle: Text('João Vitor Pedreira de Castro · RM 554628 · FIAP 3SIR'),
        ),
        const ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.code),
          title: Text('Tecnologias'),
          subtitle: Text('Flutter, Dart, http, SharedPreferences e API ViaCEP'),
        ),
      ]),
    )),
  );
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  const _InfoCard({required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) => Card(child: Padding(
    padding: const EdgeInsets.all(19),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CircleAvatar(backgroundColor: AppTheme.mint, child: Icon(icon, color: AppTheme.forest)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 7),
        Text(description, style: const TextStyle(height: 1.5)),
      ])),
    ]),
  ));
}
