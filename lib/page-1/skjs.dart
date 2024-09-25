import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedSearchBox extends StatefulWidget {
  @override
  _AnimatedSearchBoxState createState() => _AnimatedSearchBoxState();
}

class _AnimatedSearchBoxState extends State<AnimatedSearchBox> {
  final List<String> _hintTexts = [
    'Musician',
    'Dhol Artist',
    'Singer',
    'Band',
    'DJ'
  ]; // List of hint texts
  int _currentHintIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startHintTextAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _startHintTextAnimation() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentHintIndex = (_currentHintIndex + 1) % _hintTexts.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Material( // Wrap the TextField with Material
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: _hintTexts[_currentHintIndex],
              hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
