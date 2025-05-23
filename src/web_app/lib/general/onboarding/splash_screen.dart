// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:milsat_project_app/extras/components/shared_prefs/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../extras/components/files.dart';

class SplashScreen extends StatefulWidget {
  static const String name = 'splash-screen';
  static const String route = '/splash-screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();

    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onboardingShown = prefs.getBool('onboardingShown') ?? false;
    bool isLoggedIn = prefs.getBool(SharedPrefKeys.isLoggedIn) ?? false;

    if (onboardingShown || isLoggedIn) {
      setState(() {
        _showOnboarding = false;
      });
    } else {
      setState(() {
        _showOnboarding = true;
        prefs.setBool('onboardingShown', true);
      });
    }
    _onboardScreen();
  }

  _onboardScreen() async {
    await Future.delayed(const Duration(milliseconds: 3000), () {});

    _showOnboarding
        ? context.go(OnboardingScreen.route)
        : context.go(LoginScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          'assets/splash_image.svg',
        ),
      ),
    );
  }
}
