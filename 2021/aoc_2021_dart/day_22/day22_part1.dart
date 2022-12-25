// https://adventofcode.com/2021/day/22
import 'dart:io';

import 'utils.dart';

void main() {
  print('--- Day 22: Reactor Reboot ---');

  final bootStepSequence = File('input.txt')
      .readAsLinesSync()
      .map(BootStep.fromString)
      .where((bootStep) =>
          bootStep.intersects(Cuboid(Point(-50, -50, -50), Point(50, 50, 50))))
      .toList();

  int on = 0;

  for (int x = -50; x <= 50; x++) {
    for (int y = -50; y <= 50; y++) {
      for (int z = -50; z <= 50; z++) {
        State state = State.off;
        Point point = Point(x, y, z);
        bootStepSequence
            .where((bootStep) => bootStep.cuboid.contains(point))
            .forEach((bootStep) {
          state = bootStep.action;
        });
        if (state == State.on) on++;
      }
    }
  }

  print('    Part 1: ${on}');
}
