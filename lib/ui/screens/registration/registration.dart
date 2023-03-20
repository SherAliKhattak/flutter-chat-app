import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/data/services/auth_service.dart';
import 'package:flutter_chat_app/utils/consts/consts.dart';
import 'package:flutter_chat_app/ui/custom_widgets/bold_text.dart';
import 'package:flutter_chat_app/ui/custom_widgets/custom_button.dart';
import 'package:flutter_chat_app/data/controllers/auth_controller.dart';
import 'package:flutter_chat_app/data/controllers/user_info_controller.dart';
import 'package:flutter_chat_app/ui/components/themes/themes.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  Country selectedCountry = Country(
      phoneCode: '92',
      countryCode: 'PK',
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "Pakistan",
      example: "Pakistan",
      displayName: "Pakistan",
      displayNameNoCountryCode: "PK",
      e164Key: '');

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    TickerFuture tickerFuture = _controller.repeat();
    tickerFuture.timeout(const Duration(seconds: 3 * 10), onTimeout: () {
      _controller.forward(from: 0);
      _controller.stop(canceled: false);
    });

    _controller.reset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserInfoController.i.phoneNumber.selection = TextSelection.fromPosition(
        TextPosition(offset: UserInfoController.i.phoneNumber.text.length));
    return Scaffold(
      backgroundColor: CustomColors.kscaffoldColor,
      body: AuthController.i.isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: Get.height * 0.3,
                          width: Get.width,
                          child: Lottie.asset('assets/images/chatApp.json',
                              repeat: true,
                              reverse: true,
                              controller: _controller, onLoaded: (composition) {
                            _controller
                              ..duration = composition.duration
                              ..forward();
                          }, fit: BoxFit.fill),
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        const BoldText(
                          text: 'Registration',
                          textSize: 20,
                          color: CustomColors.kprimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        const Text(
                          loremIpsum,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: CustomColors.ktextColor, fontSize: 15),
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              UserInfoController.i.phoneNumber.text.length <= 9
                                  ? UserInfoController.i.phoneNumber.text =
                                      value
                                  : null;
                            });
                          },
                          controller: UserInfoController.i.phoneNumber,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              suffixIcon: UserInfoController
                                          .i.phoneNumber.text.length ==
                                      10
                                  ? const SizedBox(
                                      child: Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ),
                                    )
                                  : null,
                              hintText: 'Enter Phone Number',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: CustomColors.ktextColor2)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: CustomColors.ktextColor2)),
                              prefixIcon: SizedBox(
                                  child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: InkWell(
                                  onTap: (() {
                                    showCountryPicker(
                                        showPhoneCode: true,
                                        context: context,
                                        onSelect: ((value) {
                                          setState(() {
                                            selectedCountry = value;
                                          });
                                        }));
                                  }),
                                  child: Text(
                                      "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}"),
                                ),
                              ))),
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        CustomButton(
                          onTap: () => sendPhoneNumber(),
                          buttonColor: CustomColors.kprimaryColor,
                          text: "SEND",
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = UserInfoController.i.phoneNumber.text.trim();
    AuthServices()
        .siginInwithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber");
  }
}
