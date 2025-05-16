// lib/screens/user/order_history_screen.dart (lanjutan)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qurbanqu/core/config/app_colors.dart';
import 'package:qurbanqu/core/config/styles.dart';
import 'package:qurbanqu/model/order_model.dart';
import 'package:qurbanqu/model/product_model.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  bool _isLoading = true;
  List<OrderModel> _orderList = [];
  Map<String, ProductModel> _ProductMap = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulasi pemuatan data dari database
    await Future.delayed(const Duration(seconds: 2));

    // Data dummy untuk demonstrasi
    final dummyProduct = {
      '1': ProductModel(
        id: '1',
        nama: 'Sapi Limosin Premium',
        jenis: 'Sapi',
        deskripsi: 'Sapi Limosin kualitas premium.',
        harga: 18500000,
        berat: 450,
        stok: 5,
        gambar:
            'https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8Y293fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60',
      ),
      '2': ProductModel(
        id: '2',
        nama: 'Domba Merino Super',
        jenis: 'Domba',
        deskripsi: 'Domba Merino dengan bulu yang tebal.',
        harga: 3500000,
        berat: 50,
        stok: 10,
        gambar:
            'https://images.unsplash.com/photo-1484557985045-edf25e08da73?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c2hlZXB8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60',
      ),
    };

    final dummyOrders = [
      OrderModel(
        id: '1',
        userId: 'user123',
        hewanId: '1',
        tanggalPesanan: DateTime.now().subtract(const Duration(days: 5)),
        jumlah: 1,
        totalHarga: 18500000,
        status: 'selesai',
      ),
      OrderModel(
        id: '2',
        userId: 'user123',
        hewanId: '2',
        tanggalPesanan: DateTime.now().subtract(const Duration(days: 2)),
        jumlah: 2,
        totalHarga: 7000000,
        status: 'diproses',
      ),
      OrderModel(
        id: '3',
        userId: 'user123',
        hewanId: '1',
        tanggalPesanan: DateTime.now(),
        jumlah: 1,
        totalHarga: 18500000,
        status: 'menunggu',
      ),
    ];

    if (mounted) {
      setState(() {
        _ProductMap = dummyProduct;
        _orderList = dummyOrders;
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'menunggu':
        return Colors.orange;
      case 'diproses':
        return Colors.blue;
      case 'selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'menunggu':
        return 'Menunggu Pembayaran';
      case 'diproses':
        return 'Sedang Diproses';
      case 'selesai':
        return 'Selesai';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    final formatDate = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Pesanan')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _orderList.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 72, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    const Text('Belum ada pesanan', style: AppStyles.heading2),
                    const SizedBox(height: 8),
                    const Text(
                      'Pesanan Anda akan muncul di sini',
                      style: AppStyles.bodyTextSmall,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Mulai Belanja'),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: _loadData,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _orderList.length,
                  itemBuilder: (context, index) {
                    final order = _orderList[index];
                    final Product = _ProductMap[order.hewanId];

                    if (Product == null) {
                      return const SizedBox();
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Status dan Tanggal
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      order.status,
                                    ).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    _getStatusText(order.status),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: _getStatusColor(order.status),
                                    ),
                                  ),
                                ),
                                Text(
                                  formatDate.format(order.tanggalPesanan),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Info Pesanan
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Gambar
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    Product.gambar,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Detail
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Product.nama,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Jenis: ${Product.jenis}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Jumlah: ${order.jumlah} ekor',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Total: ${formatCurrency.format(order.totalHarga)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Aksi
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (order.status == 'menunggu')
                                  OutlinedButton(
                                    onPressed: () {
                                      // Implementasi batal pesanan
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Fitur batal pesanan akan segera hadir!',
                                          ),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      side: const BorderSide(color: Colors.red),
                                    ),
                                    child: const Text('Batalkan'),
                                  ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    // Implementasi detail pesanan
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Fitur detail pesanan akan segera hadir!',
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Detail'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
