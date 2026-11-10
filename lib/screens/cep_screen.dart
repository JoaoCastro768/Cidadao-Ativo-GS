import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/address.dart';
import '../services/cep_service.dart';
import '../theme/app_theme.dart';

enum CepStatus { initial, loading, success, error }

class CepScreen extends StatefulWidget {
  const CepScreen({super.key});
  @override
  State<CepScreen> createState() => _CepScreenState();
}

class _CepScreenState extends State<CepScreen> {
  final _controller = TextEditingController();
  final _service = CepService();
  CepStatus _status = CepStatus.initial;
  Address? _address;
  String? _error;

  Future<void> _search() async {
    FocusScope.of(context).unfocus();
    setState(() { _status = CepStatus.loading; _error = null; _address = null; });
    try {
      final address = await _service.lookup(_controller.text);
      if (!mounted) return;
      setState(() { _address = address; _status = CepStatus.success; });
    } on CepException catch (e) {
      if (!mounted) return;
      setState(() { _error = e.message; _status = CepStatus.error; });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Ocorreu um erro inesperado. Tente novamente.';
        _status = CepStatus.error;
      });
    }
  }

  @override
  void dispose() { _controller.dispose(); _service.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Consultar CEP', style: TextStyle(fontWeight: FontWeight.bold))),
    body: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 680),
      child: ListView(padding: const EdgeInsets.fromLTRB(20, 12, 20, 110), children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppTheme.mint, borderRadius: BorderRadius.circular(18)),
          child: const Row(children: [
            Icon(Icons.pin_drop_outlined, color: AppTheme.forest, size: 36),
            SizedBox(width: 13),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Localize um endereço', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('Dados de endereço consultados em tempo real pela API ViaCEP.'),
            ])),
          ]),
        ),
        const SizedBox(height: 22),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) {
            if (_status != CepStatus.loading) _search();
          },
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(8)],
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.location_searching),
            labelText: 'Digite o CEP',
            hintText: '01001000',
            helperText: 'Digite somente os 8 números',
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _status == CepStatus.loading ? null : _search,
          icon: const Icon(Icons.search),
          label: const Text('Consultar endereço'),
        ),
        const SizedBox(height: 24),
        if (_status == CepStatus.initial)
          const _MessagePanel(icon: Icons.travel_explore,
            title: 'Pronto para consultar',
            message: 'Preencha o CEP para localizar bairro, cidade e logradouro.')
        else if (_status == CepStatus.loading)
          const Card(child: Padding(padding: EdgeInsets.all(30), child: Column(children: [
            CircularProgressIndicator(), SizedBox(height: 14), Text('Consultando ViaCEP...'),
          ])))
        else if (_status == CepStatus.error)
          Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
            const Icon(Icons.wifi_off_outlined, color: Colors.deepOrange, size: 38),
            const SizedBox(height: 10),
            Text(_error ?? 'Não foi possível consultar', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton.icon(onPressed: _search,
              icon: const Icon(Icons.refresh), label: const Text('Tentar novamente')),
          ])))
        else if (_address != null)
          Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(children: [
                Icon(Icons.verified_outlined, color: AppTheme.forest),
                SizedBox(width: 9),
                Text('Endereço encontrado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ]),
              const Divider(height: 28),
              _AddressRow('CEP', _address!.cep),
              _AddressRow('Logradouro', _address!.street.isEmpty ? 'Não informado' : _address!.street),
              _AddressRow('Bairro', _address!.neighborhood.isEmpty ? 'Não informado' : _address!.neighborhood),
              _AddressRow('Cidade', _address!.city),
              _AddressRow('Estado', _address!.state),
            ],
          ))),
        const SizedBox(height: 25),
        const Text('Fonte: ViaCEP. A consulta depende de conexão com a internet.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.black54)),
      ]),
    )),
  );
}

class _MessagePanel extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  const _MessagePanel({required this.icon, required this.title, required this.message});

  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(26),
    child: Column(children: [
      Icon(icon, color: AppTheme.forest, size: 44),
      const SizedBox(height: 12),
      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 7),
      Text(message, textAlign: TextAlign.center),
    ])));
}

class _AddressRow extends StatelessWidget {
  final String label;
  final String value;
  const _AddressRow(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 3),
      Text(value.isEmpty ? 'Não informado' : value),
    ]),
  );
}
