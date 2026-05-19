import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Architectural business controller managing native on-device audio capture and speech-to-text processing.
class SpeechController {
  final stt.SpeechToText _speechEngine = stt.SpeechToText();

  /// Initializes the hardware microphone bindings and checks system permissions.
  Future<bool> initializeSpeechEngine() async {
    try {
      bool available = await _speechEngine.initialize(
        onStatus: (status) => print('Speech Engine Telemetry Status: $status'),
        onError: (errorNotification) => print('Speech Engine Telemetry Error: $errorNotification'),
      );
      return available;
    } catch (e) {
      print('Speech Engine Critical Exception: $e');
      return false;
    }
  }

  /// Begins listening to the microphone stream and captures Indonesian vocal inputs.
  void startListeningStream({
    required Function(String) onResultCallback,
  }) async {
    await _speechEngine.listen(
      localeId: 'id_ID', // Hardcoded to Indonesian language mapping for local micro-vendors
      onResult: (result) {
        onResultCallback(result.recognizedWords);
      },
    );
  }

  /// Terminates the current audio capturing stream safely.
  void stopListeningStream() async {
    await _speechEngine.stop();
  }

  /// Evaluates if the device microphone is actively capturing audio packets.
  bool get isCurrentlyListening => _speechEngine.isListening;
}