import 'package:flutter/material.dart';

import 'package:futsal_booking/model/lapangan/booking_model.dart';
import 'package:futsal_booking/services/lapangan/booking_services.dart';
import 'package:futsal_booking/views/etikcet.dart';
import 'package:intl/intl.dart';

class PemesananPage extends StatefulWidget {
  const PemesananPage({super.key});

  @override
  State<PemesananPage> createState() => _PemesananPageState();
}

class _PemesananPageState extends State<PemesananPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Booking>> _futureBookings;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBookings();
  }

  void _loadBookings() {
    setState(() {
      _futureBookings = BookingService.getMyBookings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 AppBar Custom dengan TabBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(131),
        child: Container(
          padding: const EdgeInsets.only(top: 70),
          decoration: const BoxDecoration(color: Color(0xFF0A1847)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Pemesanan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 20),
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.yellow,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(text: "Pemesanan Berlangsung"),
                  Tab(text: "Riwayat Pemesanan"),
                ],
              ),
            ],
          ),
        ),
      ),

      // 🔹 Body dengan TabBarView
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(isHistory: false),
          _buildBookingList(isHistory: true),
        ],
      ),
    );
  }

  // 🔹 Booking List dari API dengan filter otomatis
  Widget _buildBookingList({required bool isHistory}) {
    return FutureBuilder<List<Booking>>( // ✅ FIX: Ganti jadi List<Booking>
      future: _futureBookings,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error: ${snapshot.error}"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadBookings,
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
          );
        }

        final allBookings = snapshot.data ?? [];

        // 🔹 Filter berdasarkan tanggal
        final now = DateTime.now();
        final filteredBookings = allBookings.where((booking) {
          final bookingDate = DateTime.tryParse(booking.date);
          if (bookingDate == null) return false;
          if (isHistory) {
            return bookingDate.isBefore(now);
          } else {
            return bookingDate.isAtSameMomentAs(now) || bookingDate.isAfter(now);
          }
        }).toList();

        if (filteredBookings.isEmpty) {
          return Center(
            child: Text(
              isHistory ? "Belum ada riwayat pemesanan" : "Belum ada pemesanan aktif",
              style: const TextStyle(fontSize: 16),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            _loadBookings();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredBookings.length,
            itemBuilder: (context, index) {
              final booking = filteredBookings[index];
              return _buildBookingCard(booking);
            },
          ),
        );
      },
    );
  }

  // 🔹 Card Pemesanan (style sama)
  Widget _buildBookingCard(Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Nama Lapangan)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1C1234),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Text(
              booking.fieldName ?? "Lapangan ${booking.fieldId}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          // Isi Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.yellow[700],
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.sports_soccer,
                    size: 36, color: Colors.black87),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tanggal: ${DateFormat('dd MMMM yyyy').format(DateTime.parse(booking.date))}",
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black87),
                      ),
                      Text(
                        "Jam: ${booking.startTime} - ${booking.endTime}",
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Status: ${booking.status}",
                        style: TextStyle(
                          fontSize: 12,
                          color: booking.status == "confirmed" 
                              ? Colors.green 
                              : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1234),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Chat Penyewa",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 🔹 Lihat E-Tiket
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ETiketPage(booking: booking),
                  ),
                );
              },
              child: const Text(
                "Lihat E-Tiket",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}