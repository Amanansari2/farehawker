class Airline{
  final String code;
  final String name;
  final String logo;

  Airline({
    required this.code,
    required this.name,
    required this.logo
  });

  factory Airline.fromJson(Map<String, dynamic> json){
    return Airline(
        code: json['code'] ?? '',
        name: json['name'] ?? '',
        logo: json['logo'] ?? ''
    );
  }

  Map<String, dynamic> toCacheJson() {
    return {
      'code' : code,
      'name' : name,
      'logo' : logo
    };
  }

  factory Airline.fromCacheJson(Map<String, dynamic> json){
    return Airline(
        code: json['code'] ?? '',
        name: json['name'] ?? '',
        logo: json['logo'] ?? ''
    );
  }
}