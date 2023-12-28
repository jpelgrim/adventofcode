import 'dart:io';

void main(List<String> args) {
  print('--- Day 10: Cathode-Ray Tube ---');

  final filename = args.isNotEmpty ? args[0] : './lib/day10/input.txt';
  final input = File(filename).readAsLinesSync();

  var result = <int>[1, 1];
  for (var i = 0; i < input.length; i++) {
    result.add(result.last);
    if (input[i].startsWith('addx')) {
      result.add(result.last + int.parse(input[i].substring(5)));
    }
  }

  var part1 = 0;
  for (var p = 20; p <= 220; p += 40) {
    part1 += result[p] * p;
  }
  print('    Part 1: ${part1}');

  var screen = List.generate(6, (i) => List.generate(40, (i) => ' '));
  for (var c = 0; c < 240; c++) {
    var signal = result[c + 1];
    var spriteCenter = c % 40;
    var spritePositions = [spriteCenter - 1, spriteCenter, spriteCenter + 1];
    if (spritePositions.contains(signal)) {
      screen[c ~/ 40][c % 40] = "█";
    }
  }

  print('    Part 2:');
  for (var s in screen) print('    ${s.join('')}');
}
