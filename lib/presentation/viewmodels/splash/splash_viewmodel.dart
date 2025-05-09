import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../views/login/login_view.dart';
import '../../views/home/home_view.dart';
import '../../viewmodels/login/unit_dropdown_viewmodel.dart';

class SplashViewModel {
  final UnitDropdownViewModel unitVM = UnitDropdownViewModel();

  Future<void> loadAndNavigate(BuildContext context) async {
    // Precache de imagen
    await precacheImage(const AssetImage('assets/images/logo_blanco.png'), context);

    // Esperar a que carguen los datos de Firebase
    await unitVM.fetchUnidades();

    // Delay de splash
    await Future.delayed(const Duration(milliseconds: 1600));

    // 🔍 **Verificar si hay un usuario autenticado**
    User? currentUser = FirebaseAuth.instance.currentUser;

    // 🔀 **Redirigir a HomeView o LoginView según el estado de sesión**
    if (currentUser != null) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) => HomeView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slide = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutQuart,
            ));

            return SlideTransition(
              position: slide,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) => LoginView(unitVM: unitVM),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slide = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutQuart,
            ));

            return SlideTransition(
              position: slide,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        ),
      );
    }
  }
}
