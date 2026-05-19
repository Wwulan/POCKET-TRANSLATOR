import 'package:speech_to_text/speech_to_text.dart';

/// Business logic controller managing offline localized acoustic speech-to-text streams.
class SpeechController {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  /// Validates system audio hardware permissions and boots up the STT subsystem engine.
  Future<bool> initializeSpeechEngine() async {
    if (_isInitialized) return true;
    try {
      _isInitialized = await _speechToText.initialize(
        onError: (errorNotification) => print('Acoustic Stream Error: $errorNotification'),
        onStatus: (statusNotification) => print('Acoustic Stream Status: $statusNotification'),
      );
      return _isInitialized;
    } catch (e) {
      print('Speech Recognition Engine Lifecycle Failure: $e');
      return false;
    }
  }

  /// Evaluates whether the device microphone channel is actively capturing data stream at runtime.
  bool get isCurrentlyListening => _speechToText.isListening;

  /// Starts streaming acoustic data and parses it based on the specified runtime locale.
  void startListeningStream({
    required Function(String) onResultCallback,
    String localeId = 'id_ID',
  }) {
    // Ensuring the system doesn't trigger operations on an uninitialized infrastructure
    if (!_isInitialized) return;

    _speechToText.listen(
      localeId: localeId,
      onResult: (result) {
        if (result.recognizedWords.isNotEmpty) {
          onResultCallback(result.recognizedWords);
        }
      },
    );
  }

  /// Terminates the ongoing vocal audio capture stream session instantly.
  void stopListeningStream() {
    _speechToText.stop();
  }
}