class ProfileModel {
  final int id;
  final String name;
  final String lname;
  final String email;
  final String phone;
  final String passportNo;
  final String passportExpiry;
  final String dob;
  final String gender;

  ProfileModel({
    required this.id,
    required this.name,
    required this.lname,
    required this.email,
    required this.phone,
    required this.passportNo,
    required this.passportExpiry,
    required this.dob,
    required this.gender,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      lname: json['lname'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      passportNo: json['passport_no'] ?? '',
      passportExpiry: json['passport_expiry'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lname': lname,
      'email': email,
      'phone': phone,
      'passport_no': passportNo,
      'passport_expiry': passportExpiry,
      'dob': dob,
      'gender': gender,
    };
  }
}
