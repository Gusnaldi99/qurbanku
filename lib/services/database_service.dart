// lib/services/database_service.dart
import 'package:firebase_database/firebase_database.dart';
import '../models/user_model.dart';

class DatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Menyimpan data pengguna ke Realtime Database
  Future<void> createUser(UserModel user) async {
    try {
      await _dbRef.child('users').child(user.uid).set({
        'nama': user.nama,
        'email': user.email,
        'telepon': user.telepon,
        'alamat': user.alamat,
        'role': user.role,
      });
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  // Mengambil data pengguna berdasarkan UID
  Future<UserModel> getUser(String uid) async {
    try {
      final snapshot = await _dbRef.child('users').child(uid).once();
      if (snapshot.snapshot.exists) {
        final userData = snapshot.snapshot.value as Map<dynamic, dynamic>;
        return UserModel(
          uid: uid,
          nama: userData['nama'],
          email: userData['email'],
          telepon: userData['telepon'],
          alamat: userData['alamat'],
          role: userData['role'],
        );
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error getting user: $e');
      rethrow;
    }
  }
}
