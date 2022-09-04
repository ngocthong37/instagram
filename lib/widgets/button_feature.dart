import 'package:flutter/material.dart';

class ButtonFeater extends StatelessWidget {
  const ButtonFeater({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      width: 100,
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.white
        ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.black.withOpacity(0.4)
      ),
      child: Center(child: Text(text)),
    );
  }
}
