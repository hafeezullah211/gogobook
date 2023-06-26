
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gogobook/Screens/home_screens/nav_screen.dart';
import 'package:gogobook/Screens/reset_pass_screens/forgot_pass_screen.dart';
import 'package:gogobook/Screens/signUp_screen/sign_up_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Services/connectivity_service.dart';
import 'theme_changer.dart';
import 'Screens/login_screens/logo_screen.dart';
import 'Screens/login_screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  // bool isFirebaseUserLoggedIn = FirebaseAuth.instance.currentUser != null;

  checkInternetConnectivity().then((isConnected) {
    if (isConnected) {
      runApp(
        ChangeNotifierProvider<ThemeChanger>(
          create: (_) => ThemeChanger(ThemeData.light()),
          child: MyApp(
            // isLoggedIn: isLoggedIn && isFirebaseUserLoggedIn,
          ),
        ),
      );
    } else {
      runApp(InternetConnectionDialog());
    }
  });
}

class MyApp extends StatefulWidget {
  // final bool isLoggedIn;

  // MyApp({required this.isLoggedIn});


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var auth = FirebaseAuth.instance;
  var isLogin = false;

  checkIfLogin() async{
    auth.authStateChanges().listen((User? user) {
      if(user != null && mounted){
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  void initState(){
    checkIfLogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeChanger>(
      builder: (context, themeChanger, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GoGoBook',
        theme: themeChanger
            .currentTheme, // Access the theme using a method (e.g., getThemeData())
        initialRoute: FirebaseAuth.instance.currentUser == null ? '/' : 'home',
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
        home: isLogin ? HomeScreen3(onLogout: (){}) : LogoScreen(),

      ),
    );
  }
}

class InternetConnectionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AlertDialog(
            title: Text('No Internet Connection'),
            content: Text(
                'Please turn on your internet connection to use this app.'),
            actions: [
              TextButton(
                onPressed: () {
                  // Perform action to redirect user to device settings to enable internet
                },
                child: Text('Open Settings'),
              ),
              TextButton(
                onPressed: () {
                  // Perform action to exit the app or show alternative content
                },
                child: Text('Exit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
