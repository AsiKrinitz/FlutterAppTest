import 'dart:convert';
import 'dart:ffi';

class UserModel {
  int? id;
  String? firstName;
  String? lastName;
  String? nickName;
  String email;
  String password;
  String? phone;
  String? dateOfBirth;
  String? aboutMe;
  String? pictureUrl;
  String? createdAt;
  String? lastEnter;

  UserModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.nickName,
      required this.email,
      required this.password,
      this.phone,
      this.dateOfBirth,
      this.aboutMe,
      this.pictureUrl,
      this.createdAt,
      this.lastEnter});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        nickName: json["nickName"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        dateOfBirth: json["dateOfBirth"],
        aboutMe: json["aboutMe"],
        pictureUrl: json["pictureUrl"],
        createdAt: json["createdAt"],
        lastEnter: json["lastEnter"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "nickName": nickName,
        "email": email,
        "password": password,
        "phone": phone,
        "dateOfBirth": dateOfBirth,
        "aboutMe": aboutMe,
        "pictureUrl": pictureUrl,
        "createdAt": createdAt,
        "lastEnter": lastEnter
      };
}
