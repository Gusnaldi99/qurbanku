// lib/widgets/kurban_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../constants/styles.dart';
import '../constants/colors.dart';
import '../models/kurban_model.dart';

class KurbanCard extends StatelessWidget {
  final KurbanModel kurban;
  final VoidCallback onTap;

  const KurbanCard({Key? key, required this.kurban, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Hewan
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                kurban.gambar.isNotEmpty
                    ? kurban.gambar
                    : 'https://via.placeholder.com/400x200?text=Hewan+Kurban',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    'https://via.placeholder.com/400x200?text=Tidak+Ada+Gambar',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Jenis dan Nama
                  Text(
                    kurban.jenis.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(kurban.nama, style: AppStyles.heading2),
                  const SizedBox(height: 8),

                  // Harga dan Detail
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatCurrency.format(kurban.harga),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        '${kurban.berat} kg',
                        style: AppStyles.bodyTextSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Status Stok
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          kurban.stok > 0
                              ? AppColors.secondary.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      kurban.stok > 0 ? 'Stok: ${kurban.stok}' : 'Stok Habis',
                      style: TextStyle(
                        fontSize: 12,
                        color: kurban.stok > 0 ? AppColors.primary : Colors.red,
                      ),
                    ),
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
