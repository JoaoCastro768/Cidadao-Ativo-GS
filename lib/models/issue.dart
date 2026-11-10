import 'dart:convert';

class Issue {
  final String id;
  final String title;
  final String description;
  final String category;
  final String neighborhood;
  final DateTime createdAt;
  final bool isFavorite;
  final bool isResolved;

  const Issue({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.neighborhood,
    required this.createdAt,
    this.isFavorite = false,
    this.isResolved = false,
  });

  Issue copyWith({bool? isFavorite, bool? isResolved}) => Issue(
        id: id,
        title: title,
        description: description,
        category: category,
        neighborhood: neighborhood,
        createdAt: createdAt,
        isFavorite: isFavorite ?? this.isFavorite,
        isResolved: isResolved ?? this.isResolved,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'neighborhood': neighborhood,
        'createdAt': createdAt.toIso8601String(),
        'isFavorite': isFavorite,
        'isResolved': isResolved,
      };

  factory Issue.fromJson(Map<String, dynamic> data) => Issue(
        id: data['id'] as String,
        title: data['title'] as String,
        description: data['description'] as String,
        category: data['category'] as String,
        neighborhood: data['neighborhood'] as String,
        createdAt: DateTime.parse(data['createdAt'] as String),
        isFavorite: data['isFavorite'] == true,
        isResolved: data['isResolved'] == true,
      );

  static List<Issue> decodeList(String raw) {
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((value) => Issue.fromJson(value as Map<String, dynamic>))
        .toList();
  }

  static String encodeList(List<Issue> items) =>
      jsonEncode(items.map((item) => item.toJson()).toList());
}

const issueCategories = <String>[
  'Iluminação',
  'Pavimentação',
  'Limpeza',
  'Acessibilidade',
  'Água e esgoto',
  'Outros',
];
