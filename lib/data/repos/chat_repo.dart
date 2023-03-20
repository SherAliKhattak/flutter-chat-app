import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/data/services/db_service.dart';
import 'package:flutter_chat_app/utils/models/chat_model.dart';
import '../../main.dart';
import '../../utils/models/chat_contact.dart';
import '../../utils/models/user_info_model.dart';
import '../../ui/components/enums/message_enum.dart';
import '../../ui/components/snackbars.dart';

class ChatRepo {
  final _firestore = FirebaseFirestore.instance;

  void sendTextMessage(BuildContext context, String text, String receiverUserId,
      UserInfoModel senderUser) async {
    try {
      var timeSent = DateTime.now();
      UserInfoModel receiverUserData;

      var userDataMap =
          await _firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserInfoModel.fromJson(userDataMap.data()!);
      saveDatatoContactsSubcollection(
          senderUser, receiverUserData, text, timeSent, receiverUserId);
      saveMessagetoMessages(
          messageType: MessageEnum.text,
          messageId: uuid.v1(),
          receiverUserId: receiverUserId,
          receiverUserName: receiverUserData.username!,
          text: text,
          timeSent: timeSent,
          userName: senderUser.username!);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  saveDatatoContactsSubcollection(
      UserInfoModel senderUserData,
      UserInfoModel receiverUserData,
      String text,
      DateTime timeSent,
      String receiverUserId) async {
    var receiverChatContact = ChatContact(
        name: senderUserData.username,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text);

    await _firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(receiverChatContact.toMap());

    var senderChatContact = ChatContact(
        name: receiverUserData.username,
        profilePic: receiverUserData.profilePic,
        contactId: receiverUserData.uid,
        timeSent: timeSent,
        lastMessage: text);

    await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(senderChatContact.toMap());
  }

  saveMessagetoMessages(
      {required String receiverUserId,
      required String text,
      required DateTime timeSent,
      required String messageId,
      required String userName,
      required String receiverUserName,
      required MessageEnum messageType}) async {
    final message = Messages(
        senderId: FirebaseAuth.instance.currentUser!.uid,
        receiverId: receiverUserId,
        message: text,
        type: messageType,
        date: timeSent,
        messageId: messageId,
        isSeen: false);

    await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toJson());

    await _firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toJson());
  }

  Future sendImageFile(
      {required BuildContext context,
      File? file,
      required String receiverUid,
      UserInfoModel? sendUserData,
      MessageEnum? messageEnum}) async {
    try {
      var timeSent = DateTime.now();
      var messageId = uuid.v1();
      String imageUrl = await DBservice().storeProfileImage(
          'chat/${messageEnum!.type}/${sendUserData!.uid}/$receiverUid/$messageId',
          file!);

      UserInfoModel receiverUserData;
      var userDataMap = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverUid)
          .get();
      receiverUserData = UserInfoModel.fromJson(userDataMap.data());

      String contactMessage;
      switch (messageEnum) {
        case MessageEnum.image:
          contactMessage = '📸 photo';
          break;

        case MessageEnum.audio:
          contactMessage = '🎙 Audio';
          break;
        case MessageEnum.video:
          contactMessage = '🎥 video';
          break;
        case MessageEnum.gif:
          contactMessage = 'GIF';
          break;
        default:
          contactMessage = 'GIF';
      }
      saveDatatoContactsSubcollection(sendUserData, receiverUserData,
          contactMessage, timeSent, receiverUid);

      saveMessagetoMessages(
          receiverUserId: receiverUid,
          text: imageUrl,
          timeSent: timeSent,
          messageId: messageId,
          userName: sendUserData.username!,
          receiverUserName: receiverUserData.username!,
          messageType: messageEnum);
    } catch (e) {
      showSnackbar(context, 'error is here ${e.toString()}');
    }
  }
}
