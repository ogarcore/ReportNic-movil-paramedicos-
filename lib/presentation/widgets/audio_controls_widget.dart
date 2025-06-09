import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home/audio_controls_viewmodel.dart'; // Ajusta el path

class AudioControlsWidget extends StatelessWidget {
  const AudioControlsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AudioControlsViewModel>(context);

    return Stack(
      children: [
        // TEXTO TRANSCRITO
        Positioned(
          top: 125,
          left: 25,
          right: 25,
          child: Center(
            child: Text(
              viewModel.transcribedText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromARGB(255, 8, 81, 153),
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),

        // MICRÓFONO
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.21,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTapDown: (_) => viewModel.startListening(),
              onTapUp: (_) => viewModel.stopListening(),
              onTapCancel: () => viewModel.stopListening(),
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xFF42A5F5),
                      Color(0xFF1976D2),
                      Color(0xFF0D47A1),
                    ],
                    radius: 0.9,
                    stops: [0.1, 0.6, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1976D2).withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 4,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mic_none,
                  color: Colors.white,
                  size: 60,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
