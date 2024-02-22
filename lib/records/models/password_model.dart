// To parse this JSON data, do
//
//     final passwordModel = passwordModelFromJson(jsonString);

import 'dart:convert';

PasswordModel? passwordModelFromJson(String str) =>
    PasswordModel.fromJson(json.decode(str));

String passwordModelToJson(PasswordModel? data) => json.encode(data!.toJson());

class PasswordModel {
  PasswordModel(
      {required this.title,
      required this.login,
      required this.password,
      required this.website,
      required this.notes,
      required this.length,
      this.folderKey = '',
      this.folderName = ''});

  String? title;
  String folderKey;
  String folderName;
  String? login;
  String? password;
  String? website;
  String? notes;
  int? length;

  factory PasswordModel.fromJson(Map<String, dynamic> json) => PasswordModel(
        title: json["title"],
        folderKey: json["folderKey"],
        folderName: json["folderName"],
        login: json["login"],
        password: json["password"],
        website: json["website"],
        notes: json["notes"],
        length: json["length"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "folderKey": folderKey,
        "folderName": folderName,
        "login": login,
        "password": password,
        "website": website,
        "notes": notes,
        'length': length
      };
}
