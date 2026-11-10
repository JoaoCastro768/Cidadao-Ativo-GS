import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/address.dart';

class CepException implements Exception {
  final String message;
  const CepException(this.message);
  @override
  String toString() => message;
}

class CepService {
  final http.Client _client;
  final bool _ownsClient;

  CepService({http.Client? client})
      : _client = client ?? http.Client(),
        _ownsClient = client == null;

  Future<Address> lookup(String input) async {
    final cep = input.replaceAll(RegExp(r'\D'), '');
    if (cep.length != 8) {
      throw const CepException('Digite um CEP com 8 números.');
    }

    try {
      final response = await _client
          .get(Uri.https('viacep.com.br', '/ws/$cep/json/'))
          .timeout(const Duration(seconds: 12));

      if (response.statusCode != 200) {
        throw const CepException(
          'Não foi possível consultar o CEP. Tente novamente.',
        );
      }
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, dynamic>) {
        throw const CepException('Resposta inválida do serviço de CEP.');
      }
      if (decoded['erro'] == true) {
        throw const CepException('CEP não encontrado. Confira o número.');
      }
      return Address.fromJson(decoded);
    } on CepException {
      rethrow;
    } on FormatException {
      throw const CepException('O serviço retornou dados inválidos.');
    } catch (_) {
      throw const CepException(
        'Falha de conexão. Verifique sua internet e tente novamente.',
      );
    }
  }

  void dispose() {
    if (_ownsClient) _client.close();
  }
}
