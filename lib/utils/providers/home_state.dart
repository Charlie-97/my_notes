import 'package:flutter/material.dart';

class MyNotesState extends ChangeNotifier {
  bool loading = false;

  List<Widget> notesList = [];

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

  bool isReversed = true;
  void reverseOrder() {
    isReversed = !isReversed;
    notifyListeners();
  }

  bool isLongPressed = false;
  void longPressed() {
    isLongPressed = true;
    notifyListeners();
  }
}
