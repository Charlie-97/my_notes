import 'package:flutter/material.dart';

class MyNotesState extends ChangeNotifier {
  int _counter = 0;
  bool loading = false;
  int get counter => _counter;

  List<Widget> notesList = [];

  void updateCounter() {
    _counter++;
    notifyListeners();
  }

  void startLoader() {
    loading = true;
    notifyListeners();
  }

  void stopLoader() {
    loading = false;
    notifyListeners();
  }

  void refresh() async {
    startLoader();
    await Future.delayed(const Duration(seconds: 3));
    startLoader();
    notifyListeners();
  }
}
