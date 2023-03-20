import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfoTextField extends StatelessWidget {
  const UserInfoTextField({
    Key? key,
    required this.text,
    required this.emailController,
    this.validator,
    required this.isObsecure,
    required this.icon,
  }) : super(key: key);

  final TextEditingController emailController;
  final String text;
  final bool isObsecure;
  final String? Function(String?)? validator;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: Get.height * 0.06,
      width: Get.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.green.shade100,
              child: icon,
            ),
            SizedBox(
              width: Get.width * 0.04,
            ),
            SizedBox(
              width: Get.width * 0.6,
              child: TextFormField(
                validator: validator,
                controller: emailController,
                obscureText: isObsecure,
                decoration: InputDecoration(
                  hintText: text,
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
