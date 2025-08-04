class SignUpModel {
  final int? id;
  final String name;
  final String lname;
  final String email;
  final String phone;
  final String? password;
  final String? confirmPassword;
  final String passportNo;
  final String passportExpiry;
  final String dob;
  final String gender;

  SignUpModel({
    this.id,
    required this.name,
    required this.lname,
    required this.email,
    required this.phone,
     this.password,
     this.confirmPassword,
    required this.passportNo,
    required this.passportExpiry,
    required this.dob,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null)
      'id': id,
      'name': name,
      'lname': lname,
      'email': email,
      'phone': phone,
      'password': password,
      'confirm_password': confirmPassword,
      'passport_no': passportNo,
      'passport_expiry': passportExpiry,
      'dob': dob,
      'gender': gender,
    };
  }

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      id: json['id'],
      name: json['name'],
      lname: json['lname'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      confirmPassword: json['confirm_password'],
      passportNo: json['passport_no'] ?? '',
      passportExpiry: json['passport_expiry'] ?? '',
      dob: json['dob'],
      gender: json['gender'],
    );
  }
}
