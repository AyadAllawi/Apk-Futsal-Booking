import 'package:flutter/material.dart';

class LapanganScreen extends StatefulWidget {
  const LapanganScreen({super.key});

  @override
  State<LapanganScreen> createState() => _LapanganScreenState();
}

class _LapanganScreenState extends State<LapanganScreen> {
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 210,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0C1C3C),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 27,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Pilihan Lapangan!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          // vertical: 1,
                        ),
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C2C4C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: "Cari Lapangan di Jakarta",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            icon: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 1,
                              ),
                              child: Icon(Icons.search, color: Colors.white),
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip(
                  "All",
                  Colors.grey[300]!,
                  Colors.yellow.shade700,
                ),
                const SizedBox(width: 8),
                _buildFilterChip("Tersedia", Colors.grey[300]!, Colors.green),
                const SizedBox(width: 8),
                _buildFilterChip("Penuh", Colors.grey[300]!, Colors.red),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // List Lapangan
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildLapanganCard(
                  nama: "CGV Sport Hall FX",
                  alamat: "Jl. Jend. Sudirman No.25",
                  rating: 4.2,
                  jumlahRating: 40,
                  harga: "150k/jam",
                  jarak: "1.6 km",
                  availableSlot: 2,

                  image: "assets/images/foto/lapangan1.jpg",
                ),
                const SizedBox(height: 12),
                _buildLapanganCard(
                  nama: "Futsal Cilandak",
                  alamat: "Jl. TB Simatupang",
                  rating: 4.5,
                  jumlahRating: 30,
                  harga: "200k/jam",
                  jarak: "2.5 km",
                  availableSlot: 1,

                  image: "assets/images/foto/lapangan2.jpg",
                ),
                const SizedBox(height: 12),
                _buildLapanganCard(
                  nama: "Futsal Cilandak",
                  alamat: "Jl. TB Simatupang",
                  rating: 4.5,
                  jumlahRating: 30,
                  harga: "200k/jam",
                  jarak: "2.5 km",
                  availableSlot: 1,

                  image: "assets/images/foto/lapangan3.jpg",
                ),
                _buildLapanganCard(
                  nama: "Futsal Cilandak",
                  alamat: "Jl. TB Simatupang",
                  rating: 4.5,
                  jumlahRating: 30,
                  harga: "200k/jam",
                  jarak: "2.5 km",
                  availableSlot: 1,

                  image: "assets/images/foto/lapangan4.jpg",
                ),
                //Proyek
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, Color bg, Color selectedColor) {
    return FilterChip(
      label: Text(label),
      selected: selectedFilter == label,
      onSelected: (_) {
        setState(() {
          selectedFilter = label;
        });
      },
      backgroundColor: bg,
      selectedColor: selectedColor,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: selectedFilter == label ? Colors.white : Colors.black,
      ),

      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }

  // Lapangan Card
  Widget _buildLapanganCard({
    required String nama,
    required String alamat,
    required double rating,
    required int jumlahRating,
    required String harga,
    required String jarak,
    required int availableSlot,

    required String image,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0C1C3C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(
                  image,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
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
                    color: Colors.yellow,
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  alamat,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.orange),
                    const SizedBox(width: 4),

                    Text(
                      "$rating ($jumlahRating)",

                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),

                    const Spacer(),
                    Text(
                      harga,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Divider(),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "Available $availableSlot Slot Today",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Spacer(),
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
