import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_notes/helpers/loaders/loading_screen_controller.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen() => _shared;

  LoadingScreenController? controller;

  void hide() {
    controller?.close();
    controller = null;
  }

  void show({required BuildContext context}) {
    if (controller != null) {
      return;
    } else {
      controller = showOverlay(context: context);
    }
  }

  LoadingScreenController showOverlay({required BuildContext context}) {
    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.white.withAlpha(150),
          child: Center(
            child: SpinKitFoldingCube(
              color: Theme.of(context).colorScheme.primary,
              size: size.width * .35,
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        overlay.remove();
        return true;
      },
    );
  }
}
