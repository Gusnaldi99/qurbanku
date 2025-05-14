// lib/models/user_model.dart
class UserModel {
  final String uid;
  final String nama;
  final String email;
  final String telepon;
  final String alamat;
  final String role;

  UserModel({
    required this.uid,
    required this.nama,
    required this.email,
    required this.telepon,
    required this.alamat,
    required this.role,
  });

  // Mengubah data menjadi Map untuk disimpan di Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nama': nama,
      'email': email,
      'telepon': telepon,
      'alamat': alamat,
      'role': role,
    };
  }

  // Membuat objek UserModel dari Map
  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      nama: map['nama'],
      email: map['email'],
      telepon: map['telepon'],
      alamat: map['alamat'],
      role: map['role'],
    );
  }
}
