import 'package:flutter/material.dart';
import '../controllers/translation_controller.dart';

class MainTranslationScreen extends StatefulWidget {
  const MainTranslationScreen({super.key});

  @override
  State<MainTranslationScreen> createState() => _MainTranslationScreenState();
}

class _MainTranslationScreenState extends State<MainTranslationScreen> {
  final TranslationController _translationController = TranslationController();
  final TextEditingController _inputController = TextEditingController();
  
  String _translatedOutput = "Translation output will appear here...";
  bool _isEngineReady = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeTranslationEngine();
  }

  /// Asynchronously downloads and registers the local ML models on boot
  Future<void> _initializeTranslationEngine() async {
    bool ready = await _translationController.downloadOfflineModels();
    setState(() {
      _isEngineReady = ready;
    });
  }

  /// Triggers the edge-ai translation processing logic
  Future<void> _handleTranslation() async {
    if (!_isEngineReady || _inputController.text.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

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
                // Input Card (Indonesian Local Vendor Speech Input)
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: _inputController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: "Enter Indonesian text or tap mic...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Action Translation Action Button
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _handleTranslation,
                  icon: _isProcessing 
                    ? const SizedBox(
                        width: 20, 
                        height: 20, 
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                      )
                    : const Icon(Icons.translate),
                  label: Text(_isProcessing ? "Processing Data..." : "Translate to English"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Output Card (Processed English Target Model Output)
                Expanded(
                  child: Card(
                    color: Colors.teal[50],
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _translatedOutput,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.teal[900],
                        ),
                      ),
                    ),
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
                Text("Downloading Offline ML Weights to Device Hardware..."),
              ],
            ),
          ),
    );
  }
}