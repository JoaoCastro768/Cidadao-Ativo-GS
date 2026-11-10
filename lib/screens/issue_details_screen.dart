import 'package:flutter/material.dart';
import '../models/issue.dart';
import '../services/issue_storage.dart';
import '../theme/app_theme.dart';
import '../widgets/issue_card.dart';

class IssueDetailsScreen extends StatefulWidget {
  final Issue issue;
  final IssueStorage storage;
  const IssueDetailsScreen({super.key, required this.issue, required this.storage});

  @override
  State<IssueDetailsScreen> createState() => _IssueDetailsScreenState();
}

class _IssueDetailsScreenState extends State<IssueDetailsScreen> {
  late Issue _issue;
  bool _busy = false;
  bool _changed = false;

  @override
  void initState() { super.initState(); _issue = widget.issue; }

  Future<void> _modify(Issue next) async {
    setState(() => _busy = true);
    try {
      await widget.storage.update(next);
      if (!mounted) return;
      setState(() { _issue = next; _busy = false; _changed = true; });
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Não foi possível atualizar o registro.'),
      ));
    }
  }

  Future<void> _delete() async {
    final accepted = await showDialog<bool>(
      context: context, builder: (context) => AlertDialog(
        title: const Text('Excluir registro?'),
        content: const Text('Essa ação não poderá ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
        ],
      ),
    );
    if (accepted != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await widget.storage.delete(_issue.id);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Não foi possível excluir o registro.')));
    }
  }

  String _date(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop) Navigator.of(context).pop(_changed);
    },
    child: Scaffold(
      appBar: AppBar(title: const Text('Detalhes da ocorrência'), actions: [
        IconButton(
          tooltip: _issue.isFavorite ? 'Remover dos favoritos' : 'Favoritar',
          onPressed: _busy ? null : () => _modify(_issue.copyWith(isFavorite: !_issue.isFavorite)),
          icon: Icon(_issue.isFavorite ? Icons.bookmark : Icons.bookmark_outline),
        ),
      ]),
      body: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: ListView(padding: const EdgeInsets.all(20), children: [
          Card(child: Padding(padding: const EdgeInsets.all(22), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(backgroundColor: AppTheme.mint, radius: 27,
                child: Icon(categoryIcon(_issue.category), color: AppTheme.forest, size: 28)),
              const SizedBox(height: 18),
              Text(_issue.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 6, children: [
                Chip(label: Text(_issue.category)),
                Chip(label: Text(_issue.isResolved ? 'Concluído localmente' : 'Registrado')),
              ]),
              const Divider(height: 30),
              const Text('Local', style: TextStyle(fontWeight: FontWeight.w700)),
              Text(_issue.neighborhood),
              const SizedBox(height: 15),
              const Text('Data do registro', style: TextStyle(fontWeight: FontWeight.w700)),
              Text(_date(_issue.createdAt)),
              const SizedBox(height: 15),
              const Text('Descrição', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(_issue.description, style: const TextStyle(height: 1.5)),
            ],
          ))),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: _busy ? null : () => _modify(_issue.copyWith(isResolved: !_issue.isResolved)),
            icon: Icon(_issue.isResolved ? Icons.undo : Icons.check_circle_outline),
            label: Text(_issue.isResolved ? 'Marcar como em aberto' : 'Marcar como concluído'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(onPressed: _busy ? null : _delete,
            icon: const Icon(Icons.delete_outline), label: const Text('Excluir registro')),
          const SizedBox(height: 15),
          const Text('Situação controlada pelo usuário. Não representa o status de uma solicitação oficial.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 12)),
        ]),
      )),
    ),
  );
}
