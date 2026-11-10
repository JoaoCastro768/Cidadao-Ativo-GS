import 'package:flutter/material.dart';
import '../models/issue.dart';
import '../services/issue_storage.dart';
import '../theme/app_theme.dart';
import '../widgets/issue_card.dart';
import 'issue_details_screen.dart';

class IssuesScreen extends StatefulWidget {
  final IssueStorage storage;
  final VoidCallback onDataChanged;
  const IssuesScreen({super.key, required this.storage, required this.onDataChanged});

  @override
  State<IssuesScreen> createState() => _IssuesScreenState();
}

class _IssuesScreenState extends State<IssuesScreen> {
  final _searchController = TextEditingController();
  List<Issue> _issues = [];
  String _filter = 'Todos';
  bool _loading = true;
  String? _error;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final issues = await widget.storage.getAll();
      if (mounted) setState(() { _issues = issues; _error = null; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _error = 'Não foi possível ler os registros.'; _loading = false; });
    }
  }

  List<Issue> get _filtered {
    final term = _searchController.text.toLowerCase().trim();
    return _issues.where((issue) {
      final filterMatches = _filter == 'Todos' ||
          (_filter == 'Favoritos' && issue.isFavorite) ||
          (_filter == 'Em aberto' && !issue.isResolved) ||
          (_filter == 'Concluídos' && issue.isResolved);
      final searchMatches = term.isEmpty ||
          '${issue.title} ${issue.category} ${issue.neighborhood} ${issue.description}'
              .toLowerCase().contains(term);
      return filterMatches && searchMatches;
    }).toList();
  }

  Future<void> _toggleFavorite(Issue issue) async {
    try {
      await widget.storage.update(issue.copyWith(isFavorite: !issue.isFavorite));
      if (!mounted) return;
      await _load();
      widget.onDataChanged();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao atualizar favorito.')));
    }
  }

  Future<void> _openDetails(Issue issue) async {
    final changed = await Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (_) => IssueDetailsScreen(issue: issue, storage: widget.storage),
    ));
    if (!mounted) return;
    if (changed == true) {
      await _load();
      widget.onDataChanged();
    }
  }

  @override
  void dispose() { _searchController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final displayed = _filtered;
    return Scaffold(
      appBar: AppBar(title: const Text('Meus registros', style: TextStyle(fontWeight: FontWeight.bold))),
      body: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: RefreshIndicator(onRefresh: _load, child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 105),
          children: [
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Buscar por título, bairro ou categoria',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: ['Todos', 'Em aberto', 'Concluídos', 'Favoritos'].map(
                (option) => Padding(padding: const EdgeInsets.only(right: 8), child:
                  ChoiceChip(
                    selected: _filter == option,
                    onSelected: (_) => setState(() => _filter = option),
                    label: Text(option),
                  )),
              ).toList()),
            ),
            const SizedBox(height: 15),
            if (_loading)
              const Center(child: Padding(padding: EdgeInsets.all(28), child: CircularProgressIndicator()))
            else if (_error != null)
              Column(children: [Text(_error!), TextButton(onPressed: _load, child: const Text('Tentar novamente'))])
            else if (displayed.isEmpty)
              Card(child: Padding(padding: const EdgeInsets.all(30), child: Column(children: [
                Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade600),
                const SizedBox(height: 10),
                const Text('Nenhum registro encontrado.', textAlign: TextAlign.center),
                const SizedBox(height: 8),
                const Text('Experimente mudar o filtro ou criar uma ocorrência.', textAlign: TextAlign.center),
              ])))
            else
              ...displayed.map((issue) => IssueCard(
                issue: issue, onTap: () => _openDetails(issue),
                onFavorite: () => _toggleFavorite(issue),
              )),
            const SizedBox(height: 8),
            Text('${displayed.length} registro(s) exibido(s)',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.ocean)),
          ],
        ))),
      ),
    );
  }
}
