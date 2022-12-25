import 'dart:io';

void main(List<String> args) {
  print('--- Day  3: Rucksack Reorganization ---');

  final filename = args.isNotEmpty ? args[0] : './lib/day3/input.txt';
  final input = File(filename).readAsLinesSync();
  final listOfPriorities = toListOfPriorities(input);
  var part1 = 0;
  for (List<int> priorities in listOfPriorities) {
    var middleIndex = priorities.length ~/ 2;
    var left = priorities.take(middleIndex);
    var right = priorities.skip(middleIndex);
    var overlap = left.where((e) => right.contains(e)).toList();
    part1 += overlap[0];
  }
  print('    Part 1: $part1');

  var part2 = 0;
  for (var i = 0; i < listOfPriorities.length; i++) {
    if (i > 0 && i % 3 == 2) {
      var rucksack1 = listOfPriorities[i - 2];
      var rucksack2 = listOfPriorities[i - 1];
      var rucksack3 = listOfPriorities[i];
      var inRucksack1And2 = rucksack1
          .where((element) => rucksack2.contains(element))
          .toList();
      var inAllRucksacks = rucksack3
          .where((element) => inRucksack1And2.contains(element))
          .toList();
      part2 += inAllRucksacks[0];
    }
  }

  print('    Part 1: $part2');
}

// -----------------------------------------------------------------------------
// From https://adventofcode.com/2022/day/3
//
//     Every item type can be converted to a priority:
//
//     Lowercase item types a through z have priorities 1 through 26.
//     Uppercase item types A through Z have priorities 27 through 52.
//
// -----------------------------------------------------------------------------
//
// The character value of 'a' is 97
// The character value of 'A' is 65
//
// A lowercase letter can be identified with 'character value > 96'
//
// The priority of 'a' should be 1, so we should subtract 96 from the char value
// The priority of 'A' should be 27, so we should subtract …
// 65 - x = 27
// x = 65 - 27
// x = 38
// …from the char value
//
// -----------------------------------------------------------------------------
final List<List<int>> Function(List<String>) toListOfPriorities =
    (List<String> lines) => lines
        .map((e) => e.runes.map((c) => c > 96 ? (c - 96) : (c - 38)).toList())
        .toList();
