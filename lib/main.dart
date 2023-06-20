import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gogobook/Screens/home_screens/nav_screen.dart';
import 'package:gogobook/Screens/reset_pass_screens/enter_code_screen.dart';
import 'package:gogobook/Screens/reset_pass_screens/forgot_pass_screen.dart';
import 'package:gogobook/Screens/reset_pass_screens/set_pass_screen.dart';
import 'package:gogobook/Screens/signUp_screen/sign_up_screen.dart';
// import 'package:untitled/Screens/home_screens/nav_screen.dart';
// import 'package:untitled/Screens/home_screens/home_page_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Services/connectivity_service.dart';
import 'theme_changer.dart';
import 'Screens/genre_screen.dart';
import 'Screens/login_screens/logo_screen.dart';
import 'Screens/login_screens/login_screen.dart';
// import 'Screens/login_screens/password_screen.dart';
import 'Screens/terms_screen.dart';
import 'Screens/privacy_screen.dart';
// import 'Screens/theme_floating_action_button.dart ';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  checkInternetConnectivity().then((isConnected) {
    if (isConnected) {
      runApp(ChangeNotifierProvider<ThemeChanger>(
        create: (_) => ThemeChanger(ThemeData.light()),
        child: MyApp(isLoggedIn: isLoggedIn),
      ));
    } else {
      runApp(InternetConnectionDialog());
    }
  });
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _doubleBackToExitPressedOnce = false;

  void handleSuccessfulLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    Navigator.pushReplacementNamed(context, '/home');
  }

  void handleLogout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeChanger>(
      builder: (context, themeChanger, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GoGoBook',
        theme: themeChanger
            .currentTheme, // Access the theme using a method (e.g., getThemeData())
        initialRoute: widget.isLoggedIn ? '/home' : '/',
        routes: {
          '/': (context) => LogoScreen(),
          '/login': (context) => LoginScreen(
                onLogin: () => handleSuccessfulLogin(context),
              ),
          '/home': (context) => HomeScreen3(
                onLogout: () => handleLogout(context),
              ),
          '/forgot_password': (context) => ForgotPasswordScreen(),
          '/signup': (context) => SignUpScreen(),
        },
      ),
    );
  }

  // Handle back button navigation and exit behavior

  Future<bool> onWillPop(BuildContext context) async {
    if (_doubleBackToExitPressedOnce) {
      // If the back button is pressed again, close the app
      return true;
    }

    _doubleBackToExitPressedOnce = true;
    // Show a toast or snackbar message to inform the user to press back again to exit
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Press back again to exit'),
        duration: Duration(seconds: 2),
      ),
    );

    // Reset the flag variable after a certain duration
    await Future.delayed(Duration(seconds: 2));
    _doubleBackToExitPressedOnce = false;

    // Return false to prevent the default back button behavior
    return false;
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