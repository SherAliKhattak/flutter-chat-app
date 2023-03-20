import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ui/components/themes/themes.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final Color? buttonColor;
  final String? text;

  const CustomButton(
      {super.key, required this.buttonColor, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Get.height * 0.06,
        width: Get.width * 0.7,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text!,
            style: const TextStyle(
                color: CustomColors.kwhiteColor,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
