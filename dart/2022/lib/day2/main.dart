import 'dart:io';

void main(List<String> args) {
  print('--- Day  2: Rock Paper Scissors ---');

  final filename = args.isNotEmpty ? args[0] : './lib/day2/input.txt';
  final input = File(filename).readAsLinesSync();
  var games = rpsParser(input);
  var part1 = processGameList(games);
  print('    Part 1: $part1');

  games = rpsStrategyParser(input);
  var part2 = processGameList(games);
  print('    Part 2: $part2');
}

enum RPS {
  Rock,
  Paper,
  Scissors
}

int processGameList(List<List<RPS>> input) {
  return input.fold(0, (previousValue, element) {
      var score = 0;
      score += gameResult(element);
      score += handValue(element);
      return previousValue + score;
    });
}

int gameResult(List<RPS> element) {
  switch (element[1]) {
    case RPS.Rock:
      switch (element[0]) {
        case RPS.Rock:
          return 3;
        case RPS.Paper:
          return 0;
        case RPS.Scissors:
          return 6;
      }
    case RPS.Paper:
      switch (element[0]) {
        case RPS.Rock:
          return 6;
        case RPS.Paper:
          return 3;
        case RPS.Scissors:
          return 0;
      }
    case RPS.Scissors:
      switch (element[0]) {
        case RPS.Rock:
          return 0;
        case RPS.Paper:
          return 6;
        case RPS.Scissors:
          return 3;
      }
  }
}

int handValue(List<RPS> element) => element[1].index + 1;

// Parser for part 1
final List<List<RPS>> Function(List<String>) rpsParser = (input) => input
    .map((e) => e.split(' ').map((e) {
          if (e == 'A' || e == 'X') return RPS.Rock;
          if (e == 'B' || e == 'Y') return RPS.Paper;
          return RPS.Scissors;
        }).toList())
    .toList();

// Parser for part 2
final List<List<RPS>> Function(List<String>) rpsStrategyParser =
    (input) => input.map((e) {
          var instruction = e.split(' ');
          final otherHand = instruction[0] == 'A'
              ? RPS.Rock
              : instruction[0] == 'B'
                  ? RPS.Paper
                  : RPS.Scissors;
          switch (instruction[1]) {
            case 'X':
              // Need to lose
              switch (otherHand) {
                case RPS.Rock:
                  return [RPS.Rock, RPS.Scissors];
                case RPS.Paper:
                  return [RPS.Paper, RPS.Rock];
                case RPS.Scissors:
                  return [RPS.Scissors, RPS.Paper];
              }
            case 'Y':
              // Need to draw
              switch (otherHand) {
                case RPS.Rock:
                  return [RPS.Rock, RPS.Rock];
                case RPS.Paper:
                  return [RPS.Paper, RPS.Paper];
                case RPS.Scissors:
                  return [RPS.Scissors, RPS.Scissors];
              }
            default:
              // Need to win
              switch (otherHand) {
                case RPS.Rock:
                  return [RPS.Rock, RPS.Paper];
                case RPS.Paper:
                  return [RPS.Paper, RPS.Scissors];
                case RPS.Scissors:
                  return [RPS.Scissors, RPS.Rock];
              }
          }
        }).toList();
