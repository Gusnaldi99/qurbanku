// lib/screens/admin/manage_kurban_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../../models/kurban_model.dart';
import 'add_edit_kurban_screen.dart';

class ManageKurbanScreen extends StatefulWidget {
  const ManageKurbanScreen({Key? key}) : super(key: key);

  @override
  State<ManageKurbanScreen> createState() => _ManageKurbanScreenState();
}

class _ManageKurbanScreenState extends State<ManageKurbanScreen> {
  bool _isLoading = true;
  List<KurbanModel> _kurbanList = [];
  String _filterType = 'Semua';

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

  List<KurbanModel> get _filteredKurban {
    if (_filterType == 'Semua') {
      return _kurbanList;
    } else {
      return _kurbanList.where((kurban) => kurban.jenis == _filterType).toList();
    }
  }

  Future<void> _deleteKurban(String id) async {
    // Konfirmasi hapus
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Hewan Kurban'),
        content: const Text('Apakah Anda yakin ingin menghapus hewan kurban ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (result == true) {
      setState(() {
        _isLoading = true;
      });

      // Simulasi proses hapus dari database
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _kurbanList.removeWhere((kurban) => kurban.id == id);
        _isLoading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hewan kurban berhasil dihapus'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Hewan Kurban'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: Column(
                children: [
                  // Filter
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Text('Filter: '),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: _filterType,
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
                            if (value != null) {
                              setState(() {
                                _filterType = value;
                              });
                            }
                          },
                        ),
                        const Spacer(),
                        Text(
                          'Total: ${_filteredKurban.length} hewan',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // List
                  Expanded(
                    child: _filteredKurban.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.pets,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tidak ada hewan kurban $_filterType',
                                  style: AppStyles.heading2,
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const AddEditKurbanScreen(),
                                      ),
                                    ).then((_) => _refreshData());
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Tambah Hewan'),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredKurban.length,
                            itemBuilder: (context, index) {
                              final kurban = _filteredKurban[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Gambar
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          kurban.gambar,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 16),

                                      // Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primary.withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    kurban.jenis,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  formatCurrency.format(kurban.harga),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              kurban.nama,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Berat: ${kurban.berat} kg',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Stok: ${kurban.stok} ekor',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: kurban.stok < 5 ? Colors.red : Colors.black,
                                                fontWeight: kurban.stok < 5 ? FontWeight.bold : FontWeight.normal,
                                              ),
                                            ),
                                            const SizedBox(height: 8),

                                            // Buttons
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                TextButton.icon(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) => AddEditKurbanScreen(
                                                          kurban: kurban,
                                                        ),
                                                      ),
                                                    ).then((_) => _refreshData());
                                                  },
                                                  icon: const Icon(Icons.edit),
                                                  label: const Text('Edit'),
                                                ),
                                                const SizedBox(width: 8),
                                                TextButton.icon(
                                                  onPressed: () => _deleteKurban(kurban.id),
                                                  icon: const Icon(Icons.delete, color: Colors.red),
                                                  label: const Text(
                                                    'Hapus',
                                                    style: TextStyle(color: Colors.red),
                                                  ),
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
                            },
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditKurbanScreen(),
            ),
          ).then((_) => _refreshData());
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
} 