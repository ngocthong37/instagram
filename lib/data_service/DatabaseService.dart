import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/data_service/StorageMethod.dart';
import 'package:instagram/models/user_model.dart' as model;

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  // saving user data
  Future savingUserData(
      String fullName, String email, String bio, Uint8List image) async {
    String photoUrl =
        await StorageMethods().uploadImageToStorage('profilePic', image, false);

    model.User user = model.User(
        fullName: fullName,
        email: email,
        bio: bio,
        uid: uid!,
        followers: [],
        following: [],
        photoUrl: photoUrl);
    return await userCollection.doc(uid).set(user.toJson());
  }

  Future<model.User> getUserData() async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    return model.User.fromNap(snapshot);
  }
}
