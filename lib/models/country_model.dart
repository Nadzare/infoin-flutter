class Country {
  final String name;
  final String code;
  final String flagUrl;

  Country({
    required this.name,
    required this.code,
    required this.flagUrl,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']['common'] ?? 'Unknown',
      code: (json['cca2'] ?? 'XX').toLowerCase(),
      flagUrl: json['flags']['png'] ?? '',
    );
  }
}
