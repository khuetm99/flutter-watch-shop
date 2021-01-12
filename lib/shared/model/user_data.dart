class UserData {
  String fullName;
  String email;
  String phone;
  String avatar;
  String token;
  String createdAt;

  UserData({this.fullName, this.email, this.phone, this.avatar, this.token,
    this.createdAt});

  factory UserData.fromJson(Map<String, dynamic> map) {
    return UserData(
      fullName: map['fullName'],
      email: map['email'],
      phone: map['phone'],
      avatar: map['avatar'],
      token: map['token'],
      createdAt: map['createdAt'],
    );
  }
}