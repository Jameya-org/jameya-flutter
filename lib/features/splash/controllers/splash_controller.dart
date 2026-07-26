import 'dart:async';

import 'package:flutter/material.dart';

// Controls the typing animation and UI state on the splash screen
class SplashController extends ChangeNotifier {
  final String fullText = 'Jameya.';

  // Characters revealed so far
  String displayedText = '';

  // Whether the logo has slid up
  bool moveUp = false;
  // Whether the language buttons are visible
  bool showButtons = false;

  // Milliseconds between each character being typed
  static const int typingSpeed = 400;

  Timer? _timer;
  int _currentIndex = 0;

  // Starts the letter-by-letter typing animation
  void startTyping() {
    // Show the first character immediately without waiting for the first timer tick
    _currentIndex = 1;
    displayedText = fullText.substring(0, _currentIndex);
    notifyListeners();

    _timer = Timer.periodic(const Duration(milliseconds: typingSpeed), (timer) {
      if (_currentIndex < fullText.length) {
        _currentIndex++;
        displayedText = fullText.substring(0, _currentIndex);
        notifyListeners();

        if (_currentIndex == fullText.length) {
          timer.cancel();

          moveUp = true;
          notifyListeners();

          Future.delayed(const Duration(milliseconds: 400), () {
            showButtons = true;
            notifyListeners();
          });
        }
      }
    });
  }

  // Cancels the timer to avoid memory leaks on dispose
  void disposeController() {
    _timer?.cancel();
  }
}
