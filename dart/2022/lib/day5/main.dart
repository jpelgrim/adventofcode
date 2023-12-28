import 'dart:io';

void main(List<String> args) {
  print('--- Day  5: Supply Stacks ---');

  final filename = args.isNotEmpty ? args[0] : './lib/day5/input.txt';
  final input = File(filename).readAsLinesSync();
  var stackAndInstructions = toStacksAndInstructions(input);
  for (List<int> instruction in stackAndInstructions.instructions) {
    for (var i = 0; i < instruction[0]; i++) {
      stackAndInstructions.stacks[instruction[2] - 1]
          .add(stackAndInstructions.stacks[instruction[1] - 1].removeLast());
    }
  }

  var part1 = stackAndInstructions.stacks.map((e) => e.last).join('');
  print('    Part 1: $part1');

  stackAndInstructions = toStacksAndInstructions(input);
  var staging = List<String>.empty(growable: true);
  for (List<int> instruction in stackAndInstructions.instructions) {
    for (var i = 0; i < instruction[0]; i++) {
      staging.add(stackAndInstructions.stacks[instruction[1] - 1].removeLast());
    }
    while (staging.isNotEmpty) {
      stackAndInstructions.stacks[instruction[2] - 1].add(staging.removeLast());
    }
  }

  var part2 = stackAndInstructions.stacks.map((e) => e.last).join('');

  print('    Part 2: $part2');
}

class StacksAndInstructions {
  StacksAndInstructions(this.stacks, this.instructions);

  List<List<String>> stacks;

  List<List<int>> instructions;
}

final StacksAndInstructions Function(List<String>) toStacksAndInstructions =
    (List<String> input) {
  var nrOfStacksLine =
      input.where((element) => element.trim().startsWith('1')).toList()[0];
  var nrOfStacks = int.parse(nrOfStacksLine[nrOfStacksLine.length - 1]);
  var stacksReversed = input
      .where((e) => e.contains('['))
      .map((e) {
        var level = List<String>.generate(nrOfStacks, (index) => '');
        for (var i = 0; i < nrOfStacks; i++) {
          var index = 1 + (i * 4);
          if (index < e.length && e[index] != ' ') {
            level[i] = e[index];
          }
        }
        return level;
      })
      .toList()
      .reversed
      .toList();

  var stacks = List<List<String>>.generate(
      nrOfStacks, (index) => List<String>.empty(growable: true));
  for (var i = 0; i < stacksReversed.length; i++) {
    var row = stacksReversed[i];
    for (var j = 0; j < row.length; j++) {
      if (row[j] != '') stacks[j].add(row[j]);
    }
  }

  var instructions = input.where((e) => e.contains('move')).map((e) {
    var line = e.split(' ').toList();
    return [line[1], line[3], line[5]].map((e) => int.parse(e)).toList();
  }).toList();

  return StacksAndInstructions(stacks, instructions);
};
