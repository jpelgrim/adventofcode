// https://adventofcode.com/2021/day/1
import 'dart:io';

void main() {
  int nrOfIncrements = 0;
  final measurements = File('input.txt')
      .readAsLinesSync()
      .map((e) => int.parse(e))
      .toList();
  for (var i = 1; i < measurements.length - 2; i++) {
    final previousSum =
        measurements[i - 1] + measurements[i] + measurements[i + 1];
    final currentSum =
        measurements[i] + measurements[i + 1] + measurements[i + 2];
    if (currentSum > previousSum) {
      nrOfIncrements++;
    }
  }
  print('    Part 2: $nrOfIncrements');
}
