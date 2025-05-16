// lib/main.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qurbanqu/core/config/app_colors.dart';
import 'package:qurbanqu/firebase_options.dart';
import 'package:qurbanqu/presentation/admin/pages/admin_dashboard.dart';
import 'package:qurbanqu/presentation/auth/pages/login_screen.dart';
import 'package:qurbanqu/presentation/home/pages/home_screen.dart';
// import 'package:qurbanqu/presentation/product/pages/product_seeder.dart'; // Mungkin tidak diperlukan lagi jika product_seeder hanya untuk sekali jalan
import 'package:qurbanqu/service/auth_service.dart';
import 'package:qurbanqu/service/product_service.dart'; // Import ProductService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Gunakan MultiProvider jika ada lebih dari satu service
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<ProductService>(
          create: (_) => ProductService(),
        ), // Tambahkan ProductService di sini
      ],
      child: MaterialApp(
        title: 'QurbanQu',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

// lib/main.dart
// Hanya bagian AuthWrapper yang diperbarui

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder(
      stream: authService.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;

          if (user == null) {
            return const LoginScreen();
          }

          // Cek role user
          return FutureBuilder<bool>(
            future: authService.isUserAdmin(user.uid),
            builder: (context, adminSnapshot) {
              if (adminSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              // Arahkan ke halaman sesuai role
              if (adminSnapshot.data == true) {
                return const AdminDashboard();
              } else {
                return const HomeScreen();
              }
            },
          );
        }

        // Menampilkan loading saat menunggu koneksi
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
