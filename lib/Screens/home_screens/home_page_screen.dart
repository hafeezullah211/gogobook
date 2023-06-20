import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:gogobook/Screens/home_screens/banner_home.dart';
import 'package:gogobook/Screens/home_screens/horizontal_view.dart';
import 'package:gogobook/Screens/home_screens/profile_screen.dart';
// import 'package:gogobook/Screens/home_screens/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widgets/button.dart';
import '../../models/books.dart';
import '../../theme_changer.dart';
import '../theme_floating_action_button.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomePage> {
//   ScrollController _scrollController = ScrollController();
//   bool _showLeftArrow = false;
//   bool _showRightArrow = false;
//   List<Book> bookmarkedBooksList = [];
//   List<Book> _books = [];
//   bool _isLoading = false;
//
//   void fetchBookmarks() async {
//     try {
//       final userId = FirebaseAuth.instance.currentUser?.uid;
//       if (userId != null) {
//         final bookmarkedBooksSnapshot = await FirebaseFirestore.instance
//             .collection('bookmarks')
//             .doc(userId)
//             .collection('books')
//             .get();
//
//         final bookmarkedBooks = bookmarkedBooksSnapshot.docs
//             .map((doc) => Book(
//           id: doc.id,
//           imageUrl: doc['imageUrl'],
//           title: doc['title'],
//           authors: List<String>.from(doc['authors']),
//           description: doc['description'],
//           publisher: doc['publisher'],
//           publishedDate: doc['publishDate'],
//           pageCount: doc['pagesCount'],
//           language: doc['language'],
//           isbn: doc['isbn'],
//           averageRating: doc['averageRating'],
//           ratingsCount: doc['ratingsCount'],
//         ))
//             .toList();
//
//         // Update the state with the fetched bookmarked books
//         setState(() {
//           bookmarkedBooksList = bookmarkedBooks;
//         });
//       }
//     } catch (e) {
//       print('Failed to fetch bookmarks: $e');
//       // Handle error
//     }
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_scrollListener);
//     fetchBookmarks();
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_scrollListener);
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _scrollListener() {
//     setState(() {
//       _showLeftArrow = _scrollController.position.pixels > 0;
//       _showRightArrow = _scrollController.position.pixels <
//           _scrollController.position.maxScrollExtent;
//     });
//   }
//
//   void _scrollTo(double offset) {
//     _scrollController.jumpTo(offset);
//   }
//
//   int _currentIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     List<String> adImages = [
//       'assets/images/ad_banner.png',
//       'assets/images/ad_banner.png',
//       'assets/images/ad_banner.png'
//     ];
//
//     final currentTime = DateTime.now();
//     String greeting;
//
//     if (currentTime.hour >= 0 && currentTime.hour < 12) {
//       greeting = 'Good Morning';
//     } else if (currentTime.hour >= 12 && currentTime.hour < 16) {
//       greeting = 'Good Afternoon';
//     } else if (currentTime.hour >= 16 && currentTime.hour < 20) {
//       greeting = 'Good Evening';
//     } else {
//       greeting = 'Good Night';
//     }
//
//     // List<Book> bookmarkedBooks = [
//     //   Book(
//     //     title: 'Book 1',
//     //     author: 'Author 1',
//     //     coverImage: 'assets/images/book_cover_photo.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 2',
//     //     author: 'Author 2',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 3',
//     //     author: 'Author 3',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 4',
//     //     author: 'Author 4',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 5',
//     //     author: 'Author 5',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   // Add more books as needed
//     // ];
//     //
//     // List<Book> booksAlreadyRead = [
//     //   Book(
//     //     title: 'Book 1',
//     //     author: 'Author 1',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 2',
//     //     author: 'Author 2',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 3',
//     //     author: 'Author 3',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 4',
//     //     author: 'Author 4',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 5',
//     //     author: 'Author 5',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   // Add more books as needed
//     // ];
//     //
//     // List<Book> wishlistBooks = [
//     //   Book(
//     //     title: 'Book 1',
//     //     author: 'Author 1',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 2',
//     //     author: 'Author 2',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 3',
//     //     author: 'Author 3',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 4',
//     //     author: 'Author 4',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 5',
//     //     author: 'Author 5',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   // Add more books as needed
//     // ];
//     //
//     // List<Book> recommendedBooks = [
//     //   Book(
//     //     title: 'Book 1',
//     //     author: 'Author 1',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 2',
//     //     author: 'Author 2',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 3',
//     //     author: 'Author 3',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 4',
//     //     author: 'Author 4',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 5',
//     //     author: 'Author 5',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   Book(
//     //     title: 'Book 6',
//     //     author: 'Author 6',
//     //     coverImage: 'assets/images/book_cover.jpg',
//     //   ),
//     //   // Add more books as needed
//     // ];
//
//     return Consumer<ThemeChanger>(builder: (context, themeChanger, _) {
//       return MaterialApp(
//         title: 'Home Page',
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
//               // backgroundColor: isDarkMode ? Colors.black : Colors.white,
//               body: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             greeting,
//                             style: const TextStyle(
//                               // color: isDarkMode ? Colors.white : Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 28,
//                               fontFamily: 'Sora',
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(
//                               Icons.settings,
//                               // color: isDarkMode ? Colors.white : Colors.black,
//                               size: 40,
//                             ),
//                             onPressed: () {
//                               // Handle user icon click
//                             },
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       AdBanner(adImages: adImages),
//                       const SizedBox(
//                         height: 16,
//                       ),
//
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: bookmarkedBooksList.length,
//                           itemBuilder: (context, index) {
//                             final book = bookmarkedBooksList[index];
//                             return BookCard(
//                               book: book,
//                               showBookmarkIcon: true,
//                             );
//                           },
//                         ),
//                       ),
//                       // ElevatedButton(
//                       //     onPressed: () {
//                       //       Navigator.push(
//                       //           context,
//                       //           MaterialPageRoute(
//                       //               builder: (context) => BookmarksScreen()));
//                       //     },
//                       //     child: Text('Show Bookmarks')),
//                       // HorizontalBooksList(
//                       //   books: bookmarks,
//                       //   categoryName: 'Bookmarked Books',
//                       //   showBookmarkIcon: false,
//                       // ),
//                       // BookmarksScreen(),
//                       // const SizedBox(
//                       //   height: 16,
//                       // ),
//                       // HorizontalBooksList(
//                       //   books: booksAlreadyRead,
//                       //   categoryName: 'Books Already Read',
//                       //   showBookmarkIcon: true,
//                       // ),
//                       // const SizedBox(
//                       //   height: 16,
//                       // ),
//                       // HorizontalBooksList(
//                       //   books: wishlistBooks,
//                       //   categoryName: 'Wishlist Books',
//                       //   showBookmarkIcon: true,
//                       // ),
//                       // const SizedBox(
//                       //   height: 16,
//                       // ),
//                       // HorizontalBooksList(
//                       //   books: recommendedBooks,
//                       //   categoryName: 'Recommended Books',
//                       //   showBookmarkIcon: true,
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//               floatingActionButton: ThemeFloatingActionButton(),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
class HomePage extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  ScrollController _scrollController = ScrollController();
  bool _showLeftArrow = false;
  bool _showRightArrow = false;
  List<Book> bookmarkedBooksList = [];
  List<Book> wishlistBooksList = [];
  List<Book> booksAlreadyReadBooksList = [];


  List<Book> _books = [];
  bool _isLoading = false;

  void fetchBookmarks() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final bookmarkedBooksSnapshot = await FirebaseFirestore.instance
            .collection('bookmarks')
            .doc(userId)
            .collection('books')
            .get();

        final bookmarkedBooks = bookmarkedBooksSnapshot.docs
            .map((doc) => Book(
                  id: doc.id,
                  imageUrl: doc['imageUrl'],
                  title: doc['title'],
                  authors: List<String>.from(doc['authors']),
                  description: doc['description'],
                  publisher: doc['publisher'],
                  publishedDate: doc['publishDate'].toDate(),
                  pageCount: doc['pagesCount'],
                  language: doc['language'],
                  isbn: doc['isbn'],
                  averageRating: doc['averageRating'],
                  ratingsCount: doc['ratingsCount'],
                ))
            .toList();

        // Update the state with the fetched bookmarked books
        setState(() {
          bookmarkedBooksList = bookmarkedBooks;
        });
      }
    } catch (e) {
      print('Failed to fetch bookmarks: $e');
      // Handle error
    }
  }

  void fetchWishlist() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final bookmarkedBooksSnapshot = await FirebaseFirestore.instance
            .collection('Wishlist')
            .doc(userId)
            .collection('books')
            .get();

        final bookmarkedBooks = bookmarkedBooksSnapshot.docs
            .map((doc) => Book(
          id: doc.id,
          imageUrl: doc['imageUrl'],
          title: doc['title'],
          authors: List<String>.from(doc['authors']),
          description: doc['description'],
          publisher: doc['publisher'],
          publishedDate: doc['publishDate'].toDate(),
          pageCount: doc['pagesCount'],
          language: doc['language'],
          isbn: doc['isbn'],
          averageRating: doc['averageRating'],
          ratingsCount: doc['ratingsCount'],
        ))
            .toList();

        // Update the state with the fetched bookmarked books
        setState(() {
          wishlistBooksList = bookmarkedBooks;
        });
      }
    } catch (e) {
      print('Failed to fetch Wishlist Books: $e');
      // Handle error
    }
  }

  void fetchBooksAlreadyReadlist() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final bookmarkedBooksSnapshot = await FirebaseFirestore.instance
            .collection('BooksAlreadyRead')
            .doc(userId)
            .collection('books')
            .get();

        final bookmarkedBooks = bookmarkedBooksSnapshot.docs
            .map((doc) => Book(
          id: doc.id,
          imageUrl: doc['imageUrl'],
          title: doc['title'],
          authors: List<String>.from(doc['authors']),
          description: doc['description'],
          publisher: doc['publisher'],
          publishedDate: doc['publishDate'].toDate(),
          pageCount: doc['pagesCount'],
          language: doc['language'],
          isbn: doc['isbn'],
          averageRating: doc['averageRating'],
          ratingsCount: doc['ratingsCount'],
        ))
            .toList();

        // Update the state with the fetched bookmarked books
        setState(() {
          booksAlreadyReadBooksList = bookmarkedBooks;
        });
      }
    } catch (e) {
      print('Failed to fetch Wishlist Books: $e');
      // Handle error
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetchBookmarks();
    fetchWishlist();
    fetchBooksAlreadyReadlist();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    setState(() {
      _showLeftArrow = _scrollController.position.pixels > 0;
      _showRightArrow = _scrollController.position.pixels <
          _scrollController.position.maxScrollExtent;
    });
  }

  void _scrollTo(double offset) {
    _scrollController.jumpTo(offset);
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<String> adImages = [
      'assets/images/ad_banner.png',
      'assets/images/ad_banner.png',
      'assets/images/ad_banner.png'
    ];

    final currentTime = DateTime.now();
    String greeting;

    if (currentTime.hour >= 0 && currentTime.hour < 12) {
      greeting = 'Good Morning';
    } else if (currentTime.hour >= 12 && currentTime.hour < 16) {
      greeting = 'Good Afternoon';
    } else if (currentTime.hour >= 16 && currentTime.hour < 20) {
      greeting = 'Good Evening';
    } else {
      greeting = 'Good Night';
    }

    return Consumer<ThemeChanger>(builder: (context, themeChanger, _) {
      return MaterialApp(
        title: 'Home Page',
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
              // backgroundColor: isDarkMode ? Colors.black : Colors.white,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            greeting,
                            style: const TextStyle(
                              // color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              fontFamily: 'Sora',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.settings,
                              // color: isDarkMode ? Colors.white : Colors.black,
                              size: 40,
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AdBanner(adImages: adImages),
                      const SizedBox(
                        height: 16,
                      ),


                      if (bookmarkedBooksList.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        HorizontalBooksList(
                          books: bookmarkedBooksList,
                          categoryName: "Bookmarked Books",
                        ),
                        const SizedBox(height: 16),
                      ],


                      if (wishlistBooksList.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        HorizontalBooksList(
                          books: wishlistBooksList,
                          categoryName: "Wishlist Books",
                          showBookmarkIcon: true,
                        ),
                        const SizedBox(height: 16),
                      ],

                      const SizedBox(height: 16,),
                      HorizontalBooksList(
                          books: booksAlreadyReadBooksList,
                          categoryName: 'Books Already Read',
                          showBookmarkIcon: true,
                      ),

                    ],
                  ),
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

class BookCard extends StatefulWidget {
  final Book book;
  final bool showBookmarkIcon;
  final VoidCallback? onBookmarkTapped;

  BookCard({
    required this.book,
    this.showBookmarkIcon = false,
    this.onBookmarkTapped,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    isBookmarked = widget.book.isBookmarked;
  }

  void addToBookmarks() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final bookmarkedBookRef = FirebaseFirestore.instance
            .collection('bookmarks')
            .doc(userId)
            .collection('books')
            .doc(widget.book.id);

        await bookmarkedBookRef.set({
          'imageUrl': widget.book.imageUrl,
          'title': widget.book.title,
          'authors': widget.book.authors,
          'description': widget.book.description,
          'publisher': widget.book.publisher,
          'publishDate': widget.book.publishedDate,
          'pagesCount': widget.book.pageCount,
          'language': widget.book.language,
          'isbn': widget.book.isbn,
          'averageRating': widget.book.averageRating,
          'ratingsCount': widget.book.ratingsCount,
          // Add other book details as desired
        });

        setState(() {
          isBookmarked = true;
        });
      }
    } catch (e) {
      print('Failed to add to bookmarks: $e');
      // Handle error
    }
  }

  void removeFromBookmarks() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final bookmarkedBookRef = FirebaseFirestore.instance
            .collection('bookmarks')
            .doc(userId)
            .collection('books')
            .doc(widget.book.id);

        await bookmarkedBookRef.delete();

        setState(() {
          isBookmarked = false;
        });
      }
    } catch (e) {
      print('Failed to remove from bookmarks: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(49, 51, 51, 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailsScreen(book: widget.book),
            ),
          );
        },
        child: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.book.imageUrl,
                width: 230,
                height: 270,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.book.title.length > 20
                          ? '${widget.book.title.substring(0, 20)}...'
                          : widget.book.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'Sora',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.book.authors.join(', ').length > 20
                          ? '${widget.book.authors.join(', ').substring(0, 20)}...'
                          : widget.book.authors.join(', '),
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Sora',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.showBookmarkIcon)
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isBookmarked = !isBookmarked;
                  });
                  if (isBookmarked) {
                    addToBookmarks();
                  } else {
                    removeFromBookmarks();
                  }
                },
                child: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: const Color(0xfffab313),
                  size: 32,
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

