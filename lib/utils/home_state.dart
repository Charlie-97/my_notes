import 'package:flutter/material.dart';
import 'package:my_notes/services/crud/notes_service.dart';

class MyNotesState extends ChangeNotifier {
  bool loading = false;

  List<Widget> notesList = [];

  List<DatabaseNote> favorites = [];
  bool isFavourite = false;

  bool toggleFavourite() {
    isFavourite = !isFavourite;
    notifyListeners();
    return isFavourite;
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
