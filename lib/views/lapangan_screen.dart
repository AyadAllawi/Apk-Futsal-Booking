import 'package:flutter/material.dart';
import 'package:futsal_booking/api/register_user.dart';
import 'package:futsal_booking/model/lapangan/card_user_lapangan.dart';
import 'package:futsal_booking/views/admin/add_lapangan.dart';

class LapanganScreen extends StatefulWidget {
  const LapanganScreen({super.key});

  @override
  State<LapanganScreen> createState() => _LapanganScreenState();
}

class _LapanganScreenState extends State<LapanganScreen> {
  late Future<SportCard> fieldsFuture;
  List<Datum> allFields = [];
  List<Datum> filteredFields = [];
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

    List<Datum> tempFields = List.from(allFields);

    // Filter berdasarkan status
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

    // Filter berdasarkan pencarian
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1847),
        elevation: 0,
        title: const Text(
          "Pilihan Lapangan!",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.white),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: _onSearchChanged,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: "Cari Lapangan di Jakarta",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<SportCard>(
        future: fieldsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData && allFields.isEmpty) {
            allFields = snapshot.data!.data;
            _filterFields();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.yellow),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (filteredFields.isEmpty) {
            return const Center(
              child: Text(
                "Tidak ada lapangan",
                style: TextStyle(color: Colors.black54),
              ),
            );
          }

          return Column(
            children: [
              // Filter chips
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    buildFilterChip("All"),
                    const SizedBox(width: 10),
                    buildFilterChip("Tersedia"),
                    const SizedBox(width: 10),
                    buildFilterChip("Penuh"),
                  ],
                ),
              ),

              // List Lapangan
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredFields.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildLapanganCard(field: filteredFields[index]),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFieldScreen(
                onFieldAdded: (newField) {
                  setState(() {
                    allFields.add(newField);
                    _filterFields();
                  });
                },
              ),
            ),
          );
        },
        backgroundColor: Colors.yellow.shade700,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget buildFilterChip(String label) {
    bool isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () => _applyFilter(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.yellow[700] : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
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

  Widget _buildLapanganCard({required Datum field}) {
    final price = double.tryParse(field.pricePerHour ?? "0") ?? 0;
    final isAvailable = price < 200000;

    // pilih gambar aman
    final imageSource = (field.imageUrl ?? "").isNotEmpty
        ? field.imageUrl!
        : (field.imagePath ?? "").isNotEmpty
        ? field.imagePath!
        : "https://via.placeholder.com/300x200.png?text=No+Image";

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A1847),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: (imageSource.isNotEmpty)
                      ? Image.network(
                          imageSource,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/images/foto/placeholder.png",
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          "assets/images/foto/placeholder.png",
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
                      color: isAvailable ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isAvailable ? "Tersedia" : "Penuh",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Jakarta, Indonesia",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      const Text(
                        "4.2 (40)",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const Spacer(),
                      Text(
                        "Rp${field.pricePerHour ?? "-"} /jam",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        isAvailable ? "Available 5 Slot" : "Sudah Penuh",
                        style: TextStyle(
                          color: isAvailable ? Colors.green : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: isAvailable ? () {} : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow.shade700,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text("Booking"),
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
