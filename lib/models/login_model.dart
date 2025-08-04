class LoginModel {
  final String status;
  final String message;
  final String token;
  final int id;

  LoginModel({
    required this.status,
    required this.message,
    required this.token,
    required this.id,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'token': token,
      'user_id': id,
    };
  }
}
