import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AudioControlsWidget extends StatefulWidget {
  final VoidCallback onEdit;
  final VoidCallback onSend;
  final VoidCallback onMicPress;
  final VoidCallback onMicRelease;

  const AudioControlsWidget({
    Key? key,
    required this.onEdit,
    required this.onSend,
    required this.onMicPress,
    required this.onMicRelease,
  }) : super(key: key);

  @override
  _AudioControlsWidgetState createState() => _AudioControlsWidgetState();
}

class _AudioControlsWidgetState extends State<AudioControlsWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 125,
          left: 25,
          right: 25,
          child: Center(
            child: const Text(
              'Mantén presionado el botón para grabar',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 8, 81, 153),
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          left: 30,
          right: 30,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón de Editar
                  GestureDetector(
                    onTap: widget.onEdit,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.only(right: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          colors: [Colors.white, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: const Color(0xFF0D47A1),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        HugeIcons.strokeRoundedEdit03,
                        color: Color(0xFF0D47A1),
                        size: 28,
                      ),
                    ),
                  ),
                  // Botón de Enviar
                  GestureDetector(
                    onTap: widget.onSend,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.only(left: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          colors: [Colors.white, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: const Color(0xFF2E7D32),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        HugeIcons.strokeRoundedNavigation03,
                        color: Color(0xFF2E7D32),
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Botón de Micrófono
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.21,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTapDown: (_) {
                setState(() => _isPressed = true);
                widget.onMicPress();
              },
              onTapUp: (_) {
                setState(() => _isPressed = false);
                widget.onMicRelease();
              },
              onTapCancel: () => setState(() => _isPressed = false),
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
