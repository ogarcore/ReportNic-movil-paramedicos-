import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart'; // CAMBIO AQUÍ
import '../../views/register/verification_view.dart';

class RegisterViewModel {
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final cedulaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final ValueNotifier<String?> errorMessage = ValueNotifier(null);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  // Nuevos: errores individuales por campo
  final ValueNotifier<String?> nombreError = ValueNotifier(null);
  final ValueNotifier<String?> apellidoError = ValueNotifier(null);
  final ValueNotifier<String?> cedulaError = ValueNotifier(null);
  final ValueNotifier<String?> emailError = ValueNotifier(null);
  final ValueNotifier<String?> passwordError = ValueNotifier(null);

  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    cedulaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    errorMessage.dispose();
    isLoading.dispose();
    nombreError.dispose();
    apellidoError.dispose();
    cedulaError.dispose();
    emailError.dispose();
    passwordError.dispose();
  }

  Future<void> register(BuildContext context) async {
    final nombre = nombreController.text.trim();
    final apellido = apellidoController.text.trim();
    final cedula = cedulaController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Reiniciar errores
    nombreError.value = null;
    apellidoError.value = null;
    cedulaError.value = null;
    emailError.value = null;
    passwordError.value = null;
    errorMessage.value = null;

    bool hasError = false;

    if (nombre.isEmpty) {
      nombreError.value = 'El nombre es obligatorio';
      hasError = true;
    }
    if (apellido.isEmpty) {
      apellidoError.value = 'El apellido es obligatorio';
      hasError = true;
    }
    if (cedula.isEmpty) {
      cedulaError.value = 'La cédula es obligatoria';
      hasError = true;
    } else if (!validarCedula()) {
      cedulaError.value = 'Por favor, agregue una cedula valida';
      hasError = true;
    }
    if (email.isEmpty) {
      emailError.value = 'El correo es obligatorio';
      hasError = true;
    } else if (!validarDominioEmail(email)) {
      emailError.value = 'El correo no es válido';
      hasError = true;
    }

    if (password.isEmpty) {
      passwordError.value = 'La contraseña es obligatoria';
      hasError = true;
    }

    if (hasError) return;

    try {
      isLoading.value = true;
      errorMessage.value = null;

      // 1. Crear usuario con Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user?.uid;

      // 2. Generar ID incremental
      final snapshot = await _firestore
          .collection('paramedicos')
          .orderBy('idParamedico', descending: true)
          .limit(1)
          .get();

      int lastId = 0;
      if (snapshot.docs.isNotEmpty) {
        final lastIdStr = snapshot.docs.first['idParamedico'] as String;
        lastId = int.tryParse(lastIdStr) ?? 0;
      }
      final nextId = (lastId + 1).toString().padLeft(3, '0');

      // 3. Encriptar contraseña con flutter_bcrypt
      final salt = await FlutterBcrypt.saltWithRounds(rounds: 10);
      final hashedPassword = await FlutterBcrypt.hashPw(
        password: password,
        salt: salt,
      );

      // 4. Subir datos a Firestore
      await _firestore.collection('paramedicos').doc(userId).set({
        'nombre': nombre,
        'apellido': apellido,
        'cedula': cedula,
        'correo': email,
        'contraseña': hashedPassword,
        'fechaCreacion': FieldValue.serverTimestamp(),
        'idParamedico': nextId,
        'correoVerificado': false,
      });

      // 5. Redirigir si todo sale bien
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VerificationScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emailError.value = 'Este correo ya está registrado';
      } else if (e.code == 'invalid-email') {
        emailError.value = 'El correo no es válido';
      } else if (e.code == 'weak-password') {
        passwordError.value = 'La contraseña es muy débil';
      } else {
        errorMessage.value = 'Error inesperado: ${e.message}';
      }
    } catch (e) {
      errorMessage.value = 'Ocurrió un error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  bool validarDominioEmail(String email) {
    final dominioValido = RegExp(
      r"^[\w\.-]+@((gmail\.com)|(hotmail\.com)|(outlook\.com)|(yahoo\.es))$",
      caseSensitive: false,
    );
    return dominioValido.hasMatch(email);
  }

  bool validarCedula() {
    final regex = RegExp(r'^[0-9]{3}-[0-9]{6}-[0-9]{4}[A-Z]$');
    return regex.hasMatch(cedulaController.text.toUpperCase());
  }
}
