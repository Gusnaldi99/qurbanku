// lib/models/order_model.dart
class OrderModel {
  final String id;
  final String userId;
  final String hewanId;
  final DateTime tanggalPesanan;
  final int jumlah;
  final double totalHarga;
  final String status;

  OrderModel({
    required this.id,
    required this.userId,
    required this.hewanId,
    required this.tanggalPesanan,
    required this.jumlah,
    required this.totalHarga,
    required this.status,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['user_id'] ?? '',
      hewanId: map['hewan_id'] ?? '',
      tanggalPesanan: DateTime.fromMillisecondsSinceEpoch(
        map['tanggal_pesanan'] ?? 0,
      ),
      jumlah: map['jumlah'] ?? 0,
      totalHarga: (map['total_harga'] ?? 0).toDouble(),
      status: map['status'] ?? 'menunggu',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'hewan_id': hewanId,
      'tanggal_pesanan': tanggalPesanan.millisecondsSinceEpoch,
      'jumlah': jumlah,
      'total_harga': totalHarga,
      'status': status,
    };
  }
}
