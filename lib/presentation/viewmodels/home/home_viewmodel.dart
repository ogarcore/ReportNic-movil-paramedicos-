import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rptn_01/presentation/views/splash/splash_view.dart';

class HomeViewModel {
  Future<void> cerrarSesion(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => SplashView()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión, intenta de nuevo.')),
      );
    }
  }
}
