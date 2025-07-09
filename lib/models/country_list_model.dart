class City {
  final int id;
  final String city;
  final String citySlug;
  final String cityCode;
  final String country;
  final String countrySlug;
  final String countryCode;

  City({
    required this.id,
    required this.city,
    required this.citySlug,
    required this.cityCode,
    required this.country,
    required this.countrySlug,
    required this.countryCode,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      city: json['city'],
      citySlug: json['city_slug'],
      cityCode: json['city_code'],
      country: json['country'],
      countrySlug: json['country_slug'],
      countryCode: json['country_code'],
    );
  }
}