class BookDetailsScreen extends StatefulWidget {
  final Book book;

  const BookDetailsScreen({Key? key, required this.book}) : super(key: key);

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  bool isBookmarked = false;
  bool isWishlisted = false;
  @override
  void initState() {
    super.initState();
  }

  void addToBooksAlreadyRead() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final bookData = {
        'imageUrl': widget.book.imageUrl,
        'id': widget.book.id,
        'title': widget.book.title,
        'authors': widget.book.authors,
        'description': widget.book.description,
        'publisher': widget.book.publisher,
        'publishDate': widget.book.publishedDate,
        'pagesCount': widget.book.pageCount,
        'language': widget.book.language,
        'isbn': widget.book.isbn,
        'averageRating': widget.book.averageRating,
        'ratingsCount': widget.book.ratingsCount,

        // Add other book details as desired
      };

      if (isWishlisted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Cannot Add to Books Already Read',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: const Text(
                'Sorry! Please remove this book from the Wishlist category to add it to the Books Already Read category.',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              actions: [
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                //   child: const Text('OK'),
                // ),
                firebaseUIButton(context, 'OK', (){
                  Navigator.of(context).pop();
                })
              ],
            );
          },
        );
      } else {
        FirebaseFirestore.instance
            .collection('BooksAlreadyRead')
            .doc(userId)
            .collection('books')
            .doc(widget.book.id)
            .set(bookData)
            .then((value) {
          setState(() {
            isBookmarked = true;
          });
        }).catchError((error) {
          // Handle the error
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success!',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                content: const Text(
                  'Book added successfully in the Books Already Read List.',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                actions: [
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   child: const Text('OK'),
                  // ),
                  firebaseUIButton(context, 'OK', (){
                    Navigator.of(context).pop();
                  })
                ],
              );
            },
        );
      }
    }
  }

  void removeFromBooksAlreadyRead() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      FirebaseFirestore.instance
          .collection('BooksAlreadyRead')
          .doc(userId)
          .collection('books')
          .doc(widget.book.id)
          .delete()
          .then((value) {
        setState(() {
          isBookmarked = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success!',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: const Text(
                'Book removed successfully from the Books Already Read List.',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              actions: [
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                //   child: const Text('OK'),
                // ),
                firebaseUIButton(context, 'OK', (){
                  Navigator.of(context).pop();
                })
              ],
            );
          },
        );
      }).catchError((error) {
        // Handle the error
      });
    }
  }

  void addToWishlist() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      print(userId);
      final bookData = {
        'imageUrl': widget.book.imageUrl,
        'id': widget.book.id,
        'title': widget.book.title,
        'authors': widget.book.authors,
        'description': widget.book.description,
        'publisher': widget.book.publisher,
        'publishDate': widget.book.publishedDate,
        'pagesCount': widget.book.pageCount,
        'language': widget.book.language,
        'isbn': widget.book.isbn,
        'averageRating': widget.book.averageRating,
        'ratingsCount': widget.book.ratingsCount,
        // Add other book details as desired
      };

      if (isBookmarked) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Cannot Add to Books Already Read',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: const Text(
                'Sorry! Please remove this book from the Books Already Read category to add it to the Wishlist category.',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              actions: [
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                //   child: const Text('OK'),
                // ),
                firebaseUIButton(context, 'OK', (){
                  Navigator.of(context).pop();
                })
              ],
            );
          },
        );
      } else {
        FirebaseFirestore.instance
            .collection('Wishlist')
            .doc(userId)
            .collection('books')
            .doc(widget.book.id)
            .set(bookData)
            .then((value) {
          setState(() {
            isWishlisted = true;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success!',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                content: const Text(
                  'Book added successfully in the Wishlist Books List.',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                actions: [
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   child: const Text('OK'),
                  // ),
                  firebaseUIButton(context, 'OK', (){
                    Navigator.of(context).pop();
                  })
                ],
              );
            },
          );
        }).catchError((error) {
          // Handle the error
        });
      }
    }
  }

  void removeFromWishlist() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      FirebaseFirestore.instance
          .collection('Wishlist')
          .doc(userId)
          .collection('books')
          .doc(widget.book.id)
          .delete()
          .then((value) {
        setState(() {
          isWishlisted = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success!',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: const Text(
                'Book removed successfully from the Wishlist Books list.',
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              actions: [
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                //   child: const Text('OK'),
                // ),
                firebaseUIButton(context, 'OK', (){
                  Navigator.of(context).pop();
                })
              ],
            );
          },
        );
      }).catchError((error) {
        // Handle the error
      });
    }
  }

  void _showPaymentOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Payment Option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => UsePaypal(
                          sandboxMode: true,
                          clientId:
                          "AeLZvoYK_m8VNfaW7m7bphMzz1oI1IZnU3Y3FFVGEZET04D4rE5HR9CIu4tM3KUwqhjEcKquIW0QiGGc",
                          secretKey:
                          "EOwv9Uj3R9hyATGl_IrFkCN2G-4XhEyIZ0XbvuiSH7trOy-RbaJI2-weBAxwKsKyvP2EPbbiSOGZIsMN",
                          returnURL: "https://samplesite.com/return",
                          cancelURL: "https://samplesite.com/cancel",
                          transactions: const [
                            {
                              "amount": {
                                "total": '10.12',
                                "currency": "USD",
                                "details": {
                                  "subtotal": '10.12',
                                  "shipping": '0',
                                  "shipping_discount": 0
                                }
                              },
                              "description":
                              "The payment transaction description.",
                              // "payment_options": {
                              //   "allowed_payment_method":
                              //       "INSTANT_FUNDING_SOURCE"
                              // },
                              "item_list": {
                                "items": [
                                  {
                                    "name": "A demo product",
                                    "quantity": 1,
                                    "price": '10.12',
                                    "currency": "USD"
                                  }
                                ],
                              }
                            }
                          ],
                          note: "Contact us for any questions on your order.",
                          onSuccess: (Map params) async {
                            print("onSuccess: $params");
                          },
                          onError: (error) {
                            print("onError: $error");
                          },
                          onCancel: (params) {
                            print('cancelled: $params');
                          }),
                    ),
                  );
                },
                child: const Text('PayPal'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // _initiateGooglePayPayment();
                },
                child: const Text('Google Pay'),
              ),
            ],
          ),
        );
      },
    );
  }

  // void _initiatePayPalPayment() async {
  //   final clientId = 'YOUR_PAYPAL_CLIENT_ID'; // Replace with your PayPal Client ID
  //
  //   final PayPalResult result = await FlutterPaypal.start(
  //     clientId: clientId,
  //     currencyCode: 'USD', // Replace with the appropriate currency code
  //     amount: '10.00', // Replace with the actual book price
  //     itemName: 'Book Purchase', // Replace with the actual book name
  //     cancelUrl: 'YOUR_CANCEL_URL', // Replace with your cancel URL
  //     returnUrl: 'YOUR_RETURN_URL', // Replace with your return URL
  //   );
  //
  //   if (result.status == PayPalStatus.success) {
  //     // Payment successful
  //     // Perform necessary actions
  //   } else if (result.status == PayPalStatus.cancel) {
  //     // Payment cancelled by the user
  //     // Perform necessary actions
  //   } else {
  //     // Payment failed
  //     // Perform necessary actions
  //   }
  // }


  // void _initiateGooglePayPayment() async {
  //   final GooglePayPaymentItem paymentItem = GooglePayPaymentItem(
  //     name: 'Book Purchase',
  //     price: '10.00',
  //     type: GooglePayItemType.price,
  //   );
  //
  //   final GooglePayTokenizationParameters tokenizationParameters =
  //   GooglePayTokenizationParameters(
  //     tokenizationType: GooglePayTokenizationType.network,
  //     parameters: {
  //       'publicKey': 'YOUR_PUBLIC_KEY',
  //     },
  //   );
  //
  //   final GooglePayPaymentDataRequest paymentDataRequest =
  //   GooglePayPaymentDataRequest(
  //     merchantName: 'Your Merchant Name',
  //     totalPrice: '10.00',
  //     currencyCode: 'USD',
  //     paymentItems: [paymentItem],
  //     tokenizationParameters: tokenizationParameters,
  //   );
  //
  //   try {
  //     final GooglePayPaymentData paymentData =
  //     await FlutterGooglePay.checkout(paymentDataRequest);
  //     // Process the payment data
  //     // Perform necessary actions
  //   } catch (e) {
  //     // Handle any exceptions that occur during the payment process
  //     print('Payment Exception: $e');
  //   }
  // }

  void _launchAmazonUrl() async {
    // Replace the 'isbn' variable with the actual ISBN of the book
    String isbn = widget.book.isbn;

    // Check if the ISBN is valid
    if (isbn != null && isbn.isNotEmpty) {
      // Construct the Amazon search URL using the ISBN
      String searchUrl = 'https://www.amazon.com/s?k=${Uri.encodeComponent(isbn)}';

      // Open the URL in a web browser
      await FlutterWebBrowser.openWebPage(
        url: searchUrl,
        customTabsOptions: CustomTabsOptions(
          toolbarColor: Colors.deepPurple,
          showTitle: true,
        ),
      );
    } else {
      // Handle error if the ISBN is null or empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Invalid ISBN.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeChanger>(builder: (context, themeChanger, _) {
      return MaterialApp(
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
          child: SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(alignment: Alignment.topRight, children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Image.network(
                            widget.book.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: 30.0,
                          right: 8.0,
                          child: IconButton(
                            icon: Icon(
                              isBookmarked ? Icons.add_circle : Icons.add,
                              size: 40,
                              color: const Color(0xFFfab313),
                            ),
                            onPressed: () {
                              if (isBookmarked) {
                                removeFromBooksAlreadyRead();
                              } else {
                                addToBooksAlreadyRead();
                              }
                            },
                          ),
                        ),
                        Positioned(
                          top: 110,
                          right: 8.0,
                          child: IconButton(
                            icon: Icon(
                              Icons.favorite,
                              size: 40,
                              color: isWishlisted
                                  ? Colors.red
                                  : const Color(0xFFfab313),
                            ),
                            onPressed: () {
                              if (isWishlisted) {
                                removeFromWishlist();
                              } else {
                                addToWishlist();
                              }
                            },
                          ),
                        ),
                        Positioned(
                          top: 200,
                          right: 8.0,
                          child: IconButton(
                            onPressed: () {
                              final bookLink =
                                  'https://books.google.com/books?id=${widget.book.id}';
                              Share.share('Check out this book: $bookLink');
                            },
                            icon: const Icon(
                              Icons.share,
                              color: Color(0xFFfab313),
                              size: 40,
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      const Text(
                        'Title:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Sora',
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      Text(
                        widget.book.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Sora',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            'Author:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: 'Sora',
                            ),
                          ),
                          const SizedBox(width: 8.0,),
                          Text(
                            widget.book.authors.join(', '),
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Sora',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            'Number of Pages:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: 'Sora',
                            ),
                          ),
                          const SizedBox(width: 8.0,),
                          Text(
                            '${widget.book.pageCount}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Sora',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            'Language:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: 'Sora',
                            ),
                          ),
                          const SizedBox(width: 8.0,),
                          Text(
                            '${widget.book.language}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Sora',
                            ),
                          ),
                        ]
                      ),
                      const SizedBox(height: 10),
                      Row(
                          children: [
                            const Text(
                              'ISBN:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: 'Sora',
                              ),
                            ),
                            const SizedBox(width: 8.0,),
                            Text(
                              '${widget.book.isbn}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Sora',
                              ),
                            ),
                          ]
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Description:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Sora',
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      Text(
                        '${widget.book.description}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Sora',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                          children: [
                            const Text(
                              'Publisher:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: 'Sora',
                              ),
                            ),
                            const SizedBox(width: 8.0,),
                            Text(
                              '${widget.book.publisher}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Sora',
                              ),
                            ),
                          ]
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Publication Date:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Sora',
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      Text(
                        '${widget.book.publishedDate}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Sora',
                        ),
                      ),

                      // Buy from affiliate link or other text links
                      GestureDetector(
                        onTap: (){
                          _launchAmazonUrl();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.shopping_basket,
                                color: Color(0xFFfab313),
                              ),
                              TextButton(
                                onPressed: () {
                                  _launchAmazonUrl();
                                },
                                child: const Text(
                                  'Buy this Book',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'Sora',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      );
    });
  }
}

