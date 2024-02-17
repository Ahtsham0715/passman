import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
final firestore = FirebaseFirestore.instance;
final uid = FirebaseAuth.instance.currentUser!.uid;
final firebaseStorage = FirebaseStorage.instance;
final key = encryption.Key.fromLength(32);
final iv = encryption.IV.fromLength(16);
// final key = encryption.Key.fromSecureRandom(32);
// final iv = encryption.IV.fromSecureRandom(16);
var encrypter = encryption.Encrypter(encryption.AES(key));
// open a box
var passwordbox = Hive.box<PasswordModel>(logininfo.get('userid'));
var logininfo = Hive.box('logininfo');
var foldersbox = Hive.box('folders${logininfo.get('userid')}');
var foldersdatabox = Hive.box('foldersdata${logininfo.get('userid')}');
final appLightColor = Color(0XFFe29587);
final appDarkColor = Color(0XFFd66d75);
Gradient bodyGradient(context) {
  return LinearGradient(
    colors: [
      Color(0XFFd66d75),
      Color(0XFFe29587),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomCenter,
  );
}

Gradient appBarGradient(context) {
  return LinearGradient(
    colors: [
      Color(0XFFd66d75),
      Color(0XFFe29587),
    ],
    begin: MediaQuery.of(context).orientation == Orientation.portrait
        ? Alignment.bottomCenter
        : Alignment.bottomLeft,
    end: MediaQuery.of(context).orientation == Orientation.portrait
        ? Alignment.topCenter
        : Alignment.bottomCenter,
  );
}

List<String> apps = [
  "Facebook",
  "passman",
  "Twitter",
  "Instagram",
  "Gmail",
  "Google",
  "Youtube",
  "LinkedIn",
  // "WhatsApp",
  "Snapchat",
  "Pinterest",
  "Reddit",
  "Behance",
  "Dribbble",
  "Flickr",
  "Kakao Talk",
  "Line",
  "Messenger",
  "Spotify",
  "Telegram",
  "TikTok",
  "Snack Video",
  "Tinder",
  "Tumblr",
  "Twitch",
  "Vimeo",
  "We Chat",
  "Skype",
  "Discord",
  "Signal",
  "Sound Cloud",
  // and so on
];

Map<String, String> websites = {
  "Facebook": "https://www.facebook.com/",
  "passman": "https://www.passman.com/",
  "Sound Cloud": "https://soundcloud.com/",
  "Twitter": "https://twitter.com/",
  "Instagram": "https://www.instagram.com/",
  "Gmail": "https://mail.google.com/",
  "Google": "https://www.google.com/",
  "Youtube": "https://www.youtube.com/",
  "LinkedIn": "https://www.linkedin.com/",
  // "WhatsApp": "https://www.whatsapp.com/",
  "Snapchat": "https://www.snapchat.com/",
  "Pinterest": "https://www.pinterest.com/",
  "Reddit": "https://www.reddit.com/",
  "Behance": "https://www.behance.net/",
  "Dribbble": "https://dribbble.com/",
  "Flickr": "https://www.flickr.com/",
  "Kakao Talk": "https://www.kakao.com/en/talk",
  "Line": "https://line.me/en/",
  "Messenger": "https://www.messenger.com/",
  "Spotify": "https://www.spotify.com/",
  "Telegram": "https://telegram.org/",
  "TikTok": "https://www.tiktok.com/",
  "Snack Video": "https://www.snackvideo.com/",
  "Tinder": "https://tinder.com/",
  "Tumblr": "https://www.tumblr.com/",
  "Twitch": "https://www.twitch.tv/",
  "Vimeo": "https://vimeo.com/",
  "We Chat": "https://www.wechat.com/en/",
  "Skype": "https://www.skype.com/",
  "Discord": "https://discord.com/",
  "Signal": "https://signal.org/"
};
