import 'package:flutter/material.dart';
import 'package:futsal_booking/model/lapangan/field_model.dart';
import 'package:futsal_booking/services/lapangan/field_services.dart';

class LapanganScreen extends StatefulWidget {
  const LapanganScreen({super.key});

  @override
  State<LapanganScreen> createState() => _LapanganScreenState();
}

class _LapanganScreenState extends State<LapanganScreen> {
  List<Field> fields = [];
  List<Field> filteredFields = [];
  bool isLoading = true;
  String selectedFilter = "All";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchFields();
  }

  Future<void> fetchFields() async {
    try {
      final List<Field> response = await FieldService.getFields();

      setState(() {
        fields = response;
        filteredFields = response;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching fields: $e");
      setState(() => isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat data lapangan: $e")));
    }
  }

  void _deleteField(int id) async {
    try {
      await FieldService.deleteField(id);
      fetchFields();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lapangan berhasil dihapus")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menghapus lapangan: $e")));
    }
  }

  void _applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      _filterFields();
    });
  }

  void _filterFields() {
    List<Field> tempFields = fields;

    if (selectedFilter == "Tersedia") {
      tempFields = tempFields
          .where((field) => field.availableSlot > 0)
          .toList();
    } else if (selectedFilter == "Penuh") {
      tempFields = tempFields
          .where((field) => field.availableSlot == 0)
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      tempFields = tempFields
          .where(
            (field) =>
                field.nama.toLowerCase().contains(searchQuery.toLowerCase()) ||
                field.alamat.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    setState(() {
      filteredFields = tempFields;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      _filterFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman tambah lapangan
        },
        child: const Icon(Icons.add),
      ),
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

          Expanded(
            child: filteredFields.isEmpty
                ? const Center(
                    child: Text(
                      "Tidak ada lapangan yang ditemukan",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredFields.length,
                    itemBuilder: (context, index) {
                      final field = filteredFields[index];
                      return Column(
                        children: [
                          _buildLapanganCard(
                            field: field,
                            onDelete: () => _deleteField(field.id),
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    },
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

  Widget _buildLapanganCard({
    required Field field,
    required VoidCallback onDelete,
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
                child: Image.network(
                  field.imagePath ?? 'https://via.placeholder.com/300x150',
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
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
                  child: Text(
                    "${field.jarak} km",
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        field.nama,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  field.alamat,
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
                      "${field.rating} (${field.jumlahRating})",
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    const Spacer(),
                    Text(
                      field.pricePerHour.isNotEmpty
                          ? field.pricePerHour
                          : "Rp${field.harga.toStringAsFixed(0)}/jam",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      field.availableSlot > 0
                          ? "Available ${field.availableSlot} Slot Today"
                          : "Sudah Penuh",
                      style: TextStyle(
                        fontSize: 12,
                        color: field.availableSlot > 0
                            ? Colors.green
                            : Colors.red,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: field.availableSlot > 0
                          ? () {
                              // Navigasi ke halaman booking
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade700,
                        foregroundColor: Colors.black,
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
