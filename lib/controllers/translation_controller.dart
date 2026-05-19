import 'package:google_mlkit_translation/google_mlkit_translation.dart';

/// Business logic controller handling Edge AI machine learning translation models.
class TranslationController {
  // Initialize the translation engine from Indonesian to English
  final _onDeviceTranslator = OnDeviceTranslator(
    sourceLanguage: TranslateLanguage.indonesian,
    targetLanguage: TranslateLanguage.english,
  );

  final _modelManager = OnDeviceTranslatorModelManager();

  /// Downloads the language packages locally to enable 100% offline functionality.
  Future<bool> downloadOfflineModels() async {
    try {
      // Check if Indonesian and English models are downloaded on the hardware
      final bool isIdDownloaded = await _modelManager.isModelDownloaded(TranslateLanguage.indonesian.bcp47Code);
      final bool isEnDownloaded = await _modelManager.isModelDownloaded(TranslateLanguage.english.bcp47Code);

      if (!isIdDownloaded) {
        await _modelManager.downloadModel(TranslateLanguage.indonesian.bcp47Code);
      }
      if (!isEnDownloaded) {
        await _modelManager.downloadModel(TranslateLanguage.english.bcp47Code);
      }
      return true;
    } catch (e) {
      // System telemetry log for debugging purposes
      print('Telemetry Error: Failed to initialize offline ML weights: $e');
      return false;
    }
  }

  /// Processes text translation locally on the device's operational memory.
  Future<String> translateText(String inputText) async {
    if (inputText.trim().isEmpty) return '';
    try {
      final translationResult = await _onDeviceTranslator.translateText(inputText);
      return translationResult;
    } catch (e) {
      return 'Translation Engine Exception: ${e.toString()}';
    }
  }

  /// Dispose resource bindings to prevent memory leaks in production environment
  void closeRegistry() {
    _onDeviceTranslator.close();
  }
}