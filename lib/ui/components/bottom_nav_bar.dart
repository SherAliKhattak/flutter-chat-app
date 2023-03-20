import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ui/screens/contacts_screen/contacts_screen.dart';
import 'package:flutter_chat_app/ui/screens/home_screen/home_screen.dart';
import 'package:flutter_chat_app/ui/screens/pickup_call_screen/pickup_call_screen.dart';
import 'package:flutter_chat_app/ui/screens/profile_screen/profile_screen.dart';
import 'package:lottie/lottie.dart';
import '../../utils/assets/images.dart';

class ReturnNavBar extends StatefulWidget {
  const ReturnNavBar({Key? key}) : super(key: key);

  @override
  State<ReturnNavBar> createState() => _ReturnNavBarState();
}

class _ReturnNavBarState extends State<ReturnNavBar>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return const CurvedNavBar();
  }
}

class CurvedNavBar extends StatefulWidget {
  const CurvedNavBar({Key? key}) : super(key: key);
  @override
  State<CurvedNavBar> createState() => _CurvedNavBarState();
}

class _CurvedNavBarState extends State<CurvedNavBar>
    with TickerProviderStateMixin {
  late AnimationController idleAnimation;
  late AnimationController onchangedAnimation;
  late AnimationController onselectedAnimation;

  Duration animationDuration = const Duration(milliseconds: 1500);
  @override
  void initState() {
    super.initState();

    idleAnimation = AnimationController(
      vsync: this,
    );
    onchangedAnimation =
        AnimationController(vsync: this, duration: animationDuration);
    onselectedAnimation =
        AnimationController(vsync: this, duration: animationDuration);
  }

  Widget _callPage(int currentIndex) {
    switch (currentIndex) {
      case 1:
        return const Profile();

      case 2:
        return const Contacts();

      default:
        return const HomePage();
    }
  }

  int _index = 0;
  int previousIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PickupCall(
      scaffold: Scaffold(
        extendBody: true,
        body: _callPage(_index),
        bottomNavigationBar: CurvedNavigationBar(
          height: 60,
          index: _index,
          color: const Color(0xFF87C8EE),
          backgroundColor: const Color(0xFFF3F3F3),
          buttonBackgroundColor: Colors.white,
          animationCurve: Curves.easeOutQuart,
          animationDuration: const Duration(milliseconds: 1000),
          items: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                  _index == 1
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).secondaryHeaderColor,
                  BlendMode.srcIn),
              child: Lottie.asset(Images.plus,
                  height: 30,
                  width: 30,
                  controller: _index == 1
                      ? onselectedAnimation
                      : previousIndex == 1
                          ? onchangedAnimation
                          : idleAnimation),
            ),
          ],
          onTap: (index) {
            onselectedAnimation.reset();
            onselectedAnimation.forward();

            onchangedAnimation.value = 1;
            onchangedAnimation.reverse();
            setState(() {
              previousIndex = _index;
              _index = index;
            });
          },
        ),
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  const CustomIcon({
    Key? key,
    this.icon,
    this.iconColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: backgroundColor,
        radius: 20,
        child: Icon(
          icon,
          color: iconColor,
        ));
  }
}
