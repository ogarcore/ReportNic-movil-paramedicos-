import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AudioControlsViewModel extends ChangeNotifier {
  final stt.SpeechToText _speech = stt.SpeechToText();

  // --- NUEVO: Controlador de texto ---
  // Se manejará aquí para mantener el estado y evitar que se reinicie.
  final TextEditingController textController = TextEditingController();

  bool _isAvailable = false;
  bool _isListening = false;
  bool _isInitializing = false;
  bool _isEditing = false;
  String _localeId = '';
  String _displayText = 'Toca el botón para grabar';

  // Getters
  bool get isEditing => _isEditing;
  String get transcribedText => _displayText;
  bool get isListening => _isListening;
  bool get isReady => _isAvailable && !_isInitializing;

  AudioControlsViewModel() {
    initSpeech();
  }

  // --- NUEVO: Liberar recursos del controlador ---
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // --- MODIFICADO: Sincroniza el controlador al entrar en modo edición ---
  void toggleEditing() {
    _isEditing = !_isEditing;
    if (_isEditing) {
      // Aseguramos que el texto del controlador sea el actual
      textController.text = _displayText;
    }
    notifyListeners();
  }

  // --- MODIFICADO: Guarda el texto directamente desde el controlador ---
  void saveEditedText() {
    _displayText = textController.text;
    _isEditing = false;
    notifyListeners();
  }

  // --- El resto de los métodos ahora sincronizan el controlador ---

  Future<void> initSpeech() async {
    if (_isInitializing || _isAvailable) return;
    _isInitializing = true;
    _displayText = 'Cargando servicio de voz...';
    textController.text = _displayText; // Sincronizar
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
      textController.text = _displayText; // Sincronizar
      notifyListeners();
    }
  }

  Future<void> startListening() async {
    if (!isReady || _isListening) return;

    _isListening = true;
    _displayText = 'Grabando...';
    textController.text = _displayText; // Sincronizar
    notifyListeners();

    try {
      await _speech.listen(
        onResult: _onSpeechResult,
        localeId: _localeId.isNotEmpty ? _localeId : null,
        listenMode: stt.ListenMode.dictation,
        partialResults: true,
        pauseFor: const Duration(seconds: 6),
        listenFor: const Duration(minutes: 5),
      );
    } catch (_) {
      _isListening = false;
      _displayText = 'Error de grabación. Intenta de nuevo.';
      textController.text = _displayText; // Sincronizar
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
    _displayText = result.recognizedWords;
    textController.text = _displayText; // Sincronizar
    notifyListeners();
  }

  void _onStatus(String status) {
    if (status == 'notListening' || status == 'done') {
      _isListening = false;
      if (_displayText.trim().isEmpty || _displayText == 'Grabando...') {
        _displayText = 'No se ha detectado voz.';
        textController.text = _displayText; // Sincronizar
      }
      notifyListeners();
    }
  }

  void _onError(stt.SpeechRecognitionError error) {
    _isListening = false;
    _displayText = 'Error de grabación. Intenta de nuevo.';
    textController.text = _displayText; // Sincronizar
    notifyListeners();
  }
}