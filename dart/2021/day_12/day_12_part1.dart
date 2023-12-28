// https://adventofcode.com/2021/day/12
import 'dart:io';

void main() {
  print('--- Day 12: Passage Pathing ---');

  final lines = File('input.txt').readAsLinesSync();

  final paths = List<Path>.empty(growable: true);

  lines.forEach((line) {
    paths.addAll(Path.fromList(line.split('-')));
  });

  final validPaths = findPaths(paths, ["start"], "end");
  print('    Part 1: ${validPaths.length}');
}

List<List<String>> findPaths(List<Path> paths, List<String> steps, String end) {
  if (paths.isEmpty) return List.empty();
  List<List<String>> result = List.empty(growable: true);
  List<Path> nextSteps = validPathsFrom(steps.last, paths);
  nextSteps.forEach((path) {
    final stepResult = List<String>.from(steps, growable: true)..add(path.to);
    if (path.to == end) {
      result.add(stepResult);
    } else {
      List<Path> updatedPaths = List.from(paths)
        ..removeWhere(
            (e) => e.to == path.to && !RegExp(r'[A-Z]+').hasMatch(e.to));
      findPaths(updatedPaths, stepResult, end).forEach((element) {
        result.add(element);
      });
    }
  });
  return result;
}

List<Path> validPathsFrom(String start, List<Path> paths) =>
    paths.where((path) => path.from == start).toList();

class Path {
  Path({required this.from, required this.to});

  final String from;
  final String to;

  static List<Path> fromList(List<String> caveNames) => [
        if ("end" != caveNames[0] && "start" != caveNames[1])
          Path(from: caveNames[0], to: caveNames[1]),
        if ("end" != caveNames[1] && "start" != caveNames[0])
          Path(from: caveNames[1], to: caveNames[0]),
      ];

  @override
  String toString() => '${from}->${to}';
}
