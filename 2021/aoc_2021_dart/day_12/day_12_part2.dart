// https://adventofcode.com/2021/day/12
import 'dart:io';

void main() {
  final lines = File('input.txt').readAsLinesSync();

  final paths = List<Path>.empty(growable: true);

  lines.forEach((line) {
    paths.addAll(Path.fromList(line.split('-')));
  });

  final validPaths = findPaths(paths, ["start"], "end");

  print('    Part 2: ${validPaths.length}');
}

List<List<String>> findPaths(List<Path> paths, List<String> steps, String end) {
  if (paths.isEmpty) return List.empty();
  List<List<String>> result = List.empty(growable: true);
  List<Path> nextSteps = validPathsFrom(steps.last, paths);
  nextSteps.forEach((path) {
    final stepResult = List<String>.from(steps, growable: true)..add(path.to);
    if (path.to == end) {
      result.add(stepResult);
    } else if (!stepResult.containsMoreThanOneDuplicateSmallCave()) {
      List<Path> updatedPaths = List.from(paths);
      if (stepResult.containsDuplicateSmallCave()) {
          updatedPaths.removeWhere(
                  (e) => e.to == path.to && !RegExp(r'[A-Z]+').hasMatch(e.to));
      }
      findPaths(updatedPaths, stepResult, end).forEach((element) {
        if (element.isNotEmpty) result.add(element);
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

extension on List<String> {
  bool containsDuplicateSmallCave() {
    bool doubleSmallCave = false;
    for (int i=0; i<length; i++) {
      if (RegExp(r'[A-Z]+').hasMatch(this[i])) continue;
      if (where((element) => element == this[i]).length == 2) {
        doubleSmallCave = true;
        break;
      }
    }
    return doubleSmallCave;
  }

  bool containsMoreThanOneDuplicateSmallCave() {
    int doubleSmallCave = 0;
    for (int i=0; i<length; i++) {
      if (RegExp(r'[A-Z]+').hasMatch(this[i])) {
        continue;
      }
      if (where((element) => element == this[i]).length >= 2) {
        doubleSmallCave += 1;
      }
    }
    return doubleSmallCave > 2;
  }
}
