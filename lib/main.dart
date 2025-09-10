import 'package:flutter/material.dart';
import 'package:futsal_booking/navigations/navigation_bar.dart';
import 'package:futsal_booking/views/admin/add_lapangan.dart';
import 'package:futsal_booking/views/home_futsal.dart';
import 'package:futsal_booking/views/lapangan_screen.dart';
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
        '/register_futsal': (context) => const RegisterScreen(),
        '/home_futsal': (context) => const Home(),
        '/bot': (context) => Bottom(),
        '/lapangan': (context) => LapanganScreen(),
        '/add': (context) => AddFieldScreen(
          onFieldAdded: (field) {
            print("Lapangan baru: ${field!.nama}");
          },
        ),
      },
      // home: LoginFutsal(),
      home: SplashScreen(),
    );
  }
}
