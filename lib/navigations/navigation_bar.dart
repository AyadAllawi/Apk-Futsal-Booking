import 'package:flutter/material.dart';
import 'package:futsal_booking/views/home_futsal.dart';
import 'package:futsal_booking/views/lapangan_screen.dart';
import 'package:futsal_booking/views/pemesanan.dart';
import 'package:futsal_booking/views/profile.dart';
import 'package:get/get.dart';

class Bottom extends StatelessWidget {
  Bottom({super.key});
  static const id = "/bot";

  final NavigationController controller = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 60,
          elevation: 6,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: _navDestinations,
        ),
      ),

      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }

  static const List<NavigationDestination> _navDestinations = [
    NavigationDestination(
      icon: ImageIcon(AssetImage("assets/icons/home.png")),
      label: 'Home',
    ),
    NavigationDestination(
      icon: ImageIcon(AssetImage("assets/icons/soccer-field.png")),
      label: 'Lapangan',
    ),
    NavigationDestination(
      icon: ImageIcon(AssetImage("assets/icons/booking.png"), size: 28),

      label: 'Pemesanan',
    ),
    NavigationDestination(
      icon: ImageIcon(AssetImage("assets/icons/user.png")),
      label: 'Profile',
    ),
  ];
}

class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final List<Widget> screens = [
    const Home(),
    const LapanganScreen(),
    Pemesanan(),
    Profile(),
  ];
}
