import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/screens/sign_up_screen.dart';
import 'package:instagram/utils/utils.dart';
import '../utils/colors.dart';
import '../widgets/button_widget.dart';
import '../widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  login() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      setState(() {
      _isLoading = false;
    });
      showSnackBar("Đăng nhập thành công", context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) {
        return MobileScreenLayout();
      }), (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.message.toString(), context);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      height: 64,
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
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                        onTap: () {
                          login();
                        },
                        child: const ButtonWidget(text: "Login")),
                    const SizedBox(
                      height: 24,
                    ),
                    Text.rich(TextSpan(
                      text: "You don't have an account. ",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                            text: "Sign up now!",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpScreen()));
                              },
                            style: const TextStyle(
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
