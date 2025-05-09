import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../views/login/login_view.dart';
import '../login/unit_dropdown_viewmodel.dart';

class HomeViewModel {
  // 🔐 Función para cerrar sesión
  Future<void> cerrarSesion(BuildContext context) async {
    try {
      // 🔄 Cerrar sesión de Firebase Auth
      await FirebaseAuth.instance.signOut();

      // 🔄 Limpiar el stack de navegación y redirigir a LoginView
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginView(unitVM: UnitDropdownViewModel())),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión, intenta de nuevo.')),
      );
    }
  }
}
