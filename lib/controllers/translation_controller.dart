import 'package:google_mlkit_translation/google_mlkit_translation.dart';

/// Business logic controller handling dynamic multi-language offline edge AI translation operations.
class TranslationController {
  OnDeviceTranslator? _onDeviceTranslator;
  final OnDeviceTranslatorModelManager _modelManager = OnDeviceTranslatorModelManager();

  /// Supported application languages mapped from ISO codes to ML Kit TranslateLanguage enums.
  final Map<String, TranslateLanguage> _languageMapping = {
    'id': TranslateLanguage.indonesian,
    'en': TranslateLanguage.english,
    'ja': TranslateLanguage.japanese,
  };

  /// Downloads all required core language packs (ID, EN, JA) onto the device local storage.
  Future<bool> downloadOfflineModels() async {
    try {
      // 1. Verify and download Indonesian model dependency ('id')
      bool isIndoDownloaded = await _modelManager.isModelDownloaded('id');
      if (!isIndoDownloaded) await _modelManager.downloadModel('id');

      // 2. Verify and download English model dependency ('en')
      bool isEnglishDownloaded = await _modelManager.isModelDownloaded('en');
      if (!isEnglishDownloaded) await _modelManager.downloadModel('en');

      // 3. Verify and download Japanese model dependency ('ja')
      bool isJapaneseDownloaded = await _modelManager.isModelDownloaded('ja');
      if (!isJapaneseDownloaded) await _modelManager.downloadModel('ja');

      return true;
    } catch (e) {
      print('Edge Translation Engine Initialization Failed: $e');
      return false;
    }
  }

  /// Instantiates a dynamic translator instance based on runtime source and target selections.
  void _setupDynamicTranslator(String sourceCode, String targetCode) {
    _onDeviceTranslator?.close(); // Prevent system memory leaks by closing previous session
    
    _onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: _languageMapping[sourceCode] ?? TranslateLanguage.indonesian,
      targetLanguage: _languageMapping[targetCode] ?? TranslateLanguage.english,
    );
  }

  /// Translates input text across specified language vectors entirely offline.
  Future<String> translateText({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    if (text.trim().isEmpty) return "";
    
    try {
      // Initialize the precise runtime translation matrix
      _setupDynamicTranslator(sourceLang, targetLang);
      
      final String translation = await _onDeviceTranslator!.translateText(text);
      return translation;
    } catch (e) {
      return "Translation Error: ${e.toString()}";
    }
  }

  /// Safely closes the translation streaming channel to prevent system resource leaks.
  void closeRegistry() {
    _onDeviceTranslator?.close();
  }
}