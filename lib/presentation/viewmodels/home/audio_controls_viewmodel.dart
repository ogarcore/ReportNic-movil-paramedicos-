import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AudioControlsViewModel extends ChangeNotifier {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _transcribedText = 'Mantén presionado el botón para grabar';

  String get transcribedText => _transcribedText;
  bool get isListening => _isListening;

  Future<void> initSpeech() async {
    await _speech.initialize();
  }

  void startListening() {
    _isListening = true;
    _speech.listen(
      onResult: (result) {
        _transcribedText = result.recognizedWords;
        notifyListeners();
      },
    );
    notifyListeners();
  }

  void stopListening() {
    _speech.stop();
    _isListening = false;
    notifyListeners();
  }

  void resetTranscription() {
    _transcribedText = 'Mantén presionado el botón para grabar';
    notifyListeners();
  }
}
