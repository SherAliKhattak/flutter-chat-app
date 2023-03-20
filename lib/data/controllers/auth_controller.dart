import 'dart:developer';
import 'package:flutter_chat_app/utils/models/user_info_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController implements GetxService {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isloading = false;
  bool get isLoading => _isloading;
  String? _uid;
  String get uid => _uid!;
  UserInfoModel? _userInfoModel;
  UserInfoModel get userInfoModel => _userInfoModel!;
  @override
  void onInit() {
    checkSign();
    super.onInit();
  }

  set userInfoModel(UserInfoModel value) {
    _userInfoModel = value;
  }

  set uid(String value) {
    _uid = value;
  }

  set isSignedIn(bool value) {}

  resetIsLoading(bool state) {
    _isloading = state;
    update();
  }

  resetIsSignedIn(bool state) {
    _isSignedIn = state;
    update();
  }

  void checkSign() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    log(_isSignedIn.toString());
    update();
  }

  static AuthController get i => Get.put(AuthController());
}
