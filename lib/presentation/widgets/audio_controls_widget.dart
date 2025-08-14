import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home/audio_controls_viewmodel.dart';

class AudioControlsWidget extends StatelessWidget {
  const AudioControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AudioControlsViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
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
          // Top section with controls
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // "Toca para grabar" text with elegant styling
                Padding(
                  padding: EdgeInsets.only(bottom: screenWidth * 0.20),
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

                // Controls section with beautiful layout
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Edit button with floating effect
                    _buildFloatingActionButton(
                      icon: Icons.edit_rounded,
                      color: Colors.blueGrey.shade600,
                      onPressed: () {},
                    ),
                    
                    SizedBox(width: screenWidth * 0.15),
                    
                    // Extra large microphone button with pulse effect
                    _buildMicrophoneButton(viewModel, size: 110),
                    
                    SizedBox(width: screenWidth * 0.15),
                    
                    // Send button with floating effect
                    _buildFloatingActionButton(
                      icon: Icons.send_rounded,
                      color: Colors.blue.shade600,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom section with text container
          Container(
            margin: EdgeInsets.fromLTRB(
              screenWidth * 0.06, 
              screenWidth * 0.04, 
              screenWidth * 0.06, 
              screenWidth * 0.08
            ),
            padding: const EdgeInsets.all(20),
            height: screenWidth * 0.6,
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
            child: SingleChildScrollView(
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 16,
                  height: 1.7,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicrophoneButton(AudioControlsViewModel viewModel, {double size = 90}) {
    return GestureDetector(
      onTap: () {
        if (viewModel.isListening) {
          viewModel.stopListening();
        } else {
          viewModel.startListening();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: viewModel.isListening
                ? [Colors.red.shade400, Colors.red.shade700]
                : [Colors.blue.shade400, Colors.blue.shade700],
            stops: const [0.1, 0.9],
          ),
          boxShadow: [
            BoxShadow(
              color: (viewModel.isListening
                      ? Colors.red.shade400
                      : Colors.blue.shade400)
                  .withOpacity(0.4),
              blurRadius: viewModel.isListening ? 35 : 25,
              spreadRadius: viewModel.isListening ? 10 : 6,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (viewModel.isListening)
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
    required VoidCallback onPressed,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 12,
            spreadRadius: 3,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          highlightColor: color.withOpacity(0.1),
          splashColor: color.withOpacity(0.2),
          child: Icon(
            icon,
            color: color,
            size: 30,
          ),
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
    _animation = Tween(begin: 0.6, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
    );
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