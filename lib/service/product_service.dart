// service/product_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qurbanqu/model/product_model.dart'; // Pastikan path import model sudah benar

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'Products'; // Nama koleksi di Firestore

  // Mengambil semua produk dari Firestore
  Future<List<ProductModel>> getAllProducts() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection(_collectionName).get();
      List<ProductModel> productList =
          snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            // Menambahkan ID dokumen ke dalam data sebelum membuat ProductModel
            data['id'] = doc.id;
            return ProductModel.fromJson(data);
          }).toList();
      return productList;
    } catch (e) {
      print('Error mengambil produk: $e');
      throw Exception('Gagal mengambil data produk');
    }
  }

  // Mengambil produk berdasarkan jenis (filter)
  Future<List<ProductModel>> getProductsByType(String jenis) async {
    try {
      QuerySnapshot snapshot =
          await _firestore
              .collection(_collectionName)
              .where('jenis', isEqualTo: jenis)
              .get();
      List<ProductModel> productList =
          snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return ProductModel.fromJson(data);
          }).toList();
      return productList;
    } catch (e) {
      print('Error mengambil produk berdasarkan jenis: $e');
      throw Exception('Gagal mengambil data produk berdasarkan jenis');
    }
  }

  // Anda bisa menambahkan method lain di sini sesuai kebutuhan,
  // misalnya getProductById, addProduct, updateProduct, deleteProduct, dll.
}
