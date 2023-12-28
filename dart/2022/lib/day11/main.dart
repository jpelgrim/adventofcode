void main(List<String> args) {
  print('--- Day 11: Monkey in the Middle ---');

  final part1 = solvePuzzle(inputMonkeys(), 20, true);
  print('    Part 1: $part1');

  final part2 = solvePuzzle(inputMonkeys(), 10000, false);
  print('    Part 2: $part2');
}

int solvePuzzle(List<Monkey> input, int rounds, bool worried) {
  final monkeys = List.of(input);
  final commonMultiple = monkeys.fold(1, (p, monkey) => p * monkey.divider);

  for (var round = 1; round <= rounds; round++) {
    for (var monkey in monkeys) {
      for (var item in monkey.items) {
        monkey.inspections++;
        final newWorryLevel =
            (monkey.operation(item) % commonMultiple) ~/ (worried ? 3 : 1);
        if (newWorryLevel % monkey.divider == 0) {
          monkeys[monkey.trueIndex].add(newWorryLevel);
        } else {
          monkeys[monkey.falseIndex].add(newWorryLevel);
        }
      }
      monkey.items.clear();
    }
  }

  final inspections = monkeys.map((e) => e.inspections).toList()..sort();
  return inspections.removeLast() * inspections.removeLast();
}

class Monkey {
  Monkey(
    this.items,
    this.operation,
    this.divider,
    this.trueIndex,
    this.falseIndex,
  );

  final List<int> items;
  final int Function(int) operation;
  final int divider;
  final int trueIndex;
  final int falseIndex;
  int inspections = 0;

  void add(int item) => items.add(item);
}

List<Monkey> inputMonkeys() => [
      Monkey([77, 69, 76, 77, 50, 58], (old) => old * 11, 5, 1, 5),
      Monkey([75, 70, 82, 83, 96, 64, 62], (old) => old + 8, 17, 5, 6),
      Monkey([53], (old) => old * 3, 2, 0, 7),
      Monkey([85, 64, 93, 64, 99], (old) => old + 4, 7, 7, 2),
      Monkey([61, 92, 71], (old) => old * old, 3, 2, 3),
      Monkey([79, 73, 50, 90], (old) => old + 2, 11, 4, 6),
      Monkey([50, 89], (old) => old + 3, 13, 4, 3),
      Monkey([83, 56, 64, 58, 93, 91, 56, 65], (old) => old + 5, 19, 1, 0),
    ];