// class HorizontalBooksList extends StatefulWidget {
//   final List<Book> books;
//   final String categoryName;
//   final bool showBookmarkIcon;
//
//   HorizontalBooksList({
//     required this.books,
//     required this.categoryName,
//     this.showBookmarkIcon = false,
//   });
//
//   @override
//   _HorizontalBooksListState createState() => _HorizontalBooksListState();
// }
//
// class _HorizontalBooksListState extends State<HorizontalBooksList> {
//   ScrollController _scrollController = ScrollController();
//   bool _showLeftArrow = false;
//   bool _showRightArrow = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_scrollListener);
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_scrollListener);
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _scrollListener() {
//     setState(() {
//       _showLeftArrow = _scrollController.position.pixels > 0;
//       _showRightArrow = _scrollController.position.pixels <
//           _scrollController.position.maxScrollExtent;
//     });
//   }
//
//   void _scrollTo(double offset) {
//     _scrollController.jumpTo(offset);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.arrow_back_ios),
//               onPressed: _showLeftArrow
//                   ? () {
//                 final currentOffset = _scrollController.offset;
//                 final itemWidth = 200.0;
//                 _scrollTo(currentOffset - itemWidth);
//               }
//                   : null,
//             ),
//             Text(
//               widget.categoryName,
//               style: const TextStyle(
//                 fontFamily: 'Sora',
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.arrow_forward_ios),
//               onPressed: _showRightArrow
//                   ? () {
//                 final currentOffset = _scrollController.offset;
//                 final itemWidth = 200.0;
//                 _scrollTo(currentOffset + itemWidth);
//               }
//                   : null,
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         SingleChildScrollView(
//           controller: _scrollController,
//           scrollDirection: Axis.horizontal,
//           child: Row(children: [
//             ...widget.books.map(
//                   (book) => BookCard(
//                 book: book,
//                 showBookmarkIcon: widget.showBookmarkIcon,
//               ),
//             ),
//             if (widget.categoryName == 'Books Already Read')
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GestureDetector(
//                   onTap: () {
//                     // Implement logic for adding a book to the list
//                   },
//                   child: Card(
//                     color: const Color.fromRGBO(49, 51, 51, 0.5),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
//                     child: Column(children: [
//                       Container(
//                         width: 180,
//                         height: 295,
//                         child: const Icon(
//                           Icons.add,
//                           color: Colors.white,
//                           size: 64,
//                         ),
//                       ),
//                       const Text(
//                         'Add Book',
//                         style: TextStyle(
//                             fontFamily: 'Sora',
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white
//                         ),
//                       ),
//                       const SizedBox(height: 16,)
//                     ]),
//                   ),
//                 ),
//               ),
//           ]),
//         ),
//       ],
//     );
//   }
// }

// class BookCard extends StatefulWidget {
//   final Book book;
//   final bool showBookmarkIcon;
//   final bool showTransparentIcon;
//   final VoidCallback? onAddPressed;
//
//   BookCard({
//     required this.book,
//     this.showBookmarkIcon = false,
//     this.showTransparentIcon = false,
//     this.onAddPressed,
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
//   Widget build(BuildContext context) {
//     return Card(
//       color: const Color.fromRGBO(49, 51, 51, 0.5),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => BookPage(book: widget.book),
//             ),
//           );
//         },
//         child: Stack(children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Image.asset(
//                 widget.book.coverImage,
//                 width: 180,
//                 height: 270,
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
//                     Row(
//                       children: [
//                         const Text(
//                           'Author: ',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                             fontFamily: 'Sora',
//                           ),
//                         ),
//                         Text(
//                           widget.book.author,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontFamily: 'Sora',
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           if (widget.showBookmarkIcon)
//             Positioned(
//               top: 254,
//               right: 10,
//               child: GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     isBookmarked = !isBookmarked;
//                   });
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

// class AdBanner extends StatefulWidget {
//   final List<String> adImages;
//
//   AdBanner({required this.adImages});
//
//   @override
//   _AdBannerState createState() => _AdBannerState();
// }
//
// class _AdBannerState extends State<AdBanner> {
//   final PageController _pageController = PageController();
//   late List<String> _adImages;
//
//   @override
//   void initState() {
//     super.initState();
//     _adImages = widget.adImages;
//     _startAutoScroll();
//   }
//
//   @override
//   void didUpdateWidget(covariant AdBanner oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     _adImages = widget.adImages;
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   void _startAutoScroll() {
//     Future.delayed(const Duration(seconds: 2), () {
//       if (_pageController.hasClients) {
//         if (_pageController.page == _adImages.length - 1) {
//           _pageController.jumpToPage(0);
//         } else {
//           _pageController.nextPage(
//               duration: const Duration(milliseconds: 500), curve: Curves.linear);
//         }
//       }
//       _startAutoScroll();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200, // Adjust the height as needed
//       child: PageView.builder(
//         controller: _pageController,
//         itemCount: _adImages.length,
//         itemBuilder: (context, index) {
//           return Image.asset(_adImages[index], fit: BoxFit.cover);
//         },
//       ),
//     );
//   }
// }

// class Book {
//   final String coverImage;
//   final String title;
//   final String author;
//
//   Book({
//     required this.coverImage,
//     required this.title,
//     required this.author,
//   });
// }
//
// class BookPage extends StatefulWidget {
//   final Book book;
//
//   BookPage({required this.book});
//
//   @override
//   State<BookPage> createState() => _BookPageState();
// }
//
// class _BookPageState extends State<BookPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeChanger>(builder: (context, themeChanger, _) {
//       return MaterialApp(
//         title: 'Book Screen',
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
//               // backgroundColor: isDarkMode ? Colors.black : Colors.white,
//               body: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Book cover image
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => ExpandedImagePage(),
//                                     ));
//                               },
//                               child: Stack(
//                                   alignment: Alignment.topRight,
//                                   children: [
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         borderRadius:
//                                         BorderRadius.circular(100.0),
//                                       ),
//                                       child: Expanded(
//                                         child: Image.asset(
//                                           widget.book.coverImage,
//                                           fit: BoxFit.cover,
//                                           width: double.infinity,
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                         top: 16.0,
//                                         right: 8.0,
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             // Implement add to read wishlist logic
//                                           },
//                                           child: const Icon(
//                                             Icons.add,
//                                             color: Color(0xFFfab313),
//                                             size: 40,
//                                           ),
//                                         )),
//                                     Positioned(
//                                         top: 80,
//                                         right: 8.0,
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             // Implement add to read wishlist logic
//                                           },
//                                           child: const Icon(
//                                             Icons.favorite_outline,
//                                             color: Color(0xFFfab313),
//                                             size: 40,
//                                           ),
//                                         )),
//                                     Positioned(
//                                         top: 144,
//                                         right: 8.0,
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             // Implement add to read wishlist logic
//                                           },
//                                           child: const Icon(
//                                             Icons.share,
//                                             color: Color(0xFFfab313),
//                                             size: 40,
//                                           ),
//                                         )),
//                                   ]),
//                             ),
//                             const SizedBox(height: 16.0),
//                             // Book title
//                             Text(
//                               widget.book.title,
//                               style: const TextStyle(
//                                 // color: isDarkMode ? Colors.white : Colors.black,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 28,
//                                 fontFamily: 'Sora',
//                               ),
//                             ),
//                             const SizedBox(height: 8.0),
//                             // Book author
//                             Row(
//                               children: [
//                                 const Text(
//                                   'Author:  ',
//                                   style: TextStyle(
//                                     // color: isDarkMode ? Colors.white : Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18,
//                                     fontFamily: 'Sora',
//                                   ),
//                                 ),
//                                 Text(
//                                   widget.book.author,
//                                   style: const TextStyle(
//                                     // color: isDarkMode ? Colors.white : Colors.black,
//                                     fontSize: 18,
//                                     fontFamily: 'Sora',
//                                   ),
//                                 ),
//                               ],
//                             ),
//
//                             const SizedBox(height: 16.0),
//                             const Text(
//                               'Genre:  ',
//                               style: TextStyle(
//                                 // color: isDarkMode ? Colors.white : Colors.black,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                                 fontFamily: 'Sora',
//                               ),
//                             ),
//
//                             const SizedBox(height: 16.0),
//                             const Text(
//                               'Pages: ',
//                               style: TextStyle(
//                                 // color: isDarkMode ? Colors.white : Colors.black,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                                 fontFamily: 'Sora',
//                               ),
//                             ),
//
//                             const SizedBox(height: 16.0),
//                             // Book description
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'Description: ',
//                                   style: TextStyle(
//                                     // color: isDarkMode ? Colors.white : Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18,
//                                     fontFamily: 'Sora',
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 16,
//                                 ),
//                                 const Text(
//                                   'Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'
//                                       ' Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'
//                                       ' Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
//                                   style: TextStyle(
//                                     // color: isDarkMode ? Colors.white : Colors.black,
//                                     fontSize: 14,
//                                     fontFamily: 'Sora',
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16.0),
//                             // Buy from affiliate link or other text links
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   const Icon(
//                                     Icons.shopping_basket,
//                                     color: Color(0xFFfab313),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       // Implement buy from affiliate link logic
//                                     },
//                                     child: const Text(
//                                       'Buy this Book',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                         fontFamily: 'Sora',
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8.0),
//                                   // Add more text links or icons as needed
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               // floatingActionButton: ThemeFloatingActionButton(),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
//
// class ExpandedImagePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         onTap: () {
//           Navigator.pop(context);
//         },
//         child: Center(
//           child: Hero(
//             tag: 'book_cover_image',
//             child: Image.asset(
//               'assets/images/book.jpg',
//               fit: BoxFit.contain,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Book {
//   final String id;
//   final String title;
//   final List<String> authors;
//   final String description;
//   final String imageUrl;
//   final String publisher;
//   final DateTime? publishedDate;
//   final int? pageCount;
//   final String language;
//   final String isbn;
//   final double? averageRating;
//   final int? ratingsCount;
//   bool isBookmarked;
//
//   Book({
//     required this.id,
//     required this.title,
//     required this.authors,
//     required this.description,
//     required this.imageUrl,
//     required this.publisher,
//     required this.publishedDate,
//     required this.pageCount,
//     required this.language,
//     required this.isbn,
//     required this.averageRating,
//     required this.ratingsCount,
//     this.isBookmarked = false,
//   });
//
//   factory Book.fromJson(Map<String, dynamic> json, {required String id}) {
//     final List<dynamic>? authorList = json['authors'];
//     final List<String> authors =
//         authorList?.map((author) => author.toString()).toList() ?? ['Unknown'];
//     final String description =
//         json['description'] ?? 'No description available';
//     final String imageUrl = json['imageLinks']['thumbnail'] ?? 'No Image';
//     final String publisher = json['publisher'] ?? 'Unknown';
//     final DateTime publishedDate =
//         DateTime.tryParse(json['publishedDate']) ?? DateTime.now();
//     final int pageCount = json['pageCount'] ?? 0;
//     final String language = json['language'] ?? 'Unknown';
//     final String isbn =
//         json['industryIdentifiers'][0]['identifier'] ?? 'Unknown';
//     final double averageRating = json['averageRating']?.toDouble() ?? 0.0;
//     final int ratingsCount = json['ratingsCount'] ?? 0;
//
//     return Book(
//       id: id,
//       title: json['title'] ?? 'Unknown',
//       authors: authors,
//       description: description,
//       imageUrl: imageUrl,
//       publisher: publisher,
//       publishedDate: publishedDate,
//       pageCount: pageCount,
//       language: language,
//       isbn: isbn,
//       averageRating: averageRating,
//       ratingsCount: ratingsCount,
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
//
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
