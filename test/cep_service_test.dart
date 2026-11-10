import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:cidadao_ativo/services/cep_service.dart';

void main() {
  test('cep com menos de 8 dígitos falha antes da requisição', () async {
    final service = CepService(client: MockClient((_) async => http.Response('{}', 200)));
    await expectLater(service.lookup('123'), throwsA(isA<CepException>()));
    service.dispose();
  });

  test('JSON é transformado em modelo Dart', () async {
    final service = CepService(client: MockClient((request) async {
      expect(request.url.path, '/ws/01001000/json/');
      return http.Response(jsonEncode({
        'cep': '01001-000', 'logradouro': 'Praça da Sé', 'bairro': 'Sé',
        'localidade': 'São Paulo', 'uf': 'SP',
      }), 200, headers: {'content-type': 'application/json; charset=utf-8'});
    }));
    final address = await service.lookup('01001-000');
    expect(address.city, 'São Paulo');
    expect(address.street, 'Praça da Sé');
    service.dispose();
  });

  test('CEP não encontrado produz exceção controlada', () async {
    final service = CepService(client: MockClient((_) async => http.Response('{"erro":true}', 200)));
    await expectLater(service.lookup('99999999'), throwsA(isA<CepException>()));
    service.dispose();
  });

  test('erro HTTP produz exceção controlada', () async {
    final service = CepService(client: MockClient((_) async => http.Response('Falha', 503)));
    await expectLater(service.lookup('01001000'), throwsA(isA<CepException>()));
    service.dispose();
  });
}
