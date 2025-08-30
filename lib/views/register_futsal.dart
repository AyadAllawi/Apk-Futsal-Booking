import 'package:flutter/material.dart';
import 'package:futsal_booking/api/register_user.dart';
import 'package:futsal_booking/preference/shared_preference.dart';
import 'package:futsal_booking/views/login_futsal.dart';

class RegisterFutsal extends StatefulWidget {
  const RegisterFutsal({super.key});
  static const id = '/register_futsal';

  get data => null;

  @override
  State<RegisterFutsal> createState() => _RegisterFutsalState();

  Object? toJson() {
    return null;
  }

  static Future<RegisterFutsal> fromJson(decode) async {
    return RegisterFutsal();
  }
}

class _RegisterFutsalState extends State<RegisterFutsal> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RegisterFutsal? user;
  String? errorMessage;
  bool isVisibility = false;
  bool isLoading = false;

  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [buildBackground(), buildLayer()]));
  }

  void registerUser() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email, Password, dan Nama tidak boleh kosong"),
        ),
      );

      isLoading = false;

      return;
    }
    try {
      final result = await AuthenticationAPI.registerUser(
        email: email,
        password: password,
        name: name,
      );
      setState(() {
        user = result;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pendaftaran berhasil")));
      PreferenceHandler.saveToken(user?.data?.token.toString() ?? "");
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

  SafeArea buildLayer() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 90),
              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontFamily: 'Poppins-Bold',
                  fontSize: 24,
                  letterSpacing: -0.7,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),
              // const SizedBox(height: 15),
              const Text(
                "Login to access your account",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF888888),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 30),

              // EMAIL
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Name",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF888888),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                      hintText: "Enter your name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      // filled: true,
                      // fillColor: const Color(0xFFFFFFFF),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
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
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                      hintText: "Enter your email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      // filled: true,
                      // fillColor: const Color(0xFFFFFFFF),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // PASSWORD
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
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                      ),
                      hintText: "Enter your password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      // filled: true,
                      // fillColor: const Color(0xFFFFFFFF),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
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

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Color(0xFFF34B1B),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              height(24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    registerUser();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF283FB1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              height(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 8),
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Or Sign In With",
                    // style: TextStyle(fontSize: 12, color: AppColor.gray88),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 8),

                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              height(16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/foto/google_icon.jpg',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Google",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Color(0xFF222222),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              height(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginFutsal()),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color.fromRGBO(40, 63, 177, 1),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/foto/login.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  TextField buildTextField({
    String? hintText,
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? isVisibility : false,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisibility = !isVisibility;
                  });
                },
                icon: Icon(
                  isVisibility ? Icons.visibility_off : Icons.visibility,
                  // color: AppColor.gray88,
                ),
              )
            : null,
      ),
    );
  }

  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);

  Widget buildTitle(String text) {
    return Row(
      children: [
        // Text(text, style: TextStyle(fontSize: 12, color: AppColor.gray88)),
      ],
    );
  }
}
