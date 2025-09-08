import 'package:flutter/material.dart';
import 'package:futsal_booking/views/etikcet.dart';

class PemesananPage extends StatefulWidget {
  const PemesananPage({super.key});

  @override
  State<PemesananPage> createState() => _PemesananPageState();
}

class _PemesananPageState extends State<PemesananPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        preferredSize: const Size.fromHeight(127),
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
        children: [_buildPemesananBerlangsung(), _buildRiwayatPemesanan()],
      ),
    );
  }

  // 🔹 Halaman Pemesanan Berlangsung
  Widget _buildPemesananBerlangsung() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Penyewaan lapangan anda",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        // 🔹 Card Pemesanan
        Container(
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
              // Header (Nama Hall)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF1C1234),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: const Text(
                  "CGV Sport Hall FX",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              // Isi Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellow[700],
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.sports_soccer,
                      size: 36,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Lapangan 2",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Sabtu, 3 Januari 2023\nPukul 18.00",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🔹 Tombol Chat
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1234),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Chat Penyewa",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
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
                        builder: (context) => const ETiketPage(),
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
        ),
      ],
    );
  }

  // 🔹 Halaman Riwayat Pemesanan
  Widget _buildRiwayatPemesanan() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Penyewaan lapangan anda",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        // 🔹 Card Pemesanan
        Container(
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
              // Header (Nama Hall)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF1C1234),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: const Text(
                  "CGV Sport Hall FX",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              // Isi Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellow[700],
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.sports_soccer,
                      size: 36,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Lapangan 2",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Sabtu, 3 Januari 2023\nPukul 18.00",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🔹 Tombol Chat
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1234),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Chat Penyewa",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
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
                    // TODO: Navigate to E-Tiket Page
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
        ),
      ],
    );
  }
}
