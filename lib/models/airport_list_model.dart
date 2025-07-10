class Airport{
  final String code;
  final String name;
  final String logo;
  final String city;

  Airport({
    required this.code,
    required this.name,
    required this.logo,
    required this.city
});

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      city: json['city'] ?? ''
    );
  }

  Map<String, dynamic> toCacheJson() {
    return {
      'code' : code,
      'name' : name,
      'logo' : logo,
      'city' : city
    };
  }

  factory Airport.fromCacheJson(Map<String, dynamic> json) {
    return Airport(
        code: json['code'] ?? '',
        name: json['name'] ?? '',
        logo: json['logo'] ?? '',
        city: json['city'] ?? ''
    );
  }
}