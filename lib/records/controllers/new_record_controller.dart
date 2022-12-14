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
    print(_chars);
    password = String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    // if(password.contains(RegExp(r'^(?=.*[a-zA-Z])(?=.*[*".!@#\$%^&(){}:;<>,.\' + r"'?/~_+-=])(?=.*[0-9]).{8,30}\$")))
    progressBarValue(password);
    return password;
  }
}
