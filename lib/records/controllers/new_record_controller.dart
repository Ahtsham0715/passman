import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:passman/records/models/progressbarmodel.dart';

class NewRecordController extends GetxController {
  static const letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
  static const letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  static const number = '0123456789';
  static const special =
      '\^\$*.\[\]{}()?\-"!@#%&/\,><:;_~`+=' // <-- Notice the escaped symbols
      "'" // <-- ' is added to the expression
      '';
  ProgressBarValueModel progressmodel =
      ProgressBarValueModel(color: Colors.green, value: 0.0);
  var characters = 8.0;
  bool alphabets = true;
  bool numbers = true;
  bool specialcharacters = true;
  bool autogenerate = false;
  // double progressvalue = 0.1;

  String generateHiveKey() {
    var rng = new Random.secure();
    var values = new List<int>.generate(50, (_) => rng.nextInt(256));
    return base64Url.encode(values);
  }

  progressBarValue(String password) async {
    bool alphabetsval = password.contains(RegExp(r'[A-Z]'));
    bool numbersval = password.contains(RegExp(r'[0-9]'));
    bool specialcharactersval = password.contains(RegExp(
        r'[\^$*.\[\]{}()?\-"!@#%&/\,><:;_~`+=' // <-- Notice the escaped symbols
        "'" // <-- ' is added to the expression
        ']'));
    if (alphabetsval && numbersval && specialcharactersval) {
      // return [1.0, ];
      progressmodel = ProgressBarValueModel(color: Colors.green, value: 1.0);
    } else if (alphabetsval && numbersval) {
      // return 0.6;
      progressmodel =
          ProgressBarValueModel(color: Colors.deepOrangeAccent, value: 0.6);
    } else if (alphabetsval && specialcharactersval) {
      // return 0.75;
      progressmodel = ProgressBarValueModel(color: Colors.yellow, value: 0.75);
    } else if (numbersval && specialcharactersval) {
      // return 0.8;
      progressmodel = ProgressBarValueModel(color: Colors.yellow, value: 0.8);
    } else if (specialcharactersval) {
      // return 0.5;
      progressmodel =
          ProgressBarValueModel(color: Colors.deepOrangeAccent, value: 0.5);
    } else if (numbersval) {
      // return 0.4;
      progressmodel =
          ProgressBarValueModel(color: Colors.redAccent, value: 0.4);
    } else if (alphabetsval) {
      // return 0.2;
      progressmodel =
          ProgressBarValueModel(color: Colors.pinkAccent, value: 0.2);
    } else if (password.isEmpty) {
      progressmodel = ProgressBarValueModel(color: Colors.red, value: 0.0);
    } else {
      // return 0.1;
      progressmodel = ProgressBarValueModel(color: Colors.red, value: 0.1);
    }
  }

  // Future<String> generatePassword(int length) async {
  //   String password = '';
  //   Random.secure().nextInt(max)

  // }
  Random _rnd = Random();

  Future<String> generatePassword(
      {required int length,
      required bool alphabets,
      required bool numbers,
      required bool specchar}) async {
    String _chars = letterLowerCase;
    String password = '';
    if (alphabets) {
      _chars = _chars + letterUpperCase;
    }
    if (numbers) {
      _chars = _chars + number;
    }
    if (specchar) {
      _chars = _chars + special;
    }
    password = String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    while (true) {
      if (passwordValidator(
          password: password,
          uppercase: alphabets,
          numbers: numbers,
          specialchars: specchar)) {
        break;
      } else {
        password = String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
      }
    }

    progressBarValue(password);
    return password;
  }

  bool passwordValidator(
      {required String password,
      required bool uppercase,
      required bool numbers,
      required bool specialchars}) {
    final RegExp allregExp = new RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    final RegExp alphabets = RegExp(r"[A-Z]+");
    final RegExp symbols = RegExp(r'[`~!@#$%\^&*\(\)_+\\\-={}\[\]\/.,<>;]');
    final RegExp numbersregex = RegExp(r"[0-9.]+");
    if (uppercase && numbers && specialchars) {
      if (allregExp.hasMatch(password)) {
        return true;
      } else {
        return false;
      }
    } else if (uppercase && numbers) {
      if (alphabets.hasMatch(password) && numbersregex.hasMatch(password)) {
        return true;
      } else {
        return false;
      }
    } else if (uppercase && specialchars) {
      if (alphabets.hasMatch(password) && symbols.hasMatch(password)) {
        return true;
      } else {
        return false;
      }
    } else if (uppercase) {
      if (alphabets.hasMatch(password)) {
        return true;
      } else {
        return false;
      }
    } else if (numbers) {
      if (numbersregex.hasMatch(password)) {
        return true;
      } else {
        return false;
      }
    } else if (specialchars) {
      if (symbols.hasMatch(password)) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}
