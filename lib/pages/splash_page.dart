import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () async {
      await requestNotificationPermissions(context: context, isFirstTime: true);
      var sharedPrefs = await SharedPreferences.getInstance();
      sharedPrefs.setBool("isAppNotJustInstalled", true);
      Navigator.pushReplacementNamed(context, 'home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xff333333), Color(0xffdd1818)]),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                '',
              ),
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 70.0,
                  fontFamily: 'Canterbury',
                ),
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    RotateAnimatedText('Welcome'),
                    RotateAnimatedText('CR'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> requestNotificationPermissions(
    {required BuildContext context, required bool isFirstTime}) async {
  final PermissionStatus nStatus = await Permission.notification.request();
  if (nStatus.isGranted) {
    // Notification permissions granted
  } else if (nStatus.isDenied) {
    // Notification permissions denied
    // await openAppSettings();
    isFirstTime
        ? showNotificationSnackBar(context: context)
        : await openAppSettings();
  } else if (nStatus.isPermanentlyDenied) {
    // Notification permissions permanently denied, open app settings
    // await openAppSettings();
    isFirstTime
        ? showNotificationSnackBar(context: context)
        : await openAppSettings();
  }


}

void showNotificationSnackBar({required BuildContext context}) {
  SnackBar snackBar = SnackBar(
    content: const Text(
        "Allow notifications to receive Tasks' and Messages' notifications."),
    duration: const Duration(seconds: 5),
    margin: const EdgeInsets.all(30),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    action: SnackBarAction(
      label: "Ask Again",
      onPressed: () async {
        requestNotificationPermissions(context: context, isFirstTime: false);
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
