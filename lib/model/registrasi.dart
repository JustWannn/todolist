class Registrasi {
  final int? code;
  final bool? status;
  final String? data;

  Registrasi({this.code, this.status, this.data});

  factory Registrasi.fromJson(Map<String, dynamic> json) {
    return Registrasi(
      code: json['code'],
      status: json['status'],
      data: json['data'],
    );
  }
}
