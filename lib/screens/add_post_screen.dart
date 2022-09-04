import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/data_service/FireStoreMethod.dart';
import 'package:instagram/models/user_model.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool _isLoading = false;
  TextEditingController descriptionController = TextEditingController();

  uploadImage(BuildContext parentContext) async {
    return showDialog(
        context: parentContext,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Create a post"),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: const Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List im = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = im;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: const Text("Choose a photo from gallary"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (!kIsWeb) {
                    Uint8List im = await pickImage(ImageSource.gallery);
                    setState(() {
                      _file = im;
                    });
                  } else {
                    Uint8List im = await pickImage(ImageSource.gallery);
                  }
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  postImage(String uid, String fullName, String profileImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          fullName, profileImage, descriptionController.text, _file!, uid);
      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar("Đăng thành công", context);
        _file = null;
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
                onPressed: () {
                  uploadImage(context);
                },
                icon: const Icon(
                  Icons.upload,
                  size: 30,
                )))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Text(
                "Post to",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: false,
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    _file = null;
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      postImage(user.uid, user.fullName, user.photoUrl);
                    },
                    child: const Text(
                      "Post",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            body: Column(
              children: [
                _isLoading ? LinearProgressIndicator() : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          hintText: "Write caption...",
                          border: InputBorder.none,
                        ),
                        maxLength: 200,
                      ),
                    ),
                    SizedBox(
                        height: 60,
                        width: 60,
                        child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  alignment: FractionalOffset.topCenter,
                                  fit: BoxFit.fill,
                                  image: MemoryImage(_file!)),
                            ),
                          ),
                        ))
                  ],
                )
              ],
            ),
          );
  }
}
