import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ui/components/themes/themes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.kscaffoldColor,
      appBar: AppBar(
        backgroundColor: CustomColors.kscaffoldColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Login',
          style: TextStyle(color: CustomColors.kblackcolor),
        ),
        centerTitle: true,
      ),
    );
  }
}
