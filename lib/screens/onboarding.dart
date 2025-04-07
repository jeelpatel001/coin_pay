import 'package:coin_pay/bloc/contents_model.dart';
import 'package:coin_pay/screens/login.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFF1A1F38), Colors.black, Colors.black],
            center: Alignment.topRight,
            radius: 1.3,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: contents.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 40,
                            right: 40,
                            top: 80,
                          ),
                          child: Image.asset(
                            contents[i].imageUrl,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: DotsIndicator(
                            dotsCount: contents.length,
                            position: currentPage.toDouble(),
                            decorator: DotsDecorator(
                              color: Colors.white.withOpacity(0.2),
                              activeColor: const Color(0xFF304FFE),
                              size: const Size.square(9.0),
                              activeSize: const Size(36.0, 9.0),
                              activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            contents[i].title,
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.all(30),
                  //   child: DotsIndicator(
                  //     dotsCount: contents.length,
                  //     position: currentPage.toDouble(),
                  //     decorator: DotsDecorator(
                  //       color: Colors.white.withOpacity(0.2),
                  //       activeColor: const Color(0xFF304FFE),
                  //       size: const Size.square(9.0),
                  //       activeSize: const Size(36.0, 9.0),
                  //       activeShape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(5.0),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: SwipeButton(
                        onSwipeComplete: () {
                          if (currentPage < contents.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
                          }
                        },
                        isLastPage: currentPage == contents.length - 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🎯 Swipe Button with Page Swipe Feature
class SwipeButton extends StatefulWidget {
  final VoidCallback onSwipeComplete;
  final bool isLastPage;

  const SwipeButton({
    super.key,
    required this.onSwipeComplete,
    required this.isLastPage,
  });

  @override
  _SwipeButtonState createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<SwipeButton> {
  double position = 0.0;
  bool isDragging = false;

  @override
  Widget build(BuildContext context) {
    double buttonWidth = 310; // Total button width
    double sliderSize = 60; // Size of the sliding button

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          position += details.delta.dx;
          position = position.clamp(0.0, buttonWidth - sliderSize);
        });
      },
      onHorizontalDragEnd: (details) {
        if (position > buttonWidth - sliderSize - 10) {
          // Swipe completed, navigate to the next page
          widget.onSwipeComplete();
        }
        // Reset position after swipe
        setState(() {
          position = 0.0;
        });
      },
      child: Stack(
        children: [
          // Background of the swipe button
          Container(
            width: double.maxFinite,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Colors.grey, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  blurRadius: 0,
                  spreadRadius: 0,
                  offset: const Offset(0, 0),
                ),
              ],
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black12,
                  Colors.black12,
                  Colors.black,
                ],
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const SizedBox(width: 100),
                Text(
                  widget.isLastPage ? "Swipe to Start" : "Swipe to Next",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_right, color: Colors.white12),
                const Icon(Icons.keyboard_arrow_right, color: Colors.white30),
                const Icon(Icons.keyboard_arrow_right, color: Colors.white54),
                const Spacer(),
              ],
            ),
          ),
          // Draggable Arrow Button
          Positioned(
            left: position + 5,
            child: Container(
              width: sliderSize,
              height: 70,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
