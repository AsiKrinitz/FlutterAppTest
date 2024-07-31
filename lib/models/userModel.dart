import 'dart:convert';

class UserModel {
  String? firstName;
  String? lastName;
  String? nickName;
  String email;
  String password;
  String? phone;
  String? dateOfBirth;
  String? aboutMe;
  String? pictureUrl;

  UserModel({
    this.firstName,
    this.lastName,
    this.nickName,
    required this.email,
    required this.password,
    this.phone,
    this.dateOfBirth,
    this.aboutMe,
    this.pictureUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json["firstName"],
        lastName: json["lastName"],
        nickName: json["nickName"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        dateOfBirth: json["dateOfBirth"],
        aboutMe: json["aboutMe"],
        pictureUrl: json["pictureUrl"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "nickName": nickName,
        "email": email,
        "password": password,
        "phone": phone,
        "dateOfBirth": dateOfBirth,
        "aboutMe": aboutMe,
        "pictureUrl": pictureUrl,
      };
}
