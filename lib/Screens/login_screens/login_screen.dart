import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gogobook/Screens/home_screens/nav_screen.dart';
import 'package:gogobook/Screens/signUp_screen/sign_up_screen.dart';
import 'package:gogobook/common_widgets/button.dart';
import 'package:gogobook/common_widgets/text_form_field.dart';


class LoginScreen extends StatefulWidget {
  final Function onLogin; // Add this line
  LoginScreen({required this.onLogin}); // Add this constructor

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController textEditingController1 = TextEditingController();

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 20.0),
            filled: true,
            fillColor: Color(0xFFEAF4F4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(),
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
          )

      ),
      home: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/sfondo.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.black12,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          fontFamily: 'Sora',
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Card(
                      color: Color.fromRGBO(49, 51, 51, 0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            SizedBox(height: 16,),
                            Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(16.0, 14, 16, 14),
                                child: reusableTextField(
                                    'Email', Icons.email, false, _emailTextController
                                )
                            ),

                            SizedBox(height: 16,),
                            Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(16.0, 14, 16, 14),
                                child: reusableTextField(
                                    "Password", Icons.password, true, _passwordTextController
                                )
                            ),


                            SizedBox(height: 32.0),
                            firebaseUIButton(context, 'Login', () async {
                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: _emailTextController.text,
                                  password: _passwordTextController.text,
                                );
                                Navigator.push(context,
                                MaterialPageRoute(builder: (context) => HomeScreen3(onLogout: (){},))
                                );
                              } catch (error) {
                                // String errorMessage = 'An error occurred.';
                                Fluttertoast.showToast(
                                  msg: 'An error occurred.',
                                  gravity: ToastGravity.BOTTOM,
                                  toastLength: Toast.LENGTH_SHORT,
                                );

                                if (error is FirebaseAuthException) {
                                  if (error.code == 'user-not-found') {
                                    // errorMessage = 'User not found. Please create an account.';
                                    Fluttertoast.showToast(
                                      msg: 'User not found. Please create an account.',
                                      gravity: ToastGravity.BOTTOM,
                                      toastLength: Toast.LENGTH_SHORT,
                                    );
                                    // showSnackbar(context, 'User not found. Please create your account.');
                                  } else if (error.code == 'wrong-password') {
                                    // errorMessage = 'Incorrect email or password.';
                                    Fluttertoast.showToast(
                                      msg: 'Incorrect email or password.',
                                      gravity: ToastGravity.BOTTOM,
                                      toastLength: Toast.LENGTH_SHORT,
                                    );
                                    // showSnackbar(context, 'Incorrect email or password.');
                                  }
                                }
                                // Fluttertoast.showToast(
                                //   msg: errorMessage,
                                //   gravity: ToastGravity.BOTTOM,
                                //   toastLength: Toast.LENGTH_SHORT,
                                // );
                              }
                            }),

                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              // padding: EdgeInsets.fromLTRB(0, 0, 0, 14),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/forgot_password');
                                },
                                child: Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'Sora'
                                  ),
                                ),
                              ),
                            ),


                            SizedBox(height: 32.0),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Dont\'t have an accout? ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Sora',
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => SignUpScreen())
                                      );
                                    },
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        color: Color(0xFF07abb8),
                                        fontFamily: 'Sora',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16,)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShowSnackbar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

