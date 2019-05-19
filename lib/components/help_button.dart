import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:addition/addition_game.dart';
import 'package:addition/views/view.dart';

import 'button.dart';

class HelpButton extends Button {
  final AdditionGame game;
  Rect rect;
  Sprite sprite;

  HelpButton(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * .25,
      game.screenSize.height - (game.tileSize * 1.25),
      game.tileSize,
      game.tileSize,
    );
    sprite = Sprite('ui/icon-help.png');
  }

  void onTapDown() {
    game.activeView = View.help;
  }

  @override
  void update(double t) {}
}