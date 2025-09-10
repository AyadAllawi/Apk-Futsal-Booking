import 'dart:io';

import 'package:flutter/material.dart';
import 'package:futsal_booking/preference/shared_preference.dart';
import 'package:futsal_booking/views/login_futsal.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  String? _name;
  String? _email;


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await PreferenceHandler.getUserName();
    final email = await PreferenceHandler.getUserEmail();
    // final phone = await PreferenceHandler.getUserPhone(); // kalau ada
    setState(() {
      _name = name ?? "Guest";
      _email = email ?? "No email";
      // _phone = phone ?? "-";
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              gradient: LinearGradient(
                colors: [Color(0xFF0C1C3C), Color(0xFF0C1C3C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(height: 20),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : const AssetImage(
                                      "assets/images/foto/AyadAllawi.jpg",
                                    )
                                    as ImageProvider,
                        ),
                      ],
                    ),

                    // Kamera button tetap di pojok kanan bawah avatar
                    Positioned(
                      bottom: 0,
                      right: 0, // biar pas di sisi kanan avatar
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.photo_library,
                                    color: Color(0xFF0062DD),
                                  ),
                                  title: const Text("Pilih dari Gallery"),
                                  onTap: () {
                                    _pickImage(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.camera_alt,
                                    color: Color(0xFF0062DD),
                                  ),
                                  title: const Text("Ambil Foto"),
                                  onTap: () {
                                    _pickImage(ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blueAccent,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Color(0xFF0062DD),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Text(
                  _name ?? "Loading...",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _email ?? "",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // BODY
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildInfoTile(
                  title: "Profile Saya",
                  icon: Icons.person,
                ),
                const SizedBox(height: 12),
                _buildInfoTile(
                  title: "Ganti Password",
                  icon: Icons.lock_reset,
                ),
                const SizedBox(height: 12),
                _buildInfoTile(
                  title: "Tambahkan metode pembayaran",
                  icon: Icons.credit_card,
                ),
                const SizedBox(height: 12),
                _buildInfoTile(
                  title: "Notifikasi",
                  icon: Icons.notifications,
                  
                ),
                const SizedBox(height: 12),
                _buildInfoTile(
                  title: "Bahasa",
                  icon: Icons.language,
                  
                ),
                SizedBox(height: 10,),
                Divider(),
                 const SizedBox(height: 12),
                _buildInfoTile(
                  title: "Tentang Aplikasi",
                  icon: Icons.info,
                ),
                 const SizedBox(height: 12),
                _buildInfoTile(
                  title: "Privacy Policy",
                  icon: Icons.privacy_tip,
                ),
                 const SizedBox(height: 12),
                _buildInfoTile(
                  title: "Pengaturan",
                  icon: Icons.settings,
                ),
                const SizedBox(height: 30),

             
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    await PreferenceHandler.clearToken();
                    await PreferenceHandler.saveLogin(false);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginFutsal(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.redAccent, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required String title,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0062DD), size: 26),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'
                  ),
                ),
                const SizedBox(height: 4),
             
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
