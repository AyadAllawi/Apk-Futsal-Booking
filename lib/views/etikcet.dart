import 'package:flutter/material.dart';

class ETiketPage extends StatelessWidget {
  const ETiketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1847),
        elevation: 0,
        title: const Text("E-Tiket", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🔹 Kode Booking
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.yellow[700],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  Text(
                    "Kode Booking",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "ABC123XYZ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 Detail Penyewaan
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  children: const [
                    Text(
                      "Detail Pemesanan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Divider(height: 24, thickness: 1),

                    Text(
                      "Sport Hall: CGV Sport Hall FX",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Lapangan: Lapangan 2",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Tanggal: Sabtu, 3 Januari 2023",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text("Jam: 18.00 - 19.00", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 QR Code Dummy
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.qr_code, size: 160, color: Colors.black54),
                  const SizedBox(height: 12),
                  Text(
                    "Tunjukkan QR Code ini saat check-in",
                    style: TextStyle(color: Colors.grey.shade700),
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
