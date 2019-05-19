import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:addition/addition_game.dart';

abstract class Button {
  AdditionGame game;
  Rect rect;
  Sprite sprite;

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void onTapDown();

  void update(double t);
}