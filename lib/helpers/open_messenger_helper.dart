import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future openMessenger({
  required bool isWhatsApp,
  required String phone,
}) async {
  String formattedPhone = isWhatsApp
      ? phone.characters.first == '8'
          ? '+7${phone.substring(1, phone.length)}'
          : phone
      : phone;

  String url = isWhatsApp
      ? "whatsapp://send?phone=$formattedPhone"
      : 'tg://resolve?phone=$formattedPhone';

  if (Platform.isAndroid) {
    AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: url,
    ).launch();
  } else if (Platform.isIOS) {
    await canLaunchUrl(Uri.parse(url))
        ? launchUrl(Uri.parse(url))
        : launchUrlString(url);
  }
}
