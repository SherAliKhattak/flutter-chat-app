import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import '../../ui/screens/chat_screen/chat_screen.dart';
import '../../utils/assets/images.dart';
import '../../utils/models/user_info_model.dart';
import '../controllers/auth_controller.dart';

class ContactsRepo {
  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
        withProperties: true,
      );
    }
    return contacts;
  }

  selectContacts(Contact contact, BuildContext context) async {
    var stream = await FirebaseFirestore.instance.collection('users').get();
    for (var i in stream.docs) {
      var userData = UserInfoModel.fromJson(i);
      String selectedPhoneNumber = contact.phones[0].number.replaceAll(' ', '');
      String phoneNumber = '';
      if (selectedPhoneNumber.startsWith('0')) {
        phoneNumber = selectedPhoneNumber.replaceFirst('0', '+92');
      }
      if (selectedPhoneNumber == userData.phoneNumber ||
          phoneNumber == userData.phoneNumber) {
        Get.to(() => ChatScreen(
              targetuser: UserInfoModel(
                uid: userData.uid,
                username: contact.displayName,
                profilePic: Images.avatar,
              ),
              currentUser: UserInfoModel(
                  uid: FirebaseAuth.instance.currentUser!.uid,
                  username: AuthController.i.userInfoModel.username),
            ));
      }
    }
  }

  // String phoneNumberConverted(Contact contact) {
  //   String num1 = contact.phones[0].number.replaceAll(' ', '');
  //   String phoneNumber = '';
  //   if (num1.startsWith('0')) {
  //       phoneNumber = num1.replaceFirst('0', '+92');
  //     }

  // }
}
