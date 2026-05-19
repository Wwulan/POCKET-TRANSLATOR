import 'package:flutter/material.dart';
import 'views/main_translation_screen.dart';

void main() {
  runApp(const KakiLimaVoiceApp());
}

class KakiLimaVoiceApp extends StatelessWidget {
  const KakiLimaVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Translator for Street Vendors',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const MainTranslationScreen(),
    );
  }
}