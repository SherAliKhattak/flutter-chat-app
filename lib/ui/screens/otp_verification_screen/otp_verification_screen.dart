import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/data/services/auth_service.dart';
import 'package:flutter_chat_app/data/services/db_service.dart';
import 'package:flutter_chat_app/ui/components/snackbars.dart';
import 'package:flutter_chat_app/ui/custom_widgets/bold_text.dart';
import 'package:flutter_chat_app/ui/custom_widgets/custom_button.dart';
import 'package:flutter_chat_app/data/controllers/auth_controller.dart';
import 'package:flutter_chat_app/utils/routes/routes.dart';
import 'package:flutter_chat_app/data/services/local_db.dart';
import 'package:flutter_chat_app/ui/components/themes/themes.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

class OTPVerification extends StatefulWidget {
  final String? otp;
  const OTPVerification({
    super.key,
    this.otp = '',
  });

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  String? otpCode;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.kscaffoldColor,
      body: SafeArea(
        child: AuthController.i.isLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: const EdgeInsets.all(20),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 200,
                          width: Get.width * 0.5,
                          child: Lottie.asset('assets/images/otp.json',
                              repeat: true,
                              controller: _controller, onLoaded: (composition) {
                            _controller
                              ..duration = composition.duration
                              ..forward();
                          }, fit: BoxFit.fill),
                        ),
                        // Image.asset(Images.chatAppImage),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        const BoldText(
                          textAlign: TextAlign.center,
                          text: 'Verification',
                          fontWeight: FontWeight.bold,
                          textSize: 28,
                          color: CustomColors.kprimaryColor,
                        ),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        const BoldText(
                          textAlign: TextAlign.center,
                          text: 'Enter your code number',
                          fontWeight: FontWeight.w600,
                          textSize: 12,
                          color: CustomColors.ktextColor,
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        Container(
                          height: Get.height * 0.3,
                          decoration: BoxDecoration(
                              color: CustomColors.kwhiteColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [],
                              ),
                              Pinput(
                                defaultPinTheme: PinTheme(
                                  padding: const EdgeInsets.all(5),
                                  height: 60,
                                  width: Get.width * 0.12,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: CustomColors.kprimaryColor,
                                      border: Border.all(
                                          color: CustomColors.kprimaryColor)),
                                  textStyle: const TextStyle(
                                      color: CustomColors.kwhiteColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                                onCompleted: ((value) {
                                  setState(() {
                                    otpCode = value;
                                    log(otpCode.toString());
                                  });
                                }),
                                length: 6,
                              ),
                              SizedBox(
                                height: Get.height * 0.03,
                              ),
                              CustomButton(
                                  onTap: (() {
                                    if (otpCode != null) {
                                      verifyOTP(context, otpCode!);
                                    } else {
                                      showSnackbar(
                                          context, 'Enter 6 digit Code');
                                    }
                                  }),
                                  buttonColor: CustomColors.kprimaryColor,
                                  text: 'Verify')
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void verifyOTP(BuildContext context, String userOtp) {
    AuthServices().verifyOtp(
        context: context,
        verificationId: widget.otp!,
        userOtp: userOtp,
        onSuccess: () {
          DBservice().checkIfuserExists().then((state) {
            if (state == true) {
              log(state.toString());
              DBservice().getDataFromFirestore().then((value) {
                Preferences.saveUserData().then((value) {
                  Preferences().setSignIn().then((value) {
                    Get.offNamed(RouteHelper.getHome());
                  });
                });
              });
            } else {
              Get.offAllNamed(RouteHelper.getuserInfo());
            }
          });
        });
  }
}
