import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data_service/DatabaseService.dart';
import '../models/user_model.dart' as model;

class UserProvider with ChangeNotifier {
  model.User? _user;

  model.User get getUser => _user!;

  Future<void> refreshUser() async {
    model.User user =
        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .getUserData();
    debugPrint("email: ${user.email}");
    _user = user;
    notifyListeners();
  }
}
