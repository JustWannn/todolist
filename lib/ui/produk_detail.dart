import 'package:flutter/material.dart';
import 'package:toko_kita/bloc/produk_bloc.dart';
import 'package:toko_kita/model/produk.dart';
import 'package:toko_kita/ui/produk_form.dart';

class ProdukDetail extends StatefulWidget {
  final Produk produk;

  const ProdukDetail({super.key, required this.produk});

  @override
  State<ProdukDetail> createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  bool _isDeleting = false; // Indikator untuk proses penghapusan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Aktivitas'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menambahkan Title di atas konten
              const Text(
                "Judul Aktivitas",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              _buildDetailItem("", widget.produk.kodeProduk),
              const SizedBox(height: 16),

              const Text(
                "Deskripsi",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              _buildDetailItem("", widget.produk.namaProduk),
              const SizedBox(height: 16),

              const Text(
                "Hari/Tanggal",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              _buildDetailItem("", widget.produk.hargaProduk),
              const SizedBox(height: 24),

              // Tombol Edit dan Hapus
              _tombolHapusEdit(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan item detail dengan Card untuk desain yang lebih cantik
  Widget _buildDetailItem(String label, String value) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Text(
              "$label: ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis, // Jika teks terlalu panjang
                maxLines: 5, // Membatasi maksimal baris deskripsi
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tombol untuk Edit dan Hapus
  Widget _tombolHapusEdit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tombol Edit
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text(" Ubah "),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Tombol berwarna biru
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProdukForm(produk: widget.produk),
                ),
              ).then((value) {
                if (value == true) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Aktivitas berhasil diperbarui")),
                  );
                  setState(() {}); // Perbarui UI setelah edit
                }
              });
            },
          ),
        ),
        // Tombol Hapus
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: OutlinedButton.icon(
            icon: _isDeleting
                ? const CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.red)
                : const Icon(Icons.delete, color: Colors.red),
            label: const Text(" Hapus ", style: TextStyle(color: Colors.red)),
            onPressed: _isDeleting ? null : _confirmHapus,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red), // Warna border merah
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Dialog Konfirmasi Hapus
  void _confirmHapus() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Konfirmasi",
          style: TextStyle(color: Colors.red),
        ),
        content: const Text("Anda yakin ingin menghapus aktivitas ini?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context), // Tutup dialog
          ),
          TextButton(
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Navigator.pop(context); // Tutup dialog
              await _hapusProduk();
            },
          ),
        ],
      ),
    );
  }

  // Fungsi untuk hapus produk dari backend
  Future<void> _hapusProduk() async {
    setState(() {
      _isDeleting = true;
    });

    try {
      await ProdukBloc.deleteProduk(
          widget.produk.id!); // Pastikan ID tidak null
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Aktivitas berhasil dihapus")),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true); // Kembali ke halaman sebelumnya
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus aktivitas: $e")),
      );
    } finally {
      setState(() {
        _isDeleting = false;
      });
    }
  }
}
