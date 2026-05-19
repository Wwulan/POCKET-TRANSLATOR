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

  // Track operational localization configurations
  String _sourceLanguage = 'id';
  String _targetLanguage = 'en';

  // Supported application locales for UI dropdown components
  final List<Map<String, String>> _availableLanguages = [
    {'code': 'id', 'name': 'Indonesian (ID) 🇮🇩', 'locale': 'id_ID'},
    {'code': 'en', 'name': 'English (EN) 🇬🇧', 'locale': 'en_US'},
    {'code': 'ja', 'name': 'Japanese (JA) 🇯🇵', 'locale': 'ja_JP'},
  ];

  // Multi-language transactional statement matrices
  final Map<String, List<String>> _localizedQuickPhrases = {
    'id': [
      "Harganya dua puluh ribu rupiah.",
      "Mau dibungkus atau makan di sini?",
      "Maaf, makanan ini tidak menggunakan daging babi.",
      "Tunggu sebentar ya, sedang saya siapkan.",
    ],
    'en': [
      "The price is twenty thousand rupiah.",
      "Is it for takeaway or dining in?",
      "Excuse me, this food is pork-free.",
      "Please hold on a moment, I am preparing it.",
    ],
    'ja': [
      "価格は二万ルピアです。(Kaku wa niman rupia desu.)",
      "お持ち帰りですか、それともここで召し上がりますか？",
      "すみません、この料理には豚肉は使われていません。",
      "少々お待ちください、ただいま準備しております。",
    ]
  };

  @override
  void initState() {
    super.initState();
    _initializeCoreHierarchy();
  }

  /// Evaluates and caches local model footprints prior to screen rendering.
  Future<void> _initializeCoreHierarchy() async {
    bool mlReady = await _translationController.downloadOfflineModels();
    bool speechReady = await _speechController.initializeSpeechEngine();
    
    setState(() {
      _isEngineReady = mlReady && speechReady;
    });
  }

  /// Toggles vocal sensory data pipelines based on selected source locale metrics.
  void _toggleVocalCapture() {
    if (_speechController.isCurrentlyListening) {
      _speechController.stopListeningStream();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      
      // Extract the correct native locale string for the speech recognition engine
      String activeLocale = _availableLanguages.firstWhere((lang) => lang['code'] == _sourceLanguage)['locale']!;
      
      _speechController.startListeningStream(
        localeId: activeLocale, // Explicitly passing the named parameter
        onResultCallback: (recognizedWords) {
          setState(() {
            _inputController.text = recognizedWords;
            _isListening = _speechController.isCurrentlyListening;
          });
        },
      );
    }
  }

  /// Initiates the automated translation sequence across selected linguistic targets.
  Future<void> _handleTranslation() async {
    if (!_isEngineReady || _inputController.text.isEmpty) return;

    setState(() => _isProcessing = true);
    
    String result = await _translationController.translateText(
      text: _inputController.text,
      sourceLang: _sourceLanguage,
      targetLang: _targetLanguage,
    );
    
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
    List<String> currentPhrases = _localizedQuickPhrases[_sourceLanguage] ?? _localizedQuickPhrases['id']!;

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
                // Language Selection Matrix Panel
                // Language Selection Matrix Panel
                Card(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Source Language Dropdown Configuration
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _sourceLanguage,
                            isExpanded: true, // Prevents RenderFlex overflow layout breakages
                            decoration: const InputDecoration(
                              labelText: 'Source', 
                              border: InputBorder.none,
                              labelStyle: TextStyle(fontSize: 12),
                            ),
                            items: _availableLanguages.map((lang) {
                              return DropdownMenuItem<String>(
                                value: lang['code'], 
                                child: Text(
                                  lang['name']!, 
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis, // Clips long text beautifully
                                )
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _sourceLanguage = value;
                                  // Auto-swap targets if they overlap to prevent compiling duplicate identity vectors
                                  if (_sourceLanguage == _targetLanguage) {
                                    _targetLanguage = _availableLanguages.firstWhere((lang) => lang['code'] != _sourceLanguage)['code']!;
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(Icons.swap_horiz, color: Colors.teal, size: 20),
                        ),
                        // Target Language Dropdown Configuration
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _targetLanguage,
                            isExpanded: true, // Prevents RenderFlex overflow layout breakages
                            decoration: const InputDecoration(
                              labelText: 'Target', 
                              border: InputBorder.none,
                              labelStyle: TextStyle(fontSize: 12),
                            ),
                            items: _availableLanguages.map((lang) {
                              return DropdownMenuItem<String>(
                                value: lang['code'], 
                                child: Text(
                                  lang['name']!, 
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis, // Clips long text beautifully
                                )
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _targetLanguage = value;
                                  if (_targetLanguage == _sourceLanguage) {
                                    _sourceLanguage = _availableLanguages.firstWhere((lang) => lang['code'] != _targetLanguage)['code']!;
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Input Field Card with Speech Mic Overlay
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
                            hintText: "Type or activate microphone for vocal input capture...",
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
                  label: Text(_isProcessing ? "Processing Data..." : "Execute Translation Session"),
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
                    itemCount: currentPhrases.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(currentPhrases[index], style: const TextStyle(fontSize: 13)),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.teal),
                          onTap: () {
                            _inputController.text = currentPhrases[index];
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