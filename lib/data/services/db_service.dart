import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/utils/models/chat_contact.dart';
import 'package:flutter_chat_app/ui/components/snackbars.dart';
import 'package:flutter_chat_app/utils/chat_screen_utils/chat_screen_utils.dart';
import 'package:flutter_chat_app/data/controllers/auth_controller.dart';
import 'package:flutter_chat_app/data/controllers/user_info_controller.dart';
import 'package:flutter_chat_app/utils/models/chat_model.dart';
import 'package:flutter_chat_app/utils/models/user_info_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/routes/routes.dart';

class DBservice {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  sendDataToFirebase(
      {required UserInfoModel? model,
      required File? image,
      required BuildContext? context,
      required Function? onSuccess}) async {
    try {
      AuthController.i.resetIsLoading(true);
      await storeProfileImage(
              "profilePic/${_firebaseAuth.currentUser!.uid}", image!)
          .then((value) {
        model!.profilePic = value;
        model.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
        model.uid = _firebaseAuth.currentUser!.uid;
      });
      _firestore
          .collection('users')
          .doc(model!.uid)
          .set(model.toFirebase())
          .then((value) => onSuccess);
      AuthController.i.resetIsLoading(false);
      log(model.uid!);
    } on FirebaseException catch (e) {
      showSnackbar(context!, e.message.toString());
      AuthController.i.resetIsLoading(false);
    }
  }

  storeData(image, BuildContext context) async {
    UserInfoModel userInfoModel = UserInfoModel(
        username: UserInfoController.i.username.text,
        about: UserInfoController.i.about.text,
        phoneNumber: FirebaseAuth.instance.currentUser!.phoneNumber!,
        profilePic: '',
        createdAt: ChatScreenUtils.formatTime(DateTime.now().toString()),
        uid: '');

    if (image != null &&
        userInfoModel.username!.isNotEmpty &&
        userInfoModel.about!.isNotEmpty) {
      sendDataToFirebase(
          model: userInfoModel,
          image: image,
          context: context,
          onSuccess: () {
            Get.toNamed(RouteHelper.getHome());
          });
      Get.toNamed(RouteHelper.getHome());
    } else {
      showSnackbar(context,
          'Please fill in the required fields and upload your Profile Pic');
    }
  }

  Future<String> storeProfileImage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    AuthController.i.resetIsLoading(true);
    await _firebaseAuth.signOut();
    AuthController.i.resetIsSignedIn(false);
    s.clear();
    Get.offAllNamed(RouteHelper.getRegistration());
    AuthController.i.resetIsLoading(false);
  }

  Future getDataFromFirestore() async {
    await _firestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      AuthController.i.userInfoModel = UserInfoModel.fromJson(snapshot);
      AuthController.i.uid = AuthController.i.userInfoModel.uid!;
    });
  }

  /// [ListAllChats] ///
  Stream<List<ChatContact>> getAllChats() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var doc in event.docs) {
        var chatContact = ChatContact.fromJson(map: doc.data());
        var userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserInfoModel.fromJson(userData.data());
        contacts.add(ChatContact(
            name: user.username,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage));
      }
      return contacts;
    });
  }

  /// [getChatMessages] ///
  Stream<List<Messages>> getIndividualChats(String receiverUid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(receiverUid)
        .collection('messages')
        .orderBy('date')
        .snapshots()
        .map((event) {
      List<Messages> messages = [];
      for (var document in event.docs) {
        messages.add(Messages.fromJson(document.data()));
      }
      return messages;
    });
  }

  Stream<DocumentSnapshot> get callStream => FirebaseFirestore.instance
      .collection('call')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  Future updateUserData(String key, String value) {
    log('message');
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({key: value});
  }

  Future<bool> checkIfuserExists() async {
    DocumentSnapshot snapshot = await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkIfNumberExists(String phoneNumber) async {
    String number = phoneNumber.replaceAll(' ', '');
    String mynumber = '';
    if (number.startsWith('0')) {
      mynumber = number.replaceFirst('0', '+92');
    }

    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: mynumber)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}
