import 'package:flutter/material.dart';
import '../services/issue_storage.dart';
import 'about_screen.dart';
import 'cep_screen.dart';
import 'home_screen.dart';
import 'issues_screen.dart';
import 'new_issue_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _storage = IssueStorage();
  int _tab = 0;
  int _revision = 0;

  void _refresh() => setState(() => _revision++);

  Future<void> _createIssue() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => NewIssueScreen(storage: _storage)),
    );
    if (!mounted) return;
    if (created == true) {
      setState(() {
        _tab = 1;
        _revision++;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Ocorrência salva neste dispositivo.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(index: _tab, children: [
          HomeScreen(
            key: ValueKey('home_$_revision'),
            storage: _storage,
            onOpenIssues: () => setState(() => _tab = 1),
            onOpenCep: () => setState(() => _tab = 2),
            onCreateIssue: _createIssue,
            onDataChanged: _refresh,
          ),
          IssuesScreen(
            key: ValueKey('issues_$_revision'),
            storage: _storage,
            onDataChanged: _refresh,
          ),
          const CepScreen(),
          const AboutScreen(),
        ]),
        floatingActionButton: _tab < 2
            ? FloatingActionButton.extended(
                onPressed: _createIssue,
                label: const Text('Registrar'),
                icon: const Icon(Icons.add_location_alt_outlined),
              )
            : null,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (value) => setState(() => _tab = value),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.space_dashboard_outlined), selectedIcon: Icon(Icons.space_dashboard), label: 'Início'),
            NavigationDestination(icon: Icon(Icons.format_list_bulleted_outlined), selectedIcon: Icon(Icons.format_list_bulleted), label: 'Registros'),
            NavigationDestination(icon: Icon(Icons.pin_drop_outlined), selectedIcon: Icon(Icons.pin_drop), label: 'CEP'),
            NavigationDestination(icon: Icon(Icons.info_outline), selectedIcon: Icon(Icons.info), label: 'Sobre'),
          ],
        ),
      );
}
