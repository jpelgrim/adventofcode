import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  print('--- Day  4: Camp Cleanup ---');

  final filename = args.isNotEmpty ? args[0] : './lib/day4/input.txt';
  final input = File(filename).readAsLinesSync();

  final listOfSectionPairs = toListOfSectionPairs(input);
  var part1 = 0;
  for (var section in listOfSectionPairs) {
    if (section[0].x <= section[1].x && section[0].y >= section[1].y ||
        section[1].x <= section[0].x && section[1].y >= section[0].y) part1++;
  }

  assert(part1 == 500);
  print('    Part 1: $part1');

  var noOverlap = 0;
  for (var section in listOfSectionPairs) {
    if (section[0].y < section[1].x || section[1].y < section[0].x) {
      noOverlap++;
    }
  }

  var part2 = input.length - noOverlap;
  assert(part2 == 815);
  print('    Part 1: $part2');
}

// Using the Point type to define a section, so it runs from Point.x to Point.y
// This saved me from having to deal with a List<List<List<int>>>
final List<List<Point>> Function(List<String>) toListOfSectionPairs = (input) =>
    input
        .map((e) =>
        e.split(',').map((e) {
              final coords = e.split('-').toList();
              return Point(int.parse(coords[0]), int.parse(coords[1]));
            }).toList())
        .toList();
