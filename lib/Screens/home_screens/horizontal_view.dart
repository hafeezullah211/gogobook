import 'package:flutter/material.dart';
import 'package:gogobook/Screens/home_screens/home_page_screen.dart';
import 'package:gogobook/Screens/home_screens/search_screen.dart';

import '../../models/books.dart';
// import 'package:gogobook/Screens/home_screens/home_page_screen.dart';

class HorizontalBooksList extends StatefulWidget {
  final List<Book> books;
  final String categoryName;
  final bool showBookmarkIcon;

  HorizontalBooksList({
    required this.books,
    required this.categoryName,
    this.showBookmarkIcon = false,
  });

  @override
  _HorizontalBooksListState createState() => _HorizontalBooksListState();
}

class _HorizontalBooksListState extends State<HorizontalBooksList> {
  ScrollController _scrollController = ScrollController();
  bool _showLeftArrow = false;
  bool _showRightArrow = false;


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.categoryName,
              style: const TextStyle(
                fontFamily: 'Sora',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            ...widget.books.map(
                  (book) => BookCard(
                book: book,
                showBookmarkIcon: widget.showBookmarkIcon,
              ),
            ),
            if (widget.categoryName == 'Books Already Read')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: const Text(
                                'Confirmation',
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF07abb8)
                              ),
                            ),
                            content: const Text(
                                'Please search for a book to add in Books Already List',
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SearchPage()),
                                    );
                                },
                                child: const Text(
                                    'OK',
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFfab313),
                                ),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  child: Card(
                    color: const Color.fromRGBO(49, 51, 51, 0.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    child: Column(children: [
                      Container(
                        width: 180,
                        height: 295,
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 64,
                        ),
                      ),
                      const Text(
                        'Add Book',
                        style: TextStyle(
                            fontFamily: 'Sora',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                      const SizedBox(height: 16,)
                    ]),
                  ),
                ),
              ),
          ]),
        ),
      ],
    );
  }
}