import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AudioControlsViewModel extends ChangeNotifier {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isAvailable = false;
  bool _isListening = false;
  bool _isInitializing = false;
  String _localeId = '';
  String _displayText = 'Toca el botón para grabar';

  String get transcribedText => _displayText;
  bool get isListening => _isListening;
  bool get isReady => _isAvailable && !_isInitializing;

  AudioControlsViewModel() {
    initSpeech();
  }

  Future<void> initSpeech() async {
    if (_isInitializing || _isAvailable) return;
    _isInitializing = true;
    _displayText = 'Cargando servicio de voz...';
    notifyListeners();

    try {
      _isAvailable = await _speech.initialize(
        onStatus: _onStatus,
        onError: _onError,
        debugLogging: false,
      );

      if (_isAvailable) {
        final sysLocale = await _speech.systemLocale();
        _localeId = sysLocale?.localeId ?? '';
        _displayText = 'Toca el botón para grabar';
      } else {
        _displayText = 'Servicio no disponible.';
      }
    } catch (_) {
      _isAvailable = false;
      _displayText = 'Error de inicialización. Intenta de nuevo.';
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<void> startListening() async {
    if (!isReady || _isListening) return;

    _isListening = true;
    _displayText = 'Grabando...'; // Mostrar mensaje inicial
    notifyListeners();

    try {
      await _speech.listen(
        onResult: _onSpeechResult,
        localeId: _localeId.isNotEmpty ? _localeId : null,
        listenMode: stt.ListenMode.dictation,
        partialResults: true,
        pauseFor: const Duration(seconds: 6), // ahora espera 6 segs de silencio
        listenFor: const Duration(minutes: 5),
      );
    } catch (_) {
      _isListening = false;
      _displayText = 'Error de grabación. Intenta de nuevo.';
      notifyListeners();
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      await _speech.stop();
      _isListening = false;
      notifyListeners();
    }
  }

  void _onSpeechResult(stt.SpeechRecognitionResult result) {
    // Si aún está en "Grabando..." y hay texto real, lo reemplaza
    if (_displayText == 'Grabando...' && result.recognizedWords.isNotEmpty) {
      _displayText = result.recognizedWords;
    } else {
      _displayText = result.recognizedWords;
    }
    notifyListeners();
  }

  void _onStatus(String status) {
    if (status == 'notListening' || status == 'done') {
      _isListening = false;
      if (_displayText.trim().isEmpty || _displayText == 'Grabando...') {
        _displayText = 'No se ha detectado voz.';
      }
      notifyListeners();
    }
  }

  void _onError(stt.SpeechRecognitionError error) {
    _isListening = false;
    _displayText = 'Error de grabación. Intenta de nuevo.';
    notifyListeners();
  }
}
