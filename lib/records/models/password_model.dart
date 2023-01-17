// To parse this JSON data, do
//
//     final passwordModel = passwordModelFromJson(jsonString);

import 'dart:convert';

PasswordModel? passwordModelFromJson(String str) =>
    PasswordModel.fromJson(json.decode(str));

String passwordModelToJson(PasswordModel? data) => json.encode(data!.toJson());

class PasswordModel {
  PasswordModel({
    required this.title,
    required this.login,
    required this.password,
    required this.website,
    required this.notes,
    required this.length,
  });

  String? title;
  String? login;
  String? password;
  String? website;
  String? notes;
  int? length;

  factory PasswordModel.fromJson(Map<String, dynamic> json) => PasswordModel(
        title: json["title"],
        login: json["login"],
        password: json["password"],
        website: json["website"],
        notes: json["notes"],
        length: json["length"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "login": login,
        "password": password,
        "website": website,
        "notes": notes,
      };
}
