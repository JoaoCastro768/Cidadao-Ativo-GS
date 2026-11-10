import 'package:flutter/material.dart';
import '../models/issue.dart';
import '../services/issue_storage.dart';
import '../theme/app_theme.dart';

class NewIssueScreen extends StatefulWidget {
  final IssueStorage storage;
  const NewIssueScreen({super.key, required this.storage});

  @override
  State<NewIssueScreen> createState() => _NewIssueScreenState();
}

class _NewIssueScreenState extends State<NewIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _neighborhood = TextEditingController();
  String _category = issueCategories.first;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose(); _description.dispose(); _neighborhood.dispose();
    super.dispose();
  }

  String? _validate(String? raw, int min) {
    final value = (raw ?? '').trim();
    if (value.isEmpty) return 'Campo obrigatório';
    if (value.length < min) return 'Informe pelo menos $min caracteres';
    return null;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false) || _saving) return;
    setState(() => _saving = true);
    try {
      final now = DateTime.now();
      final issue = Issue(
        id: '${now.microsecondsSinceEpoch}',
        title: _title.text.trim(),
        description: _description.text.trim(),
        category: _category,
        neighborhood: _neighborhood.text.trim(),
        createdAt: now,
      );
      await widget.storage.save(issue);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Não foi possível salvar. Tente novamente.')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Nova ocorrência')),
        body: Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(key: _formKey, child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(19),
                  decoration: BoxDecoration(
                    color: AppTheme.mint,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(children: [
                    Icon(Icons.campaign_outlined, color: AppTheme.forest, size: 33),
                    SizedBox(width: 14),
                    Expanded(child: Text('Descreva a situação observada. Este registro será privado e armazenado apenas neste dispositivo.')),
                  ]),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(labelText: 'Título da ocorrência', hintText: 'Ex.: Postes apagados na praça'),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) => _validate(value, 5),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  items: issueCategories.map((category) => DropdownMenuItem(
                    value: category, child: Text(category))).toList(),
                  onChanged: (value) => setState(() => _category = value ?? issueCategories.first),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _neighborhood,
                  decoration: const InputDecoration(labelText: 'Bairro ou local', hintText: 'Ex.: Mooca, São Paulo'),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) => _validate(value, 2),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _description,
                  decoration: const InputDecoration(labelText: 'Descrição detalhada', hintText: 'O que aconteceu? Onde? Há quanto tempo?'),
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 4,
                  maxLines: 6,
                  validator: (value) => _validate(value, 12),
                ),
                const SizedBox(height: 22),
                ElevatedButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(_saving ? 'Salvando...' : 'Salvar registro'),
                ),
              ],
            )),
          ),
        )),
      );
}
