import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class NotificationUtil {
  static Future<void> showNotificationSnackBar({
    required BuildContext context,
    required String content,
    required bool isSuccess,
  }) async {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.ease,
      forwardAnimationCurve: Curves.ease,
      animationDuration: const Duration(milliseconds: 500),
      isDismissible: true,
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.transparent,
      titleText: Container(),
      messageText: Container(
        padding: const EdgeInsets.all(6),
        margin: const EdgeInsets.symmetric(horizontal: 26),
        decoration: BoxDecoration(
          color: isSuccess == true ? Colors.orangeAccent : Colors.red,
          borderRadius: BorderRadius.circular(60),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 10,
          ),
        ),
      ),
    ).show(context);
  }
}
