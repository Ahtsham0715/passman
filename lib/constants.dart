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
var passwordbox = Hive.box<PasswordModel>(logininfo.get('userid'));
var logininfo = Hive.box('logininfo');

List<String> apps = [
  "Facebook",
  "Twitter",
  "Instagram",
  "Gmail",
  "Google",
  "Youtube",
  "LinkedIn",
  "WhatsApp",
  "Snapchat",
  "Pinterest",
  "Reddit",
  "Behance",
  "Dribble",
  "Flicker",
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
  "Sound Cloud": "https://soundcloud.com/",
  "Twitter": "https://twitter.com/",
  "Instagram": "https://www.instagram.com/",
  "Gmail": "https://mail.google.com/",
  "Google": "https://www.google.com/",
  "Youtube": "https://www.youtube.com/",
  "LinkedIn": "https://www.linkedin.com/",
  "WhatsApp": "https://www.whatsapp.com/",
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
  "Snack Videos": "https://www.quora.com/topic/Snack-Videos",
  "Tinder": "https://tinder.com/",
  "Tumblr": "https://www.tumblr.com/",
  "Twitch": "https://www.twitch.tv/",
  "Vimeo": "https://vimeo.com/",
  "WeChat": "https://www.wechat.com/en/",
  "Skype": "https://www.skype.com/",
  "Discord": "https://discord.com/",
  "Signal": "https://signal.org/"
};
