class Login {
  final int? code;
  final bool? status;
  final String? token;
  final int? userID;
  final String? userEmail;

  Login({
    this.code,
    this.status,
    this.token,
    this.userID,
    this.userEmail,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      code: json['code'],
      status: json['status'],
      token: json['data']['token'],
      userID: json['data']['user']['id'] is int
          ? json['data']['user']['id']
          : int.tryParse(json['data']['user']['id'] ?? ''),
      userEmail: json['data']['user']['email'],
    );
  }
}
