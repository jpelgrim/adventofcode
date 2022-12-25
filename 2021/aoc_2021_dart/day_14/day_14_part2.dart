// https://adventofcode.com/2021/day/14
import 'dart:io';

void main() {
  final lines = File('input.txt').readAsLinesSync();
  var template = lines[0];
  lines.removeAt(0);
  lines.removeAt(0);
  var rules = <String, Rule>{};
  lines.forEach((line) {
    var rule = Rule.fromList(line.split(' -> '));
    rules[rule.pair] = rule;
  });

  var firstChar = template[0];
  var lastChar = template[template.length-1];

  var pairSums = <String, int>{};

  for (int i=0; i < template.length -1; i++) {
    pairSums[template.substring(i, i+2)] = (pairSums[template.substring(i, i+2)] ?? 0) + 1;
  }

  for (int i = 0; i < 40; i++) {
    pairSums = evolve(pairSums, rules);
  }

  var charSums = <String, int>{};
  pairSums.keys.forEach((key) {
    charSums[key[0]] = (charSums[key[0]] ?? 0) + (pairSums[key] ?? 0);
    charSums[key[1]] = (charSums[key[1]] ?? 0) + (pairSums[key] ?? 0);
  });

  charSums[firstChar] = charSums[firstChar]! + 1;
  charSums[lastChar] = charSums[lastChar]! + 1;

  charSums.keys.forEach((key) {
    charSums[key] = charSums[key]! ~/ 2;
  });

  var min = charSums.values.fold<int>(0, (previousValue, element) {
    if (previousValue == 0 || element < previousValue) previousValue = element;
    return previousValue;
  });

  var max = charSums.values.fold<int>(0, (previousValue, element) {
    if (previousValue == 0 || element > previousValue) previousValue = element;
    return previousValue;
  });

  var answer = max - min;
  print('    Part 2: ${answer}');
}

Map<String, int> evolve(Map<String, int> sums, Map<String, Rule> rules) {
  final newSums = <String, int>{};
  sums.keys.forEach((key) {
    newSums[key[0] + rules[key]!.replacement] = (newSums[key[0] + rules[key]!.replacement] ?? 0) + sums[key]!;
    newSums[rules[key]!.replacement + key[1]] = (newSums[rules[key]!.replacement + key[1]] ?? 0) + sums[key]!;
  });
  return newSums;
}

class Rule {
  Rule(this.pair, this.replacement);

  String pair;
  String replacement;

  Rule.fromList(List<String> list)
      : this(list[0], list[1]);

  @override
  String toString() {
    return '$pair->$replacement';
  }
}
