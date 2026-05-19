import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'views/main_translation_screen.dart'; // Import modular view

void main() async {
  // Ensure Flutter engine bindings are initialized before asynchronous operations
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive Local Database Engine for offline data persistence
  await Hive.initFlutter();
  await Hive.openBox('vendor_history_box');

  runApp(const KakiLimaVoiceApp());
}

class KakiLimaVoiceApp extends StatelessWidget {
  const KakiLimaVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Translator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Utilizing a modern corporate-safe Teal color palette
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MainTranslationScreen(),// Pointing directly to our layout
    );
  }
}

/// Core User Interface Gateway for real-time translation stream.
/// This temporary view will be modularly migrated into the views directory.
class MainTranslationScreen extends StatefulWidget {
  const MainTranslationScreen({super.key});

  @override
  State<MainTranslationScreen> createState() => _MainTranslationScreenState();
}

class _MainTranslationScreenState extends State<MainTranslationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KakiLima Voice Core'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Edge AI Environment Initialized Successfully. Ready for Real-time Offline Translation Engine Deployment. 🚀',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}