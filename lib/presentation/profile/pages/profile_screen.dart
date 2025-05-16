// lib/screens/user/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:qurbanqu/common/custom_button.dart';
import 'package:qurbanqu/core/config/app_colors.dart';
import 'package:qurbanqu/core/config/styles.dart';
import 'package:qurbanqu/presentation/auth/pages/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  bool _isEditing = false;

  // Controller untuk form edit
  final _namaController = TextEditingController();
  final _teleponController = TextEditingController();
  final _alamatController = TextEditingController();

  // Data dummy user
  Map<String, dynamic> _userData = {
    'nama': 'Ahmad Rizky',
    'email': 'ahmad@example.com',
    'telepon': '081234567890',
    'alamat': 'Jl. Contoh No. 123, Jakarta Selatan',
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _teleponController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    // Simulasi pemuatan data dari database
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;

        // Isi controller dengan data user
        _namaController.text = _userData['nama'] ?? '';
        _teleponController.text = _userData['telepon'] ?? '';
        _alamatController.text = _userData['alamat'] ?? '';
      });
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveProfile() async {
    // Validasi data
    if (_namaController.text.isEmpty ||
        _teleponController.text.isEmpty ||
        _alamatController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field harus diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulasi menyimpan data ke database
    await Future.delayed(const Duration(seconds: 2));

    // Update data user
    setState(() {
      _userData = {
        'nama': _namaController.text,
        'email': _userData['email'], // Email tidak bisa diganti
        'telepon': _teleponController.text,
        'alamat': _alamatController.text,
      };
      _isLoading = false;
      _isEditing = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil berhasil diperbarui'),
        backgroundColor: AppColors.primary,
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _toggleEditMode,
            ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Foto Profil
                    Center(
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.primary,
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (!_isEditing)
                            Text(
                              _userData['nama'] ?? '',
                              style: AppStyles.heading1,
                            ),
                          const SizedBox(height: 4),
                          Text(
                            _userData['email'] ?? '',
                            style: AppStyles.bodyTextSmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Form atau Info Detail
                    if (_isEditing) _buildEditForm() else _buildProfileInfo(),

                    const SizedBox(height: 32),

                    // Tombol Logout
                    if (!_isEditing)
                      CustomButton(
                        text: 'Logout',
                        onPressed: _logout,
                        isOutlined: true,
                        color: Colors.red,
                        icon: Icons.logout,
                      ),
                  ],
                ),
              ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Informasi Pribadi', style: AppStyles.heading2),
        const SizedBox(height: 16),
        _buildInfoItem(
          icon: Icons.phone,
          title: 'Nomor Telepon',
          value: _userData['telepon'] ?? '-',
        ),
        const Divider(),
        _buildInfoItem(
          icon: Icons.home,
          title: 'Alamat',
          value: _userData['alamat'] ?? '-',
        ),
        const Divider(),
        const SizedBox(height: 24),

        // Statistics
        const Text('Statistik', style: AppStyles.heading2),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                count: '3',
                title: 'Pesanan',
                icon: Icons.shopping_bag,
              ),
            ),
            Expanded(
              child: _buildStatItem(
                count: '2',
                title: 'Selesai',
                icon: Icons.check_circle,
              ),
            ),
            Expanded(
              child: _buildStatItem(
                count: '1',
                title: 'Proses',
                icon: Icons.pending,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Edit Profil', style: AppStyles.heading2),
          const SizedBox(height: 16),

          // Nama
          TextFormField(
            controller: _namaController,
            decoration: const InputDecoration(
              labelText: 'Nama Lengkap',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 16),

          // Email (disabled)
          TextFormField(
            initialValue: _userData['email'],
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Telepon
          TextFormField(
            controller: _teleponController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Nomor Telepon',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
          ),
          const SizedBox(height: 16),

          // Alamat
          TextFormField(
            controller: _alamatController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Alamat',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.home),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Batal',
                  onPressed: _toggleEditMode,
                  isOutlined: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(text: 'Simpan', onPressed: _saveProfile),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String count,
    required String title,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
