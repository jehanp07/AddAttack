import 'dart:ui';
import 'package:addition/components/button.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:addition/controllers/number_button_manager.dart';

class NumberButton extends Button {
  NumberButtonManager generator;
  Rect numberRect;
  bool isSelected = false;
  bool isOffScreen = false;
  Sprite inactiveSprite;
  int value;
  double get speed => tileSize * (generator.game.iPadFlag ? 1.5 : 3);
  Offset destination;
  Size screenSize;
  double tileSize;

  NumberButton(this.generator, this.screenSize, this.tileSize) {
    game = generator.game;
    value = generator.generateNewValue();
    Offset location = _setNewLocation();
    double sizingFactor = game.iPadFlag ? 0.75 : 1.5;
    numberRect =
        Rect.fromLTWH(location.dx, location.dy,
            tileSize * sizingFactor, tileSize * sizingFactor);
    destination = _setNewLocation();
    _setSprites();
  }

  void render(Canvas c) {
    if (isSelected) {
      inactiveSprite.renderRect(c, numberRect.inflate(2));
    } else {
      sprite.renderRect(c, numberRect.inflate(2));
      // inflate creates a copy of the rectangle it was called on but inflated to a multiplier
    }
  }

  void update(double timeDelta) {
    if (isSelected) { // drop the button off the screen
      numberRect = numberRect.translate(0, tileSize * 12 * timeDelta);
    } else {
      double stepDistance = speed * timeDelta;  // step towards target
      Offset toTarget = destination - Offset(numberRect.left, numberRect.top);
      if (stepDistance < toTarget.distance) {
        Offset stepToTarget =
            Offset.fromDirection(toTarget.direction, stepDistance);
        numberRect = numberRect.shift(stepToTarget);
      } else {
        numberRect = numberRect.shift(toTarget);
        destination = _setNewLocation(); // if get to target, create new one.
      }

      if (numberRect.top > screenSize.height) {
        // +ve y direction is downward
        isOffScreen = true;
      }
    }
  }

  void onTapDown() {
    isSelected = true;
    generator.updateWith(value);
    generator.spawnNewNumber();
  }

  void refreshValue() {
    value = generator.generateNewValue();
    _setSprites();
  }

  void _setSprites() {
    sprite = Sprite('numbers/black/' + value.toString() + '-black.png');
    inactiveSprite = Sprite('numbers/gray/' + value.toString() + '-gray.png');
  }

  Offset _setNewLocation() {
    double x =
        generator.rnd.nextDouble() * (screenSize.width - (tileSize * 2.025));
    double y =
        generator.rnd.nextDouble() * (screenSize.height - (tileSize * 2.025));
    return Offset(x, y);
  }
}
