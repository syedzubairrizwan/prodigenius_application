import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MotivationalCarousel extends StatefulWidget {
  const MotivationalCarousel({super.key});

  @override
  State<MotivationalCarousel> createState() => _MotivationalCarouselState();
}

class _MotivationalCarouselState extends State<MotivationalCarousel> {
  final PageController _controller = PageController();
  final List<String> quotes = [
    "Push yourself, no one else is going to do it for you.",
    "Success doesn't come from what you do occasionally, it comes from what you do consistently.",
    "Great things never come from comfort zones.",
    "Wake up with determination. Go to bed with satisfaction.",
    "Dream it. Wish it. Do it.",
    "Stay positive, work hard, make it happen.",
    "The key to success is to focus on goals, not obstacles.",
  ];

  Timer? _autoScrollTimer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_controller.hasClients) {
        _currentIndex++;
        if (_currentIndex >= quotes.length) _currentIndex = 0;
        _controller.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _controller,
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.deepPurpleAccent,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        quotes[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _controller,
          count: quotes.length,
          effect: ExpandingDotsEffect(
            activeDotColor: Colors.deepPurple,
            dotHeight: 8,
            dotWidth: 8,
          ),
        ),
      ],
    );
  }
}
