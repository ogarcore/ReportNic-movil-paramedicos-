import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../viewmodels/splash/splash_viewmodel.dart';

class SplashView extends StatefulWidget {
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with TickerProviderStateMixin {
  final SplashViewModel viewModel = SplashViewModel();
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();

    // Controlador para la animación de escala
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1800),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

    // Controlador para Lottie
    _lottieController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 5200),
    );

    _scaleController.forward();
    _lottieController.repeat();

    Future.delayed(Duration(milliseconds: 1000), () {
      // Navegación sin animación
      viewModel.loadAndNavigate(context);
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/logo_blanco.png', width: 130),
              const SizedBox(height: 30),
              SizedBox(
                height: 115,
                width: 115,
                child: Lottie.asset(
                  'assets/animations/loading.json',
                  controller: _lottieController,
                  repeat: true,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
