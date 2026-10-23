import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Supabase с защитой от ошибок,
  // чтобы приложение не зависало на чёрном экране
  try {
    await Supabase.initialize(
      url: 'https://dpkeejiyynpdujsteuzq.supabase.co',
      anonKey: 'sb_publishable_A-zoI5L2UKvUjEl_z_XI7A_f3vtrGzU',
    );
  } catch (e, st) {
    debugPrint('Supabase init error: $e\n$st');
    runApp(const _InitErrorApp());
    return;
  }

  runApp(const MyApp());
}

/// Экран, если Supabase не инициализировался
class _InitErrorApp extends StatelessWidget {
  const _InitErrorApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Не удалось запустить приложение.\nПроверьте подключение и попробуйте снова.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4CAF50),
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}