import 'package:flutter/material.dart';

class SubHeading extends StatelessWidget {
  SubHeading({
    super.key,
    required this.str,
    this.fontSize = 18,
    this.color = Colors.white,
    this.align = TextAlign.left,
  });
  String str;
  double fontSize;
  Color color;
  TextAlign align;
  @override
  Widget build(BuildContext context) {
    return Text(
      str,
      textAlign: align,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: fontSize,
            color: color,
          ),
    );
  }
}
