import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/button_feature.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key, required this.uid}) : super(key: key);
  final uid;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  var user, postLen;
  bool isLoading = false;

  getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      var userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
      setState(() {
        user = userSnap.data()!;
      });
      var posts = await FirebaseFirestore.instance
          .collection("post")
          .where('uid', isEqualTo: widget.uid)
          .get();
      setState(() {
        postLen = posts.docs.length;
      });
        setState(() {
          isLoading = false;
        });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Row(children: [
                Text(user['fullName'],
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.arrow_drop_down))
              ]),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle_outlined)),
              ],
            ),
            body: ListView(children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 25),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(user['photoUrl']),
                            ),
                            Positioned(
                                bottom: 4,
                                right: 2,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                      border: Border.all(
                                          width: 1, color: Colors.black)),
                                  child: const Center(
                                    child: Text("+"),
                                  ),
                                ))
                          ],
                        ),
                        Expanded(child: Container()),
                        Column(
                          children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text(postLen.toString(), style: TextStyle(fontSize: 20)),
                                    Text(
                                      "Posts",
                                      style: TextStyle(fontSize: 13),
                                    )
                                ],
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Column(
                                children: [
                                  Text(user['follower'].length.toString(),
                                      style: TextStyle(fontSize: 20)),
                                  const Text("Follower",
                                      style: TextStyle(fontSize: 13))
                                ],
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Column(
                                children: [
                                  Text(user['following'].length.toString(),
                                      style: TextStyle(fontSize: 20)),
                                  const Text("Following",
                                      style: TextStyle(fontSize: 13))
                                ],
                              ),
                              ],
                              )
                            ],
                            
                          )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  user['uid'] != widget.uid ? Row(
                    children: [
                      ButtonFeater(text: "Follow"),
                      SizedBox(width: 15,),
                      ButtonFeater(text: "Message")
                    ],
                  ) : Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("post")
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return GridView.builder(
                          shrinkWrap: true,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 1.5,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapshot.data! as dynamic).docs[index];

                            return Container(
                              child: Image(
                                image: NetworkImage(snap['postUrl']),
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      })
                ],
              ),
            ]),
          );
  }
}
