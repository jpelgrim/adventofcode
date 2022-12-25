// https://adventofcode.com/2021/day/11
import 'dart:io';

import 'matrix.dart';
import 'point.dart';

void main() {
  final matrix = File('input.txt')
      .readAsLinesSync()
      .map((e) => e.split('').map((e) => int.parse(e)).toList(growable: false))
      .toList(growable: false);

  var stepCount = 0;
  do {
    stepCount++;
    final flashes = matrix.increaseEnergy();
    if (flashes.isNotEmpty) {
      final previousFlashes = Set<Point>.from(flashes);
      do {
        final newFlashes = matrix.flashNeighbours(previousFlashes);
        if (newFlashes.length == 0) {
          break;
        }
        previousFlashes.clear();
        previousFlashes.addAll(newFlashes);
        flashes.addAll(newFlashes);
      } while (true);
    }

    if (matrix.allZeroes()) break;
  } while (true);

  print('    Part 2: $stepCount');
}

