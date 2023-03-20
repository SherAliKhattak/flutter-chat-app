import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ui/components/snackbars.dart';
import 'package:get/get.dart';
import '../services/db_service.dart';
import '../services/local_db.dart';

class UserInfoController extends GetxController implements GetxService {
  File? file;
  late TextEditingController username;
  late TextEditingController about;
  late TextEditingController phoneNumber;

  bool isLoading = false;
  @override
  void onInit() {
    username = TextEditingController();
    about = TextEditingController();
    phoneNumber = TextEditingController();

    super.onInit();
  }

  resetIsLoading(bool value) {
    isLoading = value;
    update();
  }

  Future<File?> pickImage(
    BuildContext context,
  ) async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.any);
      if (result != null) {
        file = File(result.files.first.path!);
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    update();
    return file;
  }

  updateUserInfo(String infoType, String value) async {
    await DBservice().updateUserData(infoType, value);
    await DBservice()
        .getDataFromFirestore()
        .then((value) => Preferences.saveUserData())
        .then((value) => Preferences().getDataFromSP());
    update();
    Get.back();
  }

  updateProfilePic(BuildContext context) async {
    file = await pickImage(context);
    if (file != null) {
      resetIsLoading(true);
      String result = await DBservice().storeProfileImage(
          "profilePic/${FirebaseAuth.instance.currentUser!.uid}", file!);
      await DBservice().updateUserData('profilePic', result);
      await DBservice()
          .getDataFromFirestore()
          .then((value) => Preferences.saveUserData())
          .then((value) => Preferences().getDataFromSP());
      resetIsLoading(false);
    } else {}
    update();
  }

  bool isValidPhoneNumber(String? value) =>
      RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)')
          .hasMatch(value ?? '');

  static UserInfoController get i => Get.put(UserInfoController());
}
