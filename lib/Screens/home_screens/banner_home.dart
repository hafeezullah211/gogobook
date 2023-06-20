import 'package:flutter/material.dart';

class AdBanner extends StatefulWidget {
  final List<String> adImages;

  AdBanner({required this.adImages});

  @override
  _AdBannerState createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  final PageController _pageController = PageController();
  late List<String> _adImages;

  @override
  void initState() {
    super.initState();
    _adImages = widget.adImages;
    _startAutoScroll();
  }

  @override
  void didUpdateWidget(covariant AdBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    _adImages = widget.adImages;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 2), () {
      if (_pageController.hasClients) {
        if (_pageController.page == _adImages.length - 1) {
          _pageController.jumpToPage(0);
        } else {
          _pageController.nextPage(
              duration: const Duration(milliseconds: 500), curve: Curves.linear);
        }
      }
      _startAutoScroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Adjust the height as needed
      child: PageView.builder(
        controller: _pageController,
        itemCount: _adImages.length,
        itemBuilder: (context, index) {
          return Image.asset(_adImages[index], fit: BoxFit.cover);
        },
      ),
    );
  }
}