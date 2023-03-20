import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../ui/screens/otp_verification_screen/otp_verification_screen.dart';
import '../../ui/components/snackbars.dart';
import '../controllers/auth_controller.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void siginInwithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: ((phoneAuthCredential) async {}),
          verificationFailed: ((error) {
            throw Exception(error);
          }),
          timeout: const Duration(seconds: 60),
          codeSent: ((verificationId, forceResendingToken) {
            Get.to(() => OTPVerification(
                  otp: verificationId,
                ));
          }),
          codeAutoRetrievalTimeout: ((verificationId) {}));
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message.toString());
    }
  }

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    AuthController.i.resetIsLoading(true);
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOtp,
      );
      User? user = (await _firebaseAuth.signInWithCredential(creds)).user!;
      onSuccess();
      AuthController.i.resetIsLoading(false);
    } on FirebaseAuthException catch (e) {
      e.toString();
    }
  }
}
