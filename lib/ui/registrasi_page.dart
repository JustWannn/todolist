import 'package:flutter/material.dart';
import 'package:toko_kita/bloc/registrasi_bloc.dart';
import 'package:toko_kita/widget/success_dialog.dart';
import 'package:toko_kita/widget/warning_dialog.dart';
import 'package:toko_kita/helpers/app_exception.dart';
import 'package:toko_kita/ui/login_page.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(32.0),
              constraints: const BoxConstraints(maxWidth: 350),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Registrasi",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Silahkan Daftar untuk Melanjutkan",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _namaTextField(),
                    const SizedBox(height: 16),
                    _emailTextField(),
                    const SizedBox(height: 16),
                    _passwordTextField(),
                    const SizedBox(height: 16),
                    _passwordKonfirmasiTextField(),
                    const SizedBox(height: 24),
                    _buttonRegistrasi(),
                    const SizedBox(height: 16),
                    _loginRedirectButton(), // Add the login redirect button
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Membuat Textbox Nama
  Widget _namaTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama"),
      keyboardType: TextInputType.text,
      controller: _namaTextboxController,
      validator: (value) {
        if (value!.length < 3) {
          return "Nama harus diisi minimal 3 karakter";
        }
        return null;
      },
    );
  }

  // Membuat Textbox Email
  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Email"),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        // validasi email
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern.toString());
        if (!regex.hasMatch(value)) {
          return "Format email salah";
        }
        return null;
      },
    );
  }

  // Membuat Textbox Password
  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Password"),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.length < 5) {
          return "Password minimal 6 karakter atau lebih";
        }
        return null;
      },
    );
  }

  // Membuat Textbox Konfirmasi Password
  Widget _passwordKonfirmasiTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Konfirmasi Password"),
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (value) {
        if (value != _passwordTextboxController.text) {
          return "Konfirmasi Password tidak sama";
        }
        return null;
      },
    );
  }

  // Membuat Tombol Registrasi
  Widget _buttonRegistrasi() {
    return ElevatedButton(
      child: const Text("Registrasi"),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) _submit();
        }
      },
    );
  }

  // Fungsi submit registrasi
  void _submit() async {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await RegistrasiBloc.registrasi(
        nama: _namaTextboxController.text,
        email: _emailTextboxController.text,
        password: _passwordTextboxController.text,
      );

      setState(() {
        _isLoading = false;
      });

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const SuccessDialog(
          description: "Registrasi berhasil, silahkan login",
        ),
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      String errorMessage = 'Registrasi gagal, silahkan coba lagi';

      if (error is FetchDataException) {
        errorMessage = 'Kesalahan koneksi: ${error.message}';
      } else if (error is BadRequestException) {
        errorMessage = 'Request tidak valid: ${error.message}';
      } else if (error is UnauthorizedException) {
        errorMessage = 'Anda tidak terotorisasi: ${error.message}';
      } else if (error is UnprocessableEntityException) {
        errorMessage = 'Data tidak dapat diproses: ${error.message}';
      } else if (error is InvalidInputException) {
        errorMessage = 'Input tidak valid: ${error.message}';
      }

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WarningDialog(
          description: errorMessage,
        ),
      );
    }
  }

  // Tombol untuk mengarahkan ke halaman login
  Widget _loginRedirectButton() {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const LoginPage()), // Make sure to replace this with your LoginPage
        );
      },
      child: const Text(
        "Sudah punya akun? Login disini",
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
