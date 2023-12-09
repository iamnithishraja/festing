import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  Heading({
    super.key,
    required this.str,
    this.fontSize = 28,
    this.color = Colors.white,
    this.alignment,
  });
  String str;
  double fontSize;
  Color color;
  TextAlign? alignment;
  @override
  Widget build(BuildContext context) {
    return Text(
      str,
      textAlign: alignment,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: fontSize,
            color: color,
          ),
    );
  }
}
