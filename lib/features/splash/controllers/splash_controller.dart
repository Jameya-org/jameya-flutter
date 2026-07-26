import 'dart:async';

import 'package:flutter/material.dart';

class SplashController extends ChangeNotifier {
  final String fullText = 'Jameya.';

  String displayedText = '';

  bool moveUp = false;
  bool showButtons = false;

  static const int typingSpeed = 400;

  Timer? _timer;
  int _currentIndex = 0;

  void startTyping() {
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

  void disposeController() {
    _timer?.cancel();
  }
}
