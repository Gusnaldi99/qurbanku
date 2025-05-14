// lib/screens/user/kurban_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../../models/kurban_model.dart';
import '../../widgets/custom_button.dart';

class KurbanDetailScreen extends StatefulWidget {
  final KurbanModel kurban;

  const KurbanDetailScreen({Key? key, required this.kurban}) : super(key: key);

  @override
  State<KurbanDetailScreen> createState() => _KurbanDetailScreenState();
}

class _KurbanDetailScreenState extends State<KurbanDetailScreen> {
  int _quantity = 1;
  bool _isLoading = false;

  void _incrementQuantity() {
    if (_quantity < widget.kurban.stok) {
      setState(() {
        _quantity++;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stok tidak mencukupi'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  Future<void> _addToCart() async {
    setState(() {
      _isLoading = true;
    });

    // Simulasi proses checkout
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    // Tampilkan dialog sukses
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Pesanan Berhasil'),
            content: const Text(
              'Hewan kurban telah ditambahkan ke keranjang Anda. Silakan lanjutkan ke pembayaran.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // Kembali ke halaman utama
                },
                child: const Text('Kembali ke Beranda'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Di sini akan navigasi ke halaman checkout
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur checkout akan segera hadir!'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                child: const Text('Lanjut ke Pembayaran'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.kurban.nama)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Hewan
            Hero(
              tag: 'kurban-${widget.kurban.id}',
              child: CachedNetworkImage(
                imageUrl: widget.kurban.gambar,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                errorWidget:
                    (context, url, error) => Image.network(
                      'https://via.placeholder.com/400x250?text=Tidak+Ada+Gambar',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ),
            ),

            // Info Utama
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          widget.kurban.jenis.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          const Text(
                            '4.8',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(120 ulasan)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Nama dan Harga
                  Text(widget.kurban.nama, style: AppStyles.heading1),
                  const SizedBox(height: 8),
                  Text(
                    formatCurrency.format(widget.kurban.harga),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Spesifikasi
                  const Text('Spesifikasi', style: AppStyles.heading2),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSpecItem(
                          icon: Icons.scale,
                          title: 'Berat',
                          value: '${widget.kurban.berat} kg',
                        ),
                      ),
                      Expanded(
                        child: _buildSpecItem(
                          icon: Icons.inventory,
                          title: 'Stok',
                          value: '${widget.kurban.stok} ekor',
                        ),
                      ),
                      Expanded(
                        child: _buildSpecItem(
                          icon: Icons.verified,
                          title: 'Kualitas',
                          value: 'Premium',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Deskripsi
                  const Text('Deskripsi', style: AppStyles.heading2),
                  const SizedBox(height: 8),
                  Text(
                    widget.kurban.deskripsi,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Pengaturan Jumlah
                  const Text('Jumlah', style: AppStyles.heading2),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildQuantityButton(
                        icon: Icons.remove,
                        onPressed: _decrementQuantity,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      _buildQuantityButton(
                        icon: Icons.add,
                        onPressed: _incrementQuantity,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Stok: ${widget.kurban.stok}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Total Harga
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Harga:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatCurrency.format(
                            widget.kurban.harga * _quantity,
                          ),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tombol Pesan
                  CustomButton(
                    text: 'Pesan Sekarang',
                    onPressed: _addToCart,
                    isLoading: _isLoading,
                    icon: Icons.shopping_cart,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}
