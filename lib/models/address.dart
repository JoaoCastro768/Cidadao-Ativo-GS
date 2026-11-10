class Address {
  final String cep;
  final String street;
  final String neighborhood;
  final String city;
  final String state;

  const Address({
    required this.cep,
    required this.street,
    required this.neighborhood,
    required this.city,
    required this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        cep: (json['cep'] ?? '').toString(),
        street: (json['logradouro'] ?? '').toString(),
        neighborhood: (json['bairro'] ?? '').toString(),
        city: (json['localidade'] ?? '').toString(),
        state: (json['uf'] ?? '').toString(),
      );

  String get readableLocation => [
        if (street.isNotEmpty) street,
        if (neighborhood.isNotEmpty) neighborhood,
        '$city/$state',
      ].join(' · ');
}
