import 'dart:io';

void main(List<String> args) {
  print('--- Day  1: Calorie Counting ---');
  
  final filename = args.isNotEmpty ? args[0] : './lib/day1/input.txt';
  final input = File(filename).readAsLinesSync();
  var sums = sumsParser(input);
  var part1 = sums[sums.length - 1];
  print('    Part 1: ${part1}');

  final part2 = sums.reversed
      .toList()
      .getRange(0, 3)
      .fold(0, (previousValue, element) => previousValue + element);
  print('    Part 2: ${part2}');
}

final List<int> Function(List<String>) sumsParser = (input) {
  List<int> sums = [];
  var sum = 0;
  for (String line in input) {
    if (line.isEmpty) {
      sums.add(sum);
      sum = 0;
    } else {
      sum += int.parse(line);
    }
  }
  sums.add(sum);

  sums.sort();
  return sums;
};
