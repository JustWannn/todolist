class Produk {
  final int? id; // Tetap nullable untuk produk baru
  final String kodeProduk;
  final String namaProduk;
  final String hargaProduk; // Harga tetap sebagai String

  Produk({
    this.id,
    required this.kodeProduk,
    required this.namaProduk,
    required this.hargaProduk,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'] != null
          ? int.tryParse(json['id'].toString())
          : null, // Konversi id ke int
      kodeProduk: json['kode_produk'] ?? '',
      namaProduk: json['nama_produk'] ?? '',
      hargaProduk: json['harga'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode_produk': kodeProduk,
      'nama_produk': namaProduk,
      'harga': hargaProduk, // Harga dikirim sebagai String
    };
  }
}
