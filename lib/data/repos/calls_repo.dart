import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ui/screens/call_screen/call_screen.dart';
import 'package:flutter_chat_app/utils/models/call_model.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../../utils/models/user_info_model.dart';

class CallsRepo {
  final _firebaseFirestore = FirebaseFirestore.instance;

  void makeCall(
    CallModel sendCallData,
    BuildContext context,
    CallModel receiverCallData,
  ) async {
    try {
      await _firebaseFirestore
          .collection('call')
          .doc(sendCallData.callerId)
          .set(sendCallData.toMap());

      await _firebaseFirestore
          .collection('call')
          .doc(sendCallData.receiverId)
          .set(receiverCallData.toMap());

      Get.to(() => CallScreen(
            call: sendCallData,
            channelId: sendCallData.callId!,
          ));
    } catch (e) {
      e.toString();
    }
  }

  void endCall(
      String senderCallId, BuildContext context, String receiverCallid) async {
    try {
      await _firebaseFirestore.collection('call').doc(senderCallId).delete();
      await _firebaseFirestore.collection('call').doc(receiverCallid).delete();
    } catch (e) {
      e.toString();
    }
  }

  String callId = uuid.v1();
  void callData(BuildContext context, UserInfoModel targetUser,
      UserInfoModel currentUser) {
    CallModel senderCallData = CallModel(
        callerId: currentUser.uid,
        callerName: currentUser.username,
        callerPic: currentUser.profilePic,
        receiverId: targetUser.uid,
        receiverName: targetUser.username,
        receiverPic: targetUser.profilePic,
        callId: callId,
        hasDialled: true);
    CallModel receiverCalldata = CallModel(
        callerId: currentUser.uid,
        callerName: currentUser.username,
        callerPic: currentUser.profilePic,
        receiverId: targetUser.uid,
        receiverName: targetUser.username,
        receiverPic: targetUser.profilePic,
        callId: callId,
        hasDialled: false);
    CallsRepo().makeCall(senderCallData, context, receiverCalldata);
  }
}
