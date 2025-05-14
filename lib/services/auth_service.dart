// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _db = DatabaseService();

  // Mendapatkan user saat ini
  User? get currentUser => _auth.currentUser;

  // Stream untuk status autentikasi
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Registrasi dengan email dan password
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String nama,
    required String telepon,
    required String alamat,
  }) async {
    try {
      // 1. Buat akun di Firebase Authentication
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Simpan data tambahan user ke Realtime Database
      await _db.createUser(
        UserModel(
          uid: result.user!.uid,
          nama: nama,
          email: email,
          telepon: telepon,
          alamat: alamat,
          role: 'user', // Default sebagai user biasa
        ),
      );

      return result;
    } catch (e) {
      print('Error registrasi: $e');
      rethrow; // Lempar error ke UI untuk ditangani
    }
  }

  // Login dengan email dan password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error login: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  // Memeriksa apakah user adalah admin
  Future<bool> isUserAdmin(String uid) async {
    try {
      final user = await _db.getUser(uid);
      return user.role == 'admin';
    } catch (e) {
      print('Error checking admin status: $e');
      return false;
    }
  }
}