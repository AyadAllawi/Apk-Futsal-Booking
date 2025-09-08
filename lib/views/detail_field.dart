import 'package:flutter/material.dart';
import 'package:futsal_booking/model/lapangan/field_model.dart';
import 'package:futsal_booking/model/lapangan/schedule.dart';
import 'package:futsal_booking/services/lapangan/booking_services.dart';

class LapanganDetailPage extends StatefulWidget {
  final Datum field; // ✅ pakai Datum (lapangan) dari card_user_lapangan.dart

  const LapanganDetailPage({super.key, required this.field});

  @override
  State<LapanganDetailPage> createState() => _LapanganDetailPageState();
}

class _LapanganDetailPageState extends State<LapanganDetailPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  bool isLoading = false;

  // Pick tanggal
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  // Pick jam
  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          selectedStartTime = picked;
        } else {
          selectedEndTime = picked;
        }
      });
    }
  }

  // Booking
  Future<void> _bookNow() async {
    if (selectedDate == null ||
        selectedStartTime == null ||
        selectedEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih tanggal & jam terlebih dahulu")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Format date & time
      final date =
          "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
      final startTime =
          "${selectedStartTime!.hour.toString().padLeft(2, '0')}:${selectedStartTime!.minute.toString().padLeft(2, '0')}";
      final endTime =
          "${selectedEndTime!.hour.toString().padLeft(2, '0')}:${selectedEndTime!.minute.toString().padLeft(2, '0')}";

      // 1. Buat schedule
      final Schedule? schedule = await BookingService.createSchedule(
        fieldId: widget.field.id,
        date: date,
        startTime: startTime,
        endTime: endTime,
      );

      if (schedule != null) {
        // 2. Booking (contoh userId = 1, nanti ambil dari session)
        final booking = await BookingService.createBooking(
          userId: 1,
          scheduleId: schedule.id,
        );

        if (booking != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Booking berhasil 🎉")));
          Navigator.pop(context); // balik setelah booking
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal membuat booking")),
          );
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Gagal membuat jadwal")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal booking: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final field = widget.field;
    final imageSource = (field.imageUrl ?? "").isNotEmpty
        ? field.imageUrl!
        : (field.imagePath ?? "").isNotEmpty
        ? field.imagePath!
        : "https://via.placeholder.com/600x400.png?text=No+Image";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 🔹 Gambar utama
          Stack(
            children: [
              Image.network(
                imageSource,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 40,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),

          // 🔹 Info detail lapangan
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF0A1847),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Nama & harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Expanded(
                      //   child: Text(
                      //     field.name,
                      //     style: const TextStyle(
                      //       fontSize: 22,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.white,
                      //     ),
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // ),
                      Text(
                        "Rp ${field.pricePerHour ?? "0"} / jam",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 🔹 Rating
                  Row(
                    children: const [
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      SizedBox(width: 4),
                      Text(
                        "4.5 (120 Reviews)",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 🔹 Alamat (sementara hardcode / bisa dari API kalau ada)
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: Colors.white70, size: 18),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "Jl. Jenderal Sudirman No.25, Jakarta Pusat",
                          style: TextStyle(color: Colors.white70),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Form Booking
                  const Text(
                    "Booking Jadwal",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickDate,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              selectedDate == null
                                  ? "Pilih Tanggal"
                                  : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickTime(true),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              selectedStartTime == null
                                  ? "Jam Mulai"
                                  : selectedStartTime!.format(context),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickTime(false),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              selectedEndTime == null
                                  ? "Jam Selesai"
                                  : selectedEndTime!.format(context),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // 🔹 Tombol Booking
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: isLoading ? null : _bookNow,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              "Sewa Sekarang",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
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
