import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:addition/addition_game.dart';

class TitleView {
  final AdditionGame game;
  Rect titleRect;
  Sprite titleSprite;

  TitleView(this.game) {
    titleRect = Rect.fromLTWH(
      game.tileSize,
      (game.screenSize.height / 2) - (game.tileSize * 4),
      game.tileSize * 7,
      game.tileSize * 4,
    );
    titleSprite = Sprite('branding/logo.png');
  }

  void render(Canvas c) {
    titleSprite.renderRect(c, titleRect);
  }

  void update(double t) {}
}