// https://adventofcode.com/2021/day/22
import 'dart:io';

import 'utils.dart';

void main() {
  final bootSeq =
      File('input.txt').readAsLinesSync().map(BootStep.fromString).toList();

  var cuboids = <Cuboid>[];

  for (int i = 0; i < bootSeq.length; i++) {
    if (cuboids.isEmpty && bootSeq[i].action == State.on) {
      cuboids.add(bootSeq[i].cuboid);
      continue;
    }
    cuboids = cuboids.minus(bootSeq[i].cuboid);
    if (bootSeq[i].action == State.on) {
      cuboids.add(bootSeq[i].cuboid);
    }
  }

  print('    Part 2: ${cuboids.size()}');
}
