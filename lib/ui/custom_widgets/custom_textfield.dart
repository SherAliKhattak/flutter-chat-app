import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ui/components/themes/themes.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.text,
    required this.emailController,
    this.validator,
    required this.isObsecure,
    this.prefixicon,
    this.suffixIcon,
    this.onSubmit,
  }) : super(key: key);

  final TextEditingController emailController;
  final String text;
  final bool isObsecure;
  final String? Function(String?)? validator;
  final Icon? prefixicon;
  final Widget? suffixIcon;
  final String? Function(String?)? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: Get.height * 0.06,

      decoration: BoxDecoration(
        color: CustomColors.ktextColor2,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: Get.width * 0.04,
            ),
            SizedBox(
              width: Get.width * 0.6,
              child: TextFormField(
                onFieldSubmitted: onSubmit,
                validator: validator,
                controller: emailController,
                obscureText: isObsecure,
                decoration: InputDecoration(
                  prefixIcon: prefixicon,
                  suffixIcon: suffixIcon,
                  hintText: text,
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
