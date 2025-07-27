import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'providers/todo_provider.dart';
import 'providers/event_provider.dart';
import 'providers/reflection_provider.dart';
import 'screens/main_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await initializeDateFormatting('id_ID', null);
    await NotificationService().init();
  } catch (e) {
    // Graceful fallback if initialization fails
    if (kDebugMode) {
      print('Warning: Some services failed to initialize: $e');
    }
  }
  
  runApp(const SelfManagementApp());
}

class SelfManagementApp extends StatelessWidget {
  const SelfManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => TodoProvider()),
        ChangeNotifierProvider(create: (ctx) => EventProvider()),
        ChangeNotifierProvider(create: (ctx) => ReflectionProvider()),
      ],
      child: MaterialApp(
        title: 'Self Management App',
        debugShowCheckedModeBanner: false,

        // --- PERUBAHAN UTAMA DI SINI ---
        theme: ThemeData(
          // Gunakan ColorScheme dari Material 3 untuk tema yang lebih modern
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4A90E2), // Warna biru yang kita gunakan
            brightness: Brightness.light,
          ),
          useMaterial3: true, // Aktifkan Material 3

          // Atur tema default untuk semua Card di aplikasi
          cardTheme: const CardThemeData(
            elevation: 3, // Beri sedikit efek bayangan/elevasi
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),

          // Kita tetap bisa definisikan AppBarTheme jika ingin kustomisasi lebih
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF4A90E2),
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: const MainScreen(),
      ),
    );
  }
}
