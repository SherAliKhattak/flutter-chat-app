import 'package:flutter/material.dart';

import '../components/themes/themes.dart';

class BoldText extends StatelessWidget {
  final String text;
  final double? textSize;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final Color? color;
  const BoldText({
    Key? key,
    required this.text,
    this.textSize = 15,
    this.textAlign,
    this.fontWeight,
    this.color = CustomColors.kblackcolor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: textSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
