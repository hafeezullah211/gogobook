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
            // IconButton(
            //   icon: const Icon(Icons.arrow_back_ios),
            //   onPressed: _showLeftArrow
            //       ? () {
            //     final currentOffset = _scrollController.offset;
            //     final itemWidth = 200.0;
            //     _scrollTo(currentOffset - itemWidth);
            //   }
            //       : null,
            // ),
            Text(
              widget.categoryName,
              style: const TextStyle(
                fontFamily: 'Sora',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            // IconButton(
            //   icon: const Icon(Icons.arrow_forward_ios),
            //   onPressed: _showRightArrow
            //       ? () {
            //     final currentOffset = _scrollController.offset;
            //     final itemWidth = 200.0;
            //     _scrollTo(currentOffset + itemWidth);
            //   }
            //       : null,
            // ),
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
                    // Implement logic for adding a book to the list
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