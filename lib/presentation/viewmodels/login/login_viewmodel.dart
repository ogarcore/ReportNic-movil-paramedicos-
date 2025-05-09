import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../views/home/home_view.dart';
import '../../views/login/code_register_view.dart';

class LoginViewModel {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailError = ValueNotifier<String?>(null);
  final passwordError = ValueNotifier<String?>(null);
  final verificationError = ValueNotifier<String?>(null);
  final unidadController = TextEditingController();

  bool _isLoadingViewModel = false;

  // Limpiar errores
  void clearErrors() {
    emailError.value = null;
    passwordError.value = null;
    verificationError.value = null;
  }

  // Validar campos de texto
  bool validateFields() {
    clearErrors();
    bool isValid = true;

    if (emailController.text.trim().isEmpty) {
      emailError.value = 'El correo es obligatorio';
      isValid = false;
    }
    if (passwordController.text.trim().isEmpty) {
      passwordError.value = 'La contraseña es obligatoria';
      isValid = false;
    }

    return isValid;
  }

  // Navegar a la pantalla de registro
  void navigateToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CodigoRegistroView()),
    );
  }

  // Función para iniciar sesión
  Future<void> login(BuildContext context, String? selectedUnit) async {
    if (!validateFields()) return; 
    if (selectedUnit == null) {
      verificationError.value = "La unidad no puede estar vacía."; 
      return;
    }

    _isLoadingViewModel = true;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final query = await FirebaseFirestore.instance
          .collection('paramedicos')
          .where('correo', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        emailError.value = 'Correo no encontrado';
        _isLoadingViewModel = false;
        return;
      }

      final doc = query.docs.first;
      final hashedPassword = doc['contraseña'] ?? '';
      final correoVerificado = doc['correoVerificado'] ?? false;

      final passwordMatches = await FlutterBcrypt.verify(
        password: password,
        hash: hashedPassword,
      );

      if (!passwordMatches) {
        passwordError.value = 'Contraseña incorrecta';
        _isLoadingViewModel = false;
        return;
      }

      if (!correoVerificado) {
        verificationError.value = 'El correo aún no ha sido verificado';
        _isLoadingViewModel = false;
        return;
      }

      // ✅ **Inicio de sesión en Firebase Auth**
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 🔐 **Guardar sesión en Firebase**
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('Usuario autenticado correctamente: ${user.email}');
      }

      // ✅ **Navegar a HomeView y limpiar el stack**
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeView()),
        (route) => false,
      );
    } catch (e) {
      print("Error en login: $e");
      verificationError.value = 'Ocurrió un error inesperado durante el inicio de sesión.';
    } finally {
      _isLoadingViewModel = false;
    }
  }

  bool get isLoading => _isLoadingViewModel;
}
