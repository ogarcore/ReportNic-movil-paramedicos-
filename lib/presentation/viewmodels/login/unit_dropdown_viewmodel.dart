import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UnitDropdownViewModel {
  final ValueNotifier<List<String>> unidades = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(true);
  final ValueNotifier<String?> error = ValueNotifier(null);

  UnitDropdownViewModel() {
    fetchUnidades();
  }

  Future<void> fetchUnidades() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('ambulancias').get();

      final unidadesList = snapshot.docs
          .where((doc) => doc.data().containsKey('codigo'))
          .map((doc) => doc['codigo'] as String)
          .toList();

      unidades.value = unidadesList;
    } catch (e) {
      error.value = 'Error al cargar unidades';
    } finally {
      isLoading.value = false;
    }
  }

  void dispose() {
    unidades.dispose();
    isLoading.dispose();
    error.dispose();
  }
}
