import 'package:flutter/material.dart';
import 'package:futsal_booking/api/register_user.dart';
import 'package:futsal_booking/navigations/navigation_bar.dart';
import 'package:futsal_booking/preference/shared_preference.dart';
import 'package:futsal_booking/views/register_futsal.dart';

class LoginFutsal extends StatefulWidget {
  const LoginFutsal({super.key});
  static const String id = "/login_futsal";
  @override
  State<LoginFutsal> createState() => _LoginFutsalState();
}

class _LoginFutsalState extends State<LoginFutsal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isVisibility = false;
  RegisterFutsal? user;
  String? errorMessage;
  bool isLoading = false;

  bool _isObscure = true;

  void loginUser() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email, Password, dan Nama tidak boleh kosong"),
        ),
      );
      isLoading = false;

      return;
    }
    try {
      final result = await AuthenticationAPI.loginUser(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login berhasil")));
      user = result;
      PreferenceHandler.saveToken(user?.data?.token.toString() ?? "");
      Navigator.pushNamedAndRemoveUntil(
        context,
        Bottom.id,
        (Route<dynamic> route) => false,
      );

      print(user?.toJson());
    } catch (e) {
      print(e);
      setState(() {
        errorMessage = e.toString();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage.toString())));
    } finally {
      setState(() {});
      isLoading = false;
    }
    // final user = User(email: email, password: password, name: name);
    // await DbHelper.registerUser(user);
    // Future.delayed(const Duration(seconds: 1)).then((value) {
    //   isLoading = false;
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text("Pendaftaran berhasil")));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060F30),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Transform.translate(
              offset: const Offset(-20, 30),
              child: Image.asset(
                "assets/images/foto/Logo.png",
                width: 290,
                height: 180,
              ),
            ),
          ),

          // Main Layout
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 200),
                            const Text(
                              "Masuk",
                              style: TextStyle(
                                fontFamily: 'Poppins-Bold',
                                fontSize: 24,
                                letterSpacing: -0.7,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 1),
                              child: Text(
                                "Dan coba pengalaman baru di FutZone!",
                                style: TextStyle(color: Color(0xFFFFFFFF)),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // ===== Email =====
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Email Address",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF888888),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintStyle: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      color: Colors.white70,
                                    ),
                                    hintText: "Enter your email",
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white38,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Password",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF888888),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: _isObscure,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintStyle: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                    hintText: "Enter your password",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white38,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isObscure
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password wajib diisi';
                                    }
                                    if (value.length < 6) {
                                      return 'Password minimal 6 karakter';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 5),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Color(0xFF888888),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        setState(() {
                                          print("Login Clicked");
                                        });
                                        loginUser();
                                      },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  backgroundColor: const Color(0xFF283FB1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(21),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        "Masuk",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Belum Punya Akun? ",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          letterSpacing: -0.5,
                          color: Color(0xFF888888),
                        ),
                      ),
                      TextButton(
                        child: const Text(
                          "Daftar",
                          style: TextStyle(
                            color: Color.fromRGBO(6, 46, 245, 1),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, RegisterFutsal.id);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
