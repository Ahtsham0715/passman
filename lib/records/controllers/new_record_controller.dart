import 'dart:math';

import 'package:get/state_manager.dart';

class NewRecordController extends GetxController {
  static const letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
  static const letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  static const number = '0123456789';
  static const special = '@#%^*>\$@?/[]=+';

  var characters = 8.0;
  bool alphabets = true;
  bool numbers = true;
  bool specialcharacters = true;
  bool autogenerate = true;

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
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
