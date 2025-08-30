import 'package:flutter/material.dart';
import 'package:futsal_booking/views/home_futsal.dart';
import 'package:futsal_booking/views/login_futsal.dart';
import 'package:futsal_booking/views/register_futsal.dart';
import 'package:futsal_booking/views/splash_screens.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting("id_ID");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 3, 3, 3),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/splash_screen': (context) => const SplashScreen(),
        '/login_futsal': (context) => const LoginFutsal(),
        '/register_futsal': (context) => const RegisterFutsal(),
        '/home_futsal': (context) => const Home(),
      },
      // home: LoginFutsal(),
      home: const SplashScreen(),
    );
  }
}
