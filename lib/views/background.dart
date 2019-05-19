import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:addition/addition_game.dart';

class Background {
  final AdditionGame game;
  Sprite bgSprite;
  Rect bgRect;

  Background(this.game) {
    bgSprite = Sprite('bg/background.png');
    bgRect = Rect.fromLTWH(
      0,
      game.screenSize.height - (game.tileSize * 23),
      game.tileSize * 9,
      game.tileSize * 23,
    );
  }

  void render(Canvas c) {
    bgSprite.renderRect(c, bgRect);
  }

  void update(double t) {}
}