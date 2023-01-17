import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:passman/records/models/password_model.dart';
import 'package:encrypt/encrypt.dart' as encryption;

double? responsiveHW(ctx, {ht, wd}) {
  return (ht != null)
      ? MediaQuery.of(ctx).size.height * ht / 100
      : (wd != null)
          ? MediaQuery.of(ctx).size.width * wd / 100
          : null;
}

var height = Get.height;

var width = Get.width;

final enckey = encryption.Key.fromLength(32);
final iv = encryption.IV.fromLength(16);
var encrypter = encryption.Encrypter(encryption.AES(enckey));
// open a box
var passwordbox = Hive.box<PasswordModel>('my_data');
var logininfo = Hive.box('logininfo');
