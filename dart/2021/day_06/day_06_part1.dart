// https://adventofcode.com/2021/day/6
import 'dart:io';

void main() {
  print('--- Day 6: Lanternfish ---');

  List<int> fish = File('input.txt')
      .readAsStringSync()
      .split(',')
      .map((e) => int.parse(e))
      .toList(growable: true);

  for(int i=0; i < 80; i++) {
    final nrOfZeroes = fish.fold<int>(0, (previousValue, element) => previousValue + (element == 0 ? 1 : 0));
    for(int j=0; j < fish.length; j++) {
      if (fish[j] == 0) {
        fish[j] = 6;
      } else {
        fish[j] = fish[j] - 1;
      }
    }
    for(int i=0; i < nrOfZeroes; i++) {
      fish.add(8);
    }
  }

  print('    Part 1: ${fish.length}');
}
