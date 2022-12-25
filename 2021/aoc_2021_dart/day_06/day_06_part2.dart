// https://adventofcode.com/2021/day/6
import 'dart:io';

void main() {
  List<int> fish = File('input.txt')
      .readAsStringSync()
      .split(',')
      .map((e) => int.parse(e))
      .toList(growable: true);
  List<int> sums = List.filled(9, 0);
  fish.forEach((element) {
    sums[element] = sums[element] + 1;
  });

  for (int i = 0; i < 256; i++) {
    final nrOfZeroes = sums[0];
    for (int j = 0; j < 8; j++) {
      sums[j] = sums[j + 1];
    }
    sums[6] = sums[6] + nrOfZeroes;
    sums[8] = nrOfZeroes;
  }

  final answer =
      sums.fold<int>(0, (previousValue, element) => previousValue + element);

  print('    Part 2: ${answer}');
}
