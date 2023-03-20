import 'package:flutter_chat_app/ui/components/enums/message_enum.dart';
import 'package:flutter_chat_app/utils/chat_screen_utils/chat_screen_utils.dart';

class Messages {
  String? senderId;
  String? receiverId;
  String? message;
  MessageEnum? type;
  DateTime? date;
  String? isSentByme;
  String? messageId;
  bool? isSeen;

  Messages(
      {this.message,
      this.date,
      this.isSentByme,
      this.isSeen,
      this.messageId,
      this.senderId,
      this.receiverId,
      this.type});

  Messages.fromJson(map) {
    senderId = map['senderId'] ?? '';
    receiverId = map['receiverId'] ?? '';
    date = ChatScreenUtils().toDateTime(map['date']);
    isSentByme = map['isSentByme'] ?? '';
    isSeen = map['isSeen'] ?? '';
    message = map['message'] ?? '';
    type = (map['type'] as String).toEnum();
    messageId = map['messageId'] ?? '';
  }

  toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'date': date,
      'isSentByme': isSentByme,
      'isSeen': isSeen,
      'message': message,
      'type': type!.type,
      'messageId': messageId
    };
  }
}
