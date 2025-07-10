class City {
  final String city;
  final String cityCode;
  final String country;

  City({
    required this.city,
    required this.cityCode,
    required this.country,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      city: json['city'] ?? '',
      cityCode: json['city_code'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toCacheJson() {
    return {
      'city': city,
      'cityCode': cityCode,
      'country': country,
    };
  }

  factory City.fromCacheJson(Map<String, dynamic> json) {
    return City(
      city: json['city'] ?? '',
      cityCode: json['cityCode'] ?? '',
      country: json['country'] ?? '',
    );
  }
}
