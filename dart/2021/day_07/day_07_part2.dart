// https://adventofcode.com/2021/day/7
import 'dart:io';

import 'dart:math';

void main() {
  List<int> positions = File('input.txt')
      .readAsStringSync()
      .split(',')
      .map((e) => int.parse(e))
      .toList();
  final low = positions.fold<int>(
      0,
      (previousValue, element) =>
          (previousValue == 0 || element < previousValue)
              ? element
              : previousValue);

  final high = positions.fold<int>(
      0,
      (previousValue, element) =>
          (previousValue == 0 || element > previousValue)
              ? element
              : previousValue);
  var leastAmountOfFuel = 0;
  for (int i = low; i < high; i++) {
    final amountOfFuel =
        calculateAmountOfFuel(position: i, positions: positions);
    if (leastAmountOfFuel == 0 || amountOfFuel < leastAmountOfFuel)
      leastAmountOfFuel = amountOfFuel;
  }

  print('    Part 2: ${leastAmountOfFuel}');
}

int calculateAmountOfFuel(
        {required int position, required List<int> positions}) =>
    positions.fold<int>(0, (previousValue, element) {
      var sum = previousValue;
      var from = min(element, position);
      var to = max(element, position);
      for (int i = from, cost = 1; i < to; i++, cost++) {
        sum += cost;
      }
      return sum;
    });
