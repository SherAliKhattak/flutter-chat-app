import 'package:flutter_chat_app/ui/screens/chat_screen/chat_screen.dart';
import 'package:flutter_chat_app/ui/screens/contacts_screen/contacts_screen.dart';
import 'package:flutter_chat_app/ui/screens/login_screen/login_screen.dart';
import 'package:flutter_chat_app/ui/screens/onboarding_screens/onboarding_screen.dart';
import 'package:flutter_chat_app/ui/screens/otp_verification_screen/otp_verification_screen.dart';
import 'package:flutter_chat_app/ui/screens/registration/registration.dart';
import 'package:flutter_chat_app/ui/screens/user_info_screen.dart/user_info.dart';
import 'package:get/get.dart';

import '../../ui/components/bottom_nav_bar.dart';

class RouteHelper {
  static const String homePage = "/home";
  static const String onboarding = "/onboarding";
  static const String chatScreen = "/ChatScreen";
  static const String loginScreen = "/loginScreen";
  static const String registration = "/registration";
  static const String otpScreen = "/OtpScreen";
  static const String userInfo = "/userInfo";
  static const String contacts = "/contacts";
  static String getHome() => homePage;
  static String getOnbarding() => onboarding;
  static String getChatScreen() => chatScreen;
  static String getLoginScreen() => loginScreen;
  static String getRegistration() => registration;
  static String getOTPScreen() => otpScreen;
  static String getuserInfo() => userInfo;
  static String getContactsScreen() => contacts;
  static List<GetPage> routes = [
    GetPage(
        name: homePage,
        page: () {
          return const ReturnNavBar();
        },
        transition: Transition.leftToRight,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: userInfo,
        page: () {
          return const UserInfo();
        },
        transition: Transition.leftToRight,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: loginScreen,
        page: () {
          return const LoginScreen();
        },
        transition: Transition.leftToRight,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
      name: onboarding,
      page: () {
        return const OnboardingScreen();
      },
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: chatScreen,
      page: () {
        return const ChatScreen();
      },
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
        name: registration,
        page: () {
          return const Registration();
        },
        transition: Transition.leftToRight,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: otpScreen,
        page: () {
          return const OTPVerification();
        },
        transition: Transition.leftToRight,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: contacts,
        page: () {
          return const Contacts();
        },
        transition: Transition.leftToRight,
        transitionDuration: const Duration(milliseconds: 500)),
  ];
}
