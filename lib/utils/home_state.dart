import 'package:flutter/material.dart';

class HomeState extends ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  void updateCounter(int newCounter) {
    _counter = newCounter;
    notifyListeners();
  }
}
