import 'dart:convert';
import 'dart:typed_data';
// import 'dart:ffi';

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
  Uint8List? pictureUrl; // Change type to Uint8List to store image as BLOB
  // String? createdAt;
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
      // this.createdAt,
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
        pictureUrl: json["pictureUrl"] != null
            ? Base64Decoder().convert(json["pictureUrl"])
            : null,
        // createdAt: json["createdAt"],
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
        "pictureUrl":
            pictureUrl != null ? Base64Encoder().convert(pictureUrl!) : null,
        "lastEnter": lastEnter
      };
}
