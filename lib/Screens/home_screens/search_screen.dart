import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gogobook/LanguageChnageProvider.dart';
import 'package:gogobook/Screens/home_screens/home_page_screen.dart';
import 'package:gogobook/Screens/home_screens/tile_preview.dart';
import 'package:gogobook/Services/firestore_service.dart';
import 'package:gogobook/Services/google_api_service.dart';
import 'package:gogobook/common_widgets/button.dart';
import 'package:gogobook/theme_changer.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../generated/l10n.dart';
import '../../models/books.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'barcodeScannerPage.dart';

enum BookDisplayStyle {
  Tile,
  Card,
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  BookDisplayStyle _bookDisplayStyle = BookDisplayStyle.Tile;
  final FirestoreService firestoreService = FirestoreService();
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  late TextEditingController _searchController;
  List<Book> _books = [];
  List<String> _searchHistory = [];
  bool _isLoading = false;
  bool _showSearchHistory = false;
  String _barcodeResult = '';
  TextEditingController _searchBarController = TextEditingController();
  late CameraController _cameraController;
  late Future<void> _cameraInitializer;

  void _selectBookDisplayStyle(BookDisplayStyle? style) {
    if (style != null) {
      setState(() {
        _bookDisplayStyle = style;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadSearchHistory();
    _cameraInitializer = _initializeCamera();
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
    );
    await _cameraController.initialize();
  }

  Future<void> _scanBarcode() async {
    try {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        await _cameraInitializer;

        final result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Select Camera',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Sora',
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(
                      'Back Camera',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        fontFamily: 'Sora',
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop(CameraLensDirection.back);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Front Camera',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        fontFamily: 'Sora',
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop(CameraLensDirection.front);
                    },
                  ),
                ],
              ),
            );
          },
        );

        if (result != null) {
          final barcodeResult = await FlutterBarcodeScanner.scanBarcode(
            '#ff6666',
            'Cancel',
            true,
            ScanMode.DEFAULT,
          );

          if (!mounted) return;

          setState(() {
            _barcodeResult = barcodeResult;
          });

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Barcode Result',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Sora',
                  ),
                ),
                content: Text(_barcodeResult),
                actions: [
                  TextButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _barcodeResult));
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Copy',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'Sora',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Exit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'Sora',
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Handle camera permission not granted
        print('Camera permission not granted');
      }
    } on PlatformException catch (e) {
      // Handle platform exceptions
      print('Platform Exception: ${e.message}');
    } catch (e) {
      // Handle other exceptions
      print('Exception: $e');
    }
  }

  Future<void> _loadSearchHistory() async {
    List<String> searchHistory = await SearchHistory.loadSearchHistory();
    setState(() {
      _searchHistory = searchHistory;
    });
  }

  Future<void> _saveSearchHistory() async {
    await SearchHistory.saveSearchHistory(_searchHistory);
  }

  void _searchBooks(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await searchBooks(query);
      setState(() {
        _books = response.books.cast<Book>();
        _isLoading = false;
      });
      if (_books.isNotEmpty) {
        final random = Random();
        final randomIndex = random.nextInt(_books.length);
        final randomBook = _books[randomIndex];

        // Save the randomly selected book to Firestore
        final userRef = FirebaseFirestore.instance
            .collection('RecommendedBooks')
            .doc(userId);
        final recommendedBooks = await userRef.get();
        final existingBooks = recommendedBooks.exists
            ? (recommendedBooks.data() as Map<String, dynamic>)['books']
                as List<dynamic>
            : [];

        // Check if the book is already in the user's recommended books
        final bookExists =
            existingBooks.any((book) => book['bookId'] == randomBook.id);
        if (!bookExists) {
          existingBooks.add({
            'bookId': randomBook.id,
            'title': randomBook.title,
            'author': randomBook.authors,
            'isbn': randomBook.isbn,
            'description': randomBook.description,
            'language': randomBook.language,
            'publishedDate': randomBook.publishedDate,
            'publisher': randomBook.publisher,
            'imageUrl': randomBook.imageUrl,
            'averageRating': randomBook.averageRating,
            'ratingsCount': randomBook.ratingsCount,
            'numberOfPages': randomBook.pageCount
          });

          // Update the recommended books collection in Firestore
          await userRef.set({'books': existingBooks});
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _books = [];
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Sora',
              fontSize: 18,
            ),
          ),
          content: const Text(
            'This book is currently unavailable. Try to search any other book!',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontFamily: 'Sora',
              fontSize: 14,
            ),
          ),
          actions: [
            firebaseUIButton(context, 'OK', () {
              Navigator.of(context).pop();
            })
          ],
        ),
      );
    }
  }

  Future<Book?> getRandomRecommendedBook() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final recommendedBooksSnapshot = await FirebaseFirestore.instance
          .collection('RecommendedBooks')
          .doc(userId)
          .get();

      if (recommendedBooksSnapshot.exists) {
        final recommendedBooksData = recommendedBooksSnapshot.data();
        final books = (recommendedBooksData!['books'] as List<dynamic>)
            .map((bookData) => Book(
                  id: bookData['bookId'],
                  imageUrl: bookData['imageUrl'],
                  title: bookData['title'],
                  authors: List<String>.from(bookData['author']),
                  description: bookData['description'],
                  publisher: bookData['publisher'],
                  publishedDate: bookData['publishedDate'].toDate(),
                  pageCount: bookData['number of pages'],
                  language: bookData['language'],
                  isbn: bookData['isbn'],
                  averageRating: bookData['average rating'],
                  ratingsCount: bookData['Ratings Count'],
                ))
            .toList();

        if (books.isNotEmpty) {
          final random = Random();
          final randomIndex = random.nextInt(books.length);
          final randomBook = books[randomIndex];
          return randomBook;
        }
      }
    }

    // Return null when there are no recommended books
    return null;
  }

  void _submitSearch(String query) async {
    if (userId != null) {
      await SearchHistory.addSearchQuery(query);
    }

    _searchController.clear();
    _searchBooks(query);

    setState(() {
      _showSearchHistory = false;
    });

    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _deleteSearchHistory(int index) async {
    String query = _searchHistory[index];
    await SearchHistory.removeSearchQuery(query);

    setState(() {
      _searchHistory.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeChanger>(
      builder: (context, themeChanger, _) => MaterialApp(
        title: 'Search Screen',
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
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Search',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 32,
                                fontFamily: 'Sora',
                              ),
                            ),
                            IconButton(
                                onPressed: _scanBarcode,
                                icon: Icon(
                                    Icons.qr_code_scanner,
                                  size: 32,
                                ),
                            )
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(22.0),
                                labelText: 'Name/Title, Author',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'Sora',
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .black, // Change border color when not focused
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Color(
                                        0xFFCDE7BE), // Change border color when focused
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _showSearchHistory =
                                      true; // Show the search history
                                });
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 63.0,
                              child: TextButton(
                                onPressed: () {
                                  _submitSearch(_searchController.text);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xFF07abb8)),
                                  side: MaterialStateProperty.all<BorderSide>(
                                    const BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Search',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Sora',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // if (_searchController.text.isNotEmpty)
                    Visibility(
                      visible: _showSearchHistory,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchHistory.length,
                        itemBuilder: (context, index) {
                          final item = _searchHistory[index];
                          return ListTile(
                            title: Text(item),
                            trailing: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _deleteSearchHistory(index);
                              },
                            ),
                            onTap: () {
                              _searchController.text =
                                  item; // Paste the text in the search field
                              _submitSearch(item); // Trigger the search
                              // Remove the selected book from the search history list
                              setState(() {
                                _searchHistory.removeAt(index);
                              });
                              _saveSearchHistory();
                            },
                          );
                        },
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                'Filter Options',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Sora',
                                  fontSize: 18,
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: const Text(
                                      'Tile Preview',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Sora',
                                      ),
                                    ),
                                    leading: Radio<BookDisplayStyle>(
                                      value: BookDisplayStyle.Tile,
                                      groupValue: _bookDisplayStyle,
                                      onChanged: (BookDisplayStyle? newValue) {
                                        setState(() {
                                          _bookDisplayStyle = newValue!;
                                        });
                                        Navigator.pop(
                                            context); // Dismiss the pop-up after selection
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text(
                                      'Card Preview',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Sora',
                                      ),
                                    ),
                                    leading: Radio<BookDisplayStyle>(
                                      value: BookDisplayStyle.Card,
                                      groupValue: _bookDisplayStyle,
                                      onChanged: (BookDisplayStyle? newValue) {
                                        setState(() {
                                          _bookDisplayStyle = newValue!;
                                        });
                                        Navigator.pop(
                                            context); // Dismiss the pop-up after selection
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Filter',
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),

                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else if (_bookDisplayStyle == BookDisplayStyle.Tile)
                      ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {
                            PointerDeviceKind.mouse,
                            PointerDeviceKind.touch,
                          },
                        ),
                        child: Scrollbar(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _books.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 4,
                            ),
                            itemBuilder: (context, index) {
                              final book = _books[index];

                              return TilePreview(
                                book: book,
                                showBookmarkIcon: true,
                              );
                            },
                          ),
                        ),
                      )
                    else if (_bookDisplayStyle == BookDisplayStyle.Card)
                      Scrollbar(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: (_books.length / 2).ceil(),
                          itemBuilder: (context, index) {
                            final int leftCardIndex = index * 2;
                            final int rightCardIndex = leftCardIndex + 1;

                            return Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: BookCard(
                                      book: _books[leftCardIndex],
                                      showBookmarkIcon: true,
                                    ),
                                  ),
                                ),
                                if (rightCardIndex < _books.length)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: BookCard(
                                        book: _books[rightCardIndex],
                                        showBookmarkIcon: true,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16.0, 14, 16, 14),
                      child: ElevatedButton(
                        child: const Text(
                          'Recommend me a Book',
                          style: TextStyle(
                            fontFamily: "Sora",
                            color: Color(0xFF07abb8),
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        onPressed: () async {
                          final recommendedBook =
                              await getRandomRecommendedBook();
                          if (recommendedBook != null) {
                            showDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    BookCard(book: recommendedBook),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    firebaseUIButton(context, 'ok', () {
                                      Navigator.of(context).pop();
                                    }),
                                  ],
                                ),
                                width:
                                    250, // Set the desired width of the dialog
                                height:
                                    470, // Set the desired height of the dialog
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('No Recommended Books'),
                                content: Text(
                                  'You have to search for some books in the search bar to let me recommend you a book.',
                                  style: TextStyle(
                                    fontFamily: "Sora",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                                actions: [
                                  firebaseUIButton(context, 'ok', () {
                                    Navigator.of(context).pop();
                                  }),
                                ],
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding:
                              const EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 20.0),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // floatingActionButton: ThemeFloatingActionButton(),
          ),
        ),
      ),
    );
  }
}

