import 'package:flutter/material.dart';
import 'package:futsal_booking/model/lapangan/card_user_lapangan.dart';
import 'package:futsal_booking/model/lapangan/schedule.dart';
import 'package:futsal_booking/preference/shared_preference.dart';

import 'package:futsal_booking/services/lapangan/booking_services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class LapanganDetailPage extends StatefulWidget {
  final Field field;

  const LapanganDetailPage({super.key, required this.field});

  @override
  State<LapanganDetailPage> createState() => _LapanganDetailPageState();
}

class _LapanganDetailPageState extends State<LapanganDetailPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedStart;
  TimeOfDay? selectedEnd;

  bool _isLoading = false;

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickStartTime() async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) setState(() => selectedStart = picked);
  }

  Future<void> _pickEndTime() async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) setState(() => selectedEnd = picked);
  }

Future<void> _submitBooking() async {
  if (selectedDate == null || selectedStart == null || selectedEnd == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lengkapi semua data booking!")),
    );
    return;
  }

  setState(() => _isLoading = true);

  try {
    final date = DateFormat("yyyy-MM-dd").format(selectedDate!);
    
    // ✅ FIX: Convert TimeOfDay to 24-hour format
    final startTime = _formatTimeOfDayTo24Hour(selectedStart!);
    final endTime = _formatTimeOfDayTo24Hour(selectedEnd!);

    print('[DEBUG] Date: $date');
    print('[DEBUG] Start Time: $startTime');
    print('[DEBUG] End Time: $endTime');

    // 🔹 Buat schedule di API
    final schedule = await BookingService.createSchedule(
      fieldId: widget.field.id,
      date: date,
      startTime: startTime,
      endTime: endTime,
    );

    if (schedule != null) {
      // 🔹 Ambil user ID dari shared preferences
      final userId = await PreferenceHandler.getUserId();
      
      if (userId == null) {
        throw Exception("User ID tidak ditemukan. Silakan login kembali.");
      }

      // 🔹 Booking dengan user ID yang benar
      final booking = await BookingService.createBooking(
        userId: userId,
        scheduleId: schedule.id,
      );

      if (booking != null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Booking berhasil dibuat!")),
  );
  Navigator.pop(context); 
  
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal membuat booking!")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal membuat schedule!")),
      );
    }
  } catch (e) {
    print('[ERROR] Submit Booking: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}

// ✅ NEW: Helper function to convert TimeOfDay to 24-hour format
String _formatTimeOfDayTo24Hour(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute'; // Returns like "22:44"
}
  @override
  Widget build(BuildContext context) {
    final field = widget.field;

    return Scaffold(
      backgroundColor: const Color(0xFF0C1C3C),
      body: Stack(
        children: [
          // 🔹 Scroll content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar Lapangan
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    field.imageUrl ??
                        "https://via.placeholder.com/400x200.png?text=No+Image",
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama + rating
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              field.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text("1.6 km"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: const [
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          SizedBox(width: 4),
                          Text("4.2 (40)",
                              style: TextStyle(color: Colors.white70)),
                          SizedBox(width: 10),
                          Icon(Icons.local_offer,
                              color: Colors.orange, size: 18),
                          SizedBox(width: 4),
                          Text("10% Discount area",
                              style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Alamat
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on,
                              color: Colors.white, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Jl. Jenderal Sudirman No.25, Tanah Abang, Jakarta Pusat",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final Uri url = Uri.parse(
                                        "https://maps.google.com/?q=${field.name}");
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    }
                                  },
                                  child: const Text(
                                    "Buka di Google Maps",
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Fasilitas
                      const Text(
                        "Fasilitas",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: const [
    Row(
      children: [
        Icon(Icons.straighten, color: Colors.white70, size: 20),
        SizedBox(width: 6),
        Text("Ukuran : 16.8m x 24.95m", style: TextStyle(color: Colors.white70)),
      ],
    ),
    SizedBox(height: 6),
    Row(
      children: [
        Icon(Icons.people, color: Colors.white70, size: 20),
        SizedBox(width: 6),
        Text("Kapasitas : 14 orang", style: TextStyle(color: Colors.white70)),
      ],
    ),
    SizedBox(height: 6),
    Row(
      children: [
        Icon(Icons.local_parking, color: Colors.white70, size: 20),
        SizedBox(width: 6),
        Text("Tempat Parkir", style: TextStyle(color: Colors.white70)),
      ],
    ),
    SizedBox(height: 6),
    Row(
      children: [
        Icon(Icons.mosque, color: Colors.white70, size: 20),
        SizedBox(width: 6),
        Text("Mushola", style: TextStyle(color: Colors.white70)),
      ],
    ),
    SizedBox(height: 6),
    Row(
      children: [
        Icon(Icons.videocam, color: Colors.white70, size: 20),
        SizedBox(width: 6),
        Text("Full CCTV", style: TextStyle(color: Colors.white70)),
      ],
    ),
    SizedBox(height: 6),
    Row(
      children: [
        Icon(Icons.chair, color: Colors.white70, size: 20),
        SizedBox(width: 6),
        Text("Ruang Tunggu", style: TextStyle(color: Colors.white70)),
      ],
    ),
    SizedBox(height: 6),
    Row(
      children: [
        Icon(Icons.room_preferences, color: Colors.white70, size: 20),
        SizedBox(width: 6),
        Text("Ruang Ganti", style: TextStyle(color: Colors.white70)),
      ],
    ),
  ],
),

                      const SizedBox(height: 20),

                      // Pilih Jadwal
                      const Text(
                        "Pilih Jadwal",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),

                      ElevatedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_today),
                        label: Text(selectedDate == null
                            ? "Pilih Tanggal"
                            : DateFormat("yyyy-MM-dd").format(selectedDate!)),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _pickStartTime,
                        icon: const Icon(Icons.access_time),
                        label: Text(selectedStart == null
                            ? "Pilih Jam Mulai"
                            : selectedStart!.format(context)),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _pickEndTime,
                        icon: const Icon(Icons.access_time_filled),
                        label: Text(selectedEnd == null
                            ? "Pilih Jam Selesai"
                            : selectedEnd!.format(context)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Bottom Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rp. ${field.pricePerHour ?? '0'}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 14),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text(
                            "Sewa Sekarang",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
