import 'package:flutter/material.dart';

import '../components/themes/themes.dart';

class CircleWithIcon extends StatelessWidget {
  final IconData? icon;
  const CircleWithIcon({
    Key? key,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: CustomColors.ktextColor2,
      child: CircleAvatar(
          radius: 20,
          backgroundColor: CustomColors.kwhiteColor,
          child: Icon(
            icon,
            color: Colors.grey,
          )),
    );
  }
}
