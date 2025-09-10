import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedFilter = "All";
  late Future<String?> futureName;

  @override
  void initState() {
    super.initState();
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1C3C),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
       
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(backgroundColor: Colors.grey),
                      const SizedBox(width: 15),
                      FutureBuilder<String?>(
                        future: futureName,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              "Hi, ...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return const Text(
                              "Hi, Error",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          } else {
                            return Text(
                              "Hi, ${snapshot.data ?? "User"}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              ),
            ),

            /// 🔹 Search Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Mau sewa lapangan dimana?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C2C4C),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: "Cari Lapangan di Jakarta",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              icon: Icon(Icons.search, color: Colors.white),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C2C4C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "Jakarta",
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip(
                    "All",
                    "Semua",
                    Colors.grey[300]!,
                    Colors.grey[600]!,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    "Tersedia",
                    "Tersedia",
                    Colors.green,
                    Colors.green,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip("Penuh", "Penuh", Colors.red, Colors.red),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 Scrollable Content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 201, 201, 201),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(15),
                  children: [
                    /// Rekomendasi
                    const Text(
                      "Rekomendasi untuk kamu",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildLapanganCard(
                      nama: "CGV Sport Hall FX",
                      alamat: "Jl. Jend. Sudirman No.25",
                      rating: 4.2,
                      harga: "300k/jam",
                      jarak: "1.6 km",
                      image: "assets/images/foto/lapangan1.jpg",
                    ),
                    const SizedBox(height: 12),
                    _buildLapanganCard(
                      nama: "Futsal Cilandak",
                      alamat: "Jl. TB Simatupang",
                      rating: 4.5,
                      harga: "350k/jam",
                      jarak: "2.5 km",
                      image: "assets/images/foto/lapangan2.jpg",
                    ),

                    const SizedBox(height: 20),

                    /// Favorit
                    const Text(
                      "Lapangan Favorit",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildLapanganCard(
                      nama: "CGV Sport Hall FX",
                      alamat: "Jl. Jend. Sudirman No.25",
                      rating: 4.2,
                      harga: "300k/jam",
                      jarak: "1.6 km",
                      image: "assets/images/foto/lapangan1.jpg",
                    ),
                    const SizedBox(height: 12),
                    _buildLapanganCard(
                      nama: "Futsal Cilandak",
                      alamat: "Jl. TB Simatupang",
                      rating: 4.5,
                      harga: "350k/jam",
                      jarak: "2.5 km",
                      image: "assets/images/foto/lapangan2.jpg",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Widget FilterChip Builder
  Widget _buildFilterChip(
    String value,
    String label,
    Color selectedColor,
    Color bgColor,
  ) {
    return FilterChip(
      label: Text(label),
      selected: selectedFilter == value,
      onSelected: (_) {
        setState(() {
          selectedFilter = value;
        });
      },
      backgroundColor: Colors.grey[300],
      selectedColor: selectedColor,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: selectedFilter == value ? Colors.white : Colors.black,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
    );
  }

  /// 🔹 Widget Card Lapangan
  Widget _buildLapanganCard({
    required String nama,
    required String alamat,
    required double rating,
    required String harga,
    required String jarak,
    required String image,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C2C4C),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              children: [
                Image.asset(
                  image,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 145, 206, 4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      jarak,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Info Lapangan
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  alamat,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Divider(color: Colors.grey),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    const Spacer(),
                    Text(
                      harga,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
