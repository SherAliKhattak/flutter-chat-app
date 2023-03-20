class CallModel {
  final String? callerId;
  final String? callerName;
  final String? callerPic;
  final String? receiverId;
  final String? receiverName;
  final String? receiverPic;
  final String? callId;
  final bool? hasDialled;

  CallModel({
    this.callerId,
    this.callerName,
    this.callerPic,
    this.receiverId,
    this.receiverName,
    this.receiverPic,
    this.callId,
    this.hasDialled,
  });
  Map<String, dynamic> toMap() {
    return {
      'callerId': callerId,
      'callerName': callerName,
      'callerPic': callerPic,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverPic': receiverPic,
      'callId': callId,
      'hasDialled': hasDialled
    };
  }

  factory CallModel.fromMap({map}) {
    return CallModel(
      callerId: map['callerId'] ?? '',
      callerName: map['callerName'] ?? '',
      callerPic: map['callerPic'] ?? '',
      receiverId: map['receiverId'] ?? '',
      receiverName: map['receiverName'] ?? '',
      receiverPic: map['receiverPic'] ?? '',
      callId: map['callId'] ?? '',
      hasDialled: map['hasDialled'] ?? false,
    );
  }
}
