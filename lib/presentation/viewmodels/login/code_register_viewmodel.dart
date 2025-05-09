import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum CodigoEstado { valido, yaUsado, noExiste, error }

class CodigoRegistroViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isVerifying = false;

  Future<CodigoEstado> verificarCodigo(String codigo) async {
    isVerifying = true;
    notifyListeners();

    try {
      final snapshot = await _firestore.collection('codigos').get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data['codigo']?.toString().toUpperCase() == codigo) {
          if (data['valido'] == true) {
            await _firestore.collection('codigos').doc(doc.id).update({
              'valido': false,
            });
            isVerifying = false;
            notifyListeners();
            return CodigoEstado.valido;
          } else {
            isVerifying = false;
            notifyListeners();
            return CodigoEstado.yaUsado;
          }
        }
      }
      isVerifying = false;
      notifyListeners();
      return CodigoEstado.noExiste;
    } catch (e) {
      debugPrint('Error al verificar código: $e');
      isVerifying = false;
      notifyListeners();
      return CodigoEstado.error;
    }
  }
}
