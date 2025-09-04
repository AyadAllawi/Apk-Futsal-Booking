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
        final price = double.tryParse(field.pricePerHour) ?? 0;
        return price < 200000;
      }).toList();
    } else if (selectedFilter == "Penuh") {
      tempFields = tempFields.where((field) {
        final price = double.tryParse(field.pricePerHour) ?? 0;
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
      body: FutureBuilder<SportCard>(
        future: fieldsFuture,
        builder: (context, snapshot) {
          // Handle initial data setup tanpa setState
          if (snapshot.hasData && allFields.isEmpty) {
            final sportCard = snapshot.data!;
            allFields = sportCard.data;
            _filterFields(); // Filter pertama kali
          }

          return _buildContent(snapshot);
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

  Widget _buildContent(AsyncSnapshot<SportCard> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              "Error: ${snapshot.error}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshData,
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      );
    } else if (snapshot.hasData) {
      return Column(
        children: [
          // Header dengan search
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
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C2C4C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          onChanged: _onSearchChanged,
                          decoration: const InputDecoration(
                            hintText: "Cari Lapangan di Jakarta",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(Icons.search, color: Colors.white),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Filter chips
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

          // List lapangan
          Expanded(
            child: filteredFields.isEmpty
                ? const Center(
                    child: Text(
                      "Tidak ada lapangan yang ditemukan",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _refreshData,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredFields.length,
                      itemBuilder: (context, index) {
                        final field = filteredFields[index];
                        return Column(
                          children: [
                            _buildLapanganCard(field: field),
                            const SizedBox(height: 12),
                          ],
                        );
                      },
                    ),
                  ),
          ),
        ],
      );
    } else {
      return const Center(
        child: Text(
          "Tidak ada data lapangan",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
  }

  Widget _buildFilterChip(String label, Color bg, Color selectedColor) {
    return FilterChip(
      label: Text(label),
      selected: selectedFilter == label,
      onSelected: (_) => _applyFilter(label),
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

  Widget _buildLapanganCard({required Datum field}) {
    final price = double.tryParse(field.pricePerHour) ?? 0;
    final isAvailable = price < 200000;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0C1C3C),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Gambar lapangan
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  field.imageUrl.isNotEmpty
                      ? field.imageUrl
                      : (field.imagePath.isNotEmpty
                            ? field.imagePath
                            : 'https://via.placeholder.com/300x150?text=No+Image'),
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 40,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
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
                  child: const Text(
                    "0.5 km",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Positioned(
                left: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isAvailable ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(8),
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

          // Info lapangan
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        field.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  "Jakarta, Indonesia",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    const Text(
                      "4.5 (120)",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    const Spacer(),
                    Text(
                      "Rp${field.pricePerHour}/jam",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey, height: 20),
                Row(
                  children: [
                    Text(
                      isAvailable ? "Available 5 Slot" : "Sudah Penuh",
                      style: TextStyle(
                        fontSize: 12,
                        color: isAvailable ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: isAvailable
                          ? () {
                              print(field.name);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade700,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text("Booking Sekarang"),
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
