import 'package:flutter/foundation.dart';

typedef CloseLoadingScreen = bool Function();

@immutable
class LoadingScreenController {
  final CloseLoadingScreen close;

  const LoadingScreenController({required this.close});



}
