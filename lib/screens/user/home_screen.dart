// lib/screens/user/home_screen.dart
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../../models/kurban_model.dart';
import '../../widgets/kurban_card.dart';
import 'kurban_detail_screen.dart';
import 'profile_screen.dart';
import 'order_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  List<KurbanModel> _kurbanList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulasi pemuatan data dari database
    await Future.delayed(const Duration(seconds: 2));

    // Data dummy untuk demonstrasi
    final dummyData = [
      KurbanModel(
        id: '1',
        nama: 'Sapi Limosin Premium',
        jenis: 'Sapi',
        deskripsi:
            'Sapi Limosin kualitas premium. Diternakkan dengan pakan berkualitas dan perawatan terbaik.',
        harga: 18500000,
        berat: 450,
        stok: 5,
        gambar:
            'https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8Y293fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60',
      ),
      KurbanModel(
        id: '2',
        nama: 'Domba Merino Super',
        jenis: 'Domba',
        deskripsi:
            'Domba Merino dengan bulu yang tebal dan kualitas daging yang premium. Hasil peternakan lokal terpercaya.',
        harga: 3500000,
        berat: 50,
        stok: 10,
        gambar:
            'https://images.unsplash.com/photo-1484557985045-edf25e08da73?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c2hlZXB8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60',
      ),
      KurbanModel(
        id: '3',
        nama: 'Kambing Etawa Pilihan',
        jenis: 'Kambing',
        deskripsi:
            'Kambing Etawa dengan kualitas daging yang lembut dan bernutrisi tinggi. Diternak dengan standar tinggi.',
        harga: 2800000,
        berat: 35,
        stok: 15,
        gambar:
            'https://images.unsplash.com/photo-1524764517232-b6e486885e78?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Z29hdHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
      ),
      KurbanModel(
        id: '4',
        nama: 'Sapi Bali Unggulan',
        jenis: 'Sapi',
        deskripsi:
            'Sapi Bali kualitas unggulan, dibesarkan dengan pakan organik untuk kualitas daging terbaik.',
        harga: 15000000,
        berat: 400,
        stok: 3,
        gambar:
            'https://images.unsplash.com/photo-1527153857715-3908f2bae5e8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8Y293fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60',
      ),
    ];

    if (mounted) {
      setState(() {
        _kurbanList = dummyData;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QurbanQu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _loadData,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(color: AppColors.primary),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selamat Datang di QurbanQu',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Temukan hewan kurban terbaik untuk Anda',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppColors.accent,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Pesan kurban sekarang untuk dapatkan harga terbaik!',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Filter
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Row(
                        children: [
                          const Text(
                            'Pilihan Hewan Kurban',
                            style: AppStyles.heading2,
                          ),
                          const Spacer(),
                          DropdownButton<String>(
                            value: 'Semua',
                            items: const [
                              DropdownMenuItem(
                                value: 'Semua',
                                child: Text('Semua'),
                              ),
                              DropdownMenuItem(
                                value: 'Sapi',
                                child: Text('Sapi'),
                              ),
                              DropdownMenuItem(
                                value: 'Kambing',
                                child: Text('Kambing'),
                              ),
                              DropdownMenuItem(
                                value: 'Domba',
                                child: Text('Domba'),
                              ),
                            ],
                            onChanged: (value) {
                              // Implementasi filter di sini
                            },
                          ),
                        ],
                      ),
                    ),

                    // Daftar Hewan Kurban
                    Expanded(
                      child:
                          _kurbanList.isEmpty
                              ? const Center(
                                child: Text(
                                  'Tidak ada hewan kurban tersedia',
                                  style: AppStyles.bodyText,
                                ),
                              )
                              : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                itemCount: _kurbanList.length,
                                itemBuilder: (context, index) {
                                  final kurban = _kurbanList[index];
                                  return KurbanCard(
                                    kurban: kurban,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => KurbanDetailScreen(
                                                kurban: kurban,
                                              ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
    );
  }
}
