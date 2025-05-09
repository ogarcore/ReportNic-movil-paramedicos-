import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerificationViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<bool> checkIfEmailVerifiedAndUpdate() async {
    await _auth.currentUser?.reload();
    final user = _auth.currentUser;
    if (user != null && user.emailVerified) {
      await _firestore.collection('paramedicos').doc(user.uid).update({
        'correoVerificado': true,
      });
      return true;
    }
    return false;
  }
}
