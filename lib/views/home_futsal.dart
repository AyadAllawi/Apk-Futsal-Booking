import 'package:flutter/material.dart';
import 'package:futsal_booking/model/lapangan/field_model.dart';
import 'package:futsal_booking/preference/shared_preference.dart';
import 'package:futsal_booking/services/lapangan/field_services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedFilter = "All";
  late Future<String?> futureName;
  late Future<List<Datum>> futureFields;

  @override
  void initState() {
    super.initState();
    futureName = PreferenceHandler.getUserName();
    futureFields = FieldService.getFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 HEADER
            Container(
              padding: const EdgeInsets.only(
                top: 20,
                left: 16,
                right: 16,
                bottom: 20,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF0A1847),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header row
                  Row(
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

                  const SizedBox(height: 16),

                  /// Search
                  const Text(
                    "Mau sewa lapangan dimana?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Color(0xFF1C2C4C),
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
                          color: Color(0xFF1C2C4C),
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

                  const SizedBox(height: 16),

                  /// Filter
                  Row(
                    children: [
                      _buildFilterChip("All", "Semua", Colors.blue),
                      const SizedBox(width: 8),
                      _buildFilterChip("Tersedia", "Tersedia", Colors.green),
                      const SizedBox(width: 8),
                      _buildFilterChip("Penuh", "Penuh", Colors.red),
                    ],
                  ),
                ],
              ),
            ),

            /// 🔹 BODY
            Expanded(
              child: Container(
                color: const Color(0xFFF3F3F3),
                child: FutureBuilder<List<Datum>>(
                  future: futureFields,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Error: ${snapshot.error}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("Tidak ada data lapangan"),
                      );
                    }

                    final fields = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: fields.length,
                      itemBuilder: (context, index) {
                        final field = fields[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildLapanganCard(field: field),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 FilterChip
  Widget _buildFilterChip(String value, String label, Color color) {
    return FilterChip(
      label: Text(label),
      selected: selectedFilter == value,
      onSelected: (_) => setState(() => selectedFilter = value),
      backgroundColor: Colors.grey[300],
      selectedColor: color,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: selectedFilter == value ? Colors.white : Colors.black,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
    );
  }

  /// 🔹 Card Lapangan
  Widget _buildLapanganCard({required Datum field}) {
    final imageSource = (field.imageUrl ?? "").isNotEmpty
        ? field.imageUrl!
        : (field.imagePath ?? "").isNotEmpty
        ? field.imagePath!
        : "https://via.placeholder.com/300x200.png?text=No+Image";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
            child: Image.network(
              imageSource,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  "https://via.placeholder.com/300x200.png?text=No+Image",
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (field.name != null && field.name!.isNotEmpty)
                      ? field.name!
                      : "Nama tidak tersedia",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const Text(
                  "Alamat belum ada", // ganti kalau API ada alamat
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const Divider(),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.orange),
                    const SizedBox(width: 4),
                    const Text(
                      "4.5",
                      style: TextStyle(fontSize: 12),
                    ), // dummy rating sementara
                    const Spacer(),
                    Text(
                      "${field.pricePerHour ?? '0'}/jam",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
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
