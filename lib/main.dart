import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gogobook/LocaleString.dart';
import 'package:gogobook/Screens/home_screens/nav_screen.dart';
import 'package:gogobook/Screens/reset_pass_screens/forgot_pass_screen.dart';
import 'package:gogobook/Screens/signUp_screen/sign_up_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_changer.dart';
import 'Screens/login_screens/logo_screen.dart';
import 'Screens/login_screens/login_screen.dart';
import 'package:get/get.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  // bool isFirebaseUserLoggedIn = FirebaseAuth.instance.currentUser != null;

  runApp(
    ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(ThemeData.light()),
      child: const MyApp(
          // isLoggedIn: isLoggedIn && isFirebaseUserLoggedIn,
          ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // final bool isLoggedIn;

  // MyApp({required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var auth = FirebaseAuth.instance;
  var isLogin = false;
  late ConnectivityResult result;
  late StreamSubscription subscription;
  var isConnected = false;

  @override
  void initState() {
    super.initState();
    startStreaming();
    checkIfLogin();
  }

  checkInternet() async {
    result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      isConnected = true;
    } else {
      showDialogueBox();
    }
    setState(() {});
  }

  showDialogueBox() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text('No Internet'),
              content: const Text('Please Check Your Internet Connection.'),
              actions: [
                CupertinoButton.filled(
                    child: const Text('Retry'),
                    onPressed: () {
                      Navigator.pop(context);
                      checkInternet();
                    })
              ],
            ));
  }

  startStreaming() {
    subscription = Connectivity().onConnectivityChanged.listen((event) async {
      checkInternet();
    });
  }

  checkIfLogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeChanger>(
      builder: (context, themeChanger, _) => GetMaterialApp(
        translations: LocaleString(),
        locale: Locale('en_US'),
        debugShowCheckedModeBanner: false,
        title: 'GoGoBook',
        theme: themeChanger
            .currentTheme,
        initialRoute: FirebaseAuth.instance.currentUser == null ? '/' : '/home',
        routes: {
          '/login': (context) => LoginScreen(
                onLogin: () {},
              ),
          '/home': (context) => HomeScreen3(
                onLogout: () {},
              ),
          '/forgot_password': (context) => ForgotPasswordScreen(),
          '/signup': (context) => SignUpScreen(),
        },
        home: isLogin ? HomeScreen3(onLogout: () {}) : LogoScreen(),
      ),
    );
  }
}