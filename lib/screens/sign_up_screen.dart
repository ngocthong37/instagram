import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/screens/login_screen.dart';

import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/button_widget.dart';
import '../widgets/text_field.dart';
import 'auth/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  Uint8List? image;

  AuthService auth = AuthService();
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    Flexible(
                      child: Container(),
                      flex: 2,
                    ),
                    SvgPicture.asset(
                      'assets/icon_instagram.svg',
                      color: primaryColor,
                      height: 64,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Stack(
                      children: [
                        image == null
                            ? const CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(
                                    "https://images.unsplash.com/photo-1464548440467-d10d8aab562a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80"),
                              )
                            : CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(image!)),
                        Positioned(
                            bottom: 0,
                            right: 5,
                            child: IconButton(
                                onPressed: () {
                                  selectImage();
                                },
                                icon: const Icon(
                                  Icons.add_a_photo,
                                  size: 30,
                                )))
                      ],
                    ),
                    const SizedBox(
                      height: 64,
                    ),
                    TextFieldInput(
                      hintText: 'Enter your name',
                      textInputType: TextInputType.name,
                      textEditingController: _nameController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldInput(
                      hintText: 'Enter your email',
                      textInputType: TextInputType.emailAddress,
                      textEditingController: _emailController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldInput(
                      hintText: 'Enter your password',
                      textInputType: TextInputType.visiblePassword,
                      textEditingController: _passwordController,
                      isPass: true,
                    ),
                    TextFieldInput(
                      hintText: 'Enter your bio',
                      textInputType: TextInputType.text,
                      textEditingController: _bioController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                        onTap: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          await auth
                              .signUp(
                                  _emailController.text,
                                  _passwordController.text,
                                  _nameController.text,
                                  _bioController.text,
                                  image!)
                              .then((value) {
                            setState(() {
                              _isLoading = false;
                            });
                            if (value == true) {
                              showSnackBar("Đăng kí thành công", context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return LoginScreen();
                              }));
                            } else {
                              showSnackBar(value, context);
                            }
                          });
                        },
                        child: const ButtonWidget(text: "Sign Up")),
                    const SizedBox(
                      height: 24,
                    ),
                    Text.rich(TextSpan(
                      text: "You already have an account. ",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                            text: "Login up now!",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return LoginScreen();
                                }));
                              },
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                decoration: TextDecoration.underline))
                      ],
                    )),
                    Flexible(
                      child: Container(),
                      flex: 2,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
