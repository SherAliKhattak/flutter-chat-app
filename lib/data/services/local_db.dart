import 'dart:convert';
import 'package:flutter_chat_app/data/controllers/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/models/user_info_model.dart';

class Preferences {
  static Future saveUserData() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    s.setString(
        'user_model', jsonEncode(AuthController.i.userInfoModel.toFirebase()));
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    AuthController.i.resetIsSignedIn(true);
  }

  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    AuthController.i.userInfoModel = UserInfoModel.fromJson(jsonDecode(data));
    AuthController.i.uid = AuthController.i.userInfoModel.uid!;
  }
}
