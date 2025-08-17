import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home/audio_controls_viewmodel.dart';

class AudioControlsWidget extends StatelessWidget {
  final VoidCallback onSend;

  const AudioControlsWidget({super.key, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AudioControlsViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Tamaños dinámicos que cambian según el estado de edición
    final bool isEditing = viewModel.isEditing;
    final double micButtonSize = isEditing ? 80 : 110;
    final double fabSize = isEditing ? 50 : 60;
    final double horizontalSpacing = isEditing ? screenWidth * 0.10 : screenWidth * 0.15;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade100,
              const Color(0xFFE3F2FD),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          children: [
            // Sección superior con controles
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Texto "Toca para grabar"
                  Padding(
                    padding: EdgeInsets.only(bottom: screenWidth * 0.15),
                    child: Text(
                      'Toca para grabar',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade800,
                        letterSpacing: 0.8,
                        shadows: [
                          Shadow(
                            color: Colors.white.withOpacity(0.6),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Controles con animación de espaciado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFloatingActionButton(
                        icon: isEditing ? Icons.check_rounded : Icons.edit_rounded,
                        color: Colors.blueGrey.shade600,
                        size: fabSize,
                        onPressed: () {
                          if (isEditing) {
                            viewModel.saveEditedText();
                            FocusScope.of(context).unfocus();
                          } else {
                            viewModel.toggleEditing();
                          }
                        },
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        width: horizontalSpacing,
                      ),
                      _buildMicrophoneButton(
                        viewModel, 
                        size: micButtonSize,
                        isDisabled: isEditing, // Bloquear en modo edición
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        width: horizontalSpacing,
                      ),
                      _buildFloatingActionButton(
                        icon: Icons.send_rounded,
                        color: isEditing 
                            ? Colors.grey.shade400 
                            : Colors.blue.shade600,
                        size: fabSize,
                        onPressed: isEditing ? null : onSend, // Bloquear en modo edición
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Contenedor del texto con altura animada
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              margin: EdgeInsets.fromLTRB(
                screenWidth * 0.06,
                screenWidth * 0.04,
                screenWidth * 0.06,
                screenWidth * 0.08,
              ),
              padding: const EdgeInsets.all(20),
              height: isEditing ? screenWidth * 0.90 : screenWidth * 0.6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.75),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade200.withOpacity(0.15),
                    blurRadius: 30,
                    spreadRadius: 2,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.9),
                  width: 1.8,
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: isEditing
                      ? TextField(
                          controller: viewModel.textController,
                          maxLines: null,
                          autofocus: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero
                          ),
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 16,
                            height: 1.7,
                          ),
                          textAlign: TextAlign.left,
                        )
                      : Text(
                          viewModel.transcribedText.isEmpty
                              ? "Aquí aparecerá lo que digas..."
                              : viewModel.transcribedText,
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 16,
                            height: 1.7,
                          ),
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMicrophoneButton(
    AudioControlsViewModel viewModel, {
    required double size,
    required bool isDisabled, // Nuevo parámetro para deshabilitar
  }) {
    return GestureDetector(
      onTap: isDisabled 
          ? null // Deshabilitar si está en modo edición
          : () {
              if (viewModel.isListening) {
                viewModel.stopListening();
              } else {
                viewModel.startListening();
              }
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: isDisabled
                ? [Colors.grey.shade400, Colors.grey.shade600] // Color gris cuando está deshabilitado
                : viewModel.isListening
                    ? [Colors.red.shade400, Colors.red.shade700]
                    : [Colors.blue.shade400, Colors.blue.shade700],
            stops: const [0.1, 0.9],
          ),
          boxShadow: [
            BoxShadow(
              color: (isDisabled
                      ? Colors.grey.shade400
                      : viewModel.isListening
                          ? Colors.red.shade400
                          : Colors.blue.shade400)
                  .withOpacity(isDisabled ? 0.2 : 0.4),
              blurRadius: viewModel.isListening ? 35 : 25,
              spreadRadius: viewModel.isListening ? 10 : 6,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (viewModel.isListening && !isDisabled)
              PulseAnimation(
                child: Container(
                  width: size + 20,
                  height: size + 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade400.withOpacity(0.15),
                  ),
                ),
              ),
            Icon(
              viewModel.isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
              color: Colors.white,
              size: size * 0.4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
    required double size,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 12,
            spreadRadius: 3,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(size / 2),
          highlightColor: color.withOpacity(0.1),
          splashColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: size * 0.5),
        ),
      ),
    );
  }
}

class PulseAnimation extends StatefulWidget {
  final Widget child;

  const PulseAnimation({super.key, required this.child});

  @override
  _PulseAnimationState createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _animation = Tween(
      begin: 0.6,
      end: 1.4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Opacity(
            opacity: 1 - (_animation.value - 0.6) / 0.8,
            child: widget.child,
          ),
        );
      },
    );
  }
}