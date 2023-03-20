import 'package:flutter/material.dart';
import 'package:flutter_chat_app/utils/dependencies/init.dart';
import 'package:flutter_chat_app/utils/routes/routes.dart';
import 'package:flutter_chat_app/ui/screens/contacts_screen/contacts_screen.dart';
import 'package:get/get.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AppBindings(),
      home: const Contacts(),
      initialRoute: RouteHelper.onboarding,
      getPages: RouteHelper.routes,
    );
  }
}
