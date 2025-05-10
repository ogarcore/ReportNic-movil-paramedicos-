import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuDrawerViewModel {
  final userName = ValueNotifier<String>('Cargando...');
  final email = ValueNotifier<String>('Cargando...');

  MenuDrawerViewModel() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('paramedicos')
            .where('correo', isEqualTo: user.email)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final data = snapshot.docs.first.data();
          userName.value = data['nombre'] ?? 'Sin nombre';
          email.value = data['correo'] ?? 'Sin correo';
        } else {
          userName.value = 'Usuario no encontrado';
          email.value = 'Correo no disponible';
        }
      } else {
        userName.value = 'No autenticado';
        email.value = 'No autenticado';
      }
    } catch (e) {
      userName.value = 'Error al cargar';
      email.value = 'Error al cargar';
    }
  }
}
