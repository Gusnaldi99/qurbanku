// lib/screens/admin/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qurbanqu/core/config/app_colors.dart';
import 'package:qurbanqu/core/config/styles.dart';
import 'package:qurbanqu/presentation/auth/pages/login_screen.dart';
import 'package:qurbanqu/presentation/product/pages/products_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _isLoading = true;
  final Map<String, dynamic> _dashboardData = {};

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    // Simulasi pemuatan data dari database
    await Future.delayed(const Duration(seconds: 2));

    // Data dummy untuk demonstrasi
    final dummyData = {
      'totalPesanan': 42,
      'pesananBaru': 5,
      'pesananDiproses': 12,
      'pesananSelesai': 25,
      'totalPendapatan': 124500000,
      'stokSapi': 8,
      'stokKambing': 15,
      'stokDomba': 10,
      'recentOrders': [
        {
          'id': 'ORD001',
          'customer': 'Ahmad Rizky',
          'hewan': 'Sapi Limosin',
          'tanggal': DateTime.now().subtract(const Duration(hours: 3)),
          'total': 18500000,
          'status': 'menunggu',
        },
        {
          'id': 'ORD002',
          'customer': 'Budi Santoso',
          'hewan': 'Kambing Etawa',
          'tanggal': DateTime.now().subtract(const Duration(hours: 5)),
          'total': 2800000,
          'status': 'diproses',
        },
        {
          'id': 'ORD003',
          'customer': 'Citra Dewi',
          'hewan': 'Domba Merino',
          'tanggal': DateTime.now().subtract(const Duration(hours: 8)),
          'total': 3500000,
          'status': 'selesai',
        },
      ],
    };

    if (mounted) {
      setState(() {
        _dashboardData.addAll(dummyData);
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    // Konfirmasi logout
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Apakah Anda yakin ingin keluar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Logout'),
              ),
            ],
          ),
    );

    if (result == true) {
      // Proses logout
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      // Kembali ke halaman login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
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

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    final formatDate = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _loadDashboardData,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting
                      Text('Selamat Datang, Admin!', style: AppStyles.heading1),
                      Text(
                        'Berikut adalah ringkasan data QurbanQu',
                        style: AppStyles.bodyTextSmall,
                      ),
                      const SizedBox(height: 24),

                      // Stats Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'Total Pesanan',
                              value: _dashboardData['totalPesanan'].toString(),
                              icon: Icons.shopping_cart,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Pendapatan',
                              value: formatCurrency.format(
                                _dashboardData['totalPendapatan'],
                              ),
                              icon: Icons.attach_money,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'Pesanan Baru',
                              value: _dashboardData['pesananBaru'].toString(),
                              icon: Icons.new_releases,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Dalam Proses',
                              value:
                                  _dashboardData['pesananDiproses'].toString(),
                              icon: Icons.pending_actions,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Selesai',
                              value:
                                  _dashboardData['pesananSelesai'].toString(),
                              icon: Icons.check_circle,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Stock Status
                      const Text(
                        'Status Stok Hewan',
                        style: AppStyles.heading2,
                      ),
                      const SizedBox(height: 12),
                      _buildStockCard(
                        animalType: 'Sapi',
                        stock: _dashboardData['stokSapi'],
                        icon: Icons.pets,
                      ),
                      const SizedBox(height: 8),
                      // lib/screens/admin/admin_dashboard.dart (lanjutan)
                      _buildStockCard(
                        animalType: 'Kambing',
                        stock: _dashboardData['stokKambing'],
                        icon: Icons.pets,
                      ),
                      const SizedBox(height: 8),
                      _buildStockCard(
                        animalType: 'Domba',
                        stock: _dashboardData['stokDomba'],
                        icon: Icons.pets,
                      ),
                      const SizedBox(height: 24),

                      // Recent Orders
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Pesanan Terbaru',
                            style: AppStyles.heading2,
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to orders screen
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Fitur daftar pesanan akan segera hadir!',
                                  ),
                                ),
                              );
                            },
                            child: const Text('Lihat Semua'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...(_dashboardData['recentOrders'] as List).map((order) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      order['id'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(
                                          order['status'],
                                        ).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        order['status'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: _getStatusColor(
                                            order['status'],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Customer',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          Text(order['customer']),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Hewan',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          Text(order['hewan']),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Tanggal',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          Text(
                                            formatDate.format(order['tanggal']),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Total',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          Text(
                                            formatCurrency.format(
                                              order['total'],
                                            ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        // View order details
                                      },
                                      child: const Text('Detail'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Process order
                                      },
                                      child: const Text('Proses'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductsScreen()),
          );
        },
        icon: const Icon(Icons.pets),
        label: const Text('Kelola Hewan'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockCard({
    required String animalType,
    required int stock,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  animalType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Stok tersedia: $stock ekor',
                  style: TextStyle(
                    color: stock < 5 ? Colors.red : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductsScreen()),
                );
              },
              child: const Text('Kelola'),
            ),
          ],
        ),
      ),
    );
  }
}
