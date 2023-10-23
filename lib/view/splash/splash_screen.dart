import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import '../../resources/resources.dart';
import '../../routes/routes_name.dart';
import '../../services/services.dart';

// Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final userPreferences = UserPreferences();

  @override
  void initState() {
    super.initState();
    userPreferences.getUserInfo();
    navigation();
  }

  void navigation() {
    Duration duration = const Duration(seconds: 3);
    Future.delayed(
      duration,
          () {
        if (UserPreferences.loggedIn==true) {
          // its yes move to dashboard screen
          log(UserPreferences.userId.toString());
          context.go(RoutesName.dashboardScreen);
        } else {
          // its no move to login screen
          context.go(RoutesName.loginScreen);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(AnimationAssets.splashAnimation),
                Text(
                  StringManager.myApp,
                  style: TextStyle(
                    fontSize: 55.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "DancingScript",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
