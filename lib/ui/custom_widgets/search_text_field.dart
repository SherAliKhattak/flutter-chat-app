import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../components/themes/themes.dart';

class SearchTextFiled extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function(String)? onchanged;
  const SearchTextFiled(
      {super.key,
      required this.hintText,
      required this.controller,
      this.onchanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Theme.of(context).iconTheme.color),
      onChanged: onchanged,
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: CustomColors.ksearchBackground,
        enabledBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(width: 1, color: CustomColors.ktextColor2),
          borderRadius: BorderRadius.circular(30.0),
        ),
        prefixIcon: Icon(
          FontAwesomeIcons.magnifyingGlass,
          size: 15,
          color: Theme.of(context).iconTheme.color,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w200,
          color: Theme.of(context).hintColor,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).cardColor),
        ),
      ),
    );
  }
}
