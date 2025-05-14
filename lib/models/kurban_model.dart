// lib/models/kurban_model.dart
class KurbanModel {
  final String id;
  final String nama;
  final String jenis;
  final String deskripsi;
  final double harga;
  final double berat;
  final int stok;
  final String gambar;

  KurbanModel({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.deskripsi,
    required this.harga,
    required this.berat,
    required this.stok,
    required this.gambar,
  });

  factory KurbanModel.fromMap(Map<String, dynamic> map, String id) {
    return KurbanModel(
      id: id,
      nama: map['nama'] ?? '',
      jenis: map['jenis'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      harga: (map['harga'] ?? 0).toDouble(),
      berat: (map['berat'] ?? 0).toDouble(),
      stok: map['stok'] ?? 0,
      gambar: map['gambar'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'jenis': jenis,
      'deskripsi': deskripsi,
      'harga': harga,
      'berat': berat,
      'stok': stok,
      'gambar': gambar,
    };
  }
}
