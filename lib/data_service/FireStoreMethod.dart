import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/data_service/StorageMethod.dart';
import 'package:instagram/models/post.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(String fullName, String profImage,
      String description, Uint8List file, String uid) async {
    String res = "Some error occcurred";
    try {
      String postId = const Uuid().v1();
      String photoUrl =
          await StorageMethods().uploadImageToStorage('post', file, true);
      Post post = Post(
        description: description,
        fullName: fullName,
        uid: uid,
        postId: postId,
        datePublished: DateTime.now().toString(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );
      _firestore.collection("post").doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    String res = "Some error occcurred";
    try {
      if (text.isNotEmpty) {
        String commentedId = const Uuid().v1();
        _firestore
            .collection("post")
            .doc(postId)
            .collection("comments")
            .doc(commentedId)
            .set({
          'profilePic': profilePic,
          'text': text,
          'postId': postId,
          'uid': uid,
          'name': name,
          'commentId': commentedId,
          'datePublished': DateTime.now().toString()
        });
        res = "success";
        print(res);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Something went wrong";

    try {
      if (likes.contains(uid)) {
        _firestore.collection("post").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection("post").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
      res = "success";
      return res;
    } catch (e) {
      return e.toString();
    }
  }

  Future<int> getComments(String postId) async {
    QuerySnapshot comments = await _firestore
        .collection('post')
        .doc(postId)
        .collection("comments")
        .get();
    return comments.docs.length;
  }

  // deleting post

  Future<void> deletePost(String postId) async {
    try {
      _firestore.collection("post").doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
