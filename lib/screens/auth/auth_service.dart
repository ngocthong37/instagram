import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';

import '../../data_service/DatabaseService.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future signUp(String email, String password, String fullName, String bio,
      Uint8List image) async {
    try {
      User? user = (await auth.createUserWithEmailAndPassword(
        email: email, password: password))
        .user!;
      await DatabaseService(uid: user.uid)
        .savingUserData(fullName, email, bio, image);
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
