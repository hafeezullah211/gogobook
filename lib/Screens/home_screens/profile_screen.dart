import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gogobook/LanguageChnageProvider.dart';
import 'package:gogobook/LocaleString.dart';
import 'package:gogobook/Screens/login_screens/logo_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/button.dart';
import '../../theme_changer.dart';
import '../login_screens/login_screen.dart';

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

  final List locale = [
    {'name': 'English', 'locale': Locale('en_US')},
    {'name': 'Italian', 'locale': Locale('it_IT')},
  ];

  updateLanguage(Locale locale){
    Get.back();
    Get.updateLocale(locale);
  }

  builddialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text(
              'Choose a Language',
              style: TextStyle(
                fontFamily: 'Sora',
              ),
            ),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          GestureDetector(
                            onTap: (){
                              updateLanguage(locale[index]['locale']);
                            },
                              child: Text(locale[index]["name"])
                          ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.blue,
                    );
                  },
                  itemCount: locale.length),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // final themeChanger = Provider.of<ThemeChanger>(context);

    return Consumer<ThemeChanger>(
      builder: (context, themeChanger, _) => MaterialApp(
        // translations: LocaleString(),
        // locale: Locale('en_US'),
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
                      _currentUser?.displayName ?? 'loadingText...'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        fontFamily: 'Sora',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Email:'.tr,
                      style: TextStyle(
                        // color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'Sora',
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      _currentUser?.email ?? 'loadingText...'.tr,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 32.0),
                    firebaseUIButton(context, 'signOut'.tr, () {
                      User? user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        if (user.providerData.any(
                            (userInfo) => userInfo.providerId == 'password')) {
                          // User logged in using Email/Password, perform sign out
                          FirebaseAuth.instance.signOut().then((value) {
                            print('Signed Out');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LogoScreen()));
                          });
                        } else if (user.providerData.any((userInfo) =>
                            userInfo.providerId == 'google.com')) {
                          // User logged in using Google Sign-In, perform sign out
                          GoogleSignIn().signOut().then((value) {
                            FirebaseAuth.instance.signOut().then((value) {
                              print('Signed Out');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LoginScreen(onLogin: () {})));
                            });
                          });
                        }
                      }
                    }),
                    const SizedBox(height: 16.0),
                    Text(
                      'basicOptions'.tr,
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
                      title: Text(
                        'supportUs'.tr,
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
                    const SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        builddialog(context);
                      },
                      child: ListTile(
                        leading: const Icon(
                          Icons.language,
                          color: Color(0xFFfab313),
                          size: 40,
                        ),
                        title: Text(
                          'changeLanguageText'.tr,
                          style: TextStyle(
                            // color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'Sora',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16.0, 14, 16, 14),
                      child: ElevatedButton(
                        onPressed: () {
                          Provider.of<ThemeChanger>(context, listen: false)
                              .toggleTheme();
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 3,
                            padding: const EdgeInsets.fromLTRB(
                                14.0, 14.0, 14.0, 14.0),
                            backgroundColor: const Color(0xFF07abb8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            )),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.light_mode, // Light mode icon
                              size: 40,
                              color: Color(0xFFfab313),
                            ),
                            SizedBox(width: 8), // Space between icons
                            Text(
                              'switchThemeButton'.tr,
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
                    // ElevatedButton(
                    //     onPressed: () {
                    //       context.setLocale(Locale('en', 'US'));
                    //     },
                    //     child: const Text('English')),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       context.setLocale(Locale('it'));
                    //     },
                    //     child: const Text('Italian')),
                  ],
                ),
              ),
              // floatingActionButton: ThemeFloatingActionButton(),
            ),
          ),
        ),
      ),
    );
  }
}
//
// class LanguageDropDown extends StatefulWidget {
//   @override
//   _LanguageDropDownState createState() => _LanguageDropDownState();
// }
//
// class _LanguageDropDownState extends State<LanguageDropDown> {
//   String _selectedLanguage = 'English';
//
//   final List<String> _languages = [
//     'English',
//     'Italian',
//     // Add more languages as needed
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       decoration: const InputDecoration(
//         enabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Color(0xFF07abb8)),
//         ),
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Color(0xFF07abb8)),
//         ),
//       ),
//       value: _selectedLanguage,
//       onChanged: (newValue) {
//         setState(() {
//           _selectedLanguage = newValue!;
//         });
//         // Change the app's language here based on the selected language
//         _changeLanguage(context, _selectedLanguage);
//       },
//       items: _languages.map((language) {
//         return DropdownMenuItem<String>(
//           value: language,
//           child: Text(language),
//         );
//       }).toList(),
//     );
//   }
//
//   void _changeLanguage(BuildContext context, String language) {
//     final locale = Locale(_getLocaleCode(language));
//     // const AppLocalizationDelegate().load(locale); // Load the new locale
//     // You can also save the selected language to shared preferences or any other storage mechanism if needed
//   }
//
//   String _getLocaleCode(String language) {
//     // Map the language names to their respective locale codes
//     switch (language) {
//       case 'English':
//         return 'en';
//       case 'Italian':
//         return 'it';
//       // Add more cases as needed
//       default:
//         return 'en'; // Default to English
//     }
//   }
// }
