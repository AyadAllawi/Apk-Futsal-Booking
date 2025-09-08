import 'package:flutter/material.dart';
import 'package:futsal_booking/api/register_user.dart';
import 'package:futsal_booking/model/lapangan/card_user_lapangan.dart';
import 'package:futsal_booking/views/detail_field.dart';

class LapanganScreen extends StatefulWidget {
  const LapanganScreen({super.key});

  @override
  State<LapanganScreen> createState() => _LapanganScreenState();
}

class _LapanganScreenState extends State<LapanganScreen>
    with SingleTickerProviderStateMixin {
  late Future<SportCard> fieldsFuture;
  List<Field> allFields = [];
  List<Field> filteredFields = [];
  String selectedFilter = "All";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fieldsFuture = AuthenticationAPI.getFields();
  }

  void _applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      _filterFields();
    });
  }

  void _filterFields() {
    if (allFields.isEmpty) return;

    List<Field> tempFields = List.from(allFields);

    if (selectedFilter == "Tersedia") {
      tempFields = tempFields.where((field) {
        final price = double.tryParse(field.pricePerHour ?? "0") ?? 0;
        return price < 200000;
      }).toList();
    } else if (selectedFilter == "Penuh") {
      tempFields = tempFields.where((field) {
        final price = double.tryParse(field.pricePerHour ?? "0") ?? 0;
        return price >= 200000;
      }).toList();
    }

    if (searchQuery.isNotEmpty) {
      tempFields = tempFields
          .where(
            (field) =>
                field.name.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    filteredFields = tempFields;
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      _filterFields();
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      fieldsFuture = AuthenticationAPI.getFields();
      allFields = [];
      filteredFields = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 Header biru
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
                  // Bar atas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Pilihan Lapangan!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Search bar
                  TextField(
                    onChanged: _onSearchChanged,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Cari Lapangan di Jakarta",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 🔹 Filter Tabs warna-warni
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

            /// 🔹 Body (FutureBuilder isi lapangan)
            Expanded(
              child: FutureBuilder<SportCard>(
                future: fieldsFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData && allFields.isEmpty) {
                    allFields = snapshot.data!.data; // ✅ isi List<Field>
                    _filterFields();
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.yellow),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (filteredFields.isEmpty) {
                    return const Center(
                      child: Text(
                        "Tidak ada lapangan",
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: filteredFields.length,
                      itemBuilder: (context, index) {
                        final field = filteredFields[index];

                        return AnimatedSlide(
                          offset: const Offset(0, 0.2),
                          duration: Duration(milliseconds: 400 + (index * 100)),
                          curve: Curves.easeOut,
                          child: AnimatedOpacity(
                            opacity: 1,
                            duration: Duration(
                              milliseconds: 400 + (index * 100),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),

                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LapanganDetailPage(field: field),
                                    ),
                                  );
                                },
                                child: _buildLapanganCard(field: field),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, Color color) {
    bool isSelected = selectedFilter == value;
    return GestureDetector(
      onTap: () => _applyFilter(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[300],
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  /// 🔹 Card Lapangan
  Widget _buildLapanganCard({required Field field}) {
    final imageSource = (field.imageUrl ?? "").isNotEmpty
        ? field.imageUrl!
        : (field.imagePath ?? "").isNotEmpty
            ? field.imagePath!
            : "https://via.placeholder.com/300x200.png?text=No+Image";

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A1847),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Gambar
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageSource,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellow[700],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "1.6 km",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            // Detail
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      const Text(
                        "4.2 (40)", // dummy rating
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        "${field.pricePerHour ?? "0"} / jam",
                        style: const TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
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
