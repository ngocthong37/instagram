import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String fullName;
  final String uid;
  final String photoUrl;
  final List followers;
  final List following;
  final String bio;
  User({
    required this.email,
    required this.fullName,
    required this.uid,
    required this.photoUrl,
    required this.followers,
    required this.following,
    required this.bio,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "fullName": fullName,
        "uid": uid,
        "photoUrl": photoUrl,
        "follower": followers,
        "following": following,
        "bio": bio,
      };

  static User fromNap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      email: snapshot['email'],
      fullName: snapshot['fullName'],
      uid: snapshot['uid'],
      photoUrl: snapshot['photoUrl'],
      followers: snapshot['follower'],
      following: snapshot['following'],
      bio: snapshot['bio']
    );
  }
}
