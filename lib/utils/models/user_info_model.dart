class UserInfoModel {
  String? username;
  String? about;
  String? phoneNumber;
  String? profilePic;
  String? createdAt;
  String? uid;

  UserInfoModel(
      {this.username,
      this.about,
      this.phoneNumber,
      this.profilePic,
      this.createdAt,
      this.uid});

  factory UserInfoModel.fromJson(map) {
    return UserInfoModel(
        username: map['username'] ?? '',
        about: map['about'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        profilePic: map['profilePic'] ?? '',
        createdAt: map['createdAt'] ?? '',
        uid: map['uid'] ?? '');
  }
  toFirebase() {
    return {
      "username": username,
      "about": about,
      "phoneNumber": phoneNumber,
      "uid": uid,
      "createdAt": createdAt,
      "profilePic": profilePic
    };
  }
}
