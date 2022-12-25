// https://adventofcode.com/2021/day/11
import 'dart:io';

import 'matrix.dart';
import 'point.dart';

// PS Visualized this one in a Flutter app here: https://dartpad.dev/?id=ee72b5d43fb6455a24c465121565511f
void main() {
  print('--- Day 11: Dumbo Octopus ---');

  final matrix = File('input.txt')
      .readAsLinesSync()
      .map((e) => e.split('').map((e) => int.parse(e)).toList(growable: false))
      .toList(growable: false);

  var popCount = 0;
  for (int i = 0; i < 100; i++) {
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
      popCount += flashes.length;
    }
  }

  print('    Part 1: $popCount');
}
