import 'package:flutter/material.dart';

class Pemesanan extends StatefulWidget {
  const Pemesanan({super.key});

  @override
  State<Pemesanan> createState() => _PemesananState();
}

class _PemesananState extends State<Pemesanan>
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
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          "Pemesanan",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 24,
            color: Color(0xFF0A192F),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFF0066FF),
          labelColor: Color(0xFF0066FF),
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: "Bookingan Berlangsung"),
            Tab(text: "Riwayat Booking"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                "Penyewaan lapangan anda",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A192F),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFDCB58),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "CGV Sport Hall FX",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          color: Color(0xFF0A192F),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.sports_soccer,
                            size: 36,
                            color: Color(0xFF0066FF),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Lapangan 2",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0A192F),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Sabtu, 3 Januari 2023\nPukul 18.00",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 13,
                                    color: Color(0xFF7D7D7D),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            width: 120,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: const DecorationImage(
                                image: AssetImage(
                                  "assets/images/foto/lapangan1.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Chip(
                            label: Text(
                              "Berlangsung",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: Color(0xFF2ECC71),
                            visualDensity: VisualDensity.compact,
                          ),

                          Text(
                            "Lihat E-Tiket",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 13,
                              color: Color(0xFF0066FF),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge Venue
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFDCB58),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "CGV Sport Hall FX",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          color: Color(0xFF0A192F),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.sports_soccer,
                            size: 36,
                            color: Color(0xFF7D7D7D),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Lapangan 2",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0A192F),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Sabtu, 3 Januari 2023\nPukul 18.00",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 13,
                                    color: Color(0xFF7D7D7D),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            width: 120,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: const DecorationImage(
                                image: AssetImage(
                                  "assets/images/foto/lapangan1.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Chip(
                            label: Text(
                              "Selesai",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: Color(0xFF7D7D7D),
                            visualDensity: VisualDensity.compact,
                          ),

                          Text(
                            "Lihat E-Tiket",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 13,
                              color: Color(0xFF0066FF),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Center(
            child: Text(
              "Belum ada riwayat pemesanan",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
