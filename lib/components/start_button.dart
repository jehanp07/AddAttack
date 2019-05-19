import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:addition/addition_game.dart';
import 'package:addition/views/view.dart';

import 'button.dart';

class StartButton extends Button {
  final AdditionGame game;
  Rect rect;
  Sprite sprite;

  StartButton(this.game) {
    if (game.iPadFlag) {
      rect = Rect.fromLTWH(
        game.tileSize * 3,
        (game.screenSize.height * .75) - (game.tileSize * 0.75),
        game.tileSize * 3,
        game.tileSize * 1.5,
      );
    } else {
      rect = Rect.fromLTWH(
        game.tileSize * 1.5,
        (game.screenSize.height * .75) - (game.tileSize * 1.5),
        game.tileSize * 6,
        game.tileSize * 3,
      );
    }
    sprite = Sprite('ui/start_button.png');
  }

  @override
  void onTapDown() {
    game.activeView = View.playing;
    game.generator.start();
    game.score = 0;
  }

  @override
  void update(double t) {}

}