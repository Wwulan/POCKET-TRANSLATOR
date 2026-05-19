import 'package:flutter/material.dart';
import '../controllers/translation_controller.dart';
import '../controllers/speech_controller.dart';

class MainTranslationScreen extends StatefulWidget {
  const MainTranslationScreen({super.key});

  @override
  State<MainTranslationScreen> createState() => _MainTranslationScreenState();
}

class _MainTranslationScreenState extends State<MainTranslationScreen> {
  final TranslationController _translationController = TranslationController();
  final SpeechController _speechController = SpeechController();
  final TextEditingController _inputController = TextEditingController();
  
  String _translatedOutput = "Translation output will appear here...";
  bool _isEngineReady = false;
  bool _isProcessing = false;
  bool _isListening = false;

  // Curated elite list of vendor-specific transactional statements
  final List<String> _quickPhrases = [
    "Harganya dua puluh ribu rupiah.",
    "Mau dibungkus atau makan di sini?",
    "Maaf, makanan ini tidak menggunakan daging babi.",
    "Tunggu sebentar ya, sedang saya siapkan.",
  ];

  @override
  void initState() {
    super.initState();
    _initializeCoreEngines();
  }

  Future<void> _initializeCoreEngines() async {
    bool mlReady = await _translationController.downloadOfflineModels();
    bool speechReady = await _speechController.initializeSpeechEngine();
    
    setState(() {
      _isEngineReady = mlReady && speechReady;
    });
  }

  void _toggleVocalCapture() {
    if (_speechController.isCurrentlyListening) {
      _speechController.stopListeningStream();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      _speechController.startListeningStream(
        onResultCallback: (recognizedWords) {
          setState(() {
            _inputController.text = recognizedWords;
            _isListening = _speechController.isCurrentlyListening;
          });
        },
      );
    }
  }

  Future<void> _handleTranslation() async {
    if (!_isEngineReady || _inputController.text.isEmpty) return;

    setState(() => _isProcessing = true);
    String result = await _translationController.translateText(_inputController.text);
    setState(() {
      _translatedOutput = result;
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    _translationController.closeRegistry();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('KakiLima Voice Terminal'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              _isEngineReady ? Icons.gpp_good : Icons.sync_problem,
              color: _isEngineReady ? Colors.lightGreenAccent : Colors.amber,
            ),
          )
        ],
      ),
      body: _isEngineReady 
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Input Field Card with Speech Mic overlay
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _inputController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: "Type or use microphone for vocal input...",
                            border: InputBorder.none,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton.small(
                            onPressed: _toggleVocalCapture,
                            backgroundColor: _isListening ? Colors.red : Colors.teal,
                            foregroundColor: Colors.white,
                            child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _handleTranslation,
                  icon: _isProcessing 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.translate),
                  label: Text(_isProcessing ? "Processing Data..." : "Translate to English"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Processed Output Card
                Card(
                  color: Colors.teal[50],
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _translatedOutput,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.teal[900]),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Quick Phrases Panel Section
                const Text(
                  "Quick Corporate Vendor Phrases:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: _quickPhrases.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(_quickPhrases[index], style: const TextStyle(fontSize: 13)),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.teal),
                          onTap: () {
                            _inputController.text = _quickPhrases[index];
                            _handleTranslation();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.teal),
                SizedBox(height: 16),
                Text("Syncing Edge AI Engines & Peripherals..."),
              ],
            ),
          ),
    );
  }
}