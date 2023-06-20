import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/button.dart';
import '../../theme_changer.dart';
import '../login_screens/login_screen.dart';
import '../theme_floating_action_button.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final themeChanger = Provider.of<ThemeChanger>(context);

    return Consumer<ThemeChanger>(builder: (context, themeChanger, _) {
      return MaterialApp(
        title: 'Profile Screen',
        theme: themeChanger.currentTheme,
        home: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white, // First color
                Color(0xFF07abb8), // Second color
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      _currentUser?.displayName ?? 'Loading...',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        fontFamily: 'Sora',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Email:',
                      style: TextStyle(
                        // color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'Sora',
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      _currentUser?.email ?? 'Loading...',
                      style: const TextStyle(fontSize: 16.0),
                    ),

                    const SizedBox(height: 32.0),
                    firebaseUIButton(context, 'Sign Out', () {
                      User? user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        if (user.providerData.any((userInfo) => userInfo.providerId == 'password')) {
                          // User logged in using Email/Password, perform sign out
                          FirebaseAuth.instance.signOut().then((value) {
                            print('Signed Out');
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => LoginScreen(onLogin: (){},))
                            );
                          });
                        } else if (user.providerData.any((userInfo) => userInfo.providerId == 'google.com')) {
                          // User logged in using Google Sign-In, perform sign out
                          GoogleSignIn().signOut().then((value) {
                            FirebaseAuth.instance.signOut().then((value) {
                              print('Signed Out');
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => LoginScreen(onLogin: (){}))
                              );
                            });
                          });
                        }
                      }
                    }),


                    const SizedBox(height: 16.0),
                    const Text(
                      'Basic Options',
                      style: TextStyle(
                        // color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        fontFamily: 'Sora',
                      ),
                    ),


                    const SizedBox(height: 16.0),
                    ListTile(
                      leading: const Icon(
                        Icons.wallet_giftcard,
                        color: Color(0xFFfab313),
                        size: 40,
                      ),
                      title: const Text(
                        'Support Us',
                        style: TextStyle(
                          // color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Sora',
                        ),
                      ),
                      onTap: () {
                        // Handle contact mail option
                        // Implement your logic here
                      },
                    ),


                    const SizedBox(height: 16.0),
                    ListTile(
                      leading: const Icon(
                        Icons.mail,
                        color: Color(0xFFfab313),
                        size: 40,
                      ),
                      title: const Text(
                        'gogobook.it@gmail.com',
                        style: TextStyle(
                          // color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Sora',
                        ),
                      ),
                      onTap: () {
                        // Handle contact mail option
                        // Implement your logic here
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Change language',
                            style: TextStyle(
                                fontFamily: 'Sora',
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 8),
                          LanguageDropDown(),
                        ],
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16.0, 14, 16, 14),
                      child: ElevatedButton(
                        onPressed: () {
                          Provider.of<ThemeChanger>(context, listen: false).toggleTheme();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                            padding: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 14.0),
                            backgroundColor: const Color(0xFF07abb8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            )
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.light_mode, // Light mode icon
                              size: 40,
                              color: Color(0xFFfab313),
                            ),
                            const SizedBox(width: 8), // Space between icons
                            const Text(
                              'Switch Theme',
                              style: TextStyle(
                                fontFamily: "Sora",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),


                  ],
                ),

              ),
              // floatingActionButton: ThemeFloatingActionButton(),
            ),
          ),
        ),
      );
    });
  }
}


class LanguageDropDown extends StatefulWidget {
  @override
  _LanguageDropDownState createState() => _LanguageDropDownState();
}

class _LanguageDropDownState extends State<LanguageDropDown> {
  String _selectedLanguage = 'English';

  List<String> _languages = [
    'English',
    'Italian',
    // Add more languages as needed
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF07abb8)), // Customize the color here
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF07abb8)), // Customize the color here
        ),
      ),
      value: _selectedLanguage,
      onChanged: (newValue) {
        setState(() {
          _selectedLanguage = newValue!;
        });
        // Change the app's language here based on the selected language
      },
      items: _languages.map((language) {
        return DropdownMenuItem<String>(
          value: language,
          child: Text(language),
        );
      }).toList(),
    );
  }
}
