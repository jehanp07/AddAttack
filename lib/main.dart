import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:addition/addition_game.dart';

void main() async {    // converts main into async event so we can await long-running processes

  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  Flame.images.loadAll(<String>[
    'bg/background.png',
    'bg/lose.png',
    'branding/logo.png',
    'ui/dialog-help.png',
    'ui/icon-help.png',
    'ui/start_button.png',
  ]);
  Flame.audio.loadAll([
    'sfx/up.mp3',
    'sfx/down.mp3',
  ]);

  AdditionGame game = AdditionGame();
  runApp(game.widget);

  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = game.onTapDown; // link gesture recogniser's onTapDown property to the game class's onTapDown handler
  flameUtil.addGestureRecognizer(tapper);
}

