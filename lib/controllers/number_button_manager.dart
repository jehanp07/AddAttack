import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:addition/components/number_button.dart';
import 'package:addition/addition_game.dart';
import 'package:addition/outcome.dart';

class NumberButtonManager {
  final AdditionGame game;
  Random rnd = Random();

  final maxSpawnInterval = 5000;
  final minSpawnInterval = 1000;
  final maxNumbersOnScreen = 5;
  final minRoundDurationInMs = 30000;
  final maxButtonValue = 50;
  final maxTargetValue = 300;

  int target, progressTotal, timesUp;
  int nextGenerate = 0;
  List<NumberButton> numbers = List();

  NumberButtonManager(this.game) {
    resetGoals();
  }

  void start() {
    // called when start button pressed
    resetGoals();
    nextGenerate = DateTime.now().millisecondsSinceEpoch + _buttonLifespan();
  }

  void resetGoals() {
    // called after each round
    timesUp = DateTime.now().millisecondsSinceEpoch +
        minRoundDurationInMs +
        max((30 - game.score) * 1000, 0);
    progressTotal = 0;
    target =
        _generateNewTarget();
    numbers.forEach((NumberButton number) => number.isOffScreen = true);
    _spawnNewNumbers();
  }

  void update(double t) {
    numbers.forEach((number) => number.update(t));
    numbers.removeWhere((number) => number.isOffScreen);

    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (nowTimestamp > timesUp) game.gameOver();

    if (nowTimestamp >= nextGenerate) {
      numbers
          .where((number) => !number.isSelected)
          .forEach((number) => number.refreshValue());
      nextGenerate = nowTimestamp + _buttonLifespan();
    }
  }

  void render(canvas) =>
      numbers.forEach((NumberButton number) => number.render(canvas));

  void onTapDown(TapDownDetails d) {
    for (int i = numbers.length-1; i >=0 ; i--)
      if (numbers[i].numberRect.contains(d.globalPosition)) {
        numbers[i].onTapDown();
        break;
      }
  }

  void updateWith(int selectedNumber) {
    this.progressTotal += selectedNumber;
  }

  int _buttonLifespan() {
    // level 0 -> 5s, level 20 -> 1s
    return max(minSpawnInterval, maxSpawnInterval -
        game.score * (maxSpawnInterval - minSpawnInterval)~/20);
  }

  Outcome evaluate() {
    if (DateTime.now().millisecondsSinceEpoch > timesUp) return Outcome.failure;
    if (progressTotal > target) return Outcome.failure;
    if (progressTotal == target) return Outcome.success;
    return Outcome.still_in_progress;
  }

  int generateNewValue() =>
      rnd.nextInt(max(min((target - progressTotal) * 2, maxButtonValue), 5)) + 1;

  int _generateNewTarget() => min((game.score + 1) * 20, 200) +
      min(rnd.nextInt((game.score + 1) * 10 + 1),
      rnd.nextInt(maxTargetValue));

  void spawnNewNumber() =>
      numbers.add(NumberButton(this, game.screenSize, game.tileSize));

  void _spawnNewNumbers() {
    for (int i = 0; i < maxNumbersOnScreen; i++) spawnNewNumber();
  }
}
