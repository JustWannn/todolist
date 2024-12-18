import 'package:flutter/material.dart';
import 'package:toko_kita/bloc/produk_bloc.dart';
import 'package:toko_kita/model/produk.dart';
import 'package:toko_kita/widget/warning_dialog.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;

  const ProdukForm({super.key, this.produk});

  @override
  // ignore: library_private_types_in_public_api
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  final _kodeProdukController = TextEditingController();
  final _namaProdukController = TextEditingController();
  final _hargaProdukController = TextEditingController();

  bool _isLoading = false;
  late String _judul;
  late String _tombolSubmit;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.produk != null) {
      _judul = "Ubah Aktivitas";
      _tombolSubmit = "Simpan Perubahan";
      _kodeProdukController.text = widget.produk?.kodeProduk ?? '';
      _namaProdukController.text = widget.produk?.namaProduk ?? '';
      _hargaProdukController.text = widget.produk?.hargaProduk ?? '';
    } else {
      _judul = "Tambah Aktivitas";
      _tombolSubmit = "Simpan Aktivitas";
    }
  }

  @override
  void dispose() {
    _kodeProdukController.dispose();
    _namaProdukController.dispose();
    _hargaProdukController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_judul),
        backgroundColor: Colors.blueAccent, // Sesuai dengan tema sebelumnya
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: _kodeProdukController,
                  labelText: "Judul Aktivitas",
                  validator: (value) => value == null || value.isEmpty
                      ? "Judul harus diisi"
                      : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _namaProdukController,
                  labelText: "Deskripsi",
                  validator: (value) => value == null || value.isEmpty
                      ? "Deskripsi harus diisi"
                      : null,
                  maxLines: 5, // Agar dapat menampilkan teks multiline
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _hargaProdukController,
                  labelText: "Hari/Tanggal (hari/dd-mm-yyy)",
                  validator: (value) => value == null || value.isEmpty
                      ? "Hari/Tanggal harus diisi dengan format (hari/dd-mm-yyyy)"
                      : null,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines =
        1, // Menambahkan parameter maxLines untuk mengatur banyaknya baris
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.blueAccent), // Warna label
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Sudut yang lebih lembut
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Colors.blueAccent), // Warna border saat fokus
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines, // Menyesuaikan dengan jumlah baris yang diinginkan
      validator: validator,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent, // Warna tombol submit
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12), // Sudut tombol yang lebih lembut
          ),
        ),
        onPressed: _isLoading
            ? null
            : () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    if (widget.produk != null) {
                      await _submitForm(isUpdate: true);
                    } else {
                      await _submitForm(isUpdate: false);
                    }

                    if (mounted) {
                      Navigator.pop(context, true);
                    }
                  } catch (e) {
                    if (mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => const WarningDialog(
                          description: "Proses gagal, silahkan coba lagi",
                        ),
                      );
                    }
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(_tombolSubmit),
      ),
    );
  }

  Future<void> _submitForm({required bool isUpdate}) async {
    final produk = Produk(
      id: isUpdate ? widget.produk?.id : null,
      kodeProduk: _kodeProdukController.text,
      namaProduk: _namaProdukController.text,
      hargaProduk: _hargaProdukController.text,
    );

    // Debugging: Lihat data produk yang akan dikirim
    // ignore: avoid_print
    print("Aktivitas yang akan dikirim: ${produk.toJson()}");

    if (isUpdate) {
      await ProdukBloc.updateProduk(produk: produk);
    } else {
      await ProdukBloc.addProduk(produk: produk);
    }
  }
}
