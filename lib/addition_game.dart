import 'dart:ui';
import 'package:addition/views/help_view.dart';
import 'package:device_info/device_info.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';
import 'package:addition/views/background.dart';
import 'package:addition/components/score_display.dart';
import 'package:addition/components/start_button.dart';
import 'package:addition/controllers/number_button_manager.dart';
import 'package:addition/outcome.dart';
import 'package:addition/views/view.dart';
import 'package:addition/views/title_view.dart';
import 'package:addition/views/lost_view.dart';

import 'components/button.dart';
import 'components/help_button.dart';

class AdditionGame extends Game {
  Size screenSize; // Size has floating-point width and height
  double tileSize; // will hold value of screen width/9
  bool iPadFlag;

  Background background;

  int score;

  View activeView = View.title;
  TitleView titleView;
  LostView lostView;
  HelpView helpView;
  StartButton startButton;
  HelpButton helpButton;
  ScoreDisplay scoreDisplay;

  NumberButtonManager generator;

  AdditionGame() {
    initialise();
  }

  void initialise() async {
    // async since has to wait for screen size
    score = 0;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    iPadFlag = iosInfo.name.toLowerCase().contains("ipad");

    resize(await Flame.util.initialDimensions()); // returns a Future<Size>, so
    // we wait for Future to complete and get a Size which we plug into resize()

    generator = NumberButtonManager(this);
    background = Background(this);
    titleView = TitleView(this);
    lostView = LostView(this);
    helpView = HelpView(this);
    startButton = StartButton(this);
    helpButton = HelpButton(this);
    scoreDisplay = ScoreDisplay(this);
  }

  // the next 3 methods override Game class's methods

  @override
  void render(Canvas canvas) {
    if (scoreDisplay == null) return;
    background.render(canvas);
    switch (activeView) {
      case View.title:
        titleView.render(canvas);
        _renderButtons(canvas);
        break;
      case View.lost:
        lostView.render(canvas);
        _renderButtons(canvas);
        break;
      case View.playing:
        generator.render(canvas);
        scoreDisplay.render(canvas);
        break;
      case View.help:
        helpView.render(canvas);
    }
  }

  @override
  void update(double t) {
    if (scoreDisplay == null) return;
    generator.update(t);
    if (activeView == View.playing) scoreDisplay.update(t);
  }

  @override
  void resize(Size size) {
    screenSize =
        size; // store new size passed by Flutter for later access
    tileSize = screenSize.width / 9;
  }

  void onTapDown(TapDownDetails d) {
    //TapDownDetails includes tap coords as Offset in globalPosition property
    bool isHandled = false;
    if (!isHandled && activeView == View.help) {
        activeView = View.title;
        isHandled = true;
    }
    isHandled = _checkButton(startButton, isHandled, d);
    isHandled = _checkButton(helpButton, isHandled, d);
    if (!isHandled) {
      generator.onTapDown(d);
      _evaluate();
    }
  }

  void _renderButtons(Canvas canvas) {
    helpButton.render(canvas);
    startButton.render(canvas);
  }

  bool _checkButton(Button button, bool isHandled, TapDownDetails d) {
    if (!isHandled && button.rect.contains(d.globalPosition)) {
      if (activeView == View.title || activeView == View.lost) {
        button.onTapDown();
        isHandled = true;
      }
    }
    return isHandled;
  }

  void gameOver() {
    activeView = View.lost;
    score = 0;
    generator.resetGoals();
  }

  void _evaluate() {
    switch (generator.evaluate()) {
      case Outcome.failure:
        Flame.audio.play('sfx/down.mp3');
        if (--score < 0) {
          gameOver();
        } else {
          generator.resetGoals();
        }
        break;
      case Outcome.success:
        Flame.audio.play('sfx/up.mp3');
        score++;
        generator.resetGoals();
        break;
      case Outcome.still_in_progress:
    }
  }
}
