// https://adventofcode.com/2021/day/14
import 'dart:io';

void main() {
  print('--- Day 14: Extended Polymerization ---');

  final lines = File('input.txt').readAsLinesSync();
  var template = lines[0];
  lines.removeAt(0);
  lines.removeAt(0);
  var rules = <String, Rule>{};
  lines.forEach((line) {
    var rule = Rule.fromList(line.split(' -> '));
    rules[rule.pair] = rule;
  });

  for(int s = 0; s < 10; s++) {
    var newTemplate = '';
    for(int i = 0; i < template.length - 1; i++) {
      var element = template.substring(i, i+2);
      newTemplate += rules[element]?.replacement ?? element;
    }
    newTemplate += template.substring(template.length-1,template.length);
    template = newTemplate;
  }

  var sums = <String, int>{};
  template.split('').forEach((element) {sums[element] = (sums[element] ?? 0) + 1;});

  var min = sums.values.fold<int>(0, (previousValue, element) {
    if (previousValue == 0 || element < previousValue) previousValue = element;
    return previousValue;
  });

  var max = sums.values.fold<int>(0, (previousValue, element) {
    if (previousValue == 0 || element > previousValue) previousValue = element;
    return previousValue;
  });

  print('    Part 1: ${max - min}');
}

class Rule {
  Rule(this.pair, this.replacement);

  String pair;
  String replacement;

  Rule.fromList(List<String> list)
      : this(list[0], list[0].substring(0,1)+list[1]);
}
