import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chat_model.dart';

class ChatScreenUtils {
  static String formatTime(String iso) {
    DateTime date = DateTime.parse(iso);
    DateTime now = DateTime.now();
    DateTime yDay = DateTime.now().subtract(const Duration(days: 1));
    DateTime dateFormat = DateTime.parse(
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T00:00:00.000Z');
    DateTime today = DateTime.parse(
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T00:00:00.000Z');
    DateTime yesterday = DateTime.parse(
        '${yDay.year}-${yDay.month.toString().padLeft(2, '0')}-${yDay.day.toString().padLeft(2, '0')}T00:00:00.000Z');

    if (dateFormat == today) {
      return 'Today ${DateFormat('HH:mm').format(DateTime.parse(iso))}';
    } else if (dateFormat == yesterday) {
      return 'Yesterday ${DateFormat('HH:mm').format(DateTime.parse(iso))}';
    } else {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(iso));
    }
  }

  DateTime? toDateTime(dynamic dateValue) {
    if (dateValue is DateTime) {
      return dateValue;
    } else if (dateValue is String) {
      return DateTime.parse(dateValue);
    } else if (dateValue is Timestamp) {
      return dateValue.toDate();
    } else {
      return null;
    }
  }

  BorderRadiusGeometry borderSide(Messages message) => BorderRadius.only(
        topLeft: isSentbyme(message)
            ? const Radius.circular(20)
            : const Radius.circular(20),
        bottomLeft: isSentbyme(message)
            ? const Radius.circular(20)
            : const Radius.circular(0),
        bottomRight: isSentbyme(message)
            ? const Radius.circular(0)
            : const Radius.circular(20),
        topRight: isSentbyme(message)
            ? const Radius.circular(20)
            : const Radius.circular(20),
      );

  bool isSentbyme(Messages message) {
    if (message.senderId == FirebaseAuth.instance.currentUser!.uid) {
      return true;
    } else {
      return false;
    }
  }
}
