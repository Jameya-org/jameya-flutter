import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jameya/core/utils/app_text_styles.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final String _fullText = 'Jameya.';

  String _displayedText = '';
  bool _moveUp = false;
  static const int _textDecorationToBeWrittenInScreen = 400;
  Timer? _timer;
  int _currentIndex = 0;
  bool _showButtons = false;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(
      const Duration(milliseconds: _textDecorationToBeWrittenInScreen),
      (timer) {
        if (_currentIndex < _fullText.length) {
          setState(() {
            _currentIndex++;
            _displayedText = _fullText.substring(0, _currentIndex);
          });

          if (_currentIndex == _fullText.length) {
            timer.cancel();

            setState(() {
              _moveUp = true;
            });
            Future.delayed(const Duration(milliseconds: 400), () {
              setState(() {
                _showButtons = true;
              });
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                top: _moveUp ? 360 : constraints.maxHeight / 2 - 30,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(_displayedText, style: AppTextStyles.appTitle),
                ),
              ),
              AnimatedOpacity(
                opacity: _showButtons ? 1 : 0,
                curve: Curves.ease,
                duration: Duration(milliseconds: 700),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.black,
                      height: 52,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