class CustomDialog extends Dialog {
  final Widget child;
  final double width;
  final double height;

  CustomDialog(
      {required this.child, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}

class SearchHistory {
  static const String _searchHistoryKey = 'searchHistory';

  static Future<List<String>> loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_searchHistoryKey) ?? [];
  }

  static Future<void> saveSearchHistory(List<String> searchHistory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_searchHistoryKey, searchHistory);
  }

  static Future<void> addSearchQuery(String query) async {
    List<String> searchHistory = await loadSearchHistory();
    searchHistory.remove(query); // Remove duplicate entry
    searchHistory.insert(0, query); // Add query at the beginning
    await saveSearchHistory(searchHistory);
  }

  static Future<void> removeSearchQuery(String query) async {
    List<String> searchHistory = await loadSearchHistory();
    searchHistory.remove(query);
    await saveSearchHistory(searchHistory);
  }

  static Future<void> clearSearchHistory() async {
    await saveSearchHistory([]);
  }
}

// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   final FirestoreService firestoreService = FirestoreService();
//   final String? userId = FirebaseAuth.instance.currentUser?.uid;
//   late TextEditingController _searchController;
//   List<Book> _books = [];
//   List<String> _searchHistory = [];
//   bool _isLoading = false;
//   bool _showSearchHistory = false;
//   List<String> _searchSuggestions = [];
//
//
//   @override
//   void initState() {
//     super.initState();
//     _searchController = TextEditingController();
//     _loadSearchHistory();
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadSearchHistory() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _searchHistory = prefs.getStringList('searchHistory') ?? [];
//     });
//   }
//
//   Future<void> _saveSearchHistory() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList('searchHistory', _searchHistory);
//   }
//
//   void _searchBooks(String query) async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       final response = await searchBooks(query);
//       setState(() {
//         _books = response.books.cast<Book>();
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _books = [];
//       });
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Error'),
//           content: const Text('An error occurred while searching for books.'),
//           actions: [
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   void _submitSearch(String query) async {
//     if (_searchHistory.contains(query)) {
//       return;
//     }
//     _searchController.clear(); // Clear the search text field
//     _searchBooks(query);
//     if (userId != null) {
//       setState(() {
//         _searchHistory.add(query);
//       });
//       await _saveSearchHistory();
//     }
//     setState(() {
//       _showSearchHistory = false; // Hide the search history
//     });
//     // Hide the search history list by removing the focus from the search field
//     FocusScope.of(context).requestFocus(FocusNode());
//   }
//
//   void _deleteSearchHistory(int index) async {
//     setState(() {
//       _searchHistory.removeAt(index);
//     });
//     await _saveSearchHistory();
//   }
//
//   void _fetchSearchSuggestions(String value) async {
//     // You can replace this URL with your own API endpoint that provides search suggestions
//     final url = 'https://api.example.com/search/suggestions?query=$value';
//
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final suggestions = json.decode(response.body) as List<dynamic>;
//         setState(() {
//           _searchSuggestions = suggestions.cast<String>();
//         });
//       } else {
//         throw Exception('Failed to fetch search suggestions');
//       }
//     } catch (e) {
//       print('Error: $e');
//       // Handle the error accordingly (e.g., show an error message)
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeChanger>(builder: (context, themeChanger, _) {
//       return MaterialApp(
//         title: 'Search Screen',
//         theme: themeChanger.currentTheme,
//         home: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.white, // First color
//                   Color(0xFF07abb8), // Second color
//                 ],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//             child: Scaffold(
//               body: SafeArea(
//                   child: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
//                       child: Column(
//                         children: [
//                         const SizedBox(
//                         height: 16,
//                       ),
//                       const Align(
//                         alignment: Alignment.center,
//                         child: Padding(
//                           padding: EdgeInsets.all(16.0),
//                           child: Text(
//                             'Search',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w800,
//                               fontSize: 32,
//                               fontFamily: 'Sora',
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: TextField(
//                           controller: _searchController,
//                           style: const TextStyle(
//                             color: Colors.black,
//                           ),
//                           decoration: InputDecoration(
//                             labelText: 'Name, Author',
//                             floatingLabelBehavior: FloatingLabelBehavior.never,
//                             labelStyle: const TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                               fontFamily: 'Sora',
//                             ),
//                             suffixIcon: IconButton(
//                               icon: const Icon(
//                                 Icons.search,
//                                 color: Colors.black,
//                               ),
//                               onPressed: () {
//                                 _submitSearch(_searchController.text);
//                               },
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                               borderSide: const BorderSide(
//                                 color: Colors
//                                     .black, // Change border color when not focused
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                               borderSide: const BorderSide(
//                                 color: Color(
//                                     0xFFCDE7BE), // Change border color when focused
//                               ),
//                             ),
//                           ),
//                           onChanged: (value) {
//                             setState(() {
//                               _showSearchHistory = true; // Show the search history
//                             });
//                             _fetchSearchSuggestions(value); // Fetch search suggestions based on the entered value
//                           },
//                         ),
//                       ),
//                       Visibility(
//                         visible: _showSearchHistory,
//                         child: Column(
//                           children: [
//                             if (_searchHistory.isNotEmpty)
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   'Recent Searches',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ListView.builder(
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemCount: _searchHistory.length,
//                               itemBuilder: (context, index) {
//                                 final item = _searchHistory[index];
//                                 return ListTile(
//                                   title: Text(item),
//                                   trailing: IconButton(
//                                     icon: const Icon(Icons.close),
//                                     onPressed: () {
//                                       _deleteSearchHistory(index);
//                                     },
//                                   ),
//                                   onTap: () {
//                                     _searchController.text =
//                                         item; // Paste the text in the search field
//                                     _submitSearch(item); // Trigger the search
//                                   },
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       if (_searchSuggestions.isNotEmpty)
//                   Column(
//               children: [
//               Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Search Suggestions',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: _searchSuggestions.length,
//             itemBuilder: (context, index) {
//               final suggestion = _searchSuggestions[index];
//               return ListTile(
//                 title: Text(suggestion),
//                 onTap: () {
//                   _searchController.text = suggestion;
//                   _submitSearch(suggestion);
//                 },
//               );
//             },
//           ),
//           ],
//         ),
//
//
//                       if (_isLoading)
//                         const Center(
//                           child: CircularProgressIndicator(),
//                         )
//             else if (_books.isNotEmpty)
//         Column(
//       children: [
//       ListView.builder(
//       shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: (_books.length / 2).ceil(),
//         itemBuilder: (context, index) {
//           final int leftCardIndex = index * 2;
//           final int rightCardIndex = leftCardIndex + 1;
//
//           return Row(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: BookCard(
//                     book: _books[leftCardIndex],
//                     showBookmarkIcon: true,
//                   ),
//                 ),
//               ),
//               if (rightCardIndex < _books.length)
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: BookCard(
//                       book: _books[rightCardIndex],
//                       showBookmarkIcon: true,
//                     ),
//                   ),
//                 ),
//             ],);
//         },
//       ),
//       ],),
//       if (!_isLoading && _searchController.text.isNotEmpty)
//       return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text(
//       'No books found.',
//       style: TextStyle(
//       fontSize: 18,
//       fontWeight: FontWeight.bold,
//       ),
//       ),
//       );
//
//       ],),
//       ),
//       ),
//       ),
//       ),
//       );
//     });
//   }
// }
//

// class BookDetailsScreen extends StatefulWidget {
//   final Book book;
//
//   const BookDetailsScreen({Key? key, required this.book}) : super(key: key);
//
//   @override
//   State<BookDetailsScreen> createState() => _BookDetailsScreenState();
// }
//
// class _BookDetailsScreenState extends State<BookDetailsScreen> {
//   bool isBookmarked = false;
//   bool isWishlisted = false;
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   void addToBooksAlreadyRead() {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId != null) {
//       final bookData = {
//         'imageUrl': widget.book.imageUrl,
//         'id': widget.book.id,
//         'title': widget.book.title,
//         'authors': widget.book.authors,
//         'description': widget.book.description,
//         'publisher': widget.book.publisher,
//         'publishDate': widget.book.publishedDate,
//         'pagesCount': widget.book.pageCount,
//         'language': widget.book.language,
//         'isbn': widget.book.isbn,
//         'averageRating': widget.book.averageRating,
//         'ratingsCount': widget.book.ratingsCount,
//
//         // Add other book details as desired
//       };
//
//       if (isWishlisted) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text(
//                 'Cannot Add to Books Already Read',
//                 style: TextStyle(
//                   fontFamily: 'Sora',
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               content: const Text(
//                 'Sorry! Please remove this book from the Wishlist category to add it to the Books Already Read category.',
//                 style: TextStyle(
//                   fontFamily: 'Sora',
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                 ),
//               ),
//               actions: [
//                 // ElevatedButton(
//                 //   onPressed: () {
//                 //     Navigator.of(context).pop();
//                 //   },
//                 //   child: const Text('OK'),
//                 // ),
//                 firebaseUIButton(context, 'OK', () {
//                   Navigator.of(context).pop();
//                 })
//               ],
//             );
//           },
//         );
//       } else {
//         FirebaseFirestore.instance
//             .collection('BooksAlreadyRead')
//             .doc(userId)
//             .collection('books')
//             .doc(widget.book.id)
//             .set(bookData)
//             .then((value) {
//           setState(() {
//             isBookmarked = true;
//           });
//         }).catchError((error) {
//           // Handle the error
//         });
//       }
//     }
//   }
//
//   void removeFromBooksAlreadyRead() {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId != null) {
//       FirebaseFirestore.instance
//           .collection('BooksAlreadyRead')
//           .doc(userId)
//           .collection('books')
//           .doc(widget.book.id)
//           .delete()
//           .then((value) {
//         setState(() {
//           isBookmarked = false;
//         });
//       }).catchError((error) {
//         // Handle the error
//       });
//     }
//   }
//
//   void addToWishlist() {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId != null) {
//       print(userId);
//       final bookData = {
//         'imageUrl': widget.book.imageUrl,
//         'id': widget.book.id,
//         'title': widget.book.title,
//         'authors': widget.book.authors,
//         'description': widget.book.description,
//         'publisher': widget.book.publisher,
//         'publishDate': widget.book.publishedDate,
//         'pagesCount': widget.book.pageCount,
//         'language': widget.book.language,
//         'isbn': widget.book.isbn,
//         'averageRating': widget.book.averageRating,
//         'ratingsCount': widget.book.ratingsCount,
//         // Add other book details as desired
//       };
//
//       if (isBookmarked) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text(
//                 'Cannot Add to Books Already Read',
//                 style: TextStyle(
//                   fontFamily: 'Sora',
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               content: const Text(
//                 'Sorry! Please remove this book from the Books Already Read category to add it to the Wishlist category.',
//                 style: TextStyle(
//                   fontFamily: 'Sora',
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                 ),
//               ),
//               actions: [
//                 // ElevatedButton(
//                 //   onPressed: () {
//                 //     Navigator.of(context).pop();
//                 //   },
//                 //   child: const Text('OK'),
//                 // ),
//                 firebaseUIButton(context, 'OK', () {
//                   Navigator.of(context).pop();
//                 })
//               ],
//             );
//           },
//         );
//       } else {
//         FirebaseFirestore.instance
//             .collection('Wishlist')
//             .doc(userId)
//             .collection('books')
//             .doc(widget.book.id)
//             .set(bookData)
//             .then((value) {
//           setState(() {
//             isWishlisted = true;
//           });
//         }).catchError((error) {
//           // Handle the error
//         });
//       }
//     }
//   }
//
//   void removeFromWishlist() {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId != null) {
//       FirebaseFirestore.instance
//           .collection('Wishlist')
//           .doc(userId)
//           .collection('books')
//           .doc(widget.book.id)
//           .delete()
//           .then((value) {
//         setState(() {
//           isWishlisted = false;
//         });
//       }).catchError((error) {
//         // Handle the error
//       });
//     }
//   }
//
//   void _showPaymentOptionsDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Select Payment Option'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (BuildContext context) => UsePaypal(
//                           sandboxMode: true,
//                           clientId:
//                               "AeLZvoYK_m8VNfaW7m7bphMzz1oI1IZnU3Y3FFVGEZET04D4rE5HR9CIu4tM3KUwqhjEcKquIW0QiGGc",
//                           secretKey:
//                               "EOwv9Uj3R9hyATGl_IrFkCN2G-4XhEyIZ0XbvuiSH7trOy-RbaJI2-weBAxwKsKyvP2EPbbiSOGZIsMN",
//                           returnURL: "https://samplesite.com/return",
//                           cancelURL: "https://samplesite.com/cancel",
//                           transactions: const [
//                             {
//                               "amount": {
//                                 "total": '10.12',
//                                 "currency": "USD",
//                                 "details": {
//                                   "subtotal": '10.12',
//                                   "shipping": '0',
//                                   "shipping_discount": 0
//                                 }
//                               },
//                               "description":
//                                   "The payment transaction description.",
//                               // "payment_options": {
//                               //   "allowed_payment_method":
//                               //       "INSTANT_FUNDING_SOURCE"
//                               // },
//                               "item_list": {
//                                 "items": [
//                                   {
//                                     "name": "A demo product",
//                                     "quantity": 1,
//                                     "price": '10.12',
//                                     "currency": "USD"
//                                   }
//                                 ],
//
//                                 // shipping address is not required though
//                                 // "shipping_address": {
//                                 //   "recipient_name": "Jane Foster",
//                                 //   "line1": "Travis County",
//                                 //   "line2": "",
//                                 //   "city": "Austin",
//                                 //   "country_code": "US",
//                                 //   "postal_code": "73301",
//                                 //   "phone": "+00000000",
//                                 //   "state": "Texas"
//                                 // },
//                               }
//                             }
//                           ],
//                           note: "Contact us for any questions on your order.",
//                           onSuccess: (Map params) async {
//                             print("onSuccess: $params");
//                           },
//                           onError: (error) {
//                             print("onError: $error");
//                           },
//                           onCancel: (params) {
//                             print('cancelled: $params');
//                           }),
//                     ),
//                   );
//                 },
//                 child: const Text('PayPal'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   // _initiateGooglePayPayment();
//                 },
//                 child: const Text('Google Pay'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // void _initiatePayPalPayment() async {
//   //   final clientId = 'YOUR_PAYPAL_CLIENT_ID'; // Replace with your PayPal Client ID
//   //
//   //   final PayPalResult result = await FlutterPaypal.start(
//   //     clientId: clientId,
//   //     currencyCode: 'USD', // Replace with the appropriate currency code
//   //     amount: '10.00', // Replace with the actual book price
//   //     itemName: 'Book Purchase', // Replace with the actual book name
//   //     cancelUrl: 'YOUR_CANCEL_URL', // Replace with your cancel URL
//   //     returnUrl: 'YOUR_RETURN_URL', // Replace with your return URL
//   //   );
//   //
//   //   if (result.status == PayPalStatus.success) {
//   //     // Payment successful
//   //     // Perform necessary actions
//   //   } else if (result.status == PayPalStatus.cancel) {
//   //     // Payment cancelled by the user
//   //     // Perform necessary actions
//   //   } else {
//   //     // Payment failed
//   //     // Perform necessary actions
//   //   }
//   // }
//
//   // void _initiateGooglePayPayment() async {
//   //   final GooglePayPaymentItem paymentItem = GooglePayPaymentItem(
//   //     name: 'Book Purchase',
//   //     price: '10.00',
//   //     type: GooglePayItemType.price,
//   //   );
//   //
//   //   final GooglePayTokenizationParameters tokenizationParameters =
//   //   GooglePayTokenizationParameters(
//   //     tokenizationType: GooglePayTokenizationType.network,
//   //     parameters: {
//   //       'publicKey': 'YOUR_PUBLIC_KEY',
//   //     },
//   //   );
//   //
//   //   final GooglePayPaymentDataRequest paymentDataRequest =
//   //   GooglePayPaymentDataRequest(
//   //     merchantName: 'Your Merchant Name',
//   //     totalPrice: '10.00',
//   //     currencyCode: 'USD',
//   //     paymentItems: [paymentItem],
//   //     tokenizationParameters: tokenizationParameters,
//   //   );
//   //
//   //   try {
//   //     final GooglePayPaymentData paymentData =
//   //     await FlutterGooglePay.checkout(paymentDataRequest);
//   //     // Process the payment data
//   //     // Perform necessary actions
//   //   } catch (e) {
//   //     // Handle any exceptions that occur during the payment process
//   //     print('Payment Exception: $e');
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeChanger>(builder: (context, themeChanger, _) {
//       return MaterialApp(
//         title: 'Search Screen',
//         theme: themeChanger.currentTheme,
//         home: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Colors.white, // First color
//                 Color(0xFF07abb8), // Second color
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: SafeArea(
//             child: Scaffold(
//               body: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Stack(alignment: Alignment.topRight, children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(100.0),
//                           ),
//                           child: Image.network(
//                             widget.book.imageUrl,
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                           ),
//                         ),
//                         Positioned(
//                           top: 30.0,
//                           right: 8.0,
//                           child: IconButton(
//                             icon: Icon(
//                               isBookmarked ? Icons.add_circle : Icons.add,
//                               size: 40,
//                               color: const Color(0xFFfab313),
//                             ),
//                             onPressed: () {
//                               if (isBookmarked) {
//                                 removeFromBooksAlreadyRead();
//                               } else {
//                                 AlertDialog(
//                                   title: const Text(
//                                     'Success!',
//                                     style: TextStyle(
//                                       fontFamily: 'Sora',
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                   content: const Text(
//                                     'Book added successfully in the Books Already Read category.',
//                                     style: TextStyle(
//                                       fontFamily: 'Sora',
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                   actions: [
//                                     firebaseUIButton(context, 'OK', () {
//                                       Navigator.of(context).pop();
//                                     })
//                                   ],
//                                 );
//                                 addToBooksAlreadyRead();
//
//                               }
//                             },
//                           ),
//                         ),
//                         Positioned(
//                           top: 110,
//                           right: 8.0,
//                           child: IconButton(
//                             icon: Icon(
//                               Icons.favorite,
//                               size: 40,
//                               color: isWishlisted
//                                   ? Colors.red
//                                   : const Color(0xFFfab313),
//                             ),
//                             onPressed: () {
//                               if (isWishlisted) {
//                                 removeFromWishlist();
//                               } else {
//                                 addToWishlist();
//                               }
//                             },
//                           ),
//                         ),
//                         Positioned(
//                           top: 200,
//                           right: 8.0,
//                           child: IconButton(
//                             onPressed: () {
//                               final bookLink =
//                                   'https://books.google.com/books?id=${widget.book.id}';
//                               Share.share('Check out this book: $bookLink');
//                             },
//                             icon: const Icon(
//                               Icons.share,
//                               color: Color(0xFFfab313),
//                               size: 40,
//                             ),
//                           ),
//                         ),
//                       ]),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Title: ${widget.book.title}',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           fontFamily: 'Sora',
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         'Author: ${widget.book.authors.join(', ')}',
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontFamily: 'Sora',
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         'Number of Pages: ${widget.book.pageCount}',
//                         style:
//                             const TextStyle(fontSize: 16, fontFamily: 'Sora'),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         'Language: ${widget.book.language}',
//                         style:
//                             const TextStyle(fontSize: 16, fontFamily: 'Sora'),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         'ISBN: ${widget.book.isbn}',
//                         style:
//                             const TextStyle(fontSize: 16, fontFamily: 'Sora'),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         'Description: ${widget.book.description}',
//                         style:
//                             const TextStyle(fontSize: 16, fontFamily: 'Sora'),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         'Publisher: ${widget.book.publisher}',
//                         style:
//                             const TextStyle(fontSize: 16, fontFamily: 'Sora'),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         'Publication Date: ${widget.book.publishedDate}',
//                         style:
//                             const TextStyle(fontSize: 16, fontFamily: 'Sora'),
//                       ),
//
//                       // Buy from affiliate link or other text links
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             const Icon(
//                               Icons.shopping_basket,
//                               color: Color(0xFFfab313),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 _showPaymentOptionsDialog();
//                               },
//                               child: const Text(
//                                 'Buy this Book',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                   fontFamily: 'Sora',
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 8.0),
//                           ],
//                         ),
//                       ),
//                     ]),
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }

// class BookCard extends StatefulWidget {
//   final Book book;
//   final bool showBookmarkIcon;
//   final VoidCallback? onBookmarkTapped;
//
//   BookCard({
//     required this.book,
//     this.showBookmarkIcon = false,
//     this.onBookmarkTapped,
//   });
//
//   @override
//   State<BookCard> createState() => _BookCardState();
// }
//
// class _BookCardState extends State<BookCard> {
//   bool isBookmarked = false;
//
//   @override
//   void initState() {
//     super.initState();
//     isBookmarked = widget.book.isBookmarked;
//   }
//
//   void addToBookmarks() async {
//     try {
//       final userId = FirebaseAuth.instance.currentUser?.uid;
//       if (userId != null) {
//         final bookmarkedBookRef = FirebaseFirestore.instance
//             .collection('bookmarks')
//             .doc(userId)
//             .collection('books')
//             .doc(widget.book.id);
//
//         await bookmarkedBookRef.set({
//           'imageUrl': widget.book.imageUrl,
//           'title': widget.book.title,
//           'authors': widget.book.authors,
//           'description': widget.book.description,
//           'publisher': widget.book.publisher,
//           'publishDate': widget.book.publishedDate,
//           'pagesCount': widget.book.pageCount,
//           'language': widget.book.language,
//           'isbn': widget.book.isbn,
//           'averageRating': widget.book.averageRating,
//           'ratingsCount': widget.book.ratingsCount,
//           // Add other book details as desired
//         });
//
//         setState(() {
//           isBookmarked = true;
//         });
//       }
//     } catch (e) {
//       print('Failed to add to bookmarks: $e');
//       // Handle error
//     }
//   }
//
//   void removeFromBookmarks() async {
//     try {
//       final userId = FirebaseAuth.instance.currentUser?.uid;
//       if (userId != null) {
//         final bookmarkedBookRef = FirebaseFirestore.instance
//             .collection('bookmarks')
//             .doc(userId)
//             .collection('books')
//             .doc(widget.book.id);
//
//         await bookmarkedBookRef.delete();
//
//         setState(() {
//           isBookmarked = false;
//         });
//       }
//     } catch (e) {
//       print('Failed to remove from bookmarks: $e');
//       // Handle error
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: const Color.fromRGBO(49, 51, 51, 0.5),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => BookDetailsScreen(book: widget.book),
//             ),
//           );
//         },
//         child: Stack(children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Image.network(
//                 widget.book.imageUrl,
//                 // width: 240,
//                 // height: 250,
//                 fit: BoxFit.cover,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.book.title,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                         fontFamily: 'Sora',
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Author: ${widget.book.authors.join(', ')}',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           if (widget.showBookmarkIcon)
//             Positioned(
//               top: 10,
//               right: 10,
//               child: GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     isBookmarked = !isBookmarked;
//                   });
//                   if (isBookmarked) {
//                     addToBookmarks();
//                   } else {
//                     removeFromBookmarks();
//                   }
//                 },
//                 child: Icon(
//                   isBookmarked ? Icons.bookmark : Icons.bookmark_border,
//                   color: const Color(0xfffab313),
//                   size: 32,
//                 ),
//               ),
//             ),
//         ]),
//       ),
//     );
//   }
// }

// class BookList extends StatelessWidget {
//   final List<Book> books;
//
//   BookList({
//     required this.books,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: (books.length / 2).ceil(),
//       itemBuilder: (context, index) {
//         final int firstIndex = index * 2;
//         final int secondIndex = firstIndex + 1;
//
//         return Row(
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: BookCard(
//                   book: books[firstIndex],
//                   showBookmarkIcon: true,
//                 ),
//               ),
//             ),
//             if (secondIndex < books.length)
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: BookCard(
//                     book: books[secondIndex],
//                     showBookmarkIcon: true,
//                   ),
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }
// }

// class BookmarksScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//
//     if (userId != null) {
//       return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('bookmarks')
//             .doc(userId)
//             .collection('books')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final bookmarks = snapshot.data!.docs.map((doc) {
//               final data = doc.data() as Map<String, dynamic>;
//               final publishedDate = data['publishedDate'] != null
//                   ? DateTime.parse(data['publishedDate'])
//                   : null;
//               final authors = List<String>.from(data['authors']);
//               return Book(
//                 // Extract book details from the document data
//                 id: doc.id,
//                 title: data['title'],
//                 authors: authors,
//                 description: data['description'],
//                 imageUrl: data['imageUrl'],
//                 publisher: data['publisher'],
//                 publishedDate: publishedDate,
//                 pageCount: data['pageCount'],
//                 language: data['language'],
//                 isbn: data['isbn'],
//                 averageRating: data['averageRAting'],
//                 ratingsCount: data['ratingCount'],
//
//                 // Add other book details as desired
//                 isBookmarked: true,
//               );
//             }).toList();
//
//             return Scaffold(
//               appBar: AppBar(
//                 title: Text('Bookmarks'),
//               ),
//               body: Column(
//                 children: [
//                   BookList(books: bookmarks),
//                 ],
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       );
//     } else {
//       // Handle case where user is not logged in
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Bookmarks'),
//         ),
//         body: Center(
//           child: Text('Please log in to view bookmarks'),
//         ),
//       );
//     }
//   }
// }

// class WishlistScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//
//     if (userId != null) {
//       return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('Wishlist')
//             .doc(userId)
//             .collection('books')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final bookmarks = snapshot.data!.docs.map((doc) {
//               final data = doc.data() as Map<String, dynamic>;
//               final publishedDate = data['publishedDate'] != null
//                   ? DateTime.parse(data['publishedDate'])
//                   : null;
//               final authors = List<String>.from(data['authors']);
//               return Book(
//                 // Extract book details from the document data
//                 id: doc.id,
//                 title: data['title'],
//                 authors: authors,
//                 description: data['description'],
//                 imageUrl: data['imageUrl'],
//                 publisher: data['publisher'],
//                 publishedDate: publishedDate,
//                 pageCount: data['pageCount'],
//                 language: data['language'],
//                 isbn: data['isbn'],
//                 averageRating: data['averageRAting'],
//                 ratingsCount: data['ratingCount'],
//
//                 // Add other book details as desired
//                 isBookmarked: true,
//               );
//             }).toList();
//
//             return Scaffold(
//               appBar: AppBar(
//                 title: Text('Wishlist'),
//               ),
//               body: BookList(books: bookmarks),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       );
//     } else {
//       // Handle case where user is not logged in
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Whislist'),
//         ),
//         body: Center(
//           child: Text('Please log in to view bookmarks'),
//         ),
//       );
//     }
//   }
// }
//

// class BooksAlreadyReadScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//
//     if (userId != null) {
//       return StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('BooksAlreadyRead')
//             .doc(userId)
//             .collection('books')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final bookmarks = snapshot.data!.docs.map((doc) {
//               final data = doc.data() as Map<String, dynamic>;
//               final publishedDate = data['publishedDate'] != null
//                   ? DateTime.parse(data['publishedDate'])
//                   : null;
//               final authors = List<String>.from(data['authors']);
//               return Book(
//                 // Extract book details from the document data
//                 id: doc.id,
//                 title: data['title'],
//                 authors: authors,
//                 description: data['description'],
//                 imageUrl: data['imageUrl'],
//                 publisher: data['publisher'],
//                 publishedDate: publishedDate,
//                 pageCount: data['pageCount'],
//                 language: data['language'],
//                 isbn: data['isbn'],
//                 averageRating: data['averageRAting'],
//                 ratingsCount: data['ratingCount'],
//
//                 // Add other book details as desired
//                 isBookmarked: true,
//               );
//             }).toList();
//
//             return Scaffold(
//               appBar: AppBar(
//                 title: Text('BooksAlreadyRead'),
//               ),
//               body: BookList(books: bookmarks),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       );
//     } else {
//       // Handle case where user is not logged in
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('BooksAlreadyRead'),
//         ),
//         body: Center(
//           child: Text('Please log in to view bookmarks'),
//         ),
//       );
//     }
//   }
// }
