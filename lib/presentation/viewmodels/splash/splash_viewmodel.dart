import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../views/login/login_view.dart';
import '../../views/home/home_view.dart';
import '../../viewmodels/login/unit_dropdown_viewmodel.dart';
import '../../viewmodels/register/verification_viewmodel.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../views/splash/no_internet_view.dart';

class SplashViewModel {
  final UnitDropdownViewModel unitVM = UnitDropdownViewModel();

  Future<void> loadAndNavigate(BuildContext context) async {
      final connectivityResult = await Connectivity().checkConnectivity();

    bool hasInternet = false;
    if (connectivityResult != ConnectivityResult.none) {
      try {
        final result = await InternetAddress.lookup('google.com')
            .timeout(const Duration(seconds: 3));
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          hasInternet = true;
        }
      } catch (_) {
        hasInternet = false;
      }
    }

    if (!hasInternet) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const NoInternetView()),
      );
      return;
    }

    await precacheImage(
      const AssetImage('assets/images/logo_blanco.png'),
      context,
    );

    // Esperar a que carguen los datos de Firebase
    await unitVM.fetchUnidades();

    // Delay de splash
    await Future.delayed(const Duration(milliseconds: 1200));

    // Verificar si hay un usuario autenticado
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      await currentUser.reload(); // Refrescar datos del usuario

      // Actualizar correoVerificado si se verificó fuera de la app
      await VerificationViewModel().checkIfEmailVerifiedAndUpdate();

      final refreshedUser = FirebaseAuth.instance.currentUser;

      if (refreshedUser != null && refreshedUser.emailVerified) {
        // Usuario autenticado y verificado → HomeView
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (_, __, ___) => HomeView(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              final slide = Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutQuart),
              );
              return SlideTransition(
                position: slide,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
          ),
        );
      } else {
        // Usuario autenticado pero no verificado → Login
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (_, __, ___) => LoginView(unitVM: unitVM),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              final slide = Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutQuart),
              );
              return SlideTransition(
                position: slide,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
          ),
        );
      }
    } else {
      // Usuario no autenticado → Login
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) => LoginView(unitVM: unitVM),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slide = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutQuart),
            );
            return SlideTransition(
              position: slide,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
        ),
      );
    }
  }
}
