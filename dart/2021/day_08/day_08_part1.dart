// https://adventofcode.com/2021/day/8
import 'dart:io';

void main() {
  print('--- Day 8: Seven Segment Search ---');

  List<List<String>> inputs = List.empty(growable: true);
  List<List<String>> outputs = List.empty(growable: true);

  File('input.txt').readAsLinesSync().forEach((line) {
    final inputOutput = line.split(' | ');
    inputs.add(inputOutput[0].split(' '));
    outputs.add(inputOutput[1].split(' '));
  });

  //  0:6     1:2     2:5     3:5     4:4
  //   aaaa    ....    aaaa    aaaa    ....
  //  b    c  .    c  .    c  .    c  b    c
  //  b    c  .    c  .    c  .    c  b    c
  //   ....    ....    dddd    dddd    dddd
  //  e    f  .    f  e    .  .    f  .    f
  //  e    f  .    f  e    .  .    f  .    f
  //  gggg     ....    gggg    gggg    ....
  //
  //  5:5      6:6     7:3     8:7     9:6
  //   aaaa     aaaa    aaaa    aaaa    aaaa
  //  b     .  b    .  .    c  b    c  b    c
  //  b    .   b    .  .    c  b    c  b    c
  //   dddd     dddd    ....    dddd    dddd
  //  .    f   e    f  .    f  e    f  .    f
  //  .    f   e    f  .    f  e    f  .    f
  //   gggg     gggg    ....    gggg    gggg

  // Digits with 2,3,4 and 7 segments are unique

  final answer = outputs.fold<int>(0, (previousValue, output) {
    return previousValue + output.fold<int>(0, (previousValue, digit) => [2,3,4,7].contains(digit.length) ? 1 + previousValue : previousValue);
  });

  print('    Part 1: $answer');
}
