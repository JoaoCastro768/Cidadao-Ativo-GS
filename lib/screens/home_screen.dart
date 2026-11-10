import 'package:flutter/material.dart';
import '../models/issue.dart';
import '../services/issue_storage.dart';
import '../theme/app_theme.dart';
import '../widgets/issue_card.dart';
import 'issue_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final IssueStorage storage;
  final VoidCallback onOpenIssues;
  final VoidCallback onOpenCep;
  final VoidCallback onCreateIssue;
  final VoidCallback onDataChanged;

  const HomeScreen({super.key, required this.storage, required this.onOpenIssues,
    required this.onOpenCep, required this.onCreateIssue, required this.onDataChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Issue> _issues = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final data = await widget.storage.getAll();
      if (mounted) setState(() { _issues = data; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openDetails(Issue issue) async {
    final changed = await Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (_) => IssueDetailsScreen(issue: issue, storage: widget.storage),
    ));
    if (!mounted) return;
    if (changed == true) widget.onDataChanged();
  }

  @override
  Widget build(BuildContext context) {
    final resolved = _issues.where((issue) => issue.isResolved).length;
    return Scaffold(
      backgroundColor: AppTheme.canvas,
      appBar: AppBar(title: const Text('Cidadão Ativo', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(tooltip: 'Consultar CEP', onPressed: widget.onOpenCep,
          icon: const Icon(Icons.travel_explore))]),
      body: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: RefreshIndicator(onRefresh: _load, child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 105), children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppTheme.ocean,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('SUA VOZ FAZ A DIFERENÇA', style: TextStyle(
                letterSpacing: 1.3, color: Color(0xFF9DE0CC), fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              const Text('Pequenas ações.\nUma cidade melhor.',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
              const SizedBox(height: 12),
              const Text('Registre situações do seu bairro e acompanhe suas anotações em um só lugar.',
                style: TextStyle(color: Colors.white70, height: 1.45)),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.ocean),
                onPressed: widget.onCreateIssue,
                icon: const Icon(Icons.add), label: const Text('Nova ocorrência')),
            ]),
          ),
          const SizedBox(height: 22),
          const Text('Visão geral', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(children: [
            _StatCard(label: 'Registros', value: '${_issues.length}', icon: Icons.list_alt_outlined),
            const SizedBox(width: 10),
            _StatCard(label: 'Concluídos', value: '$resolved', icon: Icons.check_circle_outline),
          ]),
          const SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Registros recentes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(onPressed: widget.onOpenIssues, child: const Text('Ver todos')),
          ]),
          if (_loading) const Center(child: Padding(
            padding: EdgeInsets.all(25), child: CircularProgressIndicator()))
          else if (_issues.isEmpty)
            Card(child: Padding(padding: const EdgeInsets.all(25), child: Column(children: [
              Icon(Icons.edit_note_outlined, size: 46, color: Colors.grey.shade600),
              const SizedBox(height: 10),
              const Text('Nenhuma ocorrência cadastrada.', textAlign: TextAlign.center),
              const SizedBox(height: 4),
              const Text('Comece criando um registro local.', textAlign: TextAlign.center),
            ])))
          else
            ..._issues.take(3).map((issue) => IssueCard(issue: issue, onTap: () => _openDetails(issue))),
          const SizedBox(height: 12),
          const Text('Demonstração acadêmica: os registros ficam no dispositivo e não são enviados à prefeitura.',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 12)),
        ]))),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) => Expanded(child: Card(child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: AppTheme.forest),
      const SizedBox(height: 15),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 26)),
      Text(label, style: const TextStyle(color: Colors.black54)),
    ]),
  )));
}
