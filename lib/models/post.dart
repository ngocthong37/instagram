import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String fullName;
  final String uid;
  final String postId;
  final String datePublished;
  final String postUrl;
  final String profImage;
  final likes;
  Post(
      {
      required this.description,
      required this.fullName,
      required this.uid,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profImage,
      required this.likes});

  Map<String, dynamic> toJson() => {
    "description": description,
    "fullName": fullName,
    "uid": uid,
    "postId": postId,
    "datePublished": datePublished,
    "postUrl": postUrl,
    "profImage": profImage,
    "likes": likes
  };

  static Post fromNap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      description: snapshot['description'],
      fullName: snapshot['fullName'],
      uid: snapshot['uid'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes']
    );
  }
}
