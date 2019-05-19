
import 'package:addition/controllers/number_button_manager.dart';

class ReadoutStyler {

  NumberButtonManager generator;

  final int colourLevelMultiplier = 100;
  final int colourLevelBands = 9;

  ReadoutStyler(this.generator);

  num countdown() => ((generator.timesUp - DateTime.now().millisecondsSinceEpoch)/1000).round();

  num _colourLevel(num value, num min, num maximum, bool ascending) {
    if (min == null || maximum == null || value == null) return colourLevelMultiplier;
    if (min == maximum || value > maximum) return colourLevelMultiplier;
    num normalised = (((value - min) * colourLevelBands) ~/ (maximum - min)) + 1;
    return colourLevelMultiplier * (ascending ? normalised : (colourLevelBands + 1) - normalised);
  }

  num scoreColourLevel() => _colourLevel(generator.game.score, 0, 20, true);

  num targetColourLevel() => _colourLevel(generator.progressTotal, 0, generator.target, true);

  num countdownColourLevel() => _colourLevel(countdown(), 0, 60, false);

}