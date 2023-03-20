import 'package:flutter_chat_app/utils/chat_screen_utils/chat_screen_utils.dart';

class ChatContact {
  final String? name;
  final String? profilePic;
  final String? contactId;
  final DateTime? timeSent;
  final String? lastMessage;

  ChatContact({
    this.name,
    this.profilePic,
    this.contactId,
    this.timeSent,
    this.lastMessage,
  });

  toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'contactId': contactId,
      'timeSent': timeSent,
      'lastMessage': lastMessage
    };
  }

  factory ChatContact.fromJson({map}) {
    return ChatContact(
        name: map['name'],
        profilePic: map['profilePic'],
        contactId: map['contactId'],
        timeSent: ChatScreenUtils().toDateTime(map['timeSent']),
        lastMessage: map['lastMessage']);
  }
}
