import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  print('--- Day 24: Blizzard Basin ---');

  final filename = args.isNotEmpty ? args[0] : './lib/day24/input.txt';
  final input = File(filename).readAsLinesSync();

  final blizzards = <Blizzard>[];
  for (var y = 1; y < input.length - 1; y++) {
    for (var x = 1; x < input[y].length - 1; x++) {
      if (input[y][x] != '.') blizzards.add(Blizzard(Point(x - 1, y - 1), input[y][x]));
    }
  }

  final gridHeight = input.length - 2;
  final gridWidth = input[0].length - 2;

  var expeditions = <Point<int>>{};
  var minutes = 1;
  var startPoint = Point(0, 0);
  var goalPoint = Point(gridWidth - 1, gridHeight - 1);
  var part1Solved = false;
  var reachedTheStartAgain = false;
  while (true) {
    // All the blizzards move in their own direction
    for (var blizzard in blizzards) {
      switch (blizzard.direction) {
        case '>':
          blizzard.position = Point((blizzard.position.x + 1) % gridWidth, blizzard.position.y);
          break;
        case 'v':
          blizzard.position = Point(blizzard.position.x, (blizzard.position.y + 1) % gridHeight);
          break;
        case '<':
          blizzard.position = Point((blizzard.position.x - 1) % gridWidth, blizzard.position.y);
          break;
        case '^':
          blizzard.position = Point(blizzard.position.x, (blizzard.position.y - 1) % gridHeight);
          break;
      }
    }

    // Analyze blizzards to find next positions for expeditions still in play or…
    var newExpeditions = <Point<int>>{};
    var currentExpeditions = List.of(expeditions);
    for (var i = expeditions.length - 1; i >= 0; i--) {
      if (currentExpeditions[i].x > 0 &&
          blizzards
              .where((element) => element.position == Point(currentExpeditions[i].x - 1, currentExpeditions[i].y))
              .isEmpty) expeditions.add(Point(currentExpeditions[i].x - 1, currentExpeditions[i].y));
      if (currentExpeditions[i].x < gridWidth - 1 &&
          blizzards
              .where((element) => element.position == Point(currentExpeditions[i].x + 1, currentExpeditions[i].y))
              .isEmpty) expeditions.add(Point(currentExpeditions[i].x + 1, currentExpeditions[i].y));
      if (currentExpeditions[i].y > 0 &&
          blizzards
              .where((element) => element.position == Point(currentExpeditions[i].x, currentExpeditions[i].y - 1))
              .isEmpty) expeditions.add(Point(currentExpeditions[i].x, currentExpeditions[i].y - 1));
      if (currentExpeditions[i].y < gridHeight - 1 &&
          blizzards
              .where((element) => element.position == Point(currentExpeditions[i].x, currentExpeditions[i].y + 1))
              .isEmpty) expeditions.add(Point(currentExpeditions[i].x, currentExpeditions[i].y + 1));
      // If there's a blizzard at the current expedition position we can't stay here, so we either should have moved in
      // one of the steps above or we're killed 🪦
      if (blizzards.any((element) => element.position == currentExpeditions[i]))
        expeditions.remove(currentExpeditions[i]);
    }
    expeditions.addAll(newExpeditions);

    // …start a new expedition at the start point
    if (blizzards.where((element) => element.position == startPoint).isEmpty) expeditions.add(startPoint);

    minutes++;

    // See if we have any expeditions near the exit
    if (expeditions.contains(goalPoint)) {
      if (!part1Solved) {
        print('    Part 1: $minutes');
        part1Solved = true;
        startPoint = Point(gridWidth - 1, gridHeight - 1);
        goalPoint = Point(0, 0);
        expeditions.clear();
      } else if (!reachedTheStartAgain) {
        reachedTheStartAgain = true;
        startPoint = Point(0, 0);
        goalPoint = Point(gridWidth - 1, gridHeight - 1);
        expeditions.clear();
      } else {
        print('    Part 2: $minutes');
        break;
      }
    }
  }
}

class Blizzard {
  Blizzard(this.position, this.direction);

  Point<int> position;
  String direction;
}
