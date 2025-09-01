import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedFilter = "All";
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
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                          "assets/images/foto/AyadAllawi.jpg",
                        ),
                        backgroundColor: Colors.grey,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Halo, Ayad",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.notifications_none, color: Colors.white, size: 30),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Mau sewa lapangan dimana ?",
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text("Semua"),
                    selected: selectedFilter == "All",
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = "All";
                      });
                    },
                    backgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 10,
                    ),
                    selectedColor: const Color(0xFF676667),
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: selectedFilter == "All"
                          ? Colors.white
                          : Colors.black,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text("Tersedia"),
                    selected: selectedFilter == "Tersedia",
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = "Tersedia";
                      });
                    },
                    backgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 10,
                    ),
                    selectedColor: Colors.green,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: selectedFilter == "Tersedia"
                          ? Colors.white
                          : Colors.black,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text("Penuh"),
                    selected: selectedFilter == "Penuh",
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = "Penuh";
                      });
                    },
                    backgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 10,
                    ),
                    selectedColor: Colors.red,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: selectedFilter == "Penuh"
                          ? Colors.white
                          : Colors.black,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                constraints: const BoxConstraints.expand(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Rekomendasi untuk kamu",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 1,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 2,
                          children: [
                            _buildLapanganCard(
                              nama: "CGV Sport Hall FX",
                              alamat: "Jl. Jend. Sudirman No.25",
                              rating: 4.2,
                              harga: "300k/jam",
                              jarak: "1.6 km",
                              image: "assets/images/foto/lapangan1.jpg",
                            ),
                            _buildLapanganCard(
                              nama: "Futsal Cilandak",
                              alamat: "Jl. TB Simatupang",
                              rating: 4.5,
                              harga: "350k/jam",
                              jarak: "2.5 km",
                              image: "assets/images/foto/lapangan2.jpg",
                            ),
                            _buildLapanganCard(
                              nama: "Lapangan A",
                              alamat: "Jl. Contoh Alamat",
                              rating: 4.3,
                              harga: "280k/jam",
                              jarak: "3.0 km",
                              image: "assets/images/foto/lapangan3.jpg",
                            ),
                            _buildLapanganCard(
                              nama: "Lapangan B",
                              alamat: "Jl. Contoh Alamat",
                              rating: 4.6,
                              harga: "400k/jam",
                              jarak: "1.2 km",
                              image: "assets/images/foto/lapangan4.jpg",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                    color: Color(0xFFFFFFFF),
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
                Divider(),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      harga,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffffffff),
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
