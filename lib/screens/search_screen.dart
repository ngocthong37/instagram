import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/screens/profile_user.dart';
import 'package:instagram/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchEdittingController =
      TextEditingController();

  bool isShowUser = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Form(
          child: TextFormField(
            controller: searchEdittingController,
            decoration: const InputDecoration(
                hintText: "Search User", border: InputBorder.none),
            onFieldSubmitted: (String _) {
              setState(() {
                if (searchEdittingController.text.isNotEmpty) {
                  isShowUser = true;
                } else {
                  isShowUser = false;
                }
              });
            },
          ),
        ),
      ),
      body: isShowUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .where('fullName',
                      isGreaterThanOrEqualTo: searchEdittingController.text)
                  .get(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
                          return UserProfileScreen(uid: snapshot.data.docs[index]['uid']);
                        })));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(snapshot.data.docs[index]['photoUrl']),
                        ),
                        title: Text(
                          snapshot.data.docs[index]['fullName'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }),
                );
              })
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection("post").get(),
              builder: ((context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GridView.custom(
                    gridDelegate: SliverQuiltedGridDelegate(
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      repeatPattern: QuiltedGridRepeatPattern.inverted,
                      pattern: [
                        QuiltedGridTile(2, 2),
                        QuiltedGridTile(1, 1),
                        QuiltedGridTile(1, 1),
                        QuiltedGridTile(1, 2),
                      ],
                    ),
                    childrenDelegate:
                      SliverChildBuilderDelegate(((context, index) {
                        return Image.network(
                          snapshot.data!.docs[index]['postUrl'],
                          fit: BoxFit.cover,
                        );
                        
                      }),
                      childCount: snapshot.data.docs.length
                    ));
              }),
            ),
    ));
  }
}
