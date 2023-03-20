import 'package:flutter_chat_app/data/controllers/auth_controller.dart';
import 'package:flutter_chat_app/data/controllers/chat_controller.dart';
import 'package:flutter_chat_app/data/controllers/user_info_controller.dart';
import 'package:get/get.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
    Get.put<ChatScreenController>(ChatScreenController());
    Get.put<UserInfoController>(UserInfoController());
  }
}
