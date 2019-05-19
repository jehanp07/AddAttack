import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:addition/addition_game.dart';

import 'readout_styler.dart';

class ScoreDisplay {
  final AdditionGame game;
  ReadoutStyler presenter;
  TextPainter targetPainter, scorePainter, countdownPainter;
  Offset targetPosition, scorePosition, countdownPosition;

  ScoreDisplay(this.game) {
    presenter = ReadoutStyler(game.generator);
    targetPainter = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    scorePainter = TextPainter(
        textAlign: TextAlign.right, textDirection: TextDirection.ltr);
    countdownPainter = TextPainter(
        textAlign: TextAlign.left, textDirection: TextDirection.ltr);

    scorePosition = Offset.zero;
    countdownPosition = Offset.zero;
    targetPosition = Offset.zero;
  }

  void render(Canvas c) {
    targetPainter.paint(c, targetPosition);
    scorePainter.paint(c, scorePosition);
    countdownPainter.paint(c, countdownPosition);
  }

  void update(double t) {
    num screenWidth = game.screenSize.width;
    num screenHeight = game.screenSize.height;

    String target = game.generator.target.toString() +
        ((game.score < 4)
            ? " : " + game.generator.progressTotal.toString()
            : "");

    TextStyle scoreStyle =
        _styleWithShadows(70, Colors.amber[presenter.scoreColourLevel()]);
    TextStyle targetStyle =
        _styleWithShadows(90, Colors.green[presenter.targetColourLevel()]);
    TextStyle countdownStyle =
        _styleWithShadows(50, Colors.red[presenter.countdownColourLevel()]);

    _updateNumberDisplay(game.score.toString(), scorePainter, scoreStyle);
    _updateNumberDisplay(target, targetPainter, targetStyle);
    _updateNumberDisplay(
        presenter.countdown().toString(), countdownPainter, countdownStyle);

    targetPosition = Offset((screenWidth / 2) - (targetPainter.width / 2),
        (screenHeight * .25) - (targetPainter.height / 2));
    scorePosition = Offset((screenWidth * .95) - scorePainter.width,
        (screenHeight * .95) - scorePainter.height);
    countdownPosition = Offset(
        (screenWidth * .05), (screenHeight * .95) - countdownPainter.height);
  }

  void _updateNumberDisplay(
      String displayNumber, TextPainter painter, TextStyle textStyle) {
    if ((painter.text?.text ?? '') != displayNumber) {
      painter.text = TextSpan(
        text: displayNumber,
        style: textStyle,
      );
      painter.layout();
    }
  }

  TextStyle _styleWithShadows(double fontSize, Color colour) {
    return TextStyle(
      color: colour,
      fontSize: fontSize,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 7,
          color: Color(0xff000000),
          offset: Offset(3, 3),
        ),
      ],
    );
  }
}
