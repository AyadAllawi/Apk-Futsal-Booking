import 'package:flutter/material.dart';
import 'package:futsal_booking/navigations/navigation_bar.dart';
import 'package:futsal_booking/preference/shared_preference.dart';
import 'package:futsal_booking/views/logreg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const id = "/splash_screen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    bool? isLogin = await PreferenceHandler.getLogin();

    Future.delayed(Duration(seconds: 3)).then((value) async {
      print(isLogin);
      if (isLogin == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Bottom()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Logreg()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF060F30),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 250),
            Container(
              child: Image(
                image: AssetImage("assets/images/foto/Logo.png"),
                fit: BoxFit.cover,
              ),
            ),
            Spacer(),
            RichText(
              text: TextSpan(
                text: 'Powered by ',
                style: const TextStyle(
                  color: Color.fromARGB(255, 121, 117, 117),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Ayad Allawi',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          
          ],
        ),
      ),
    );
  }
}
