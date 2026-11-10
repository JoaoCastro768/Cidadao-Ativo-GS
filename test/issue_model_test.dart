import 'package:flutter_test/flutter_test.dart';
import 'package:cidadao_ativo/models/issue.dart';

void main() {
  test('serialização preserva dados do registro', () {
    final issue = Issue(
      id: '123', title: 'Calçada danificada',
      description: 'Há um buraco na esquina.',
      category: 'Pavimentação', neighborhood: 'Mooca',
      createdAt: DateTime(2026, 11, 10), isFavorite: true,
    );
    final decoded = Issue.decodeList(Issue.encodeList([issue]));
    expect(decoded, hasLength(1));
    expect(decoded.first.title, 'Calçada danificada');
    expect(decoded.first.isFavorite, true);
    expect(decoded.first.isResolved, false);
    expect(decoded.first.neighborhood, 'Mooca');
  });

  test('copyWith modifica somente o estado solicitado', () {
    final issue = Issue(id: '1', title: 'Teste', description: 'Descrição',
      category: 'Limpeza', neighborhood: 'Centro', createdAt: DateTime(2026));
    final changed = issue.copyWith(isResolved: true);
    expect(changed.isResolved, true);
    expect(changed.isFavorite, false);
    expect(changed.title, issue.title);
  });
}
